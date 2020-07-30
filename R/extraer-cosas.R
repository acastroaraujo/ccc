
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
  
  ## Ojo, creo que no estoy extrayendo autos, pero pues eso no debe importar mucho
  ## Crear función aparte??
}

#' Extractor de leyes citadas
#'
#' @param texto el texto de una sentencia, tal y como viene de ccc_extraer_texto()
#'
#' @return una lista de leyes citadas en el texto
#' @export
#'
ccc_leyes_citadas <- function(texto) {
  texto %>% 
    stringr::str_extract_all("(L|l)ey \\d+ de \\d{4}") %>% 
    purrr::flatten_chr()
}


