
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

## Download

Use the `ccc_search()` function to lookup some cases.

``` r
library(ccc)
library(dplyr)

results <- ccc_search(
  text = "familia", 
  date_start = "1999-01-01", 
  date_end = "2001-12-31"
)

glimpse(results)
> Rows: 2,257
> Columns: 15
> $ relevancia       <dbl> 17.653, 15.540, 14.595, 12.729, 12.425, 12.051, 10.50…
> $ providencia      <chr> "T-1045/01", "T-244/00", "T-597/01", "T-1135/00", "C-…
> $ tipo             <chr> "Tutela", "Tutela", "Tutela", "Tutela", "Constitucion…
> $ f_sentencia      <chr> "2001-10-03", "2000-03-03", "2001-06-07", "2000-08-30…
> $ autoridades      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
> $ demandado        <chr> "Sin Información", "", "", "", "", "", "", "", "", ""…
> $ demandante       <chr> "MARIA SANDRA CRUZ PERDOMO VS. INVERSIONES RESCOL S.A…
> $ descriptores     <chr> "ACCION DE TUTELA-No es la vía para definición de exi…
> $ expediente       <chr> "469070", "T-247550", "T-427617", "T-327235 Y OTROS",…
> $ f_public         <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "…
> $ magistrado_otros <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
> $ magistrados      <chr> "Alvaro Tafur Galvis", "Fabio Morón Díaz", "Rodrigo E…
> $ normas           <chr> "", "", "", "", "LEY 466 DE 1998. “POR MEDIO DE LA CU…
> $ sintesis         <chr> "Sin Información", "Sin Información", "Sin Informació…
> $ url              <chr> "https://www.corteconstitucional.gov.co/relatoria/200…
```

This data is a little messy. The `ccc_clean_dataset()` provides some
useful tidying, but you might want to consider doing things differently.

``` r
df <- ccc_clean_dataset(results)
glimpse(df)
> Rows: 2,257
> Columns: 9
> $ id          <chr> "C-002-99", "T-015-99", "T-014-99", "T-008-99", "T-009-99"…
> $ type        <fct> C, T, T, T, T, T, T, T, T, T, T, T, T, C, T, T, T, T, T, S…
> $ year        <int> 1999, 1999, 1999, 1999, 1999, 1999, 1999, 1999, 1999, 1999…
> $ date        <date> 1999-01-20, 1999-01-21, 1999-01-21, 1999-01-21, 1999-01-2…
> $ file        <chr> "D-2104", "177540", "166086 Y OTROS", "191438 Y OTROS", "1…
> $ mp          <list> "antonio barrera carbonell", "alejandro martinez caballer…
> $ descriptors <list> <"SENTENCIA DE CONSTITUCIONALIDAD-Efectos retroactivos", …
> $ date_public <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
> $ url         <chr> "https://www.corteconstitucional.gov.co/relatoria/1999/C-0…
```

Next you’ll want to download some texts. You can use either `ccc_txt()`
or `ccc_rtf()` (*Rich Text Format*) to do this.

I prefer `ccc_txt()` because most rtf files don’t include footnotes.

``` r
url <- sample(df$url, 1)

## download from the following url
url
> [1] "https://www.corteconstitucional.gov.co/relatoria/2001/T-371-01.htm"

txt <- ccc_txt(url)
> https://www.corteconstitucional.gov.co/relatoria/2001/T-371-01.htm

## truncated output
stringr::str_trunc(txt, 1e3) |> cat()
> 
>  Sentencia T-371/01
> 
>  
>  ACCION DE TUTELA-Hecho superado por pago de acreencias laborales
> 
>  
>  Reiteración de Jurisprudencia
> 
>  
>  Referencia: expediente T-399557 
> 
>  
>  Acción de Tutela incoada por José Antonio Alarcón contra el Instituto Nacional de Adecuación de Tierras “INAT”.
> 
>  
>  Magistrado Ponente: 
>  Dr. RODRIGO ESCOBAR GIL
> 
>  
> 
>  
>  Bogotá D.C., abril cinco (5) de dos mil uno
> (2001).
> 
>  
>  La Sala Quinta de Revisión de Tutelas de la Corte Constitucional, en ejercicio de sus competencias constitucionales y legales, ha proferido la siguiente,
> 
>  
> 
>  
>  SENTENCIA
> 
>  
>  dentro del proceso de revisión de las sentencias proferidas el 11 de septiembre de 2000, por el Juzgado Segundo de Familia de Neiva y el 20 de octubre de 2000 de la Sala Civil Familia del Tribunal Superior de la misma ciudad, en el trámite de la acción de tutela interpuesta por José Antonio Alarcón contra el Instituto Nacional de Adecuación de Tierras “INAT”.
> 
>  
>  I. ANTECEDENTES
> 
>  
>  El señ...
```

Finally, you can `extract_citations()` easily as follows:

``` r
extract_citations(txt)
> [1] "T-467-96" "T-371-01"
```

## Data

There are 3 built-in datasets in this package, which cover 30 years
after the first ruling was published.

``` r
glimpse(citations)
> Rows: 629,848
> Columns: 5
> $ from      <fct> C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, …
> $ to        <fct> C-004-93, C-007-01, C-008-17, C-030-03, C-037-96, C-041-93, …
> $ weight    <int> 1, 1, 2, 1, 3, 1, 4, 4, 1, 3, 2, 1, 3, 1, 2, 19, 2, 1, 5, 2,…
> $ from_date <date> 2018-01-24, 2018-01-24, 2018-01-24, 2018-01-24, 2018-01-24,…
> $ to_date   <date> 1993-01-14, 2001-01-17, 2017-01-18, 2003-01-28, 1996-02-05,…
```

``` r
glimpse(metadata)
> Rows: 27,157
> Columns: 9
> $ id          <chr> "T-001-92", "C-004-92", "T-002-92", "C-005-92", "T-003-92"…
> $ type        <fct> T, C, T, C, T, T, T, T, T, T, T, T, T, T, T, C, T, T, T, T…
> $ year        <int> 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992, 1992…
> $ date        <date> 1992-04-03, 1992-05-07, 1992-05-08, 1992-05-11, 1992-05-1…
> $ file        <chr> "117 Y OTROS", "R.E. 001", "644", "R.E. 003", "309", "T-22…
> $ mp          <list> "jose gregorio hernandez galindo", "eduardo cifuentes mun…
> $ descriptors <list> <"ACCION DE TUTELA TRANSITORIA-Improcedencia", "ACCION DE…
> $ date_public <date> NA, NA, 1992-02-08, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
> $ url         <chr> "https://www.corteconstitucional.gov.co/relatoria/1992/T-0…
```

``` r
glimpse(docterms)
> Rows: 26,015,969
> Columns: 3
> $ doc_id <fct> C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-001-18, C-0…
> $ lemma  <fct> abierta, abierto, abordar, absoluta, abstracto, academia, acade…
> $ n      <int> 1, 1, 1, 1, 12, 3, 1, 2, 1, 7, 2, 1, 1, 1, 1, 2, 1, 1, 1, 3, 3,…
```

You can get a document-term matrix instead of `docterms` easily with the
`create_dtm()` function. The result will be a very sparse matrix.

I recommend that you load the `Matrix` package if you’re going to work
with this object.

``` r
library(Matrix)

M <- create_dtm()
dim(M)
> [1] 27157 12644

mean(M == 0) ## sparsity
> [1] 0.9242341
M[sample(nrow(M), 20), sample(ncol(M), 5)] ## random subset
> 20 x 5 sparse Matrix of class "dgCMatrix"
>           subordinar transformar estimular perseguir respectivo
> C-213-17           .           1         .         7          2
> T-176-10           .           .         .         2          1
> C-029-11           .           .         .         2         12
> C-041-04           .           .        10         .          8
> T-679-05           .           .         .         .          3
> T-1097-03          .           .         .         .          2
> T-501-19           .           .         .         1         14
> T-174-00           .           .         .         .          .
> T-626-12           .           .         .         .          1
> C-103-15           .           .         .         2         11
> T-531-94           .           .         .         .          .
> T-676-02           .           .         .         1          4
> T-354-07           .           .         .         1          2
> T-046-19           .           .         .         .          .
> T-1302-01          .           .         .         .          .
> T-002-94           .           .         .         .          2
> C-036-20           .           .         .         .          .
> T-419-17           .           .         .         .          .
> T-631-00           .           .         .         .          1
> T-448-02           .           .         .         .          .
```
