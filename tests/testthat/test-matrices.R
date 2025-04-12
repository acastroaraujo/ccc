

test_that("citation adj mat works", {
  
  out <- create_citation_adj_mat()
  expect_true(inherits(out, "dgCMatrix"))
  
})


test_that("doc term mat works", {
  
  out <- create_dtm()
  expect_true(inherits(out, "dgCMatrix"))
  
})