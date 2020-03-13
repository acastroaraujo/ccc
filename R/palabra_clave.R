

#' Title
#'
#' @param q
#' @param p
#'
#' @return
#' @export
#'
#' @examples
palabra_clave <- function(q = "y", p = 0) {
  url <- paste0(
    "https://www.corteconstitucional.gov.co/relatoria/query.aspx?anio=/relatoria/",
    "&pg=", p,
    "&buscar=", stringr::str_replace(q, pattern = " +", "+")
  )

  obj <- httr::GET(url)
  stopifnot(httr::status_code(obj) == 200)
  website <- httr::content(obj)

  sentencia <- website %>%
    rvest::html_nodes(".grow a") %>%
    rvest::html_text() %>%
    stringr::str_squish()

  link <- website %>%
    rvest::html_nodes(".grow a") %>%
    rvest::html_attr("href")

  output <- tibble::tibble(sentencia, url = link) %>%
    dplyr::mutate(type = stringr::str_extract(sentencia, "^(C|SU|T|A)"),
                  year = extract_year(sentencia)) %>%
    dplyr::select(sentencia, type, year, url)

  return(output)
}


extract_year <- function(x) {
  stringr::str_extract(x, "\\d{2}$") %>%
    as.Date("%y") %>%
    format("%Y") %>%
    as.integer()
}
