
# setup -------------------------------------------------------------------

library(tidyverse)
library(ccc)
library(furrr)

textfolder <- here::here("data-raw", "texts")

plan(multisession, workers = parallel::detectCores() - 1L)

output <- dir(textfolder, full.names = TRUE) |> 
  furrr::future_map(\(x) str_squish(read_rds(x)))

names(output) <- dir(textfolder) |> str_remove("\\.rds")

# citations ---------------------------------------------------------------

citations <- future_map(output, ccc::extract_citations)
names(citations) <- names(output)

input_el <- citations |>
  enframe(name = "from", value = "to") |>
  unnest(cols = "to")

edge_list <- input_el |>
  filter(from != to) |>              ## remove self-citation
  filter(to %in% names(citations)) 

cat("weighted network:", scales::comma(nrow(edge_list)), "\n")
cat("unweighted network:", scales::comma(nrow(distinct(edge_list))), "\n")

# add relevant metadata ---------------------------------------------------

metadata <- read_rds("data-raw/metadata.rds") |> 
  select(id, date) |> 
  drop_na()

edge_list <- edge_list |> 
  count(from, to, name = "weight") |> 
  left_join(metadata, by = c("from" = "id"), relationship = "many-to-one") |> 
  rename(from_date = date) |> 
  left_join(metadata, by = c("to" = "id"), relationship = "many-to-one") |> 
  rename(to_date = date) ## |> 
  ## allow for 100 days of time travel [!]
  ## filter(to_date - from_date <= 100)

# export ------------------------------------------------------------------

## the following lines are for memory efficiency

case_levels <- metadata$id

citations <- edge_list |> 
  mutate(
    from = factor(from, levels = case_levels),
    to = factor(to, levels = case_levels)
  )

usethis::use_data(citations, overwrite = TRUE, compress = "xz")

# add word counts -------------------------------------------

word_count <- future_map_dbl(output, \(x) str_count(x, "\\b\\w+\\b")) |> 
  enframe(name = "id", value = "word_count") |> 
  mutate(word_count = as.integer(word_count))

# modify metadata ---------------------------------------------------------

metadata <- read_rds("data-raw/metadata.rds")

net <- igraph::graph_from_data_frame(
  d = citations, 
  directed = TRUE,
  vertices = metadata
)

## make sure it is degree and not strength!!)

metadata <- metadata |> 
  left_join(
    igraph::degree(net, mode = "in") |> 
      enframe("id", "indegree") |> 
      mutate(indegree = as.integer(indegree))
  ) |> 
  left_join(
    igraph::degree(net, mode = "out") |> 
      enframe("id", "outdegree") |> 
      mutate(outdegree = as.integer(outdegree))
  ) 

metadata <- metadata |> 
  select(id, type, year, date, indegree, outdegree, everything()) |> 
  ## add id order after date.
  mutate(temp = readr::parse_integer(str_extract(id, "\\d+(?=-\\d{2})"))) |> 
  arrange(date, temp) |> 
  select(-temp)

## add word_count

metadata <- metadata |> 
  left_join(word_count) |> 
  select(id, type, year, date, indegree, outdegree, word_count, everything()) 

usethis::use_data(metadata, overwrite = TRUE, compress = "xz")
