## función provisional
## el problema está en que el formato cambia, dependiendo del año
## entonces todo es inconsistente

#' Extractor de sentencia
#'
#' @param link la dirección de la sentencia (e.g. "/relatoria/2006/C-355-06.htm")
#'
#' @return el texto de la sentencia
#' @export
#'
ccc_texto <- function(link) {
  website <- paste0("https://www.corteconstitucional.gov.co", link) %>%
    xml2::read_html()

  output <- website %>%
    rvest::html_nodes(".WordSection1") %>%
    rvest::html_text() %>%
    stringr::str_squish()

  if (purrr::is_empty(output)) {
    output <- website %>%
      rvest::html_nodes(".MsoNormal") %>%
      rvest::html_text() %>%
      stringr::str_squish()
  }

  cat(".")
  return(paste(output, collapse = " "))
}


#' Extractor de sentencias citadas
#'
#' @param texto el texto de una sentencia, tal y como viene de ccc_extraer_texto()
#'
#' @return una lista de sentencias citadas en el texto
#' @export
#'
ccc_sentencias_citadas <- function(texto) {
  texto %>%
    stringr::str_extract_all("(S|s)entencia (C|SU|T|A)-\\d+ de \\d{4}") %>%
    purrr::flatten_chr() %>%
    stringr::str_replace_all(pattern = "(S|s)entencia ([TCSU]{1,2}-\\d+) de \\d{2}(\\d{2})",
                             replacement = "\\2-\\3")
}


#' Extractor de pie de páginas
#'
#' @param link (e.g. "/relatoria/2006/C-355-06.htm")
#'
#' @return una lista de pies de página
#' @export
#'
ccc_pp <- function(link) {
  stopifnot(stringr::str_detect(link, pattern = "\\.htm"))
  website <- paste0("https://www.corteconstitucional.gov.co", link) %>%
    xml2::read_html()

  website %>%
    rvest::html_nodes(".amplia div div p") %>%
    rvest::html_text() %>%
    stringr::str_squish()

  ## Esto se puede mejorar de manera que length(pp) == número de pies de página
}
