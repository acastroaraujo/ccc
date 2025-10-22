# Setup -------------------------------------------------------------------

library(tidyverse)
library(ccc)
library(furrr)

textfolder <- here::here("data-raw", "texts")
future::plan(multisession, workers = parallel::detectCores() - 1L)

output <- dir(textfolder, full.names = TRUE) |>
  furrr::future_map(\(x) stringr::str_squish(read_rds(x)))

names(output) <- dir(textfolder) |> stringr::str_remove("\\.rds")

# get word count to remove annulled rulings
word_count <- furrr::future_map_dbl(output, \(x) stringr::str_count(x, "\\b\\w+\\b")) |>
  tibble::enframe(name = "id", value = "word_count") |>
  dplyr::mutate(word_count = as.integer(word_count))

metadata <- readr::read_rds("data-raw/metadata_init.rds") |> 
  dplyr::left_join(word_count) |>
  ## remove annulled rulings
  dplyr::filter(word_count >= 200) 

# citations ---------------------------------------------------------------

citations <- furrr::future_map(output, ccc::extract_citations)
names(citations) <- names(output)

input_el <- citations |>
  tibble::enframe(name = "from", value = "to") |>
  tidyr::unnest(cols = "to")

edge_list <- input_el |>
  ## remove self-citation
  dplyr::filter(from != to) |> 
  ## remove typos
  dplyr::filter(from %in% metadata$id, to %in% metadata$id)

message("weighted network: ", scales::comma(nrow(edge_list)))
message("unweighted network: ", scales::comma(nrow(dplyr::distinct(edge_list))))

# add relevant metadata ---------------------------------------------------

metadata <- metadata |>
  dplyr::select(id, date) 

edge_list <- edge_list |>
  dplyr::count(from, to, name = "weight") |>
  dplyr::left_join(metadata, by = c("from" = "id"), relationship = "many-to-one") |>
  dplyr::rename(from_date = date) |>
  dplyr::left_join(metadata, by = c("to" = "id"), relationship = "many-to-one") |>
  dplyr::rename(to_date = date) |>
  ## allow for 100 days of time travel [!]
  dplyr::filter(to_date - from_date <= 100) 

# export ------------------------------------------------------------------

## the following lines are for memory efficiency

case_levels <- metadata$id

citations <- edge_list |>
  dplyr::mutate(
    from = factor(from, levels = case_levels),
    to = factor(to, levels = case_levels)
  )

usethis::use_data(citations, overwrite = TRUE, compress = "xz")

# modify metadata ---------------------------------------------------------

metadata <- readr::read_rds("data-raw/metadata_init.rds")

net <- igraph::graph_from_data_frame(
  d = citations,
  directed = TRUE,
  vertices = metadata
)

## make sure it is degree and not strength!!

metadata <- metadata |>
  dplyr::left_join(
    igraph::degree(net, mode = "in") |>
      tibble::enframe("id", "indegree") |>
      dplyr::mutate(indegree = as.integer(indegree))
  ) |>
  left_join(
    igraph::degree(net, mode = "out") |>
      tibble::enframe("id", "outdegree") |>
      dplyr::mutate(outdegree = as.integer(outdegree))
  )

metadata <- metadata |>
  dplyr::select(id, type, year, date, indegree, outdegree, dplyr::everything()) |>
  ## add id order after date.
  dplyr::mutate(temp = readr::parse_integer(stringr::str_extract(id, "\\d+(?=-\\d{2})"))) |>
  dplyr::arrange(date, temp) |>
  dplyr::select(-temp)

metadata <- metadata |>
  ## add word_count
  dplyr::left_join(word_count) |>
  dplyr::select(id, type, year, date, indegree, outdegree, word_count, dplyr::everything()) |> 
  ## remove annulled rulings
  dplyr::filter(word_count >= 200) 

readr::write_rds(metadata, "data-raw/metadata.rds", compress = "gz")
usethis::use_data(metadata, overwrite = TRUE, compress = "xz")


