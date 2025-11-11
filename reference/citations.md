# Citations

The \`citations\` dataset contains and edge list of rulings that form a
large citation network.

## Usage

``` r
citations
```

## Format

A data frame with five variables:

- `from`:

  Ruling ID (Source)

- `to`:

  Ruling ID (Target)

- `weight`:

  Number of times cited

- `from_date`:

  Source Date

- `to_date`:

  Target Date

## Source

https://www.corteconstitucional.gov.co/relatoria/

## Examples

``` r
  citations
#> # A tibble: 694,565 × 5
#>    from     to       weight from_date  to_date   
#>    <fct>    <fct>     <int> <date>     <date>    
#>  1 C-001-18 C-004-93      1 2018-01-24 1993-01-14
#>  2 C-001-18 C-007-01      1 2018-01-24 2001-01-17
#>  3 C-001-18 C-008-17      2 2018-01-24 2017-01-18
#>  4 C-001-18 C-030-03      1 2018-01-24 2003-01-28
#>  5 C-001-18 C-037-96      3 2018-01-24 1996-02-05
#>  6 C-001-18 C-041-93      1 2018-01-24 1993-02-11
#>  7 C-001-18 C-042-17      4 2018-01-24 2017-02-01
#>  8 C-001-18 C-043-17      4 2018-01-24 2017-02-01
#>  9 C-001-18 C-061-08      1 2018-01-24 2008-01-30
#> 10 C-001-18 C-066-13      3 2018-01-24 2013-02-11
#> # ℹ 694,555 more rows
```
