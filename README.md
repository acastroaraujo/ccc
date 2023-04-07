
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/logo.png" width="40%" />

# ccc

<!-- badges: start -->
<!-- badges: end -->

The `ccc` package helps get information from the Colombian
Constitutional Court.

You can install the current version from [GitHub](https://github.com/)
with:

``` r
# install.packages("devtools")
devtools::install_github("acastroaraujo/ccc")
```

It has the following functions:

- `ccc_search`
- `ccc_rtf`
- `ccc_text`
- `extract_citations`

For example

``` r
library(ccc)
## Para más información:
## https://www.corteconstitucional.gov.co/relatoria/

results <- ccc_search(
  text = "proceso de paz", 
  date_start = "1998-01-01", 
  date_end = "2022-01-01"
)

df <- ccc_clean_dataset(results)

dplyr::glimpse(df)
## Rows: 212
## Columns: 17
## $ id               <chr> "C-541-17", "T-051-19", "A-250A-21", "C-171-17", "C-5…
## $ type             <chr> "C", "T", "A", "C", "C", "C", "C", "A", "C", "C", "C"…
## $ year             <int> 2017, 2019, 2021, 2017, 2014, 2017, 2010, 2021, 2017,…
## $ date             <date> 2017-08-24, 2019-02-11, 2021-05-21, 2017-03-22, 2014…
## $ expediente       <chr> "RDL-023", "T-6775252 Y OTRO ACUMULADOS", "T-7585858"…
## $ ponentes         <chr> "Iván Humberto Escrucería Mayolo", "José Fernando Rey…
## $ descriptors      <chr> "CELERIDAD EN IMPLEMENTACION NORMATIVA DEL ACUERDO FI…
## $ date_public      <date> NA, 2019-02-18, 2021-09-06, NA, NA, NA, NA, 2022-01-…
## $ url              <chr> "https://www.corteconstitucional.gov.co/relatoria/201…
## $ relevancia       <dbl> 875.559, 863.457, 835.317, 818.081, 814.902, 806.421,…
## $ tipo             <chr> "Constitucionalidad", "Tutela", "Auto", "Constitucion…
## $ autoridades      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ demandado        <chr> "", "ALTO COMISIONADO PARA LA PAZ", "", "", "ACTO LEG…
## $ demandante       <chr> "REVISION CONSTITUCIONAL DEL DECRETO LEY 891 DE 2017"…
## $ magistrado_otros <chr> "Alberto Rojas Ríos(AV)\r\nAlejandro Linares Cantillo…
## $ normas           <chr> "Decreto Ley 891 de 2017.¦Revisión de constitucionali…
## $ sintesis         <chr> "Revisión de constitucionalidad del Decreto Ley 891 d…

url <- sample(df$url, 1)

txt <- ccc_text(url)
## https://www.corteconstitucional.gov.co/relatoria/2012/C-1050-12.htm

txt |> 
  stringr::str_trunc(1e3) |> 
  cat()
## 
## 
## Sentencia C-1050/12
## 
##  
## 
##  
## 
## EXPEDICION
## POR EL GOBIERNO DE PASAPORTES DIPLOMATICOS A CONGRESISTAS Y SECRETARIOS
## GENERALES DE SENADO Y CAMARA DE REPRESENTANTES-Inexequibilidad
## 
##  
## 
## Para la Sala Plena de la Corte Constitucional, la Ley
## 1501 de 2011 ha de ser declarada inexequible por violar la restricción
## constitucional que tiene el Congreso de la República de no interferir en el
## ejercicio de las competencias propias de otro poder. La expedición de
## pasaportes diplomáticos es una decisión del Gobierno Nacional que no puede ser
## tomada por el Congreso Nacional u ordenada por este de manera perentoria.  
## 
##  
## 
##  
## 
## NORMA SOBRE EXPEDICION DE
## PASAPORTE DIPLOMATICO A LOS CONGRESISTAS DE LA REPUBLICA-Trámite
## legislativo 
## 
##  
## 
## LIBERTAD DE CONFIGURACION
## LEGISLATIVA EN MATERIA  DE RELACIONES INTERNACIONALES-Ejercicio con
## deferencia y respeto a las facultades y funciones propias del Presidente de la
## República
## 
##  
## 
## LIBERTAD DE CONFIGURACION
## LEGISLATIVA-Límites const...

table(extract_citations(txt)) |> sort()
## 
##  C-047-01 C-1060-08 C-1065-08  C-169-01  C-226-02  C-243-06 C-253A-12  C-255-03 
##         1         1         1         1         1         1         1         1 
##  C-255-96  C-292-01  C-333-12  C-368-12  C-378-08  C-399-03  C-406-94  C-466-97 
##         1         1         1         1         1         1         1         1 
##  C-468-08  C-474-03  C-504-92  C-561-04  C-563-00  C-564-95  C-580-02  C-597-10 
##         1         1         1         1         1         1         1         1 
##  C-615-02  C-665-06  C-740-98  C-746-11  C-763-09  C-777-10  C-803-09  C-828-10 
##         1         1         1         1         1         1         1         1 
##  C-880-05  C-898-11 C-1050-12  C-151-93  C-370-06  C-398-11 
##         1         1         2         2         2         2
```

## Datasets

``` r
dplyr::glimpse(citations)
## Rows: 630,065
## Columns: 5
## $ from      <chr> "C-001-18", "C-001-18", "C-001-18", "C-001-18", "C-001-18", …
## $ to        <chr> "C-004-93", "C-007-01", "C-008-17", "C-030-03", "C-037-96", …
## $ from_date <date> 2018-01-24, 2018-01-24, 2018-01-24, 2018-01-24, 2018-01-24,…
## $ to_date   <date> 1993-01-14, 2001-01-17, 2017-01-18, 2003-01-28, 1996-02-05,…
## $ weight    <int> 1, 1, 2, 1, 3, 1, 4, 4, 1, 3, 2, 1, 3, 1, 2, 19, 2, 1, 5, 2,…
dplyr::glimpse(metadata)
## Rows: 37,591
## Columns: 14
## $ providencia      <chr> "T-612/92", "A. 024/92", "A. 023/92", "T-494/92", "A.…
## $ tipo             <chr> "Tutela", "Auto", "Auto", "Tutela", "Auto", "Auto", "…
## $ f_sentencia      <chr> "1992-12-16", "1992-09-24", "1992-09-17", "1992-08-12…
## $ autoridades      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ demandado        <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "…
## $ demandante       <chr> "JULIAN GARCIA Y OTRA", "REINALDO SUAREZ FLOREZ Y OTR…
## $ descriptores     <chr> "ACCION DE TUTELA-Vigencia                           …
## $ expediente       <chr> "3693 Y OTRO", "D-109 Y OTROS", "E-002", "1909", "D-1…
## $ f_public         <chr> "1993-02-08", "1992-09-24", "1992-09-17", "1992-08-28…
## $ magistrado_otros <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ magistrados      <chr> "Alejandro Martínez Caballero", "José Gregorio Hernán…
## $ normas           <chr> "", "", "Excusa Doctora LUZ FARIN VEGA, Contadora de …
## $ sintesis         <chr> "Sin Información", "No aceptó el impedimento plantead…
## $ url              <chr> "https://www.corteconstitucional.gov.co/relatoria/199…
```
