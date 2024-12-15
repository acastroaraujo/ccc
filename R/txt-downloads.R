
#' Download Text (RTF)
#'
#' @param url character string
#'
#' @return a text 
#' @export
#'
ccc_rtf <- function(url) {
  
  if (!stringr::str_detect(url, pattern = "\\.htm")) stop(call. = FALSE, "el url debe terminar en .htm")
  message(url)
  
  input <- httr::RETRY("GET", url, httr::user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"))
  
  link_rtf <- input |> 
    httr::content(encoding = "latin1") |> 
    rvest::html_elements("a") |> 
    rvest::html_attr("href") |> 
    purrr::pluck(1)
  
  out <- striprtf::read_rtf(stringr::str_squish(paste0("https://www.corteconstitucional.gov.co/", link_rtf)), encoding = "latin1")
  
  return(paste(out, collapse = "\n"))
  
}

#' Download Text
#'
#' This function is necessary because many rtf files don't contain footnotes
#' and many footnotes contain citations.
#' 
#' @param url character string
#'
#' @return text
#' @export
#'
ccc_txt <- function(url) {
  
  if (!stringr::str_detect(url, pattern = "\\.htm")) stop(call. = FALSE, "el url debe terminar en .htm")
  message(url)
  
  input <- httr::RETRY("GET", url, httr::user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36")) 
  stopifnot(httr::status_code(input) == 200)
  website <- rvest::read_html(input)
  
  selector <- ".amplia div"
  
  out <- website |> 
    rvest::html_elements(selector) |> 
    rvest::html_text() 
  
  if (purrr::is_empty(out)) {
    selector <- "div"

    out <- website |> 
      rvest::html_elements(selector) |> 
      rvest::html_text()
  } 
  
  keep <- website |>                        ## this chunk
    rvest::html_elements(selector) |>       ## indexes all
    rvest::html_attrs()  |>                 ## redundant
    purrr::map(\(x) names(x)) |>            ## footnotes
    purrr::map_lgl(\(x) {
      if (purrr::is_empty(x)) TRUE else !stringr::str_detect(x[[1]], "id")
    }) 
  
  out <- paste(out[keep], collapse = "") |> 
    stringr::str_replace_all("(?!\\w)\r\n(?=\\w)", " ")
  
  #if (stringr::str_detect(out, pattern = "[\u0090-\u0099]")) out <- iconv(out, "UTF-8", "latin1")
    
  return(out)
  
}
