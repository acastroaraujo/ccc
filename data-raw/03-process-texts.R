
library(tidyverse)
library(ccc)
library(progress)
library(spacyr)

infolder <- here::here("data-raw", "texts")
outfolder <- here::here("data-raw", "texts-spacy")
if (!dir.exists(outfolder)) dir.create(outfolder)

# Spanish Lemmatizer
# https://github.com/pablodms/spacy-spanish-lemmatizer
# Run this on the terminal in the correct conda environment
# pip install spacy_spanish_lemmatizer
# python -m spacy_spanish_lemmatizer download wiki

# pre-process -------------------------------------------------------------

spacy_initialize("es_core_news_lg", condaenv = "spacy_condaenv")
reticulate::py_run_string("import spacy_spanish_lemmatizer")
reticulate::py_run_string('nlp.replace_pipe("lemmatizer", "spanish_lemmatizer")')
reticulate::py_run_string("nlp.max_length = 3150000")

ids <- str_remove(dir(infolder), "\\.rds")
cases_done <- str_remove(dir(outfolder), "\\.rds")
cases_left <- setdiff(ids, cases_done)

pb <- progress_bar$new(format = "[:bar] :current/:total (:percent)", total = length(cases_left))

while (length(cases_left) > 0) {
  
  x <- sample(cases_left, 1)
  
  txt <- read_rds(str_glue("{infolder}/{x}.rds")) |> 
    str_squish() |> 
    str_replace_all("\\b-(?=[^\\d])", ". ")
  
  out <- suppressWarnings(
    spacy_parse(txt, additional_attributes = c("is_stop", "is_digit"))
  )
  
  out$doc_id <- x
  
  write_rds(out, str_glue("{outfolder}/{x}.rds"))
  cases_left <- cases_left[-which(cases_left %in% x)] ## int. subset
  
  pb$tick()
  
}



# assemble ----------------------------------------------------------------

## check for html code, delete files, and re-do.


## check the ccc_paper repository, topic-models.Rmd

library(furrr)

plan(multisession, workers = parallel::detectCores() - 1L)

pos_list <- c("PROPN", "VERB", "NOUN", "ADJ")

output <- furrr::future_map(
  .x = dir(outfolder, full.names = TRUE), 
  .f = function(x) {
    read_rds(x) |> 
      ## remove stop words and digits
      filter(!is_stop, !is_digit) |> 
      ## keep only pos_list
      filter(pos %in% pos_list) |> 
      ## remove any lemma that contains a digit
      filter(str_detect(lemma, "\\d", negate = TRUE)) |> 
      ## remove any lemma that represents a person
      filter(str_detect(entity, "PER_.", negate = TRUE)) |> 
      ## remove lemmas that are two characters or less
      filter(nchar(lemma) > 2)
  }
) 

df <- list_rbind(output) |> 
  select(doc_id, sentence_id, token, lemma)

write_rds(df, "data-raw/spacy_subset.rds", compress = "gz")
