
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


#' Gender Equality Cases
#' 
#' Covers cases from 1992-08-12 to 2022-02-23
#' 
#' https://github.com/acastroaraujo/ccc/tree/master/data-raw/gender.R
#' 
#' @source https://www.corteconstitucional.gov.co/relatoria/equidaddegenero.php
#' 
#' @format A data frame with two variables:
#' \describe{
#' \item{\code{id}}{Ruling ID (Source)}
#' \item{\code{tema}}{Topic}
#' }
#' @examples
#'   gender_cases
"gender_cases"


#' Justicia Constitucional en Tiempos de Transicion
#' 
#' Covers cases from 1992-10-28 to 2019-04-03
#' 
#' https://github.com/acastroaraujo/ccc/tree/master/data-raw/transitional_justice_uniandes.R
#' 
#' @source http://justiciatransicional.uniandes.edu.co/web/
#' 
#' @format A chacter vector of rulings
#' @examples
#'   jctt_cases
"jctt_cases"


