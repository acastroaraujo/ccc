

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
    "&buscar=", stringr::str_replace(q, pattern = " +", "+")
  )

  obj <- httr::GET(url)
  stopifnot(httr::status_code(obj) == 200)
  website <- httr::content(obj)

  num_resultados <- website %>%
    rvest::html_text() %>%
    stringr::str_extract("Total de Registros --> \\d+")

  message(num_resultados)

  sentencia <- website %>%
    rvest::html_nodes(".grow a") %>%
    rvest::html_text() %>%
    stringr::str_squish()

  link <- website %>%
    rvest::html_nodes(".grow a") %>%
    rvest::html_attr("href")

  output <- tibble::tibble(sentencia, url = link) %>%
    dplyr::mutate(type = stringr::str_extract(.data$sentencia, "^(C|SU|T|A)"),
                  year = extract_year(.data$sentencia)) %>%
    dplyr::select(.data$sentencia, .data$type, .data$year, .data$url)

  return(output)
}


extract_year <- function(x) {
  stringr::str_extract(x, "\\d{2}$") %>%
    as.Date("%y") %>%
    format("%Y") %>%
    as.integer()
}
