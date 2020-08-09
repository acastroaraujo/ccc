
# internals ---------------------------------------------------------------

#' @importFrom rlang .data
#' @keywords internal
NULL

extract_year <- function(x) {
  stringr::str_extract(x, "\\d{2}$") %>%
    as.Date("%y") %>%
    format("%Y") %>%
    as.integer()
}


make_query <- function(x) {
  reserved_chrs <- c("!" = "%21", "\\$" = "%24", "&" = "%26", "'" = "\"", "\\(" = "%28", "\\)" = "%29", 
                     "\\*" = "%2A", "," = "%2C", ";" = "%3B", "=" = "%3D", ":" = "%3A",
                     "/" = "%2F", "\\?" = "%3F", "@" = "%40", "#" = "%23", "\\[" = "%5B", "\\]" = "%5D")
  
  stringr::str_replace_all(x, pattern = c(" +" = "+", reserved_chrs))
}

make_num_query <- function(x) {
  
  formato_num <- c("(^SU)-(\\d*)" = "\\1\\2", "(^A)-(\\d*)" = "\\1\\2",
                   "/(\\d+$)" = "-\\1")
  stringr::str_replace_all(x, formato_num)
  
}

extract_href_node <- function(x, input_node) {
  x %>%
    rvest::html_nodes(input_node) %>%
    rvest::html_attr("href")
}
