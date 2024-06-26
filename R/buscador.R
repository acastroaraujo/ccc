

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
      "fini" = as.character(date_start), 
      "ffin" = as.character(date_end), 
      "buscar_por" = text,
      "accion" = "search",
      "OrderbyOption" = "des__score",
      "maxprov" = "10000",
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



#' Clean Search Data
#'
#' @param df a data frame, as created by ccc_search()
#'
#' @return a data frame
#' @export
#'
ccc_clean_dataset <- function(df) {
  
  df |> 
    ## keep subset of variables
    dplyr::select("id" = "providencia", "date" = "fecha_sentencia", "file" = "expediente", "mp" = "magistrado_s_ponentes", "descriptors" = "tema_subtema", "date_public" = "f_public", "url") |> 
    ## turn characters into dates
    dplyr::mutate(
      date = as.Date(.data$date), 
      date_public = as.Date(.data$date_public)
    ) |> 
    ## Add year
    dplyr::mutate(year = as.integer(format(.data$date, "%Y"))) |> 
    ## Remove white spaces
    dplyr::mutate(id = stringr::str_replace_all(.data$id, "[:space:]", "")) |> 
    ## Removes any character at the end that's NOT a number
    dplyr::mutate(id = stringr::str_remove(.data$id, "[^\\d]+$")) |> 
    ## Replaces, e.g., C-776/03 with C-776-03
    dplyr::mutate(id = stringr::str_replace_all(.data$id, "\\.|\\/", "-")) |> 
    ## Extract prefix
    dplyr::mutate(type = stringr::str_extract(.data$id, "^(C|SU|T|A)")) |> 
    ## Filter out "Autos"
    dplyr::mutate(type = factor(.data$type)) |> 
    ## remove all spanish accents
    dplyr::mutate(dplyr::across(dplyr::where(is.character), \(x) stringi::stri_trans_general(x, "Latin-ASCII"))) |> 
    ## Clarify NAs
    dplyr::mutate(dplyr::across(dplyr::where(is.character), \(x) ifelse(stringr::str_detect(x, "(s|S)in (i|I)nformacion"), NA_character_, x))) |> 
    ## In case of duplicates, the following two lines keep the case  with the 
    ## earliest date. A handful of cases were uploaded to the database twice 
    ## on different dates.
    dplyr::arrange(.data$date) |>      
    dplyr::distinct(.data$id, .keep_all = TRUE) |> 
    ## get mp into list-column
    dplyr::mutate(mp = tolower(.data$mp)) |> 
    dplyr::mutate(mp = stringr::str_remove_all(.data$mp, "\\(conjuez\\)")) |> 
    dplyr::mutate(mp = stringr::str_split(.data$mp, "\r\n")) |> 
    dplyr::mutate(mp = purrr::map(.data$mp, stringr::str_squish)) |> 
    ## get descriptors into list-column
    dplyr::mutate(descriptors = stringr::str_split(.data$descriptors, "\r\n")) |> 
    dplyr::mutate(descriptors = purrr::map(.data$descriptors, stringr::str_squish)) |> 
    dplyr::relocate("id", "type", "year", "date", "descriptors", "mp", "date_public", "file", "url") 
  
}

## To do: query builder
# make_text_query <- function(text, AND = NULL, OR = NULL, NOT = NULL) {
#   
#   if (!purrr::is_empty(AND)) {
#     AND <- paste0("text_word_And", "...x", "=", AND)
#   }
#   if (!purrr::is_empty(OR)) {
#     OR <- paste0("text_word_Or", "...x", "=", OR)
#   }
#   if (!purrr::is_empty(NOT)) {
#     NOT <- paste0("text_word_Not", "...x", "=", NOT)
#   }
#   
#   i <- purrr::map_dbl(list(AND, OR, NOT), length)
#   text_plus <- stringr::str_replace_all(c(AND, OR, NOT), pattern = "...x", as.character(1:sum(i)))
#   
#   reserved_chrs <- c(
#     "!" = "%21", "\\$" = "%24", "&" = "%26", "'" = "\"", "\\(" = "%28", "\\)" = "%29", 
#     "\\*" = "%2A", "," = "%2C", ";" = "%3B", "=" = "%3D", ":" = "%3A",
#     "/" = "%2F", "\\?" = "%3F", "@" = "%40", "#" = "%23", "\\[" = "%5B", "\\]" = "%5D"
#   )
#   
#   text <- stringr::str_replace_all(text, pattern = c(" +" = "+", reserved_chrs))
#   
#   return(paste(c(text, text_plus), collapse = "&"))
#   
# }



