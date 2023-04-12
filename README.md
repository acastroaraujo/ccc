
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

These datasets were created using these
[scripts](https://github.com/acastroaraujo/ccc/tree/master/data-raw).

## Data

``` r
library(ccc)
library(dplyr)
```

There are 3 built-in datasets in this package, which cover 30 years
after the first ruling was published.

``` r
glimpse(citations)
# Rows: 629,848
# Columns: 5
# $ from      <fct> C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, …
# $ to        <fct> C-004-93, C-007-01, C-008-17, C-030-03, C-037-96, C-041-93, …
# $ weight    <int> 1, 1, 2, 1, 3, 1, 4, 4, 1, 3, 2, 1, 3, 1, 2, 19, 2, 1, 5, 2,…
# $ from_date <date> 2018-01-24, 2018-01-24, 2018-01-24, 2018-01-24, 2018-01-24,…
# $ to_date   <date> 1993-01-14, 2001-01-17, 2017-01-18, 2003-01-28, 1996-02-05,…
```

``` r
glimpse(metadata)
# Rows: 27,157
# Columns: 9
# $ id          <chr> "T-001-92", "C-004-92", "T-002-92", "C-005-92", "T-003-92"…
# $ type        <fct> T, C, T, C, T, T, T, T, T, T, T, T, T, T, T, C, T, T, T, T…
# $ year        <int> 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992…
# $ date        <date> 1992-04-03, 1992-05-07, 1992-05-08, 1992-05-11, 1992-05-1…
# $ file        <chr> "117 Y OTROS", "R.E. 001", "644", "R.E. 003", "309", "T-22…
# $ mp          <list> "jose gregorio hernandez galindo", "eduardo cifuentes mun…
# $ descriptors <list> <"ACCION DE TUTELA TRANSITORIA-Improcedencia", "ACCION DE…
# $ date_public <date> NA, NA, 1992-02-08, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
# $ url         <chr> "https://www.corteconstitucional.gov.co/relatoria/1992/T-0…
```

``` r
glimpse(docterms)
# Rows: 26,015,969
# Columns: 3
# $ doc_id <fct> C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-0…
# $ lemma  <fct> abierta, abierto, abordar, absoluta, abstracto, academia, acade…
# $ n      <int> 1, 1, 1, 1, 12, 3, 1, 2, 1, 7, 2, 1, 1, 1, 1, 2, 1, 1, 1, 3, 3,…
```

You can get a document-term matrix instead of `docterms` easily with the
`create_dtm()` function. The result will be a very sparse matrix.

I recommend that you load the `Matrix` package if you’re going to work
with this object.

``` r
library(Matrix)

M <- create_dtm()
dim(M)
# [1] 27157 12644

mean(M == 0) ## sparsity
# [1] 0.9242341
M[sample(nrow(M), 20), sample(ncol(M), 5)] ## random subset
# 20 x 5 sparse Matrix of class "dgCMatrix"
#           urbanizacion llano plantearse incumplida clasificada
# T-682-13             .     .          .          .           .
# T-066-12             .     .          .          .           .
# T-383-94             1     .          .          .           .
# T-1531-00            .     .          .          .           .
# T-951-06             .     .          .          .           .
# C-795-14             .     .          .          .           .
# T-016-05             .     .          .          .           .
# T-213-14             .     .          .          .           .
# T-753-14             .     .          .          .           .
# C-350-09             .     .          .          .           .
# T-260-02             .     .          .          .           .
# T-174-95             .     .          .          .           .
# T-988-07             .     .          .          .           .
# T-354-08             .     .          .          .           .
# T-840-12             .     .          .          .           .
# T-297-05             .     .          .          .           .
# C-248-99             .     .          .          .           .
# T-625-97             .     .          .          .           .
# T-501-17             .     .          .          .           .
# T-1141-04            .     .          .          .           .
```

## Download

Use the `ccc_search()` function to look up some cases.

``` r
results <- ccc_search(
  text = "familia", 
  date_start = "1999-01-01", 
  date_end = "2001-12-31"
)

glimpse(results)
# Rows: 2,257
# Columns: 15
# $ relevancia       <dbl> 17.653, 15.540, 14.595, 12.729, 12.425, 12.051, 10.50…
# $ providencia      <chr> "T-1045/01", "T-244/00", "T-597/01", "T-1135/00", "C-…
# $ tipo             <chr> "Tutela", "Tutela", "Tutela", "Tutela", "Constitucion…
# $ f_sentencia      <chr> "2001-10-03", "2000-03-03", "2001-06-07", "2000-08-30…
# $ autoridades      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
# $ demandado        <chr> "Sin Información", "", "", "", "", "", "", "", "", ""…
# $ demandante       <chr> "MARIA SANDRA CRUZ PERDOMO VS. INVERSIONES RESCOL S.A…
# $ descriptores     <chr> "ACCION DE TUTELA-No es la vía para definición de exi…
# $ expediente       <chr> "469070", "T-247550", "T-427617", "T-327235 Y OTROS",…
# $ f_public         <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "…
# $ magistrado_otros <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
# $ magistrados      <chr> "Alvaro Tafur Galvis", "Fabio Morón Díaz", "Rodrigo E…
# $ normas           <chr> "", "", "", "", "LEY 466 DE 1998. “POR MEDIO DE LA CU…
# $ sintesis         <chr> "Sin Información", "Sin Información", "Sin Informació…
# $ url              <chr> "https://www.corteconstitucional.gov.co/relatoria/200…
```

This data is a little messy. The `ccc_clean_dataset()` provides some
useful tidying, but you might want to consider doing things differently.

``` r
df <- ccc_clean_dataset(results)
glimpse(df)
# Rows: 2,257
# Columns: 9
# $ id          <chr> "C-002-99", "T-015-99", "T-014-99", "T-008-99", "T-009-99"…
# $ type        <fct> C, T, T, T, T, T, T, T, T, T, T, T, T, C, T, T, T, T, T, S…
# $ year        <int> 1999, 1999, 1999, 1999, 1999, 1999, 1999, 1999, 1999, 1999…
# $ date        <date> 1999-01-20, 1999-01-21, 1999-01-21, 1999-01-21, 1999-01-2…
# $ file        <chr> "D-2104", "177540", "166086 Y OTROS", "191438 Y OTROS", "1…
# $ mp          <list> "antonio barrera carbonell", "alejandro martinez caballer…
# $ descriptors <list> <"SENTENCIA DE CONSTITUCIONALIDAD-Efectos retroactivos", …
# $ date_public <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
# $ url         <chr> "https://www.corteconstitucional.gov.co/relatoria/1999/C-0…
```

Next you’ll want to download some texts. You can use either `ccc_txt()`
or `ccc_rtf()`. I prefer `ccc_txt()` because most rtf files don’t
include footnotes.

Here I’ll show you how to download 5 random rulings.

``` r
df_subset <- slice_sample(df, n = 5)

txts <- vector("list", nrow(df_subset))

for (i in seq_along(txts)) {
  txts[[i]] <- ccc_txt(df_subset$url[[i]])
}
# https://www.corteconstitucional.gov.co/relatoria/2000/T-1642-00.htm
# https://www.corteconstitucional.gov.co/relatoria/2000/T-1122-00.htm
# https://www.corteconstitucional.gov.co/relatoria/1999/T-863A-99.htm
# https://www.corteconstitucional.gov.co/relatoria/2001/T-1082-01.htm
# https://www.corteconstitucional.gov.co/relatoria/2000/C-533-00.htm

names(txts) <- df_subset$id

glimpse(txts)
# List of 5
#  $ T-1642-00: chr "\r\n Sentencia T-1642/00\r\n\r\n \r\n DERECHO DE LA VIUDA A RECIBIR PENSION DE SOBREVIVIENTE-Nuevo matrimonio/I"| __truncated__
#  $ T-1122-00: chr "\r\n Sentencia T-1122/00\r\n\r\n \r\n PENSION DE VEJEZ-Régimen de transición\r\n\r\n \r\n DERECHO DE PETICION-P"| __truncated__
#  $ T-863A-99: chr "\r\n Sentencia T-863A/99\r\n\r\n \r\n\r\n \r\n DERECHO DE PETICION-Pronta resolución y decisión de fondo\r\n\r\"| __truncated__
#  $ T-1082-01: chr "\r\n Sentencia T-1082/01\r\n\r\n \r\n ACCION DE TUTELA CONTRA PARTICULARES-Subordinación\r\n\r\n \r\n ACCION DE"| __truncated__
#  $ C-533-00 : chr "\r\n Sentencia C-533/00\r\n\r\n \r\n FAMILIA-Origen/FAMILIA-Formas\r\n\r\n \r\n FAMILIA-Diferencias entre forma"| __truncated__
```

Finally, you can `extract_citations()` easily as follows:

``` r
lapply(txts, extract_citations)
# $`T-1642-00`
#  [1] "T-1642-00" "C-870-99"  "C-870-99"  "T-393-97"  "C-309-96"  "T-190-93" 
#  [7] "T-553-94"  "C-389-96"  "C-002-99"  "C-080-99" 
# 
# $`T-1122-00`
# [1] "T-1122-00" "C-410-94"  "C-596-97"  "C-146-98" 
# 
# $`T-863A-99`
#  [1] "T-622-95"  "T-180-98"  "T-372-95"  "T-424-95"  "T-524-97"  "T-369-97" 
#  [7] "C-005-98"  "T-180-98"  "T-437-92"  "T-376-93"  "T-126-94"  "T-257-96" 
# [13] "SU-257-97" "T-539-92"  "T-219-94"  "T-863A-99" "T-214-98"  "T-254-93" 
# [19] "T-320-93"  "T-366-93" 
# 
# $`T-1082-01`
#  [1] "T-1082-01" "T-290-93"  "T-412-92"  "T-233-94"  "T-070-97"  "T-630-97" 
#  [7] "T-333-95"  "SU-509-01" "C-022-96"  "T-789-00"  "SU-509-01" "T-216-98" 
# 
# $`C-533-00`
# [1] "C-239-94" "C-533-00"
```
