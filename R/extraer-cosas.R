
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


#' Extraer fecha
#'
#' @param texto el texto de la sentencia
#' @param sentencia el nombre de la sentencia (e.g. C-776-03)
#'
#' @return a Date object
#' @export 
#'
ccc_fecha <- function(sentencia, texto) {
  
  input <- texto %>% 
    stringr::str_extract(paste0("Bogot(a|", intToUtf8(225), "),? D\\.? ?C\\.?,? [^\\.]+\\(", extract_year(sentencia), "\\)\\.?"))
  
  d <- input %>% 
    stringr::str_extract("\\d{1,2}")
  
  y <- input %>% 
    stringr::str_extract("\\d{4}")
  
  m <- input %>% 
    stringr::str_extract("enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre") %>% 
    stringr::str_replace_all(c("enero" = "01", "febrero" = "02", "marzo" = "03", "abril" = "04", "mayo" = "05", "junio" = "06", "julio" = "07",
                      "agosto" = "08", "septiembre" = "09", "octubre" = "10", "noviembre" = "11", "diciembre" = "12"))
  
  as.Date(paste(y, m, d, sep = "-"))
  
}


# Temporal, el output deberia ser algo asi:
# https://www.datos.gov.co/Justicia-y-Derecho/Sentencias-Corte-Constitucional-2019/5wc9-ajax

# ccc_magistrados <- function(texto) {
#   
#   tipo <- c("Cópiese, comuníquese al Gobierno, insértese en la Gaceta de la Corte Constitucional, cúmplase y archívese el expediente.", 
#             "Notifíquese, comuníquese y cúmplase.")
#   
#   if (str_detect(texto, tipo[[1]])) {
#     
#     magistrado_string <- texto %>% 
#       stringr::str_extract(pattern = regex(paste0(tipo[[1]], ".+$"), dotall = TRUE)) %>% 
#       stringr::str_replace(tipo[[1]], "") 
#       
#     
#     magistrado_string %>% 
#       str_split("[:upper:][:lower:]+")
#     
#     We need to go back before the squish happens in the finding text function and use the white space to separate these people!!
#     
#   }
#   
#   
# }




