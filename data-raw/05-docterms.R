
library(arrow)
library(tidyverse)
library(furrr)

source("data-raw/stopwords.R")
stop_words <- union(stop_words, stopwords::stopwords("es", source = "snowball"))
stop_words <- union(stop_words, stopwords::stopwords("es", source = "stopwords-iso"))

source("data-raw/stopwords_extra.R")

## create regex for roman numerals
romans <- c(as.character(utils::as.roman(1:100)), tolower(utils::as.roman(1:100)))
roman_regex <- paste(paste0("^", romans, "$"), collapse = "|")

outfolder <- "data-raw/txts-lemmas"
pos_list <- c("PROPN", "VERB", "NOUN", "ADJ")

plan(multisession, workers = parallel::detectCores() - 1L)

output <- furrr::future_map(
  .x = dir(outfolder, full.names = TRUE), 
  .f = function(x) {

  read_parquet(x) |> 
    ## remove any lemma that contains a digit
    filter(str_detect(lemma, "\\d", negate = TRUE)) |> 
    ## keep only pos_list
    filter(pos %in% pos_list) |> 
    ## remove any lemma that represents a person
    filter(str_detect(entity_type, "PER", negate = TRUE)) |> 
    ## remove any lemma that contains punctuation
    filter(str_detect(lemma, "[:punct:]", negate = TRUE)) |> 
    ## lowercase
    mutate(lemma = tolower(lemma)) |> 
    ## remove stop words 
    filter(!lemma %in% stop_words) |> 
    ## custom
    mutate(lemma = str_replace_all(lemma, c("lgbteia\\+" = "lgbtiq+", "-" = "", "<" = "", ">" = "", "estatitar", "estatutaria"))) |> 
    ## remove lemmas that are two characters or less
    filter(nchar(lemma) > 2) |> 
    ## remove roman numerals
    filter(str_detect(lemma, roman_regex, negate = TRUE)) |> 
    ## remove Spanish accents (mostly for standardization and typo correction)
    mutate(lemma = textclean::replace_non_ascii(lemma)) |> 
    ## remove extra stopwords (i.e., people's names)
    anti_join(tibble(lemma = extra_stopwords)) 

  }, .progress = TRUE
) 

df <- list_rbind(output) |> 
  count(id, lemma)

df |> filter(lemma == "estatitar")

docs <- unique(df$id)
n_docs <- length(docs)

lemma_counts <- df |>
  count(lemma) |> 
  mutate(prop = n / n_docs)

ok_lemmas <- lemma_counts |> 
  filter(prop >= 0.005, prop <= 0.99) |> 
  pull(lemma)

df <- df |> 
  filter(lemma %in% ok_lemmas)

n_words <- length(ok_lemmas)

## for memory:

docterms <- df |> 
  mutate(
    id = factor(id, levels = docs),
    lemma = factor(lemma, levels = ok_lemmas)
  )

class(docterms) <- c("tbl_df", "tbl", "data.frame")

usethis::use_data(docterms, overwrite = TRUE, compress = "xz") 

