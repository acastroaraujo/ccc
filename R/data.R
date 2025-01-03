
#' Rulings (32 Years)
#'
#' These datasets go over the first 30 years of the Colombian Constitutional 
#' Court's history. They were created using this package. See the following 
#' link to get access to the scripts that produced them:
#' https://github.com/acastroaraujo/ccc/tree/master/data-raw
#' 
#' \describe{
#'   \item{metadata}{A data frame with additional information on each case.}
#'   \item{citations}{An edge list.}
#'   \item{docterms}{A data frame with word counts for a subset of the vocabulary used across 
#' all cases.}
#' }
#'
#' @source https://www.corteconstitucional.gov.co/relatoria/
#' 
#' @name rulings
#' @format NULL

#' @rdname rulings
#' @format NULL
"metadata"

#' @rdname rulings
#' @format NULL
"citations"

#' @rdname rulings
#' @format NULL
"docterms"


#' Gender Equality Cases
#' 
#' Covers cases from 1992-08-12 to 2022-02-23
#' 
#' https://github.com/acastroaraujo/ccc/tree/master/data-raw/gender.R
#' 
#' @name gender
#' 
#' @source https://www.corteconstitucional.gov.co/relatoria/equidaddegenero.php
#' 
#' @format NULL

#' @rdname gender
#' @format NULL
"gender_cases"


#' Justicia Constitucional en Tiempos de Transicion
#' 
#' Covers cases from 1992-10-28 to 2019-04-03
#' 
#' \describe{
#'   \item{jctt_cases}{A data frame of cases, along with some nested variables.}
#' }
#' 
#' https://github.com/acastroaraujo/ccc/tree/master/data-raw/transitional_justice_uniandes.R
#' 
#' @name jctt
#' 
#' @source http://justiciatransicional.uniandes.edu.co/web/
#' 
#' @format NULL

#' @rdname jctt
#' @format NULL
"jctt_cases"


