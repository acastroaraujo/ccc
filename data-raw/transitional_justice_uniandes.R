
# setup -------------------------------------------------------------------

# project url: http://justiciatransicional.uniandes.edu.co/web/

library(tidyverse)

d <- read_rds("data-raw/fichas.rds")
pg <- read_rds("data-raw/perspectiva_global.rds")
dict <- read_rds("data-raw/dict_tema_eje_palabra.rds")

dict <- dict |> 
  mutate(across(where(is.character), textclean::replace_non_ascii))

# helpers -----------------------------------------------------------------

extract_words <- function(df, x) {
  
  df |>  
    mutate({{x}} := str_split({{x}}, "\n")) |>  
    unnest(cols = {{x}}, keep_empty = TRUE) |>  
    filter({{x}} != "" | is.na({{x}})) |>  
    mutate({{x}} := str_squish(str_remove({{x}}, "- "))) |> 
    mutate({{x}} := textclean::replace_non_ascii({{x}}))
  
}

# dict --------------------------------------------------------------------

dict_et_pc <- dict |> 
  select(palabra_clave, eje_tematico) |> 
  drop_na() |> 
  deframe()

dict_tp_et <- dict |> 
  select(eje_tematico, tema_principal) |> 
  drop_na() |> 
  deframe()

# edge list ---------------------------------------------------------------

jctt_edge_list <- pg |> 
  filter(tipo_de_fuente != "Normas nacionales") |> 
  mutate(type = str_extract(sentencia, "^(C|SU|T|A)")) |> 
  select(from = sentencia, to = descripcion, type, to_source = tipo_de_fuente, to_nature = naturaleza, to_system = sistema_general, date = fecha, president = periodo_presidencial) |> 
  mutate(to_source = ifelse(
    test = to_source == "Normas jurídicas internacionales",
    yes = to_nature,
    no = to_source
  )) |> 
  select(-to_nature) |> 
  ## remove accents
  mutate(across(where(is.character), textclean::replace_non_ascii))

# cases -------------------------------------------------------------------

d <- d |>
  rename(id = numero_de_caso, date = fecha, precedent = precedente, president = gobierno, crimes = tipos_crimenes, mp = magistrados_ponentes, msv = magistrados_salvaron_voto, mav = magistrados_aclararon_voto) |> 
  mutate(type = str_extract(id, "^(C|SU|T|A)")) |> 
  mutate(date = as.Date(date)) |> 
  select(id, type, date, precedent, crimes, president, mp, msv, mav, tema_principal = temas_principales, eje_tematico = ejes_tematicos, palabra_clave = palabras_claves, href = url) 

pc <- d |> 
  select(id, palabra_clave) |> 
  extract_words(palabra_clave) |> 
  drop_na() |> 
  mutate(eje_tematico = dict_et_pc[palabra_clave]) 

et <- d |> 
  select(id, eje_tematico) |> 
  extract_words(eje_tematico) |> 
  drop_na() |> 
  mutate(tema_principal = dict_tp_et[eje_tematico]) 

tp <- d |> 
  select(id, tema_principal) |> 
  extract_words(tema_principal) 

keywords <- tp |> 
  left_join(et) |> 
  left_join(pc) |> 
  nest(keywords = !id)

msv <- d |> 
  select(id, msv) |> 
  extract_words(msv) |> 
  mutate(msv = textclean::replace_non_ascii(msv)) |> 
  nest(msv = msv)

mav <- d |> 
  select(id, mav) |> 
  extract_words(mav) |>
  mutate(mav = textclean::replace_non_ascii(mav)) |> 
  nest(mav = mav)

mp <- d |> 
  select(id, mp) |> 
  extract_words(mp) |> 
  mutate(mp = textclean::replace_non_ascii(mp)) |> 
  nest(mp = mp)

crimes <- d |> 
  select(id, crimes) |> 
  extract_words(crimes) |> 
  mutate(crimes = textclean::replace_non_ascii(crimes)) |> 
  nest(crimes = crimes)

d <- d |> 
  select(-tema_principal, -eje_tematico, -palabra_clave, -mp, -msv, -mav, -crimes)

jctt_cases <- d |> 
  left_join(keywords) |> 
  left_join(crimes) |> 
  left_join(mp) |> 
  left_join(msv) |> 
  left_join(mav)

usethis::use_data(jctt_cases, overwrite = TRUE)
usethis::use_data(jctt_edge_list, overwrite = TRUE)
