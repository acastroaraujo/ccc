
library(ccc)
library(tidyverse)
library(progress)

# download ----------------------------------------------------------------

outfolder <- here::here("data-raw", "texts")
if (!dir.exists(outfolder)) dir.create(outfolder)

df <- read_rds("data-raw/metadata.rds") |> 
  dplyr::select("id", "type", "url") 

dict <- df |> select(id, url) |> deframe()

texts_done <- dir(outfolder) |> str_remove("\\.rds$")
texts_left <- setdiff(df$id, texts_done)

pb <- progress_bar$new(format = "[:bar] :current/:total (:percent)\n", total = length(texts_left))

while (length(texts_left) > 0) { 
  
  x <- sample(texts_left, 1)
  txt <- try(ccc_txt(dict[[x]]))
  
  write_rds(txt, str_glue("{outfolder}/{x}.rds"), compress = "gz")
  texts_left <- texts_left[-which(texts_left %in% x)] ## int. subset
  
  pb$tick()
  Sys.sleep(runif(1, 0, 2))
  
}

# debug -------------------------------------------------------------------

library(furrr)

plan(multisession, workers = parallel::detectCores() - 1L)

output <- dir(outfolder, full.names = TRUE) |> 
  furrr::future_map(\(x) read_rds(x))

names(output) <- dir(outfolder) |> str_remove("\\.rds")

error_index <- output |> 
  map_lgl(\(x) any(class(x) == "try-error")) |> 
  which()

if (length(error_index) > 0) {
  str_glue("{outfolder}/{names(output[error_index])}.rds") |> 
    file.remove()
}

empty_index <- output |> 
  map_lgl(\(x) any(nchar(x) == 0)) |> 
  which()

if (length(empty_index) > 0) {
  str_glue("{outfolder}/{names(output[empty_index])}.rds") |> 
    file.remove()
}

enc_index <- output |> 
  map_lgl(\(x) str_detect(x, "[\u0090-\u0099]")) |> 
  which()

html_index <- output |> 
  map_lgl(\(x) str_detect(x, "</div>")) |> 
  which()

if (length(html_index) > 0) {
  str_glue("{outfolder}/{names(output[empty_index])}.rds") |> 
    file.remove()

  # weird!!
  # txt <- ccc_txt("https://www.corteconstitucional.gov.co/relatoria/2010/T-078-10.htm")
  # txt <- textclean::replace_html(txt)
  # write_rds(txt, str_glue("{outfolder}/T-078-10.rds"), compress = "gz")

}
