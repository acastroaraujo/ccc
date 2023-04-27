
library(tidyverse)
library(ccc)
library(tidylog)


# download ----------------------------------------------------------------

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
  Sys.sleep(runif(1, 2, 5))
}

# clean up ----------------------------------------------------------------

metadata <- bind_rows(out) |> 
  select(-relevancia)

end_date <- min(as.Date(metadata$fecha_sentencia)) + lubridate::years(30) + lubridate::days(15)

metadata <- metadata |>
  ## keep subset of variables
  select("id" = "providencia", "date" = "fecha_sentencia", "file" = "expediente", "mp" = "magistrado_s_ponentes", "descriptors" = "tema_subtema", "date_public" = "f_public", "url") |> 
  mutate(
    date = as.Date(date), 
    date_public = as.Date(date_public)
  ) |> 
  ## Just get first 30 years
  filter(date <= end_date) |> 
  ## Add year
  mutate(year = as.integer(format(date, "%Y"))) |> 
  ## Remove white spaces
  mutate(id = str_replace_all(id, "[:space:]", "")) |> 
  ## Removes any character at the end that's NOT a number
  mutate(id = str_remove(id, "[^\\d]+$")) |> 
  ## Replaces, e.g., C-776/03 with C-776-03
  mutate(id = str_replace_all(id, "\\.|\\/", "-")) |> 
  ## Extract prefix
  mutate(type = str_extract(id, "^(C|SU|T|A)")) |> 
  ## Filter out "Autos"
  filter(type != "A") |> 
  mutate(type = factor(type)) |> 
  ## remove all spanish accents
  mutate(across(where(is.character), \(x) stringi::stri_trans_general(x, "Latin-ASCII"))) |> 
  ## Clarify NAs
  mutate(across(all_of(c("mp", "descriptors")), \(x) ifelse(str_detect(x, "(s|S)in (i|I)nformacion"), NA_character_, x))) |> 
  ## In case of duplicates, the following two lines keep the case  with the 
  ## earliest date. A handful of cases were uploaded to the database twice 
  ## on different dates.
  arrange(date) |>      
  distinct(id, .keep_all = TRUE) |> 
  ## get mp into list-column
  mutate(mp = tolower(mp)) |> 
  mutate(mp = str_remove_all(mp, "\\(conjuez\\)")) |> 
  mutate(mp = str_split(mp, "\r\n")) |> 
  mutate(mp = map(mp, str_squish)) |> 
  ## get descriptors into list-column
  mutate(descriptors = str_split(descriptors, "\r\n")) |> 
  mutate(descriptors = map(descriptors, str_squish)) |> 
  relocate("id", "type", "year", "date", "descriptors", "mp", "date_public", "file", "url") 

write_rds(metadata, "data-raw/metadata.rds", compress = "gz")



