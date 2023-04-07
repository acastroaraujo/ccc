
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
  
  input <- httr::RETRY("GET", url)
  
  link_rtf <- input |> 
    httr::content(encoding = "latin1") |> 
    rvest::html_elements("a") |> 
    rvest::html_attr("href") |> 
    purrr::pluck(1)
  
  out <- striprtf::read_rtf(paste0("https://www.corteconstitucional.gov.co/", link_rtf))
  
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
ccc_text <- function(url) {
  
  if (!stringr::str_detect(url, pattern = "\\.htm")) stop(call. = FALSE, "el url debe terminar en .htm")
  message(url)
  
  input <- httr::RETRY("GET", url)
  website <- rvest::read_html(input, encoding = "latin1")
  
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
  
  return(paste(out[keep], collapse = ""))
  
}
