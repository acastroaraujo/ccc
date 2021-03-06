
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ccc

<!-- badges: start -->

<!-- badges: end -->

Nota. La función `ccc_sentencias_citadas()` fue modificada bastante en
esta fecha: 2020-12-09

<img src="man/figures/logo.png" width="40%" />

El paquete `ccc` sirve para extraer información de la Corte
Constitucional de Colombia.

Se puede installar la versión en desarrollo desde
[GitHub](https://github.com/) con:

``` r
# install.packages("devtools")
devtools::install_github("acastroaraujo/ccc")
```

Tiene 7 funciones:

  - `ccc_tema()`, `ccc_palabra_clave()`, son una interface a los
    **buscadores** de la [página
    web](https://www.corteconstitucional.gov.co/relatoria/) de la Corte
    Constitucional.

  - `ccc_texto()` y `ccc_pp()` extraen el **texto** y los **pie de
    página** de una dirección (ej." “/relatoria/2017/C-160-17.htm”).

  - `ccc_texto_pp()` extrae ambas cosas al mismo tiempo.

  - `ccc_sentencias_citadas()` extrae las sentencias que han sido
    citadas por un texto.

  - `ccc_leyes_citadas()` extrae las leyes que han sido citadas por un
    texto.

  - `ccc_num_url()` extrae el URL de la sentencia a partir del número de
    providencia.

## Buscar por tema o palabra clave

``` r
library(ccc)
```

``` r
palabra_clave <- ccc_palabra_clave("paz", p = 0)
> Total de Registros: 5656  [0, 56]
```

`ccc_palabra_clave()` extraen 100 resultados por página. Si el total de
registros supera los 100, se necesita aumentar el argumento `p` (i.e. `p
= 1`, `p = 2`). En la consola aparece un cuadrado que señala cuántos
páginas son (en este caso: 54).

Así se ve el resultado:

``` r
str(palabra_clave)
> tibble [100 × 4] (S3: tbl_df/tbl/data.frame)
>  $ sentencia: chr [1:100] "A410-20" "A398-20" "A397-20" "A396-20" ...
>  $ type     : chr [1:100] "A" "A" "A" "A" ...
>  $ year     : int [1:100] 2020 2020 2020 2020 2020 2020 2020 2020 2020 2020 ...
>  $ path     : chr [1:100] "/Relatoria/autos/2020/A410-20.htm" "/Relatoria/autos/2020/A398-20.htm" "/Relatoria/autos/2020/A397-20.htm" "/Relatoria/autos/2020/A396-20.htm" ...
```

La función `ccc_tema()` extrae 200 resultados por página. Estos
resultados son distintos porque la Secretaría de la Corte (creo) es
quien se encarga de seleccionar las sentencias:

``` r
tema <- ccc_tema("paz")
> Total de Registros: 1515  [0, 7]
str(tema)
> tibble [229 × 5] (S3: tbl_df/tbl/data.frame)
>  $ sentencia: chr [1:229] "T-496-08" "T-647-03" "T-718-02" "T-796-07" ...
>  $ type     : chr [1:229] "T" "T" "T" "T" ...
>  $ year     : int [1:229] 2008 2003 2002 2007 2010 2019 2019 2006 2015 2005 ...
>  $ topic    : chr [1:229] "ACCION DE CUMPLIMIENTO EN MATERIA DE LEY DE JUSTICIA Y PAZ-Medio inidóneo para la protección de derechos fundam"| __truncated__ "ACCION DE TUTELA CONTRA ACERIAS PAZ DEL RIO-No pago de aportes a Fondos Privados de Pensiones" "ACCION DE TUTELA CONTRA ACERIAS PAZ DEL RIO-No pago de aportes al ISS aunque se está devengando otra pensión" "ACCION DE TUTELA CONTRA DECISIONES DE JUECES DE PAZ-Procede aunque no se aplican reglas generales de tutela con"| __truncated__ ...
>  $ path     : chr [1:229] "/relatoria/2008/T-496-08.htm" "/relatoria/2003/T-647-03.htm" "/relatoria/2002/T-718-02.htm" "/relatoria/2007/T-796-07.htm" ...
```

**Búsqueda con operadores**

Las búsquedas también se pueden hacer con *operadores* de la siguiente
manera:

``` r
tema <- ccc_tema('"paz" AND NOT "paz del rio"', p = 2)
> Total de Registros: 1507  [2, 7]
str(tema)
> tibble [529 × 5] (S3: tbl_df/tbl/data.frame)
>  $ sentencia: chr [1:529] "A009-15" "C-370-06" "C-370-06" "C-370-06" ...
>  $ type     : chr [1:529] "A" "C" "C" "C" ...
>  $ year     : int [1:529] 2015 2006 2006 2006 2006 2006 2006 2015 1995 2015 ...
>  $ topic    : chr [1:529] "DERECHOS DE LAS VICTIMAS A LA VERDAD, JUSTICIA, REPARACION Y GARANTIAS DE NO REPETICION-Flexibilidad penal en p"| __truncated__ "DERECHOS DE LAS VICTIMAS EN LEY DE JUSTICIA Y PAZ-Acceso al expediente desde su inicio" "DERECHOS DE LAS VICTIMAS EN LEY DE JUSTICIA Y PAZ-Derecho a recibir información" "DERECHOS DE LAS VICTIMAS EN LEY DE JUSTICIA Y PAZ-Participación en diligencias de versión libre, formulación de"| __truncated__ ...
>  $ path     : chr [1:529] "/relatoria/autos/2015/A009-15.htm" "/relatoria/2006/C-370-06.htm" "/relatoria/2006/C-370-06.htm" "/relatoria/2006/C-370-06.htm" ...

tema <- ccc_tema('"paz" AND "jep"')
> Total de Registros: 6  [0, 0]
str(tema)
> tibble [6 × 5] (S3: tbl_df/tbl/data.frame)
>  $ sentencia: chr [1:6] "SU139-19" "SU139-19" "A512-17" "T-365-18" ...
>  $ type     : chr [1:6] "SU" "SU" "A" "T" ...
>  $ year     : int [1:6] 2019 2019 2017 2018 2018 2017
>  $ topic    : chr [1:6] "ACCION DE TUTELA CONTRA LA JURISDICCION ESPECIAL PARA LA PAZ JEP-Improcedencia para acceder a la JEP en calidad"| __truncated__ "ACCION DE TUTELA CONTRA LA JURISDICCION ESPECIAL PARA LA PAZ JEP-Improcedencia para activar competencia prevale"| __truncated__ "CONFLICTO NEGATIVO DE COMPETENCIA SUSCITADO ENTRE JUZGADO DEL CIRCUITO Y LA JURISDICCION ESPECIAL PARA LA PAZ J"| __truncated__ "CONFLICTOS DE COMPETENCIA EN LOS QUE ESTE INVOLUCRADA LA JURISDICCION ESPECIAL PARA LA PAZ-Es constitucionalmen"| __truncated__ ...
>  $ path     : chr [1:6] "/relatoria/2019/SU139-19.htm" "/relatoria/2019/SU139-19.htm" "/relatoria/autos/2017/A512-17.htm" "/relatoria/2018/T-365-18.htm" ...
```

**NOTA.** Para que la búsqueda con operadores funcione se deben usar
comillas (`"`) alrededor de cada palabra.

Esto funciona: `'"paz" AND "jep"'`

Esto NO funciona: `"'paz' AND 'jep'"`

## Extraer texto

``` r
texto <- ccc_texto("/relatoria/2003/c-776-03.htm")
> Descargando: /relatoria/2003/c-776-03.htm
```

Se pueden extraer muchos documentos usando tidyverse, aunque esto se
puede demorar un rato…

``` r
library(tidyverse)

df <- tema %>% 
  select(-topic) %>% ## estas dos líneas eliminan duplicados que existen
  distinct()         ## porque una sentencia quepa dentro de varios temas

df <- df %>% 
  mutate(texto = map_chr(path, ccc_texto))

df
> # A tibble: 4 x 5
>   sentencia type   year path               texto                                
>   <chr>     <chr> <int> <chr>              <chr>                                
> 1 SU139-19  SU     2019 /relatoria/2019/S… "Sentencia SU139/19 ACCION DE TUTELA…
> 2 A512-17   A      2017 /relatoria/autos/… "Auto 512/17 CONFLICTO NEGATIVO DE C…
> 3 T-365-18  T      2018 /relatoria/2018/T… "Sentencia T-365/18 ACCION DE TUTELA…
> 4 C-674-17  C      2017 /relatoria/2017/C… "Sentencia C-674/17 REFORMA A LA EST…
```

## Fecha

Esta es una función experimental para extraer la fecha completa
(i.e. mes y día).

``` r
ccc_fecha("C-776-03", texto)
> [1] "2003-09-09"

df %>% 
  mutate(date = map2(sentencia, texto, ccc_fecha)) %>% 
  select(sentencia, date) %>% 
  unnest(date)
> # A tibble: 4 x 2
>   sentencia date      
>   <chr>     <date>    
> 1 SU139-19  2019-03-28
> 2 A512-17   2017-10-03
> 3 T-365-18  2018-09-04
> 4 C-674-17  2017-11-14
```

Nota. Esta función no funciona para el 100% de las sentencias.

## Extraer pies de página

``` r
pp <- ccc_pp("/relatoria/2003/c-776-03.htm")
> Descargando: /relatoria/2003/c-776-03.htm
pp[1:8] ## primeros ocho pies de página
> [1] "[1] Cfr. folio 2 del expediente."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
> [2] "[2] Cfr. folio 3 del expediente."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
> [3] "[3] El aparte citado es el siguiente: \"La predeterminación de los tributos y el principio de representación popular en esta materia tienen un objetivo democrático esencial, ya que fortalecen la seguridad jurídica y evitan los abusos impositivos de los gobernantes, puesto que el acto jurídico que impone la contribución debe establecer previamente, y con base en una discusión democrática, sus elementos esenciales para ser válido\"."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
> [4] "[4] Cfr. folio 3 del expediente."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
> [5] "[5] Cfr. folio 4 del expediente."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
> [6] "[6] El aparte citado es el siguiente: \"Para ello, la Constitución otorgó a las autoridades un conjunto de poderes para concretar este deber, los cuales se materializan en la potestad de imposición (C.P. arts. 150-11, 338), de inspección e investigación (C.P. art. 189-20) y de sanción tributarios (C.P. art. 15 último inciso). En otras palabras, el ordenamiento constitucional otorga al Legislador un poder para establecer los tributos y al mismo tiempo reconoce, a la autoridad administrativa, la facultad para exigirlos cuando la ley los determina. Además, los principios de justicia y equidad tributarios (C.P. art. 95-9 y 363) también imponen la obligación para el Estado de gravar, formal y materialmente por igual, a quienes realmente gozan de la misma capacidad económica, pues aquella es un presupuesto o premisa inicial de la tributación\". Por consiguiente, la justa distribución de las cargas públicas es un asunto de interés colectivo que exige, tanto a los particulares como a las autoridades, el deber de colaborar con el control de la recaudación de los dineros públicos. De lo contrario, se produciría una injusta distribución de la carga fiscal, por cuanto si quienes tienen que pagar, no lo hacen, en la práctica, imponen una carga adicional e inequitativa a quienes cumplen con sus obligaciones constitucionales."
> [7] "[7] Cfr. folio 5 del expediente."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
> [8] "[8] Cfr. folio 6 del expediente."
```

## Extraer texto y pies de página

``` r
texto_pp <- ccc_texto_pp("/relatoria/2003/c-776-03.htm")
> Descargando: /relatoria/2003/c-776-03.htm
```

## Extraer sentencias citas

``` r
sentencias_citadas <- ccc_sentencias_citadas(texto_pp)

table(sentencias_citadas) %>% sort(decreasing = TRUE)
> sentencias_citadas
>   C-094-93   C-597-00   C-183-98   C-333-93   C-341-98   C-511-96  C-1144-00 
>         17         13          8          8          7          7          6 
>   C-009-03   C-080-96   C-286-96   C-335-94   C-556-93   C-674-99   C-702-99 
>          5          5          5          5          5          5          5 
>   C-349-95   C-364-93   C-643-02   C-925-00   C-025-93  C-1383-00   C-150-97 
>          4          4          4          4          3          3          3 
>   C-809-01   C-866-99   C-007-02  C-1064-01  C-1115-01  C-1144-01  C-1717-00 
>          3          3          2          2          2          2          2 
>   C-194-98   C-228-93   C-238-97   C-405-97   C-419-95   C-434-96   C-485-03 
>          2          2          2          2          2          2          2 
>   C-505-99   C-506-02   C-690-96   C-711-01   C-734-02   C-992-01   T-015-95 
>          2          2          2          2          2          2          2 
>   T-284-98   T-426-92   C-023-93   C-044-02   C-052-01   C-070-94   C-084-95 
>          2          2          1          1          1          1          1 
>  C-1052-01  C-1185-00  C-1190-01  C-1215-01   C-133-93   C-140-98   C-150-03 
>          1          1          1          1          1          1          1 
>   C-153-03   C-157-02   C-158-97   C-170-01 C-17117-00   C-222-95   C-233-02 
>          1          1          1          1          1          1          1 
>   C-237-97   C-250-03   C-251-97   C-261-02   C-275-96   C-308-94   C-352-98 
>          1          1          1          1          1          1          1 
>   C-369-00   C-421-95   C-430-95   C-442-01   C-445-95   C-478-98   C-508-01 
>          1          1          1          1          1          1          1 
>   C-511-92   C-540-01   C-540-96   C-540-97   C-549-93   C-564-96   C-566-95 
>          1          1          1          1          1          1          1 
>   C-579-01   C-583-96   C-637-00   C-700-99   C-733-03   C-737-01   C-776-03 
>          1          1          1          1          1          1          1 
>   C-804-01   C-897-99   C-984-02  SU-062-99  SU-111-97  SU-430-98  SU-747-98 
>          1          1          1          1          1          1          1 
>   T-005-95  T-1031-00  T-1033-00  T-1176-00   T-119-97   T-144-95   T-146-96 
>          1          1          1          1          1          1          1 
>   T-198-95   T-208-99   T-259-03   T-268-98   T-283-98   T-298-98   T-299-03 
>          1          1          1          1          1          1          1 
>   T-328-98   T-401-92   T-434-99   T-489-98   T-495-99   T-500-96   T-502-99 
>          1          1          1          1          1          1          1 
>   T-506-96   T-527-97   T-529-97   T-532-92   T-533-92   T-545-99   T-595-02 
>          1          1          1          1          1          1          1 
>   T-604-92   T-622-97   T-644-03   T-645-96   T-680-03   T-774-00   T-850-02 
>          1          1          1          1          1          1          1 
>   T-936-99 
>          1
```

## Extraer leyes citas

``` r
leyes_citadas <- ccc_leyes_citadas(texto_pp)
table(leyes_citadas) %>% sort(decreasing = TRUE)
> leyes_citadas
> Ley 788 de 2002 Ley 488 de 1998 Ley 223 de 1995 Ley 489 de 1998 Ley 599 de 2000 
>             131              14              12               7               7 
>  Ley 49 de 1990 Ley 633 de 2000 Ley 383 de 1997  Ley 50 de 1984 Ley 100 de 1993 
>               6               5               3               3               2 
>  Ley 75 de 1986 ley 788 de 2002  Ley 80 de 1993 ley 080 de 2002 Ley 080 de 2002 
>               2               2               2               1               1 
> Ley 101 de 1993 Ley 160 de 1994 Ley 300 de 1996  Ley 34 de 1993  Ley 38 de 1969 
>               1               1               1               1               1 
> Ley 401 de 1997 ley 599 de 2000  Ley 69 de 1993 Ley 715 de 2000  Ley 89 de 1993 
>               1               1               1               1               1
```

## Extraer URL de número de providencia

``` r
# con guíon o barrita
ccc_num_url("C-017-18")
> Total de Registros: 1  [0, 0]
> [1] "/Relatoria/2018/C-017-18.htm"
ccc_num_url("C-017/18")
> Atención: El buscador no muestra resultados a partir del 2019
> Total de Registros: 1  [0, 0]
> [1] "/Relatoria/2018/C-017-18.htm"

## con o sin guión para A y SU
ccc_num_url("A232-20")
> Atención: El buscador no muestra resultados a partir del 2019
> Total de Registros: 1  [0, 0]
> [1] "/Relatoria/autos/2020/A232-20.htm"
ccc_num_url("A-232-20")
> Atención: El buscador no muestra resultados a partir del 2019
> Total de Registros: 1  [0, 0]
> [1] "/Relatoria/autos/2020/A232-20.htm"

## número al azar
ccc_num_url("776")
> Atención: El buscador no muestra resultados a partir del 2019
> Total de Registros: 18  [0, 0]
> Warning: La búsqueda encontró más de un URL
>  [1] "/Relatoria/autos/2018/A776-18.htm" "/Relatoria/2015/T-776-15.htm"     
>  [3] "/Relatoria/2014/T-776-14.htm"      "/Relatoria/2013/T-776-13.htm"     
>  [5] "/Relatoria/2012/T-776-12.htm"      "/Relatoria/2011/T-776-11.htm"     
>  [7] "/Relatoria/2010/C-776-10.htm"      "/Relatoria/2009/T-776-09.htm"     
>  [9] "/Relatoria/2008/T-776-08.htm"      "/Relatoria/2007/T-776-07.htm"     
> [11] "/Relatoria/2006/C-776-06.htm"      "/Relatoria/2005/T-776-05.htm"     
> [13] "/Relatoria/2004/T-776-04.htm"      "/Relatoria/2003/C-776-03.htm"     
> [15] "/Relatoria/2002/T-776-02.htm"      "/Relatoria/2001/C-776-01.htm"     
> [17] "/Relatoria/2000/T-776-00.htm"      "/Relatoria/1998/T-776-98.htm"
```
