
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

metadata <- bind_rows(out)
end_date <- min(as.Date(metadata$f_sentencia)) + lubridate::years(30)
metadata <- metadata |> 
  filter(as.Date(f_sentencia) <= end_date) |> 
  select(-relevancia)

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

