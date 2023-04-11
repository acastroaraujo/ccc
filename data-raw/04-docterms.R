
edgelist_projection <- function(d) {
  require(Matrix)
  row_names <- unique(d$from)
  col_names <- unique(d$to)
  i <- match(d$from, row_names)
  j <- match(d$to, col_names)
  
  M <- Matrix::sparseMatrix(
    i = i, j = j, x = 1L,
    dimnames = list(row_names, col_names)
  )
  
  message("original matrix: ", paste(dim(M), collapse = " x "))
  out <- M %*% t(M)
  message("projection matrix: ", paste(dim(out), collapse = " x "))
  return(out)
}