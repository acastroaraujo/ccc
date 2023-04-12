
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
- `ccc_clean_data`
- `ccc_txt`
- `ccc_rtf`
- `extract_citations`

And the following datasets:

- `metadata`
- `citations`
- `docterms`

## Download

Use the `ccc_search()` function to lookup some cases.

``` r
library(ccc)
library(dplyr)

results <- ccc_search(text = "familia", date_start = "1999-01-01",
    date_end = "2001-12-31")

glimpse(results)
## Rows: 2,257
## Columns: 15
## $ relevancia       <dbl> 17.653, 15.540, 14.595, 12.729, 12.425, 12.051, 10.50…
## $ providencia      <chr> "T-1045/01", "T-244/00", "T-597/01", "T-1135/00", "C-…
## $ tipo             <chr> "Tutela", "Tutela", "Tutela", "Tutela", "Constitucion…
## $ f_sentencia      <chr> "2001-10-03", "2000-03-03", "2001-06-07", "2000-08-30…
## $ autoridades      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ demandado        <chr> "Sin Información", "", "", "", "", "", "", "", "", ""…
## $ demandante       <chr> "MARIA SANDRA CRUZ PERDOMO VS. INVERSIONES RESCOL S.A…
## $ descriptores     <chr> "ACCION DE TUTELA-No es la vía para definición de exi…
## $ expediente       <chr> "469070", "T-247550", "T-427617", "T-327235 Y OTROS",…
## $ f_public         <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "…
## $ magistrado_otros <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ magistrados      <chr> "Alvaro Tafur Galvis", "Fabio Morón Díaz", "Rodrigo E…
## $ normas           <chr> "", "", "", "", "LEY 466 DE 1998. “POR MEDIO DE LA CU…
## $ sintesis         <chr> "Sin Información", "Sin Información", "Sin Informació…
## $ url              <chr> "https://www.corteconstitucional.gov.co/relatoria/200…
```

This data is a little messy. The `ccc_clean_dataset()` provides some
useful tidying, but you might want to consider doing things differently.

``` r
df <- ccc_clean_dataset(results)
glimpse(df)
## Rows: 2,257
## Columns: 9
## $ id          <chr> "C-002-99", "T-015-99", "T-014-99", "T-008-99", "T-009-99"…
## $ type        <fct> C, T, T, T, T, T, T, T, T, T, T, T, T, C, T, T, T, T, T, S…
## $ year        <int> 1999, 1999, 1999, 1999, 1999, 1999, 1999, 1999, 1999, 1999…
## $ date        <date> 1999-01-20, 1999-01-21, 1999-01-21, 1999-01-21, 1999-01-2…
## $ file        <chr> "D-2104", "177540", "166086 Y OTROS", "191438 Y OTROS", "1…
## $ mp          <list> "antonio barrera carbonell", "alejandro martinez caballer…
## $ descriptors <list> <"SENTENCIA DE CONSTITUCIONALIDAD-Efectos retroactivos", …
## $ date_public <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ url         <chr> "https://www.corteconstitucional.gov.co/relatoria/1999/C-0…
```

Next you’ll want to download some texts. You can use either `ccc_txt()`
or `ccc_rtf()` (*Rich Text Format*) to do this.

I prefer `ccc_txt()` because most rtf files don’t include footnotes.

``` r
url <- sample(df$url, 1)

## download from the following url
url
## [1] "https://www.corteconstitucional.gov.co/relatoria/2000/SU1721-00.htm"

txt <- ccc_txt(url)
## https://www.corteconstitucional.gov.co/relatoria/2000/SU1721-00.htm

txt |>
    ## truncated output
stringr::str_trunc(1000) |>
    cat()
## 
##  Sentencia  SU.1721/00
## 
##  
##  INDEFENSION-Persona respecto a medios de información/ACCION DE TUTELA CONTRA MEDIOS DE COMUNICACION-Solicitud previa de rectificación de datos publicados
## 
##  
##  LIBERTAD DE EXPRESION-Prevalencia cuando entra en conflicto con otros derechos fundamentales
## 
##  
##  La primacía de la libertad de expresión cuando entra en conflicto con otros derechos fundamentales, se explica precisamente por el criterio finalista de protección social que ostenta la libertad de expresión, particularmente cuando ella se ejercita mediante los medios de comunicación establecidos. En ese orden de ideas se reconoce que tratándose de la libertad de expresión respecto de la gestión pública, los derechos al buen nombre tienen un ámbito de mayor restricción, que cuando se trata de ese derecho frente a los particulares.
## 
##  
##  RECTIFICACION DE INFORMACION-Finalidad/RECTIFICACION DE INFORMACION-Diario el Tiempo
## 
##  
##  La rectificación prevista en el Estatuto Superior, referida en la ju...
```

Finally, you can `extract_citations()` easily as follows:

``` r
extract_citations(txt)
##  [1] "T-602-95" "T-066-98" "T-472-96" "T-066-98" "T-595-93" "T-611-92"
##  [7] "T-066-98" "T-066-98" "T-368-98" "T-066-98" "T-066-98" "T-472-96"
## [13] "T-066-98"
```

## Data

There are 3 built-in datasets in this package, which cover 30 years
after the first ruling was published.

``` r
glimpse(citations)
## Rows: 629,848
## Columns: 5
## $ from      <fct> C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, …
## $ to        <fct> C-004-93, C-007-01, C-008-17, C-030-03, C-037-96, C-041-93, …
## $ weight    <int> 1, 1, 2, 1, 3, 1, 4, 4, 1, 3, 2, 1, 3, 1, 2, 19, 2, 1, 5, 2,…
## $ from_date <date> 2018-01-24, 2018-01-24, 2018-01-24, 2018-01-24, 2018-01-24,…
## $ to_date   <date> 1993-01-14, 2001-01-17, 2017-01-18, 2003-01-28, 1996-02-05,…
```

``` r
glimpse(metadata)
## Rows: 27,157
## Columns: 9
## $ id          <chr> "T-001-92", "C-004-92", "T-002-92", "C-005-92", "T-003-92"…
## $ type        <fct> T, C, T, C, T, T, T, T, T, T, T, T, T, T, T, C, T, T, T, T…
## $ year        <int> 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992…
## $ date        <date> 1992-04-03, 1992-05-07, 1992-05-08, 1992-05-11, 1992-05-1…
## $ file        <chr> "117 Y OTROS", "R.E. 001", "644", "R.E. 003", "309", "T-22…
## $ mp          <list> "jose gregorio hernandez galindo", "eduardo cifuentes mun…
## $ descriptors <list> <"ACCION DE TUTELA TRANSITORIA-Improcedencia", "ACCION DE…
## $ date_public <date> NA, NA, 1992-02-08, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ url         <chr> "https://www.corteconstitucional.gov.co/relatoria/1992/T-0…
```

``` r
glimpse(docterms)
## Rows: 26,015,969
## Columns: 3
## $ doc_id <fct> C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-0…
## $ lemma  <fct> abierta, abierto, abordar, absoluta, abstracto, academia, acade…
## $ n      <int> 1, 1, 1, 1, 12, 3, 1, 2, 1, 7, 2, 1, 1, 1, 1, 2, 1, 1, 1, 3, 3,…
```

To see the process whereby these datasets were created, you can follow
the scripts
[here](https://github.com/acastroaraujo/ccc_datos/tree/master/data-raw).

You can get a document-term matrix instead of `docterms` easily with the
`create_dtm()` function. The result will be a very sparse matrix.

I recommend that you load the `Matrix` package if you’re going to work
with this object.

``` r
library(Matrix)

M <- create_dtm()
dim(M)
## [1] 27157 12644

mean(M == 0)  ## sparsity
## [1] 0.9242341
M[sample(nrow(M), 20), sample(ncol(M), 5)]  ## random subset
## 20 x 5 sparse Matrix of class "dgCMatrix"
##           pertinencia comparecer ilimitado busqueda cese
## C-878-11            1          .         .        .    .
## T-246-03            .          .         .        .    .
## T-564-02            .          .         .        .    .
## T-041-19            1          1         .        1    .
## T-497-13            .          .         .        .    .
## C-252-98            .          .         .        .    .
## SU-874-14           1          .         .        5    .
## T-264-21            .          .         .        .    .
## T-004-22            .          .         .        .    .
## C-1008-10           .          .         1        .    .
## T-269-13            .          .         .        .    .
## T-444-12            .          .         .        .    .
## T-329-05            .          .         .        .    .
## C-987-10            .          .         .        .    .
## C-1152-03           .          .         2        .    .
## T-217-03            .          .         .        .    .
## T-093-95            .          .         .        .    .
## C-917-01            .          .         .        .    .
## C-493-94            .          .         .        .    .
## C-048-94            .          .         .        .    .
```
