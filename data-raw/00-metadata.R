library(tidyverse)
library(ccc)
library(tidylog)

# Download ----------------------------------------------------------------

date_seq <- 1992:2024 ## get first 32 years
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

# Clean up ----------------------------------------------------------------

metadata <- dplyr::bind_rows(out) |>
  dplyr::select(-relevancia)

end_date <- as.Date("2024-04-03")

# Note. The name space is left unspecified because I wanted to use tidylog here.

metadata <- metadata |>
  ## keep subset of variables
  select(
    "id" = "providencia",
    "date" = "fecha_sentencia",
    # "file" = "expediente", # old code
    # "mp" = "magistrado_s_ponentes", # old code
    "descriptors" = "tema_subtema",
    "url"
  ) |>
  mutate(date = as.Date(date)) |>
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
  mutate(across(
    where(is.character),
    \(x) stringi::stri_trans_general(x, "Latin-ASCII")
  )) |>
  ## Clarify NAs
  mutate(across(
    # all_of(c("mp", "descriptors")), # old code
    all_of("descriptors"),
    \(x) ifelse(str_detect(x, "(s|S)in (i|I)nformacion"), NA_character_, x)
  )) |>
  ## In case of duplicates, the following two lines keep the case  with the
  ## earliest date. A handful of cases were uploaded to the database twice
  ## on different dates.
  arrange(date) |>
  distinct(id, .keep_all = TRUE) |>
  ## get mp into list-column, this is old code
  # mutate(mp = tolower(mp)) |>
  # mutate(mp = str_remove_all(mp, "\\(conjuez\\)")) |>
  # mutate(mp = str_split(mp, "\r\n")) |>
  # mutate(mp = map(mp, str_squish)) |>
  ## get descriptors into list-column
  mutate(descriptors = str_split(descriptors, "\r\n")) |>
  mutate(descriptors = map(descriptors, str_squish)) |>
  # relocate("id", "type", "year", "date", "descriptors", "mp", "file", "url") # old code
  relocate("id", "type", "year", "date", "descriptors", "url")

# Wrong Dates -------------------------------------------------------------

## There are a variety of small errors in the date assignment. I found them by
## looking at the rulings that were published on a weekend or during the holiday
## period. There are bound to be other mistakes in the rest of the dataset, but
## I noticed that they are usually a misplaced digit in the day or month field. 
## This means there is a margin of error within an interval of 10 days or 1 month,
## depending on the transcription error.

dates_fix <- c(
  ## On vacation error fix
  "T-996-10" = "2010-12-03",
  "C-658-96" = "1996-11-28",
  ## Sunday error fix
  "C-230-96" = "1996-05-23",
  "C-406-97" = "1997-08-28",
  "T-390-99" = "1999-05-27",
  "T-814-02" = "2002-09-13",
  "T-246-08" = "2008-03-06",
  "T-435-09" = "2009-07-02",
  "T-528-09" = "2009-08-05",
  "T-1046-10" = "2010-12-15",
  "T-557-11" = "2011-07-12",
  "T-715-11" = "2011-09-22",
  "C-619-12" = "2012-08-08",
  "C-1023-12" = "2012-11-28",
  "T-242-13" = "2013-04-19",
  "T-391-13" = "2013-07-02",
  "T-491-13" = "2013-07-26",
  "T-894-13" = "2013-12-03",
  "C-090-14" = "2014-02-19",
  "C-508-14" = "2014-07-16",
  "T-636-14" = "2014-09-04",
  "T-640-14" = "2014-09-04",
  "T-281-15" = "2015-05-13",
  "T-153-16" = "2016-04-01",
  "SU-440-21" = "2021-12-09",
  "C-207-23" = "2023-06-07",
  ## Saturday error fix
  "C-095-93" = "1993-02-26",
  "C-424-94" = "1994-09-29",
  "C-130-97" = "1997-03-19",
  "C-156-97" = "1997-03-19",
  "T-517-97" = "1997-10-14",
  "T-220-98" = "1998-05-14",
  "T-530-98" = "1998-09-29",
  "T-1081-00" = "2000-08-18",
  "C-1403-00" = "2000-10-19",
  "T-1640-00" = "2000-11-18",
  "T-438-01" = "2001-04-26",
  "T-1102-08" = "2008-11-06",
  "T-419-09" = "2009-06-26",
  "T-309-10" = "2010-04-30",
  "C-241-10" = "2010-04-07",
  "T-268-10" = "2010-04-19",
  "T-273-10" = "2010-04-16",
  "T-498-10" = "2010-06-17",
  "T-235-13" = "2013-04-13",
  "T-183-13" = "2013-04-05",
  "T-189-13" = "2013-04-08",
  "C-400-13" = "2013-07-03",
  "C-403-13" = "2013-07-03",
  "T-372-13" = "2013-06-27",
  "T-479-13" = "2013-07-24",
  "T-648-13" = "2013-09-17",
  "T-153-15" = "2015-04-14",
  "T-438-15" = "2015-07-13",
  "T-476-16" = "2016-09-01",
  "T-364-17" = "2017-06-01",
  "C-409-20" = "2020-09-17",
  # Appointed judges outside appointed dates:
  "T-750A-12" = "2012-09-25"
)

dfix <- enframe(dates_fix, "id", "date")

for (i in 1:nrow(dfix)) {
  metadata[metadata$id == dfix$id[[i]], "date"] <- as.Date(dfix$date[[i]])
}

metadata <- arrange(metadata, date, id)

readr::write_rds(metadata, "data-raw/metadata_init.rds", compress = "gz")


