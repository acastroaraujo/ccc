
## To do: make ccc_clean_dataset better!
## document datasets:
## https://r-pkgs.org/data.html#sec-documenting-data

out <- ccc_search("pandemia", "2000-01-01", "2007-01-01")

df <- ccc_clean_dataset(out)

link <- sample(df$url, 1)

text <- ccc_text(link)
text2 <- ccc_text(link)

cat(text)
cat(text2)
## some rtf don't have footnotes!!!

extract_citations(text)
extract_citations(text2)


# data --------------------------------------------------------------------

library(tidyverse)

date_seq <- 1992:2022
out <- vector("list", length(date_seq))

for (i in seq_along(date_seq)) {
  out[[i]] <- ccc_search(
    text = "", 
    date_start = paste0(date_seq[[i]], "-01-01"),
    date_end = paste0(date_seq[[i]], "-12-31")
  )
  cat("Downloading:", date_seq[[i]], "\r")
}

out <- bind_rows(out)

out$descriptores[[1]]

df <- ccc_clean_dataset(out)



citations <- read_rds("~/Documents/Repositories/ccc_datos/data/citations.rds")
metadata <- read_rds("~/Documents/Repositories/ccc_datos/data/metadata.rds")

end_date <- min(metadata$date) + lubridate::years(30)

metadata <- metadata |> 
  filter(date <= end_date)

metadata$ponentes |> unlist() |> table() |> sort()




# magistrados -------------------------------------------------------------




x <- df$magistrado_otros |> 
  stringr::str_extract_all("(.+\\(.*\\))") 
  
x[[193]] |> stringr::str_replace_all(pattern = "(.+)\\((.+)\\)", replacement = "\\1")


one <- purrr::map(x, \(x) stringr::str_replace_all(x, pattern = "(.+)\\((.+)\\)", replacement = "\\1"))
two <- purrr::map(x, \(x) stringr::str_replace_all(x, pattern = "(.+)\\((.+)\\)", replacement = "\\2"))

setNames(one, two)

purrr::map2(one, two, purrr::set_names) |> 
  tibble::enframe() |>
  dplyr::mutate(SV = purrr::map_if(value, \(x) length(x) > 0, purrr::pluck, "SV", .else = character(0))) |> 
  dplyr::mutate(SPV = purrr::map(value, purrr::pluck, "SPV")) |> 
  dplyr::mutate(AV = purrr::map(value, purrr::pluck, "AV")) 
  tidyr::unnest(AV)
  
  
pluck_magistrado <- function(x, type) {
  nms <- purrr::map(x, \(x) stringr::str_replace_all(x, pattern = "(.+)\\((.+)\\)", replacement = "\\2"))
  vls <- purrr::map(x, \(x) stringr::str_replace_all(x, pattern = "(.+)\\((.+)\\)", replacement = "\\1"))
  
  out <- purrr::map2(vls, nms, purrr::set_names)
  
  i_av <- purrr::map(out, \(x) which(names(x) == "AV"))
  i_sv <- purrr::map(out, \(x) which(names(x) == "SV"))
  i_spv <- purrr::map(out, \(x) which(names(x) == "SPV"))
  
  out2 <- vector("list", length(out))
  
  for (n in seq_along(out)) {
    out2[[n]]$AV <- unname(out[[n]][i_av[[n]]])
    out2[[n]]$SV <- unname(out[[n]][i_sv[[n]]])
    out2[[n]]$SPV <- unname(out[[n]][i_spv[[n]]])
  }
  
  as.data.frame(out2[[1]])
  
  if (is.null(out)) return(character(0)) else return(out)
  
}

which(names(out[[193]]) == "SPV")
list(SPV = unname(out[[193]][integer(0)]))
pluck_magistrado(x, "AV")
