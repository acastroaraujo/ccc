
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ccc <img src="man/figures/logo.png" align="right" width="240">

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
# Rows: 631,274
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
# Rows: 26,053,177
# Columns: 3
# $ doc_id <fct> C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-0…
# $ lemma  <fct> abierta, abierto, abordar, absoluta, abstracto, academia, acade…
# $ n      <int> 1, 1, 1, 1, 12, 3, 1, 2, 1, 7, 2, 1, 1, 1, 1, 2, 1, 1, 1, 3, 3,…
```

You can get a document-term matrix instead of `docterms` easily with the
`create_dtm()` function. The result will be a very sparse matrix.

*Note. Using this function will automatically load the `Matrix`
package.*

``` r
M <- create_dtm()
# Loading required package: Matrix
dim(M) ## number of rows (documents) and columns (word counts)
# [1] 27179 12658

## sparsity
mean(M == 0) 
# [1] 0.924271
```

92% of the cells in this matrix are empty, which is why we call it a
“sparse matrix.”

Here’s a random subset of this matrix

``` r
set.seed(1)
i <- sample(nrow(M), 20)
j <- sample(ncol(M), 5)
M[i, j] 
# 20 x 5 sparse Matrix of class "dgCMatrix"
#           asignado pension aplicable paciente medicion
# T-389-19         1       .         1        .        .
# T-764-01         .      18         1        .        .
# C-513-13         1      10         .        .        .
# T-958-04         .      22         1        .        .
# T-185-13         .       .         1        .        .
# T-904-07         .       7         1        .        .
# T-1099-05        .      11         2        .        .
# T-047-11         6       .         2        1        .
# C-409-09         .       .         1        .        .
# T-199-21         .       1         1        1        .
# T-126-02         1       .         .       11        .
# T-147-04         .       .         1        .        .
# T-826-14         .      47         4        .        .
# T-404-14         .       .         1        .        .
# T-236-09         .       .         1        .        .
# T-803-07         .       .         .       11        .
# T-426-95         .       .         1        .        .
# T-218-01         .       4         .        .        .
# T-1036-07        .       .         .        1        .
# T-034-94         1       .         1        .        .
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
# $ relevancia                           <dbl> 17.039, 11.153, 8.190, 7.372, 7.3…
# $ providencia                          <chr> "T-1045/01", "T-523/92", "T-1532/…
# $ tipo                                 <chr> "Tutela", "Tutela", "Tutela", "Tu…
# $ fecha_sentencia                      <chr> "2001-10-03", "1992-09-18", "2000…
# $ magistrado_s_ponentes                <chr> "", "Ciro Angarita Baron", "Carlo…
# $ magistrado_s_s_alvamento_a_claracion <lgl> NA, NA, NA, NA, NA, NA, NA, NA, N…
# $ tema_subtema                         <chr> "", "ACCION DE TUTELA CONTRA SENT…
# $ autoridades                          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, N…
# $ demandado                            <chr> "Sin Información", "", "", "", ""…
# $ demandante                           <chr> "MARIA SANDRA CRUZ PERDOMO VS. IN…
# $ expediente                           <chr> "469070", "2598", "T-324358 Y OTR…
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
# $ type        <fct> T, T, T, T, T, T, T, T, T, T, T, C, C, C, C, T, T, T, T, T…
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
# https://www.corteconstitucional.gov.co/relatoria/2000/C-533-00.htm
# https://www.corteconstitucional.gov.co/relatoria/2000/T-1350-00.htm
# https://www.corteconstitucional.gov.co/relatoria/2000/T-1561-00.htm
# https://www.corteconstitucional.gov.co/relatoria/1995/T-110-95.htm
# https://www.corteconstitucional.gov.co/relatoria/2001/T-345-01.htm

names(txts) <- df_subset$id

glimpse(txts)
# List of 5
#  $ C-533-00 : chr "\r\n Sentencia C-533/00\r\n\r\n \r\n FAMILIA-Origen/FAMILIA-Formas\r\n\r\n \r\n FAMILIA-Diferencias entre forma"| __truncated__
#  $ T-1350-00: chr "\r\n Sentencia T-1350/00\r\n\r\n \r\n\r\n \r\n DERECHO AL PAGO OPORTUNO DEL SALARIO-Fundamental\r\n\r\n \r\n SA"| __truncated__
#  $ T-1561-00: chr "\r\n Sentencia T-1561/00\r\n\r\n \r\n ACCION DE TUTELA CONTRA PARTICULARES-Subordinación\r\n\r\n \r\n ACCION DE"| __truncated__
#  $ T-110-95 : chr "\r\n Sentencia No. T-110/95\r\n\r\n \r\n\r\n \r\n DERECHOS DEL NIÑO-Cuidado personal de la madre\r\n\r\n \r\n E"| __truncated__
#  $ T-345-01 : chr "\r\n Sentencia T-345/01   \r\n\r\n \r\n DERECHO AL MINIMO VITAL DEL PENSIONADO-Pago oportuno de mesadas\r\n\r\n"| __truncated__
```

Finally, you can `extract_citations()` easily as follows:

``` r
lapply(txts, extract_citations)
# $`C-533-00`
# [1] "C-239-94" "C-533-00"
# 
# $`T-1350-00`
#  [1] "T-259-99"  "T-308-99"  "T-299-97"  "T-308-99"  "T-323-96"  "T-399-98" 
#  [7] "T-106-99"  "T-259-99"  "SU-995-99" "T-661-97"  "T-1350-00" "SU-995-99"
# [13] "SU-995-99" "SU-995-99" "SU-995-99" "SU-995-99" "SU-995-99" "T-620-00" 
# [19] "T-335-00"  "T-259-99"  "T-171-NA"  "T-020-99" 
# 
# $`T-1561-00`
#  [1] "SU-995-99" "T-011-98"  "T-172-97"  "T-437-96"  "T-576-97"  "SU-667-98"
#  [7] "T-075-98"  "SU-995-99" "T-246-00"  "T-606-99"  "T-241-00"  "T-1561-00"
# [13] "T-529-97"  "T-129-00"  "T-146-00"  "T-231-00"  "T-259-99" 
# 
# $`T-110-95`
# [1] "T-110-95"
# 
# $`T-345-01`
# [1] "T-630-99" "T-929-00" "T-126-00" "T-345-01"
```
