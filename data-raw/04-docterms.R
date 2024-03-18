
library(tidyverse)
source("data-raw/extra_stopwords.R")

df <- read_rds("data-raw/spacy_subset.rds")

docs <- unique(df$doc_id)
n_docs <- length(docs)

lemma_counts <- df |>
  count(lemma) |> 
  mutate(prop = n / n_docs)

ok_lemmas <- lemma_counts |> 
  filter(prop >= 0.005) |> 
  anti_join(tibble(lemma = stopwords)) |> 
  pull(lemma)

df <- df |> 
  filter(lemma %in% ok_lemmas)

n_words <- length(ok_lemmas)

## for memory:

docterms <- df |> 
  mutate(
    doc_id = factor(doc_id, levels = docs),
    lemma = factor(lemma, levels = ok_lemmas)
  )

class(docterms) <- c("tbl_df", "tbl", "data.frame")

usethis::use_data(docterms, overwrite = TRUE, compress = "xz") 
