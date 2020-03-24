
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ccc

<!-- badges: start -->

<!-- badges: end -->

El paquete `ccc` sirve para extraer información de la Corte
Constitucional de Colombia.

Se puede installar la versión en desarrollo desde
[GitHub](https://github.com/) con:

``` r
# install.packages("devtools")
devtools::install_github("acastroaraujo/ccc")
```

Tiene 5 funciones:

  - `ccc_tema()` y `ccc_palabra_clave()` son una interface a los
    **buscadores** de la [página
    web](https://www.corteconstitucional.gov.co/relatoria/) de la Corte
    Constitucional.

  - `ccc_texto()` y `ccc_pp()` extraen el **texto** y los **pie de
    página** de una dirección (ej." “/relatoria/2017/C-160-17.htm”).

  - `ccc_sentencias_citadas()` extrae las sentencias que han sido
    citadas por un texto.

## Buscar por tema o palabra clave

``` r
library(ccc)
```

``` r
palabra_clave <- ccc_palabra_clave("jep", p = 0)
> Total de Registros --> 104
```

`ccc_palabra_clave()` y `ccc_tema()` extraen 100 resultados por página.
Si el total de registros supera los 100, se necesita aumentar el
argumento `p` (i.e. `p = 1`).

Así se ve el resultado:

``` r
str(palabra_clave)
> Classes 'tbl_df', 'tbl' and 'data.frame': 100 obs. of  4 variables:
>  $ sentencia: chr  "A613-19" "A556-19" "A531-19" "A508A-19" ...
>  $ type     : chr  "A" "A" "A" "A" ...
>  $ year     : int  2019 2019 2019 2019 2019 2019 2019 2019 2019 2019 ...
>  $ url      : chr  "/Relatoria/autos/2019/A613-19.htm" "/Relatoria/autos/2019/A556-19.htm" "/Relatoria/autos/2019/A531-19.htm" "/Relatoria/autos/2019/A508A-19.htm" ...
```

La función `ccc_tema()` produce (a mi juicio) resultados más robustos:

``` r
tema <- ccc_tema("jep")
> Total de Registros --> 6
str(tema)
> Classes 'tbl_df', 'tbl' and 'data.frame': 6 obs. of  5 variables:
>  $ sentencia: chr  "SU139-19" "SU139-19" "A512-17" "C-674-17" ...
>  $ type     : chr  "SU" "SU" "A" "C" ...
>  $ year     : int  2019 2019 2017 2017 2018 2017
>  $ topic    : chr  "ACCION DE TUTELA CONTRA LA JURISDICCION ESPECIAL PARA LA PAZ JEP-Improcedencia para acceder a la JEP en calidad"| __truncated__ "ACCION DE TUTELA CONTRA LA JURISDICCION ESPECIAL PARA LA PAZ JEP-Improcedencia para activar competencia prevale"| __truncated__ "CONFLICTO NEGATIVO DE COMPETENCIA SUSCITADO ENTRE JUZGADO DEL CIRCUITO Y LA JURISDICCION ESPECIAL PARA LA PAZ J"| __truncated__ "CONTROL DISCIPLINARIO DE LOS MAGISTRADOS DE LA JEP-Esquema determinado por la Constitución Política y la Ley pa"| __truncated__ ...
>  $ url      : chr  "/relatoria/2019/SU139-19.htm" "/relatoria/2019/SU139-19.htm" "/relatoria/autos/2017/A512-17.htm" "/relatoria/2017/C-674-17.htm" ...
```

## Extraer texto

``` r
texto <- ccc_texto("/relatoria/2003/c-776-03.htm")
> .
```

Se pueden extraer muchos documentos usando tidyverse, aunque esto se
puede demorar un rato…

``` r
library(tidyverse)

df <- tema %>% 
  select(-topic) %>% ## estas dos líneas eliminan duplicados que existen
  distinct()         ## porque una sentencia quepa dentro de varios temas

df <- df %>% 
  mutate(texto = map_chr(url, ccc_texto))
> ....

head(df)
> # A tibble: 4 x 5
>   sentencia type   year url                texto                                
>   <chr>     <chr> <int> <chr>              <chr>                                
> 1 SU139-19  SU     2019 /relatoria/2019/S… "Sentencia SU139/19 ACCION DE TUTELA…
> 2 A512-17   A      2017 /relatoria/autos/… "Auto 512/17 CONFLICTO NEGATIVO DE C…
> 3 C-674-17  C      2017 /relatoria/2017/C… "Sentencia C-674/17 REFORMA A LA EST…
> 4 T-365-18  T      2018 /relatoria/2018/T… "Sentencia T-365/18 ACCION DE TUTELA…

## primeros mil caracteres de la C-776-03
texto %>% 
  stringr::str_trunc(1e3) %>% 
  stringr::str_wrap() %>% 
  writeLines()
> Sentencia C-776/03 COSA JUZGADA CONSTITUCIONAL-Configuración INHIBICION DE LA
> CORTE CONSTITUCIONAL-Ineptitud parcial de la demanda PROYECTO DE LEY-Congreso
> observó los términos previstos sobre los cuales media solicitud de trámite de
> urgencia FUNCION PUBLICA POR PARTICULARES-Temporalidad no es regla absoluta y
> rígida FUNCION ADMINISTRATIVA-Atribución a particulares debe hacerse delimitando
> expresamente la función FUNCION ADMINISTRATIVA POR PARTICULARES-Límites para su
> ejercicio FUNCION ADMINISTRATIVA POR PARTICULARES-Término legal de la atribución
> FUNCION ADMINISTRATIVA POR PARTICULARES-Mecanismos para su asignación REMATE DE
> BIENES POR PARTICULARES-Se limita a ejecutar las actuaciones ordenadas por el
> órgano público competente REMATE DE BIENES POR PARTICULARES-Mecanismo para hacer
> efectivo el cobro coactivo de deudas fiscales/REMATE DE BIENES POR PARTICULARES-
> Actividad de carácter instrumental El remate de bienes, por particulares, en
> tanto que mecanismo para hacer efec...
```

## Extraer pies de página

``` r
pp <- ccc_pp("/relatoria/2003/c-776-03.htm")
pp[1:5] ## primeros cinco pies de página
> [1] "[1] Cfr. folio 2 del expediente."                                                                                                                                                                                                                                                                                                                                                                                                                  
> [2] "[2] Cfr. folio 3 del expediente."                                                                                                                                                                                                                                                                                                                                                                                                                  
> [3] "[3] El aparte citado es el siguiente: \"La predeterminación de los tributos y el principio de representación popular en esta materia tienen un objetivo democrático esencial, ya que fortalecen la seguridad jurídica y evitan los abusos impositivos de los gobernantes, puesto que el acto jurídico que impone la contribución debe establecer previamente, y con base en una discusión democrática, sus elementos esenciales para ser válido\"."
> [4] "[4] Cfr. folio 3 del expediente."                                                                                                                                                                                                                                                                                                                                                                                                                  
> [5] "[5] Cfr. folio 4 del expediente."
```

## Extraer sentencias citas

``` r
sentencias_citadas <- ccc_sentencias_citadas(texto)
table(sentencias_citadas) %>% sort(decreasing = TRUE)
> sentencias_citadas
>  C-643-02  C-080-96 C-1144-00  C-485-03  C-925-00  C-084-95  C-094-93 C-1383-00 
>         4         2         2         2         2         1         1         1 
>  C-183-98  C-261-02  C-286-96  C-335-94  C-349-95  C-364-93  C-419-95  C-421-95 
>         1         1         1         1         1         1         1         1 
>  C-445-95  C-505-99  C-556-93  C-597-00  C-711-01  T-532-92 
>         1         1         1         1         1         1
```

``` r
sentencias_citadas <- ccc_sentencias_citadas(pp)
table(sentencias_citadas) %>% sort(decreasing = TRUE)
> sentencias_citadas
>  C-094-93  C-597-00  C-333-93  C-341-98  C-183-98  C-511-96  C-556-93  C-080-96 
>        15        10         6         6         5         4         4         3 
>  C-286-96  C-349-95  C-702-99  C-007-02  C-009-03 C-1064-01 C-1383-00  C-150-97 
>         3         3         3         2         2         2         2         2 
>  C-228-93  C-238-97  C-335-94  C-405-97  C-506-02  C-674-99  C-734-02  C-866-99 
>         2         2         2         2         2         2         2         2 
>  C-925-00  T-426-92  C-025-93  C-070-94 C-1052-01 C-1144-00 C-1144-01 C-1215-01 
>         2         2         1         1         1         1         1         1 
>  C-153-03  C-157-02  C-158-97  C-194-98  C-233-02  C-251-97  C-275-96  C-308-94 
>         1         1         1         1         1         1         1         1 
>  C-352-98  C-364-93  C-419-95  C-421-95  C-430-95  C-442-01  C-445-95  C-478-98 
>         1         1         1         1         1         1         1         1 
>  C-508-01  C-564-96  C-566-95  C-583-96  C-690-96  C-700-99  C-711-01  C-733-03 
>         1         1         1         1         1         1         1         1 
>  C-737-01  C-804-01  C-809-01  C-897-99 SU-111-97 SU-747-98  T-015-95  T-208-99 
>         1         1         1         1         1         1         1         1 
>  T-299-03  T-401-92  T-533-92  T-595-02  T-604-92 
>         1         1         1         1         1
```
