
#' Datasets
#'
#' These datasets go over the first 30 years of the Colombian Constitutional 
#' Court's history. They were created using this package. See the following 
#' link to get access to the code that produce them:
#' 
#' https://github.com/acastroaraujo/ccc/tree/master/data-raw
#'
#' @format Each dataset is a data frame. `citations` takes the form of an
#' "edge list," `metadata` contains additional information on each case; and
#' `docterms` contains word counts for a subset of the vocabulary used across 
#' all cases.
#' @source https://www.corteconstitucional.gov.co/relatoria/
#' @examples
#' metadata
#' citations
#' docterms
"metadata"

#' @rdname metadata
#' @format NULL
"citations"

#' @rdname metadata
#' @format NULL
"docterms"
