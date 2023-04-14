
library(httr)
library(rvest)
library(tidyverse)

url <- "https://www.corteconstitucional.gov.co/relatoria/equidaddegenero.php"

x <- paste0("?cuadro=", 1:10)
url_out <- vector("list", length(x))
case_out <- vector("list", length(x))
sec_name <- vector("character", length(x))

for (i in seq_along(x)) {
  
  website <- read_html(str_glue("{url}{x[[i]]}"))
  
  sec_name[[i]] <- website |> 
    html_elements("h4 strong") |> 
    html_text()
  
  links <- website |> 
    html_elements("tr td a") |> 
    html_attrs()
  
  n <- seq(2, length(links), by = 2)
  url_out[[i]] <- unname(unlist(links[n]))
  
  cases <- website |> 
    html_elements("tr td a") |> 
    html_text()
  
  case_out[[i]] <- cases[n]
  
  cat(x[[i]])
  
}

names(case_out) <- names(url_out) <- unlist(sec_name)

d1 <- enframe(case_out, name = "tema", value = "id") 

d2 <- enframe(url_out, name = "tema", value = "href") 

gender <- full_join(d1, d2) |> 
  unnest(c(id, href))

gender <- gender |> 
  mutate(tema = factor(tema)) |> 
  mutate(id = str_replace_all(id, "[:space:]", "")) |> 
  mutate(id = str_remove(id, "[^\\d]+$")) |> 
  mutate(id = str_replace_all(id, "\\.|\\/", "-")) |> 
  mutate(type = str_extract(id, "^(C|SU|T|A)")) |> 
  filter(type != "A") |> 
  mutate(type = factor(type)) |> 
  relocate(id, type, tema, href)

usethis::use_data(gender, overwrite = TRUE)
