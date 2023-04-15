
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
#           extraprocesales existencial ocupado fisiatria crecimiento
# T-190-16                .           .       .         .           .
# T-796-99                .           .       .         .           .
# C-151-20                .           .       .         .           1
# C-168-12                .           .       .         .           .
# T-949-13                .           .       .         .           .
# T-236-13                .           .       .         .           .
# T-851-01                .           .       .         .           .
# T-892-05                .           .       .         .           .
# T-324-94                .           .       .         .           .
# T-1011-05               .           .       .         .           .
# T-565-14                .           .       .         .           1
# C-570-16                .           .       .         .           .
# T-528-01                .           .       .         .           .
# T-707-14                .           .       .         .           .
# C-247-95                .           .       .         .           .
# T-194-12                .           .       .         .           .
# C-394-06                .           .       .         .           .
# C-1174-01               .           .       .         .           .
# T-273-05                .           .       .         .           .
# T-905-11                .           .       .         .           .
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

`jctt_*` datasets contain cases from the “Justicia Constitucional en
Tiempos de Transición” projected. More information about this project
[here](http://justiciatransicional.uniandes.edu.co/web/).

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
  date_start = "1999-01-01", 
  date_end = "2001-12-31"
)

glimpse(results)
# Rows: 2,257
# Columns: 15
# $ relevancia       <dbl> 17.654, 15.541, 14.596, 12.738, 12.425, 12.056, 10.51…
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
# https://www.corteconstitucional.gov.co/relatoria/2000/T-016-00.htm
# https://www.corteconstitucional.gov.co/relatoria/1999/C-247-99.htm
# https://www.corteconstitucional.gov.co/relatoria/2001/T-541-01.htm
# https://www.corteconstitucional.gov.co/relatoria/2001/T-1221-01.htm
# https://www.corteconstitucional.gov.co/relatoria/2000/T-1503-00.htm

names(txts) <- df_subset$id

glimpse(txts)
# List of 5
#  $ T-016-00 : chr "\r\n Sentencia T-016/00\r\n\r\n \r\n\r\n \r\n IGUALDAD DE LOS HIJOS\r\n\r\n \r\n Para la Constitución lo que in"| __truncated__
#  $ C-247-99 : chr "\r\n Sentencia C-247/99\r\n\r\n \r\n\r\n \r\n COSA JUZGADA CONSTITUCIONAL-Conciliación laboral\r\n\r\n \r\n En "| __truncated__
#  $ T-541-01 : chr "\r\n Sentencia T-541/01\r\n\r\n \r\n ACCION DE TUTELA-Procedencia excepcional pago de salarios/DERECHO AL MINIM"| __truncated__
#  $ T-1221-01: chr "\r\n Sentencia T-1221/01\r\n\r\n \r\n ACCION DE TUTELA-Improcedencia para revivir términos precluidos o actuaci"| __truncated__
#  $ T-1503-00: chr "\r\n Sentencia T-1503/00\r\n\r\n \r\n\r\n \r\n MEDIO DE DEFENSA JUDICIAL INEFICAZ-Reconocimiento oportuno de pe"| __truncated__
```

Finally, you can `extract_citations()` easily as follows:

``` r
lapply(txts, extract_citations)
# $`T-016-00`
# [1] "T-016-00"
# 
# $`C-247-99`
#  [1] "C-160-99"  "C-160-99"  "C-160-99"  "C-160-99"  "C-160-99"  "C-037-96" 
#  [7] "C-165-93"  "C-160-99"  "C-160-99"  "C-600A-95" "C-226-94"  "C-190-96" 
# [13] "C-190-96"  "C-619-96"  "C-606-92"  "C-606-92"  "C-071-95"  "C-588-97" 
# [19] "C-606-92"  "C-226-94"  "C-619-96"  "C-034-97"  "C-190-96"  "C-190-96" 
# [25] "C-547-94"  "C-220-97"  "T-492-92"  "C-299-94"  "C-025-93"  "C-025-93" 
# [31] "C-160-99"  "C-160-99"  "C-247-99"  "C-247-99" 
# 
# $`T-541-01`
#  [1] "T-063-95"  "T-437-96"  "T-426-92"  "T-147-95"  "T-244-95"  "T-212-96" 
#  [7] "T-608-96"  "T-246-96"  "T-418-96"  "SU-342-95" "T-418-96"  "C-448-96" 
# [13] "T-225-93"  "T-125-94"  "SU-478-97" "C-665-98"  "T-052-98"  "T-243-98" 
# [19] "C-401-98"  "SU-400-97" "T-661-97"  "T-541-01" 
# 
# $`T-1221-01`
#  [1] "T-575-97"  "T-1655-00" "T-356-00"  "T-499-92"  "T-501-94"  "T-1655-00"
#  [7] "T-818-01"  "T-578-98"  "T-427-01"  "C-543-92"  "T-971-01"  "T-818-01" 
# [13] "T-1221-01"
# 
# $`T-1503-00`
# [1] "T-1503-00" "T-206-97"  "T-131-00"  "T-178-00"  "T-170-00"
```
