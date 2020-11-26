
#' Extractor de sentencias citadas
#'
#' @param texto el texto de una sentencia, tal y como viene de ccc_extraer_texto()
#'
#' @return una lista de sentencias citadas en el texto
#' @export
#'
ccc_sentencias_citadas <- function(texto) {
  
  mes <- "(enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre)"
  regex_ep <- paste0("(S|s)entencia (C|SU|T|A)-(\\d+) de(l \\d{1,2} de ", mes, " de)? \\d{2}(\\d{2})")
  
  texto %>%
    stringr::str_extract_all(regex_ep) %>%
    purrr::flatten_chr() %>%
    stringr::str_replace_all(pattern = regex_ep,
                             replacement = "\\2-\\3-\\6")
  
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


#' Información sobre magistrados
#'
#' @param texto el texto de la sentencia
#'
#' @return a tibble with names and information for each Justice
#' @export
#'
ccc_magistrados <- function(texto) {

    tipo <- c(
      "Cópiese, notifíquese, comuníquese y cúmplase\\.?",
      "Notifíquese, comuníquese y cúmplase\\.?",
      "Cópiese, comuníquese al Gobierno, insértese en la Gaceta de la Corte Constitucional, cúmplase y archívese el expediente\\.?",
      "Notifíquese, comuníquese, insértese en la Gaceta de la Corte Constitucional y cúmplase\\.?",
      "Notifíquese, comuníquese, publíquese, insértese en la Gaceta de la Corte Constitucional y archívese el expediente\\.?",
      "Comuníquese, notifíquese, cúmplase e insértese en la Gaceta de la Corte Constitucional\\.?",
      "Notifíquese, comuníquese, cúmplase, publíquese, insértese en la Gaceta de la Corte Constitucional y archívese el expediente\\.?",
      "Notifíquese, comuníquese, publíquese en la Gaceta de la Corte Constitucional y cúmplase,",
      "Comuníquese, notifíquese y cúmplase\\.",
      "Notifíquese, comuníquese, insértese en la Gaceta de la Corte Constitucional, cúmplase y archívese el expediente\\.",
      "Cópiese, notifíquese, comuníquese e insértese en la Gaceta de la Corte Constitucional, cúmplase y archívese el expediente\\.",
      "Cópiese, notifíquese, comuníquese, insértese en la Gaceta de la Corte Constitucional, cúmplase y archívese el expediente\\.",
      "Cópiese, notifíquese, comuníquese, publíquese en la Gaceta de la Corte Constitucional y cúmplase\\."
    )

    index <- stringr::str_detect(texto, tipo)
    
    if (!any(index)) stop(call. = FALSE, "uknown pattern")

    magistrado_string <- texto %>%
      stringr::str_extract(stringr::regex(paste0(tipo[index], ".+$"), dotall = TRUE)) %>% 
      stringr::str_remove("\\[1\\].+") %>% 
      stringr::str_extract("(.+ Secretari(a|o) General)") %>% 
      stringr::str_remove(tipo[index]) %>% 
      stringr::str_squish()
      
      nombres <- magistrado_string %>% 
        stringr::str_extract_all("[[:upper:] ]{2,}(?=[:upper:][:lower:]+)") %>% 
        unlist() %>% 
        stringr::str_squish()
        
      info <- magistrado_string %>% 
        stringr::str_split(paste0(nombres, collapse = "|")) %>% 
        unlist() %>% 
        stringr::str_squish() 
      
      tibble::tibble(
        nombre = stringr::str_to_title(nombres), 
        info = info[info != ""]
        ) 
      
}


# Temporal, el output deberia ser algo asi:
# https://www.datos.gov.co/Justicia-y-Derecho/Sentencias-Corte-Constitucional-2019/5wc9-ajax




