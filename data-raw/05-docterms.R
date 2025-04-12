# Packages and Setup ------------------------------------------------------

library(arrow)
library(tidyverse)
library(furrr)

outfolder <- "data-raw/txts-lemmas"
pos_list <- c("PROPN", "VERB", "NOUN", "ADJ")

# Stop Words and Regex ----------------------------------------------------

source("data-raw/stopwords.R")
stop_words <- union(stop_words, stopwords::stopwords("es", source = "snowball"))
stop_words <- union(
  stop_words,
  stopwords::stopwords("es", source = "stopwords-iso")
)
source("data-raw/stopwords_extra.R")

romans <- c(
  as.character(utils::as.roman(1:100)),
  tolower(utils::as.roman(1:100))
)
roman_regex <- paste(paste0("^", romans, "$"), collapse = "|")

# Process ----------------------------------------------------------------

plan(multisession, workers = parallel::detectCores() - 1L)

output <- furrr::future_map(
  .x = dir(outfolder, full.names = TRUE),
  .f = function(x) {
    arrow::read_parquet(x) |>
      ## remove any lemma that contains a digit
      dplyr::filter(stringr::str_detect(lemma, "\\d", negate = TRUE)) |>
      ## keep only `pos_list`
      dplyr::filter(pos %in% pos_list) |>
      ## remove any lemma that represents a person
      dplyr::filter(stringr::str_detect(entity_type, "PER", negate = TRUE)) |>
      ## remove any lemma that contains punctuation
      dplyr::filter(stringr::str_detect(lemma, "[:punct:]", negate = TRUE)) |>
      ## lowercase
      dplyr::mutate(lemma = tolower(lemma)) |>
      ## remove stop words
      dplyr::filter(!lemma %in% stop_words) |>
      ## remove soft-hyphen [!]
      dplyr::mutate(lemma = stringr::str_replace_all(lemma, "\u00AD", "")) |>
      ## remove lemmas that are two characters or less
      dplyr::filter(nchar(lemma) > 2) |>
      ## remove weird <UNK> encoding
      dplyr::filter(!str_detect(lemma, "<unk>")) |>
      ## remove roman numerals
      dplyr::filter(stringr::str_detect(lemma, roman_regex, negate = TRUE)) |>
      ## remove Spanish accents — mostly for standardization and typo correction
      dplyr::mutate(
        lemma = stringi::stri_trans_general(lemma, "Latin-ASCII")
      ) |>
      ## remove extra stop words (i.e., people's names)
      dplyr::anti_join(
        dplyr::tibble(lemma = extra_stopwords),
        by = dplyr::join_by(lemma)
      ) |>
      ## weird typos
      dplyr::mutate(
        lemma = stringr::str_replace_all(
          lemma,
          pattern = c("−" = "", "<" = "", ">" = "", "´" = "", "`" = "")
        )
      ) |> View()
  },
  .progress = TRUE
)

# Organize ---------------------------------------------------------------

df <- purrr::list_rbind(output) |>
  dplyr::mutate(
    lemma = dplyr::case_when(
      stringr::str_detect(lemma, "^lgbt") ~ "lgbt",
      stringr::str_detect(lemma, "^estatuta") ~ "estatutario",
      lemma == "estatitar" ~ "estatutario",
      lemma == "adicionisar" ~ "adicionar",
      lemma == "amenacer" ~ "amenazar",
      .default = lemma
    )
  ) |>
  dplyr::count(id, lemma) |> 
  ## remove final junk
  dplyr::filter(stringr::str_detect(lemma, "^[a-zA-Z]+$"))

# Removed Annulled Rulings ------------------------------------------------

metadata <- readr::read_rds("data-raw/metadata.rds")

df <- df |> 
  dplyr::filter(id %in% metadata$id) 

# Remove rare and common words --------------------------------------------

docs <- unique(df$id)
n_docs <- length(docs)

lemma_counts <- df |>
  dplyr::count(lemma) |>
  dplyr::mutate(prop = n / n_docs)

ok_lemmas <- lemma_counts |>
  # Denny & Spirling (2018)
  dplyr::filter(prop >= 0.01, prop <= 0.99) |>
  dplyr::pull(lemma)

df <- df |>
  dplyr::filter(lemma %in% ok_lemmas)

## for memory:

docterms <- df |>
  dplyr::mutate(
    id = factor(id, levels = docs),
    lemma = factor(lemma, levels = ok_lemmas)
  )

class(docterms) <- c("tbl_df", "tbl", "data.frame")

usethis::use_data(docterms, overwrite = TRUE, compress = "xz")



