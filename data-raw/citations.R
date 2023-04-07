

library(tidyverse)
citations <- read_rds("~/Documents/Repositories/ccc_datos/data/citations.rds")

citations <- citations |> 
  filter(from_date <= as.Date("2022-02-27")) |> 
  select(from, to, from_date, to_date, weight)

usethis::use_data(citations, overwrite = TRUE)
