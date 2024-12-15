
library(readr)
library(stringr)

if (!dir.exists("data-raw/txts")) dir.create("data-raw/txts")
if (!dir.exists("data-raw/txts-lemmas")) dir.create("data-raw/txts-lemmas")
if (!dir.exists("data-raw/txts-entities")) dir.create("data-raw/txts-entities")

rds_files <- dir("data-raw/texts", full.names = TRUE)

for (i in seq_along(rds_files)) {

  txt <- readr::read_rds(rds_files[[i]])
  # txt <- readr::read_rds("data-raw/texts/C-143-18.rds")
  # replace XXXXXX-Xxxxxx with XXXXX. Xxxxx
  txt <- stringr::str_replace_all(txt, "([:upper:]+)-([:upper:][:lower:]+)", "\\1. \\2") 
  # add sentence structure to weird line breaks
  txt <- stringr::str_replace_all(txt, "(?<=\\b)\\r\\n", ". \r\n\r\n")
  # separate words that are joined by a forward slash (/)
  txt <- stringr::str_replace_all(txt, "([:alpha:]+\\/)([:alpha:]+)", "\\1 \\2")
  # save in new folder
  filename <- stringr::str_replace_all(rds_files[[i]], c("texts" = "txts", "rds$" = "txt"))
  readr::write_file(txt, filename)
}
