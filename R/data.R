#' Metadata
#'
#' The `metadata` dataset contains information about the rulings authored by
#' the Colombian Constitutional Court.
#'
#' @source https://www.corteconstitucional.gov.co/relatoria/
#'
#' @format A data frame with nine variables:
#' \describe{
#' \item{\code{id}}{Ruling ID}
#' \item{\code{type}}{Ruling Type (C, T, or SU)}
#' \item{\code{year}}{Year}
#' \item{\code{date}}{YYYY-MM-DD}
#' \item{\code{indegree}}{Citation In-degree}
#' \item{\code{outdegree}}{Citation Out-degree}
#' \item{\code{word_count}}{Word Count}
#' \item{\code{descriptors}}{Additional metadata added to some rulings by the Court}
#' \item{\code{url}}{URL to see the ruling}
#' }
#'
#'
#' @examples
#'   metadata
"metadata"

#' Citations
#'
#' The `citations` dataset contains and edge list of rulings that form a large
#' citation network.
#'
#' @source https://www.corteconstitucional.gov.co/relatoria/
#'
#' @format A data frame with five variables:
#' \describe{
#' \item{\code{from}}{Ruling ID (Source)}
#' \item{\code{to}}{Ruling ID (Target)}
#' \item{\code{weight}}{Number of times cited}
#' \item{\code{from_date}}{Source Date}
#' \item{\code{to_date}}{Target Date}
#' }
#'
#' @examples
#'   citations
"citations"

#' Document Terms
#'
#' The `doc_terms` dataset contains and edge list of rulings and lemmas (or
#' processed words).
#'
#' @source https://www.corteconstitucional.gov.co/relatoria/
#'
#' @format A data frame with three variables:
#' \describe{
#' \item{\code{id}}{Ruling ID}
#' \item{\code{lemma}}{A standardized word}
#' \item{\code{n}}{Number of times used in the document}
#' }
#'
#' @examples
#'   docterms
"docterms"
