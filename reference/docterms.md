# Document Terms

The \`doc_terms\` dataset contains and edge list of rulings and lemmas
(or processed words).

## Usage

``` r
docterms
```

## Format

A data frame with three variables:

- `id`:

  Ruling ID

- `lemma`:

  A standardized word

- `n`:

  Number of times used in the document

## Source

https://www.corteconstitucional.gov.co/relatoria/

## Examples

``` r
  docterms
#> # A tibble: 24,836,293 × 3
#>    id       lemma          n
#>    <fct>    <fct>      <int>
#>  1 T-001-92 abril          1
#>  2 T-001-92 abstencion     1
#>  3 T-001-92 abstener       2
#>  4 T-001-92 acabar         3
#>  5 T-001-92 acatar         2
#>  6 T-001-92 acceder        2
#>  7 T-001-92 accion        28
#>  8 T-001-92 accionante     2
#>  9 T-001-92 aceptar        1
#> 10 T-001-92 acta           1
#> # ℹ 24,836,283 more rows
```
