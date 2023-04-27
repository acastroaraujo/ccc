test_that("underlying database has not changed", {
  results <- ccc_search(text = "", date_start = "1992-04-01", date_end = "1992-04-30")
  out1 <- ccc_clean_dataset(results) |> dplyr::filter(type == "T")
  out2 <- metadata |> dplyr::filter(id == "T-001-92") |> dplyr::select(-indegree, -outdegree)
  expect_equal(out1, out2)
})
