

#' Buscador de sentencias por palabra clave
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

  output <- tibble::tibble(sentencia, path = link) %>%
    dplyr::mutate(type = stringr::str_extract(.data$sentencia, "^(C|SU|T|A)"),
                  year = extract_year(.data$sentencia)) %>%
    dplyr::select(.data$sentencia, .data$type, .data$year, .data$path)

  return(output)
}


#' Buscador de sentencias por palabra clave (Nueva página)
#'
#' @param q términos de búsqueda
#' @param p número de página (default es cero)
#' @param orden por relevancia o por fecha
#' @param y año (default es "Todos los años")
#'
#' @return un data frame
#' @export
#'
ccc_palabra_clave2 <- function(q, p = 0, orden = c("relevancia", "fecha"), y = NULL) {
  
  orden <- match.arg(orden)
  
  url <- paste0(
    "https://www.corteconstitucional.gov.co/relatoria/consulta.php?",
    "&pg=", p,
    "&anio=", y,
    "&order=", orden,
    "&buscar=", make_query(q)
  )
  
  obj <- httr::RETRY("GET", url)
  stopifnot(httr::status_code(obj) == 200)
  website <- httr::content(obj)
  
  num_resultados <- website %>%
    rvest::html_nodes("form+ .blog-pagination .active+ li a") %>% 
    rvest::html_attr("href") %>% 
    stringr::str_extract("\\d+$") %>% 
    as.numeric()
  
  tot <- floor(num_resultados / 100)
  
  sentencia <- website %>%
    rvest::html_nodes(".grow a") %>%
    rvest::html_text() %>%
    stringr::str_squish()
  
  
  if (purrr::is_empty(sentencia)) {
    return(NULL)
  }
  
  if (purrr::is_empty(num_resultados)) {
    num_resultados <- length(sentencia)
    tot <- 0
  }
  
  message("Total de Registros: ", num_resultados, "  [", p,  ", ", tot, "]")
  
  link <- website %>%
    rvest::html_nodes(".grow a") %>%
    rvest::html_attr("href")
  
  output <- tibble::tibble(sentencia, path = link) %>%
    dplyr::mutate(type = stringr::str_extract(.data$sentencia, "^(C|SU|T|A)"),
                  year = extract_year(.data$sentencia)) %>%
    dplyr::select(.data$sentencia, .data$type, .data$year, .data$path)
  
  return(output)
  
  
}
