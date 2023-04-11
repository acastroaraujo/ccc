

#' Buscador de Sentencias
#'
#' @param text a text query
#' @param date_start yyyy/mm/dd
#' @param date_end yyyy/mm/dd 
#'
#' @return a data frame
#' @export
#'
ccc_search <- function(text, date_start, date_end) {
  
  date_start <- as.Date(date_start)
  date_end <- as.Date(date_end)
  
  if (date_start < as.Date("1992-01-01")) stop("date_start must be larger than 1991-12-31", call. = FALSE)
  if (date_end > Sys.Date()) stop("date_end must be lower than ", Sys.Date(), call. = FALSE)
  
  output <- httr::RETRY(
    verb = "POST",
    url = "https://www.corteconstitucional.gov.co/relatoria/buscador_new/views/search/result_export_excel.php",
    body = list(
      "searchOption" = "texto", 
      "finicio" = as.character(date_start), 
      "ffin" = as.character(date_end), 
      "buscar_por" = text,
      "buscador" = "buscador",
      "OrderbyOption" = "des__score",
      "cant_providencias" = "10000",
      "totprovidencias" = "undefined",
      "datos_exportar[0]" = "prov_sentencia",
      "datos_exportar[1]" = "prov_f_sentencia",
      "datos_exportar[2]" = "prov_magistrados",
      "datos_exportar[3]" = "prov_proceso_term",
      "datos_exportar[4]" = "prov_tipo",
      "datos_exportar[5]" = "prov_f_public",
      "datos_exportar[6]" = "prov_autoridades",
      "datos_exportar[7]" = "prov_expediente",
      "datos_exportar[8]" = "prov_demandado",
      "datos_exportar[9]" = "prov_demandante",
      "datos_exportar[10]" = "prov_normas",
      "datos_exportar[11]" = "prov_descriptores",
      "datos_exportar[12]" = "prov_sintesis"
    ),
    encode = "multipart"
  )
  
  stopifnot(httr::status_code(output) == 200)
  
  href <- rvest::read_html(output) |> 
    rvest::html_elements("table tr") |> 
    utils::tail(-1) |> ## remove header
    purrr::map_chr(function(x) {
      x |> ## Extract the first link of each row
        rvest::html_elements("a") |> 
        rvest::html_attr("href") |> 
        purrr::pluck(1)
    })
  
  df <- output |> 
    rvest::read_html() |> 
    rvest::html_table() |>
    purrr::pluck(1) |> 
    janitor::clean_names() |>
    dplyr::select(-"number")

  stopifnot(nrow(df) == length(href))
  df$url <- href
  return(df)
}


make_text_query <- function(text, AND = NULL, OR = NULL, NOT = NULL) {
  
  if (!purrr::is_empty(AND)) {
    AND <- paste0("text_word_And", "...x", "=", AND)
  }
  if (!purrr::is_empty(OR)) {
    OR <- paste0("text_word_Or", "...x", "=", OR)
  }
  if (!purrr::is_empty(NOT)) {
    NOT <- paste0("text_word_Not", "...x", "=", NOT)
  }
  
  i <- purrr::map_dbl(list(AND, OR, NOT), length)
  text_plus <- stringr::str_replace_all(c(AND, OR, NOT), pattern = "...x", as.character(1:sum(i)))
  
  reserved_chrs <- c(
    "!" = "%21", "\\$" = "%24", "&" = "%26", "'" = "\"", "\\(" = "%28", "\\)" = "%29", 
    "\\*" = "%2A", "," = "%2C", ";" = "%3B", "=" = "%3D", ":" = "%3A",
    "/" = "%2F", "\\?" = "%3F", "@" = "%40", "#" = "%23", "\\[" = "%5B", "\\]" = "%5D"
  )
  
  text <- stringr::str_replace_all(text, pattern = c(" +" = "+", reserved_chrs))
  
  return(paste(c(text, text_plus), collapse = "&"))
  
}


#' Clean Dataset
#'
#' @param df a data frame, as created by ccc_search()
#'
#' @return a data frame
#' @export
#'
ccc_clean_dataset <- function(df) {
  
  df |> 
    dplyr::mutate(f_sentencia = as.Date(.data$f_sentencia), f_public = as.Date(.data$f_public)) |> 
    dplyr::mutate(year = as.integer(format(.data$f_sentencia, "%Y"))) |> 
    dplyr::mutate(type = stringr::str_extract(.data$id, "^(C|SU|T|A)")) |> 
    dplyr::relocate("id", "type", "year", "date" = "f_sentencia", "expediente", "ponentes" = "magistrados", "descriptors" = "descriptores", "date_public" = "f_public", "url")
  
}



## ccc_clean_dataset <- function(df) {
##   
##   df |> 
##     ## removes white spaces
##     dplyr::mutate(providencia = stringr::str_replace_all(.data$providencia, "[:space:]", "")) |> 
##     ## removes any character at the end that's NOT a number
##     dplyr::mutate(providencia = stringr::str_remove(.data$providencia, "[^\\d]+$")) |> 
##     ## replaces, e.g., C-776/03 with C-776-03
##     dplyr::mutate(providencia = stringr::str_replace_all(.data$providencia, "\\.|\\/", "-")) |> 
##     dplyr::mutate(f_sentencia = as.Date(.data$f_sentencia), f_public = as.Date(.data$f_public)) |> 
##     dplyr::mutate(year = as.integer(format(.data$f_sentencia, "%Y"))) |> 
##     dplyr::mutate(type = stringr::str_extract(.data$providencia, "^(C|SU|T|A)")) |> 
##     dplyr::relocate("id" = "providencia", "type", "year", "date" = "f_sentencia", "expediente", "ponentes" = "magistrados", "descriptors" = "descriptores", "date_public" = "f_public", "url")
##   
## }
