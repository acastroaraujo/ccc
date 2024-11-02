
#' @import Matrix

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Para m\u00e1s informaci\u00f3n:\n",
    "https://www.corteconstitucional.gov.co/relatoria/"
  )
}

#' @importFrom rlang .data
#' @keywords internal
NULL

#' Sparse Document-Term Matrix
#'
#' Creates a document-term matrix from the built-in docterms dataset
#' 
#' @return a dgCMatrix
#' @export
#' 
create_dtm <- function() {
  
  row_names <- levels(ccc::docterms$doc_id)
  col_names <- levels(ccc::docterms$lemma)
  
  i <- match(ccc::docterms$doc_id, row_names)
  j <- match(ccc::docterms$lemma, col_names)
  
  M <- Matrix::sparseMatrix(
    i = i, j = j, x = ccc::docterms$n,
    dimnames = list(row_names, col_names)
  )
  
  return(M)
  
}


#' Sparse Citation Matrix
#'
#' Creates a citation matrix from the edge list in ccc::citations
#' 
#' @return a dgCMatrix
#' @export
#' 
create_citation_adj_mat <- function() {
  
  i <- match(as.character(ccc::citations$from), ccc::metadata$id)
  j <- match(as.character(ccc::citations$to), ccc::metadata$id)
  n <- nrow(ccc::metadata)
  
  M <- Matrix::sparseMatrix(
    i = i, j = j, x = ccc::citations$weight,
    dims = c(n, n),
    dimnames = list(ccc::metadata$id, ccc::metadata$id)
  )
  
  return(M)
  
}


