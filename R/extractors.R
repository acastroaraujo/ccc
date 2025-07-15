#' Extractor de sentencias citadas
#'
#' @param texto el texto de una sentencia, tal y como viene de ccc_extraer_texto()
#'
#' @return una lista de sentencias citadas (C, SU, o T) en el texto.
#' @export
#'
extract_citations <- function(texto) {
  mes <- "([Ee]nero|[Ff]ebrero|[Mm]arzo|[Aa]bril|[Mm]ayo|[Jj]unio|[Jj]ulio|[Aa]gosto|[Ss]eptiembre|[Oo]ctubre|[Nn]oviembre|[Dd]iciembre)"

  ## This is the most general pattern, it should capture most cases
  regex1 <- paste0(
    "\\b(C|SU|T) ?(\\p{Pd}| ) ?(\\d{3,4}[Aa]?) ?del?( \\d{1,2} de ",
    mes,
    " de)?( ",
    mes,
    " \\d{1,2} del?)? \\d\\.?\\d(\\d{2})\\b"
  )

  # This pattern is common in the footnotes, but it also captures the name of the document
  # Thus, remember to remove self-citations
  regex2 <- "\\b(C|SU|T) ?(\\p{Pd}| ) ?(\\d{3,4}[Aa]?)(?:\\/|\\p{Pd})(?:\\d{2})?(\\d{2})\\b"

  ## This pattern tries to capture cases that are expressed in list-like fashion
  regex3 <- "\\b((?:C|SU|T)(?:\\p{Pd}| ) ?\\d{3,4}[Aa]?(?:, | y ))+[CSUT\\p{Pd} \\d, ]*de \\d{4}"

  out1 <- texto |>
    stringr::str_extract_all(regex1) |>
    purrr::flatten_chr() |>
    stringr::str_replace_all(pattern = regex1, replacement = "\\1-\\3-\\8")

  out2 <- texto |>
    stringr::str_extract_all(regex2) |>
    purrr::flatten_chr() |>
    stringr::str_replace_all(pattern = regex2, replacement = "\\1-\\3-\\4")

  out3 <- texto |>
    stringr::str_extract_all(regex3) |>
    purrr::flatten_chr() |>
    purrr::map(function(x) {
      suffix <- unlist(stringr::str_extract(x, regex1)) |>
        stringr::str_extract("\\d{2}$")

      output <- x |>
        stringr::str_extract_all("(C|SU|T) ?(\\p{Pd}| ) ?(\\d+)") |>
        purrr::flatten_chr() |>
        paste0("-", suffix) |>
        stringr::str_remove_all("[:space:]")

      output[-length(output)] ## the last case should have already been identified in out1
    }) |>
    purrr::flatten_chr()

  return(toupper(c(out1, out2, out3)))
}


ccc_leyes_citadas <- function(texto) {
  texto |>
    stringr::str_extract_all("(L|l)ey \\d+ de \\d{4}") |>
    purrr::flatten_chr()
}
