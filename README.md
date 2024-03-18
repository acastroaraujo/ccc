
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ccc <img src="man/figures/logo.png" align="right" height="138" style="float:right; height:200px;">

<!-- badges: start -->

[![R-CMD-check](https://github.com/acastroaraujo/ccc/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/acastroaraujo/ccc/actions/workflows/R-CMD-check.yaml)
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
- `gender_cases`
- `jctt_cases`
- `jctt_edge_list`

These datasets were created using these
[scripts](https://github.com/acastroaraujo/ccc/tree/master/data-raw).

## Data

``` r
library(ccc)
library(dplyr)
```

**Thirty Years**

There are 3 built-in datasets in this package that cover 30 years after
the first ruling was published.

``` r
glimpse(citations)
# Rows: 631,549
# Columns: 5
# $ from      <fct> C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, …
# $ to        <fct> C-004-93, C-007-01, C-008-17, C-030-03, C-037-96, C-041-93, …
# $ weight    <int> 1, 1, 2, 1, 3, 1, 4, 4, 1, 3, 2, 1, 3, 1, 2, 19, 2, 1, 5, 2,…
# $ from_date <date> 2018-01-24, 2018-01-24, 2018-01-24, 2018-01-24, 2018-01-24,…
# $ to_date   <date> 1993-01-14, 2001-01-17, 2017-01-18, 2003-01-28, 1996-02-05,…
```

``` r
glimpse(metadata)
# Rows: 27,179
# Columns: 11
# $ id          <chr> "T-001-92", "C-004-92", "T-002-92", "T-003-92", "C-005-92"…
# $ type        <fct> T, C, T, T, C, T, T, T, T, T, T, T, T, T, T, C, T, T, T, T…
# $ year        <int> 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992…
# $ date        <date> 1992-04-03, 1992-05-07, 1992-05-08, 1992-05-11, 1992-05-1…
# $ indegree    <int> 186, 118, 271, 142, 7, 225, 116, 34, 27, 27, 7, 71, 8, 38,…
# $ outdegree   <int> 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
# $ descriptors <list> <"ACCION DE TUTELA TRANSITORIA-Improcedencia", "ACCION DE…
# $ mp          <list> "jose gregorio hernandez galindo", "eduardo cifuentes mun…
# $ date_public <date> NA, NA, 1992-02-08, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
# $ file        <chr> "117 Y OTROS", "R.E. 001", "644", "309", "R.E. 003", "T-22…
# $ url         <chr> "https://www.corteconstitucional.gov.co/relatoria/1992/T-0…
```

``` r
glimpse(docterms)
# Rows: 25,403,840
# Columns: 3
# $ doc_id <fct> C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-0…
# $ lemma  <fct> abierto, abordar, absoluto, abstracto, academia, academico, aca…
# $ n      <int> 2, 1, 1, 12, 3, 1, 2, 1, 7, 1, 2, 1, 1, 1, 2, 1, 1, 1, 3, 3, 3,…
```

You can get a document-term matrix instead of `docterms` easily with the
`create_dtm()` function. The result will be a very sparse matrix.

*Note. Using this function will automatically load the `Matrix`
package.*

``` r
M <- create_dtm()
# Loading required package: Matrix
dim(M) ## number of rows (documents) and columns (words)
# [1] 27179 10794

## sparsity
mean(M == 0) 
# [1] 0.9134069
```

91% of the cells in this matrix are empty, which is why we call it a
“sparse matrix.”

Here’s a random subset of this matrix

``` r
set.seed(99)
i <- sample(nrow(M), 20)
j <- sample(ncol(M), 5)
M[i, j] 
# 20 x 5 sparse Matrix of class "dgCMatrix"
#           filosofia intentar causales maestro aforo
# C-629-96          .        .        .       .     .
# SU-771-14         .        .        .       .     .
# T-140-11          .        .        .       .     .
# C-189-98          .        1        .       .     .
# T-1208-03         .        .        .       .     .
# T-478-06          .        .        .       .     .
# T-703-11          .        1        1       .     .
# T-1243-00         .        .        .       .     .
# C-304-12          .        .        .       .     .
# C-040-93          .        .        .       .     .
# T-1631-00         .        .        .       .     .
# T-073-05          .        .        .       .     .
# T-1481-00         .        .        .       .     .
# T-082-94          .        .        .       .     .
# T-701-96          .        .        .       .     .
# C-915-01          .        .        .       .     .
# C-828-13          .        .        .       .     .
# T-1363-00         .        .        .       .     .
# T-270-04          .        3        .       .     3
# C-583-02          .        .        .       .     .
```

**Gender**

`gender_cases` contains cases related to gender equality across a
variety of topics, collected by experts
[here](https://www.corteconstitucional.gov.co/relatoria/equidaddegenero.php)

``` r
glimpse(gender_cases)
# Rows: 471
# Columns: 4
# $ id   <chr> "T-064-23", "T-028-23", "T-452-22", "T-425-22", "T-400-22", "T-37…
# $ type <fct> T, T, T, T, T, T, T, SU, T, T, T, T, C, T, T, C, T, C, T, C, C, S…
# $ tema <fct> "A LA IGUALDAD Y LA NO DISCRIMINACIÓN", "A LA IGUALDAD Y LA NO DI…
# $ href <chr> "/relatoria/2023/T-064-23.htm", "/relatoria/2023/T-028-23.htm", "…
```

**Transitional Justice**

`jctt_*` datasets contain cases from the “[Justicia Constitucional en
Tiempos de
Transición](http://justiciatransicional.uniandes.edu.co/web/)” by
Universidad de Los Andes.

``` r
glimpse(jctt_cases)
# Rows: 123
# Columns: 11
# $ id        <chr> "C-019-18", "C-020-18", "C-527-17", "C-006-17", "C-026-18", …
# $ type      <chr> "C", "C", "C", "C", "C", "C", "C", "C", "C", "C", "C", "C", …
# $ date      <date> 2018-04-04, 2018-04-04, 2017-08-14, 2017-01-18, 2018-04-11,…
# $ precedent <chr> "Mantiene", "Mantiene", "Crea", "Mantiene", "Mantiene", "Cre…
# $ president <chr> "Juan Manuel Santos (2014-2018)", "Juan Manuel Santos (2014-…
# $ href      <chr> "/Relatoria/2018/C-019-18.htm", "/Relatoria/2018/C-020-18.ht…
# $ keywords  <list> [<tbl_df[3 x 3]>], [<tbl_df[3 x 3]>], [<tbl_df[3 x 3]>], [<…
# $ crimes    <list> [<tbl_df[1 x 1]>], [<tbl_df[1 x 1]>], [<tbl_df[1 x 1]>], [<…
# $ mp        <list> [<tbl_df[1 x 1]>], [<tbl_df[1 x 1]>], [<tbl_df[1 x 1]>], [<…
# $ msv       <list> [<tbl_df[4 x 1]>], [<tbl_df[1 x 1]>], [<tbl_df[4 x 1]>], [<…
# $ mav       <list> [<tbl_df[4 x 1]>], [<tbl_df[1 x 1]>], [<tbl_df[4 x 1]>], [<…
```

`jctt_edge_list` contains citation data to sources “outside” the CCC.

``` r
glimpse(jctt_edge_list)
# Rows: 1,660
# Columns: 7
# $ from      <chr> "C-019-18", "C-019-18", "C-019-18", "C-019-18", "C-019-18", …
# $ to        <chr> "ONU, Asamblea General, Resolucion 2198, Protocolo sobre el …
# $ type      <chr> "C", "C", "C", "C", "C", "C", "C", "C", "C", "C", "C", "C", …
# $ to_source <chr> "Normas internacionales", "Normas internacionales", "Normas …
# $ to_system <chr> "Sistema Universal", "Sistema Universal", "Sistema Universal…
# $ date      <date> 2018-04-04, 2018-04-04, 2018-04-04, 2018-04-04, 2018-04-04,…
# $ president <chr> "Juan Manuel Santos (2014-2018)", "Juan Manuel Santos (2014-…
```

## Download

Use the `ccc_search()` function to look up some cases.

``` r
results <- ccc_search(
  text = "familia", 
  date_start = "2000-01-01", 
  date_end = "2001-12-31"
)

glimpse(results)
# Rows: 500
# Columns: 15
# $ relevancia                           <dbl> 18.195, 8.886, 7.660, 7.656, 7.63…
# $ providencia                          <chr> "T-1045/01", "T-1532/00", "T-049/…
# $ tipo                                 <chr> "Tutela", "Tutela", "Tutela", "Tu…
# $ fecha_sentencia                      <chr> "2001-10-03", "2000-11-15", "1999…
# $ magistrado_s_ponentes                <chr> "", "Carlos Gaviria Díaz", "José …
# $ magistrado_s_s_alvamento_a_claracion <lgl> NA, NA, NA, NA, NA, NA, NA, NA, N…
# $ tema_subtema                         <chr> "", "ACCION DE TUTELA TRANSITORIA…
# $ autoridades                          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, N…
# $ demandado                            <chr> "Sin Información", "", "", "", ""…
# $ demandante                           <chr> "MARIA SANDRA CRUZ PERDOMO VS. IN…
# $ expediente                           <chr> "469070", "T-324358 Y OTROS", "T-…
# $ f_public                             <chr> "", "", "", "", "", "", "", "", "…
# $ normas                               <chr> "", "", "", "", "", "", "", "", "…
# $ sintesis                             <chr> "Sin información", "Sin informaci…
# $ url                                  <chr> "https://www.corteconstitucional.…
```

This data is a little messy. The `ccc_clean_dataset()` provides some
useful tidying, but you might want to consider doing things differently.

``` r
df <- ccc_clean_dataset(results)
glimpse(df)
# Rows: 500
# Columns: 9
# $ id          <chr> "T-008-92", "T-009-92", "T-429-92", "T-439-92", "T-453-92"…
# $ type        <fct> T, T, T, T, T, T, T, T, T, T, C, C, C, C, T, T, T, T, T, T…
# $ year        <int> 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992…
# $ date        <date> 1992-05-18, 1992-05-22, 1992-06-24, 1992-07-02, 1992-07-1…
# $ descriptors <list> <"ACCION DE TUTELA-Improcedencia", "ACCION POPULAR", "DER…
# $ mp          <list> "fabio moron diaz", "alejandro martinez caballero", "ciro…
# $ date_public <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
# $ file        <chr> "399", "T-030", "1011", "1088", "1239", "1707", "399", "25…
# $ url         <chr> "https://www.corteconstitucional.gov.co/relatoria/1992/T-0…
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
# https://www.corteconstitucional.gov.co/relatoria/1996/C-389-96.htm
# https://www.corteconstitucional.gov.co/relatoria/1995/T-012-95.htm
# https://www.corteconstitucional.gov.co/relatoria/2000/T-1231-00.htm
# https://www.corteconstitucional.gov.co/relatoria/1992/T-512-92.htm
# https://www.corteconstitucional.gov.co/relatoria/1999/C-183-99.htm

names(txts) <- df_subset$id

glimpse(txts)
# List of 5
#  $ C-389-96 : chr "\r\n Sentencia C-389/96\r\n\r\n \r\n CONTROL DE CONSTITUCIONALIDAD-Alcance\r\n\r\n \r\n La Corte tiene bien est"| __truncated__
#  $ T-012-95 : chr "\r\n Sentencia No. T-012/95\r\n\r\n \r\n\r\n \r\n ACCION DE TUTELA-Hecho consumado\r\n\r\n \r\n El juez de prim"| __truncated__
#  $ T-1231-00: chr "\r\n Sentencia T-1231/00\r\n\r\n \r\n ACCION DE TUTELA CONTRA PARTICULARES-Subordinación\r\n\r\n \r\n ACCION DE"| __truncated__
#  $ T-512-92 : chr "\r\n Sentencia No. T-512/92\r\n\r\n \r\n RECTIFICACION DE INFORMACION/ACCION DE TUTELA-Improcedencia/PRINCIPIO "| __truncated__
#  $ C-183-99 : chr "\r\n Sentencia C-183/99\r\n\r\n \r\n\r\n \r\n EMBARGO DE SALARIOS Y PRESTACIONES DE FUNCIONARIOS Y EMPLEADOS DE"| __truncated__
```

Finally, you can `extract_citations()` easily as follows:

``` r
lapply(txts, extract_citations)
# $`C-389-96`
# [1] "C-389-96" "C-371-94" "C-496-94" "T-190-93" "T-553-94" "C-445-95"
# 
# $`T-012-95`
# [1] "T-519-92" "T-494-93" "T-012-95"
# 
# $`T-1231-00`
#  [1] "SU-995-99" "T-172-97"  "T-437-96"  "T-576-97"  "SU-667-98" "T-075-98" 
#  [7] "SU-995-99" "T-246-00"  "T-606-99"  "T-246-00"  "T-1231-00" "T-529-97" 
# [13] "T-129-00"  "T-146-00"  "T-231-00"  "T-259-99" 
# 
# $`T-512-92`
# [1] "T-512-92"
# 
# $`C-183-99`
# [1] "C-556-94" "C-556-94" "C-556-94" "C-556-94" "C-556-94" "C-183-99"
```
