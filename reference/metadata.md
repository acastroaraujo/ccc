# Metadata

The \`metadata\` dataset contains information about the rulings authored
by the Colombian Constitutional Court.

## Usage

``` r
metadata
```

## Format

A data frame with nine variables:

- `id`:

  Ruling ID

- `type`:

  Ruling Type (C, T, or SU)

- `year`:

  Year

- `date`:

  YYYY-MM-DD

- `indegree`:

  Citation In-degree

- `outdegree`:

  Citation Out-degree

- `word_count`:

  Word Count

- `descriptors`:

  Additional metadata added to some rulings by the Court

- `url`:

  URL to see the ruling

## Source

https://www.corteconstitucional.gov.co/relatoria/

## Examples

``` r
  metadata
#> # A tibble: 28,245 × 9
#>    id     type   year date       indegree outdegree word_count descriptors url  
#>    <chr>  <fct> <int> <date>        <int>     <int>      <int> <list>      <chr>
#>  1 T-001… T      1992 1992-04-03      188         0       7060 <chr [14]>  http…
#>  2 C-004… C      1992 1992-05-07      119         0      20107 <chr [11]>  http…
#>  3 T-002… T      1992 1992-05-08      286         0       7597 <chr [4]>   http…
#>  4 T-003… T      1992 1992-05-11      146         0       5760 <chr [8]>   http…
#>  5 C-005… C      1992 1992-05-11        7         1       6869 <chr [11]>  http…
#>  6 T-006… T      1992 1992-05-12      228         0      32408 <chr [21]>  http…
#>  7 T-007… T      1992 1992-05-13      116         0       2474 <chr [4]>   http…
#>  8 T-008… T      1992 1992-05-18       34         0       7962 <chr [11]>  http…
#>  9 T-009… T      1992 1992-05-22       28         0       3871 <chr [5]>   http…
#> 10 T-010… T      1992 1992-05-22       28         0       3473 <chr [5]>   http…
#> # ℹ 28,235 more rows
```
