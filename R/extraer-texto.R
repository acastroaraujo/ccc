
#' Extractor de sentencia
#'
#' @param path la dirección de la sentencia (e.g. "/relatoria/2006/C-355-06.htm")
#'
#' @return el texto de la sentencia
#' @export
#'
ccc_texto <- function(path) {
  
  if (!stringr::str_detect(path, pattern = "\\.htm")) stop(call. = FALSE, "la dir. debe terminar en .htm")
  message("Descargando: ", path)
  
  website <- httr::RETRY("GET", paste0("https://www.corteconstitucional.gov.co", path)) %>% 
    xml2::read_html(encoding = "latin1")
  
  ## PROVISIONAL:
  ## el problema está en que el formato cambia, dependiendo del año
  ## entonces todo es inconsistente
  
  output <- website %>%
    rvest::html_nodes(".WordSection1") %>%
    rvest::html_text() %>%
    stringr::str_squish()
  
  if (purrr::is_empty(output)) {
    output <- website %>%
      rvest::html_nodes(".Section1") %>%
      rvest::html_text() %>%
      stringr::str_squish()
  }
  
  if (purrr::is_empty(output)) {
    output <- website %>%
      rvest::html_nodes(".MsoNormal") %>%
      rvest::html_text() %>%
      stringr::str_squish()
  }
  
  return(paste(output, collapse = " "))
}

#' Extractor de pie de páginas
#'
#' @param path la dirección de la sentencia (e.g. "/relatoria/2006/C-355-06.htm")
#'
#' @return un vector de pies de página
#' @export
#'
ccc_pp <- function(path) {
  
  if (!stringr::str_detect(path, pattern = "\\.htm")) stop(call. = FALSE, "la dir. debe terminar en .htm")
  message("Descargando: ", path)
  
  website <- httr::RETRY("GET", paste0("https://www.corteconstitucional.gov.co", path)) %>% 
    xml2::read_html(encoding = "latin1")
  
  output <- website %>%
    rvest::html_nodes(".amplia div div p") %>%
    rvest::html_text() 
  
  tibble::tibble(output) %>%  ## provisional, el resultado debe ser un vector con length = número de citas
    dplyr::mutate(index = cumsum(stringr::str_starts(.data$output, "\\[\\d+\\]"))) %>% 
    dplyr::group_by(.data$index) %>% 
    dplyr::summarize(output = paste(.data$output, collapse = "\n")) %>% 
    dplyr::pull(.data$output) %>% 
    stringr::str_squish()
  
}

#' Extractor de sentencia y pies de página
#'
#' @param path la dirección de la sentencia (e.g. "/relatoria/2006/C-355-06.htm")
#'
#' @return el texto de la sentencia y sus pies de página
#' @export
#'
ccc_texto_pp <- function(path) {
  
  if (!stringr::str_detect(path, pattern = "\\.htm")) stop(call. = FALSE, "la dir. debe terminar en .htm")
  message("Descargando: ", path)
  
  website <- httr::RETRY("GET", paste0("https://www.corteconstitucional.gov.co", path)) %>% 
    xml2::read_html(encoding = "latin1")
  
  ## Cuerpo
  
  body <- website %>%
    rvest::html_nodes(".WordSection1") %>%
    rvest::html_text() %>%
    stringr::str_squish()
  
  if (purrr::is_empty(body)) {
    body <- website %>%
      rvest::html_nodes(".Section1") %>%
      rvest::html_text() %>%
      stringr::str_squish()
  }
  
  if (purrr::is_empty(body)) {
    body <- website %>%
      rvest::html_nodes(".MsoNormal") %>%
      rvest::html_text() %>%
      stringr::str_squish()
  }
  
  # Pies de página
  
  pp <- website %>%
    rvest::html_nodes(".amplia div div p") %>%
    rvest::html_text() %>% 
    stringr::str_squish()
  
  body <- paste(body, collapse = " ")
  pp <- paste(pp, collapse = " ")
  
  return(paste(body, pp, collapse = " "))
  
}


# year <- 2006
# css_type <- dplyr::case_when(
#   year == 2003 ~ ".Section1 span"
# )


