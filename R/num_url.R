

#' Buscador de URL por número de providencia
#' 
#' La página de la Corte obliga a buscar en formatos como: T-005-04 o T-005; C-143-15; SU230-15 o SU230; A180-15
#' Pero también sirve buscar SU-230-15 o A-180-15 (con el guión agregado).
#' 
#' No hay restricción para el tipo de búsqueda (ej. Buscar 776 arroja todas las providencias que contienen ese número en el nombre)
#'
#' @param q términos de búsqueda
#' @param p número de página (default es cero)
#'
#' @return un véctor tipo character
#' @export
#'
ccc_num_url <- function(q, p = 0) {
  url <- paste0(
    "https://www.corteconstitucional.gov.co/relatoria/providencia.aspx?",
    "&pg=", p,
    "&buscar=", make_num_query(q)
  )
  
  obj <- httr::RETRY("GET", url)
  stopifnot(httr::status_code(obj) == 200)
  website <- httr::content(obj)
  
  num_resultados <- website %>%
    rvest::html_text() %>%
    stringr::str_extract("Total de Registros --> \\d+") %>% 
    stringr::str_extract("\\d+") %>% 
    as.double()
  
  tot <- floor(num_resultados / 100)
  message("Total de Registros: ", num_resultados, "  [", p,  ", ", tot, "]")
  
  output <- website %>% 
    rvest::html_nodes(".grow a") %>% 
    rvest::html_attr("href") %>% 
    stringr::str_replace_all(c(" " = "%20"))
  
  if (purrr::is_empty(output)) return(NULL)
  if (length(output) > 1) warning(call. = FALSE, "La b", intToUtf8(250), "squeda encontr", intToUtf8(243), " m", intToUtf8(225), "s de un URL") 
  
  return(output)
  
}



