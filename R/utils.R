
#' @importFrom rlang .data
#' @keywords internal
NULL

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Para m\u00e1s informaci\u00f3n:\n",
    "https://www.corteconstitucional.gov.co/relatoria/"
  )
}


#' Document-Term Matrix
#'
#' Creates a document-term matrix from the built-in docterms dataset
#' 
#' @return a dgCMatrix
#' @export
#'
#' @examples
#' 
#' create_dtm()
#' 
create_dtm <- function() {
  require(Matrix)
  
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
