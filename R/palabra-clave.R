

#' Búscador de sentencias por palabra clave
#'
#' @param q términos de búsqueda
#' @param p número de página (default es cero)
#'
#' @return un data frame
#' @export
#'
ccc_palabra_clave <- function(q, p = 0) {
  url <- paste0(
    "https://www.corteconstitucional.gov.co/relatoria/query.aspx?anio=/relatoria/",
    "&pg=", p,
    "&buscar=", make_query(q)
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

  sentencia <- website %>%
    rvest::html_nodes(".grow a") %>%
    rvest::html_text() %>%
    stringr::str_squish()

  if (purrr::is_empty(sentencia)) {
    return(NULL)
  }

  link <- website %>%
    rvest::html_nodes(".grow a") %>%
    rvest::html_attr("href")

  output <- tibble::tibble(sentencia, url = link) %>%
    dplyr::mutate(type = stringr::str_extract(.data$sentencia, "^(C|SU|T|A)"),
                  year = extract_year(.data$sentencia)) %>%
    dplyr::select(.data$sentencia, .data$type, .data$year, .data$url)

  return(output)
}



