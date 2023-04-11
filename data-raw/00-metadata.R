
library(tidyverse)

date_seq <- 1992:2022 ## get first 30 years
out <- vector("list", length(date_seq))

for (i in seq_along(date_seq)) {
  out[[i]] <- try(
    ccc_search(
      text = "", 
      date_start = paste0(date_seq[[i]], "-01-01"),
      date_end = paste0(date_seq[[i]], "-12-31")
    )
  )
  cat("Downloading:", date_seq[[i]], "\r")
}

metadata <- bind_rows(out) |> 
  select(-relevancia)

end_date <- min(as.Date(metadata$f_sentencia)) + lubridate::years(30)

metadata <- metadata |> 
  filter(as.Date(f_sentencia) <= end_date) |> 
  ## removes white spaces
  dplyr::mutate(providencia = stringr::str_replace_all(.data$providencia, "[:space:]", "")) |> 
  ## removes any character at the end that's NOT a number
  dplyr::mutate(providencia = stringr::str_remove(.data$providencia, "[^\\d]+$")) |> 
  ## replaces, e.g., C-776/03 with C-776-03
  dplyr::mutate(providencia = stringr::str_replace_all(.data$providencia, "\\.|\\/", "-")) |> 
  dplyr::relocate("id" = "providencia") |> 
  mutate(across(where(is.character), \(x) ifelse(x == "Sin Informacion", NA_character_, x))) |> 
  arrange(as.Date(f_sentencia)) |>      ## In case of duplicates, this keeps the one with the
  distinct(id, .keep_all = TRUE)        ## earliest date. A handful of cases were uploaded to the
                                        ## database twice on different dates.

## clean more data -----

## AFTER CLEANING BETTER REVISIT ALL SCRIPTS

write_rds(metadata, "data-raw/metadata.rds", compress = "gz")

usethis::use_data(metadata, overwrite = TRUE)

# to to -------------------------------------------------------------------

# fix: "", "sin información", and "sala plena"

# df <- ccc_clean_dataset(metadata)
# 
# df <- df |> 
#   mutate(ponentes = stringi::stri_trans_general(ponentes, "Latin-ASCII")) |> 
#   mutate(ponentes = tolower(ponentes)) |> 
#   mutate(ponentes = str_remove_all(ponentes, "\\(conjuez\\)")) |> 
#   mutate(ponentes = str_split(ponentes, "\r\n")) |> 
#   mutate(ponentes = map(ponentes, str_squish)) 
# 
# unlist(df$ponentes) |> table() |> sort() |> enframe() |> View()

