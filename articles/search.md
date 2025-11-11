# Search and Download

## Packages

``` r
library(ccc)
library(dplyr)
library(stringr)
```

## Search

Use the
[`ccc_search()`](https://acastroaraujo.github.io/ccc/reference/ccc_search.md)
function to look up some cases.

``` r
results <- ccc_search(
  text = "familia", 
  date_start = "2000-01-01", 
  date_end = "2001-12-31"
)

glimpse(results)
#> Rows: 1,552
#> Columns: 19
#> $ relevancia                           <dbl> 18.366, 9.035, 5.063, 5.057, 5.05…
#> $ providencia                          <chr> "T-1045/01", "T-1532/00", "T-029/…
#> $ tipo                                 <chr> "Tutela", "Tutela", "Tutela", "Tu…
#> $ fecha_sentencia                      <chr> "2001-10-03", "2000-11-15", "2001…
#> $ magistrado_s_ponentes                <chr> "", "Carlos Gaviria Díaz", "Aleja…
#> $ magistrado_s_s_alvamento_a_claracion <lgl> NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ tema_subtema                         <chr> "", "ACCION DE TUTELA TRANSITORIA…
#> $ tipo_de_proceso                      <chr> "", "Acciones de Tutela", "Accion…
#> $ demandado                            <chr> "Sin Información", "", "", "Sin I…
#> $ demandante                           <chr> "MARIA SANDRA CRUZ PERDOMO VS. IN…
#> $ expediente                           <chr> "469070", "T-324358 Y OTROS", "T-…
#> $ f_public                             <chr> "", "", "", "", "", "", "", "", "…
#> $ normas                               <chr> "", "", "", "", "CODIGO CIVIL. AR…
#> $ resuelve                             <chr> "en nombre del pueblo y por manda…
#> $ seguimiento                          <chr> "", "", "Array", "", "", "Array",…
#> $ sintesis                             <chr> "", "", "", "", "", "", "", "", "…
#> $ tema                                 <chr> "DERECHOS AL TRABAJO VIDA Y MINIM…
#> $ sala_seguimiento                     <chr> "Sala plena/Revisión", "Sala plen…
#> $ url                                  <chr> "https://www.corteconstitucional.…
```

This data is a little messy. The
[`ccc_clean_dataset()`](https://acastroaraujo.github.io/ccc/reference/ccc_clean_dataset.md)
provides some useful tidying, but you might want to consider doing
things differently.

``` r
df <- ccc_clean_dataset(results)
glimpse(df)
#> Rows: 1,552
#> Columns: 9
#> $ id          <chr> "T-001-00", "A-001-00", "T-002-00", "T-007-00", "T-003-00"…
#> $ type        <fct> T, A, T, T, T, T, T, T, C, C, T, T, T, T, T, T, T, T, T, T…
#> $ year        <int> 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000…
#> $ date        <date> 2000-01-12, 2000-01-12, 2000-01-13, 2000-01-13, 2000-01-1…
#> $ descriptors <list> <"DERECHO A LA ATENCION MEDICA INTEGRAL DE ANCIANO-Examen…
#> $ mp          <list> "jose gregorio hernandez galindo", "jose gregorio hernand…
#> $ date_public <date> NA, 2000-01-28, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ file        <chr> "T-245392", "T-246504", "T-235171", "T-246991", "T-246278"…
#> $ url         <chr> "https://www.corteconstitucional.gov.co/relatoria/2000/T-0…
```

## Download

Next you’ll want to download some texts. You can use either
[`ccc_txt()`](https://acastroaraujo.github.io/ccc/reference/ccc_txt.md)
or
[`ccc_rtf()`](https://acastroaraujo.github.io/ccc/reference/ccc_rtf.md).
I prefer
[`ccc_txt()`](https://acastroaraujo.github.io/ccc/reference/ccc_txt.md)
because it seems most `.rtf` files don’t include footnotes.

This is how you download the first ruling:

``` r
txt <- ccc_txt(df$url[[1]])
#> https://www.corteconstitucional.gov.co/relatoria/2000/T-001-00.htm
```

And this is how you’d download the first 5 rulings:

``` r
txts <- lapply(df$url[1:5], ccc_txt)
#> https://www.corteconstitucional.gov.co/relatoria/2000/T-001-00.htm
#> https://www.corteconstitucional.gov.co/relatoria/autos/2000/A001-00.htm
#> https://www.corteconstitucional.gov.co/relatoria/2000/T-002-00.htm
#> https://www.corteconstitucional.gov.co/relatoria/2000/T-007-00.htm
#> https://www.corteconstitucional.gov.co/relatoria/2000/T-003-00.htm
names(txts) <- df$id[1:5]
glimpse(txts)
#> List of 5
#>  $ T-001-00: chr "\r\n Sentencia T-001/00\r\n\r\n \r\n DERECHO A LA ATENCION MEDICA INTEGRAL DE ANCIANO-Examen urgente/REVISION F"| __truncated__
#>  $ A-001-00: chr "\r\n Auto 001/00\r\n\r\n \r\n DEBIDO PROCESO DE TUTELA-Notificación iniciación de la acción\r\n\r\n \r\n Si bie"| __truncated__
#>  $ T-002-00: chr "\r\n Sentencia T-002/00\r\n\r\n \r\n EXTINCION DE DOMINIO-Bienes de pariente de presunto narcotraficante\r\n\r\"| __truncated__
#>  $ T-007-00: chr "\r\n Sentencia T-007/00\r\n\r\n \r\n ACCION DE TUTELA-Procedencia excepcional pago de acreencias laborales/CONC"| __truncated__
#>  $ T-003-00: chr "\r\n Sentencia T-003/00\r\n\r\n \r\n\r\n \r\n SISBEN-Modificación de datos/SISBEN-Nueva calificación de la situ"| __truncated__
```

Each text will look something like this:

``` r
txts[[1]] |> 
  str_trunc(2000) |> 
  cat()
#> 
#>  Sentencia T-001/00
#> 
#>  
#>  DERECHO A LA ATENCION MEDICA INTEGRAL DE ANCIANO-Examen urgente/REVISION FALLO DE TUTELA-Fallecimiento del actor
#> 
#>  
#>  La Corte considera necesario subrayar que la actividad de las entidades responsables de mantener la seguridad social en cuanto se refiere a las personas de la tercera edad están sujetas a la exigencia específica de cobijar todos los aspectos de la salud de los beneficiarios, que no otro es el significado de la expresión
#> "integral", usada por el Constituyente para referirse al contenido de la seguridad social que debe brindarse a los ancianos. Por tanto, el alcance de la protección y de los servicios a cargo de tales entes va mucho más allá del puro trámite de citas y consultas médicas, pues comprende el diagnóstico, la prevención, los tratamientos, los cuidados clínicos, los medicamentos, las cirugías, las terapias y todos aquellos elementos de atención que aseguren la eficiente cobertura de la seguridad social a favor de las personas de la tercera edad. La conducta negligente de la demandada y la negativa a brindar la atención requerida, es muy factible que haya incidido y de manera definitiva, en su pronto deceso.
#> 
#>  
#>  DERECHO A LA SALUD-Práctica inmediata e íntegra de exámenes ordenados
#> 
#>  
#>  SENTENCIA INHIBITORIA EN TUTELA-Improcedencia
#> 
#>  
#>  No pudiendo ser inhibitoria la decisión por mandato del artículo 29, parágrafo, del Decreto 2591 de 1991, habrá de ser negativa, no por haberse encontrado indemnes los derechos invocados, ni por entenderse exonerada la persona o entidad demandada, sino justamente por ser inútil e irrealizable -dadas las circunstancias- el proveído judicial, aun comprobada la conducta inconstitucional del sujeto pasivo de la demanda, como en el presente caso ocurre.
#> 
#>  
#>  Referencia: Expediente T-245392 
#> 
#>  
#>  Acción de tutela instaurada por María Arledia García García contra el Seguro Social, Seccional Antioquia
#> 
#>  
#>  Magistrado Ponente:
#>  Dr. JOSÉ GREGORIO HERNÁNDEZ GALINDO
#> 
#>  
#>  A...
```

## Citations

Finally, you can
[`extract_citations()`](https://acastroaraujo.github.io/ccc/reference/extract_citations.md)
for each individual document as follows:

``` r
extract_citations(txts[[1]])
#> [1] "T-555-97" "T-366-99" "T-428-98" "T-607-99" "T-428-98" "T-001-00"
```

Or you can do something like this for all documents:

``` r
lapply(txts, extract_citations)
#> $`T-001-00`
#> [1] "T-555-97" "T-366-99" "T-428-98" "T-607-99" "T-428-98" "T-001-00"
#> 
#> $`A-001-00`
#> character(0)
#> 
#> $`T-002-00`
#> [1] "T-002-00" "C-374-97"
#> 
#> $`T-007-00`
#> [1] "T-437-96"  "T-426-92"  "T-299-97"  "T-025-99"  "SU-995-99" "T-007-00" 
#> 
#> $`T-003-00`
#> [1] "T-003-00" "T-177-99"
```
