
#' Búscador de sentencias por índice temático
#'
#' @param q términos de búsqueda
#' @param p número de página (default es cero)
#'
#' @return un data frame
#' @export
#'
ccc_tema <- function(q, p = 0) {
  url <- paste0(
    "https://www.corteconstitucional.gov.co/relatoria/tematico.php?",
    "&pg=", p,
    "&sql=", stringr::str_replace_all(q, pattern = " +", "+")
  )

  obj <- httr::GET(url)
  stopifnot(httr::status_code(obj) == 200)
  website <- httr::content(obj)

  num_resultados <- website %>%
    rvest::html_text() %>%
    stringr::str_extract("Total de Registros --> \\d+")

  message(num_resultados)

  temas <- website %>%
    rvest::html_nodes(".cuadro p") %>%
    rvest::html_text() %>%
    stringr::str_remove("\\(.+\\)") %>%
    stringr::str_remove("^\\d+") %>%
    stringr::str_squish()

  if (purrr::is_empty(temas)) {
    return(NULL)
  }

  num_children <- 1:length(temas)
  input_nodes <- stringr::str_glue(".cuadro:nth-child({num_children}) a")

  link <- purrr::map(input_nodes, extract_href_node, x = website)

  output <- tibble::tibble(topic = temas, url = link) %>%
    tidyr::unnest(.data$url) %>%
    dplyr::mutate(sentencia = stringr::str_replace(.data$url, pattern = ".+\\/\\d{4}\\/([-ACSUT\\d]+)\\.htm", replacement = "\\1"),
                  type = stringr::str_extract(.data$sentencia, "^(C|SU|T|A)"),
                  year = extract_year(.data$sentencia)) %>%
    dplyr::select(.data$sentencia, .data$type, .data$year, .data$topic, .data$url)

  return(output)
}


extract_href_node <- function(x, input_node) {
  x %>%
    rvest::html_nodes(input_node) %>%
    rvest::html_attr("href")
}
