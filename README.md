
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

Tiene 7 funciones:

  - `ccc_tema()` y `ccc_palabra_clave()` son una interface a los
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

## Buscar por tema o palabra clave

``` r
library(ccc)
```

``` r
palabra_clave <- ccc_palabra_clave("paz", p = 0)
> Total de Registros: 5463  [0, 54]
```

`ccc_palabra_clave()` extraen 100 resultados por página. Si el total de
registros supera los 100, se necesita aumentar el argumento `p` (i.e. `p
= 1`, `p = 2`). En la consola aparece un cuadrado que señala cuántos
páginas son (en este caso: 54).

Así se ve el resultado:

``` r
str(palabra_clave)
> tibble [100 × 4] (S3: tbl_df/tbl/data.frame)
>  $ sentencia: chr [1:100] "A180-20" "A173-20" "A166-20" "A165-20" ...
>  $ type     : chr [1:100] "A" "A" "A" "A" ...
>  $ year     : int [1:100] 2020 2020 2020 2020 2020 2020 2020 2020 2020 2020 ...
>  $ path     : chr [1:100] "/Relatoria/autos/2020/A180-20.htm" "/Relatoria/autos/2020/A173-20.htm" "/Relatoria/autos/2020/A166-20.htm" "/Relatoria/autos/2020/A165-20.htm" ...
```

La función `ccc_tema()` extrae 200 resultados por página. Estos
resultados son distintos porque la Secretaría de la Corte (creo) es
quien se encarga de seleccionar las sentencias:

``` r
tema <- ccc_tema("paz")
> Total de Registros: 1492  [0, 7]
str(tema)
> tibble [222 × 5] (S3: tbl_df/tbl/data.frame)
>  $ sentencia: chr [1:222] "T-496-08" "T-647-03" "T-718-02" "T-796-07" ...
>  $ type     : chr [1:222] "T" "T" "T" "T" ...
>  $ year     : int [1:222] 2008 2003 2002 2007 2010 2019 2019 2006 2015 2005 ...
>  $ topic    : chr [1:222] "ACCION DE CUMPLIMIENTO EN MATERIA DE LEY DE JUSTICIA Y PAZ-Medio inidóneo para la protección de derechos fundam"| __truncated__ "ACCION DE TUTELA CONTRA ACERIAS PAZ DEL RIO-No pago de aportes a Fondos Privados de Pensiones" "ACCION DE TUTELA CONTRA ACERIAS PAZ DEL RIO-No pago de aportes al ISS aunque se está devengando otra pensión" "ACCION DE TUTELA CONTRA DECISIONES DE JUECES DE PAZ-Procede aunque no se aplican reglas generales de tutela con"| __truncated__ ...
>  $ path     : chr [1:222] "/relatoria/2008/T-496-08.htm" "/relatoria/2003/T-647-03.htm" "/relatoria/2002/T-718-02.htm" "/relatoria/2007/T-796-07.htm" ...
```

**Búsqueda con operadores**

Las búsquedas también se pueden hacer con *operadores* de la siguiente
manera:

``` r
tema <- ccc_tema('"paz" AND NOT "paz del rio"', p = 2)
> Total de Registros: 1484  [2, 7]
str(tema)
> tibble [501 × 5] (S3: tbl_df/tbl/data.frame)
>  $ sentencia: chr [1:501] "C-575-06" "C-370-06" "C-694-15" "T-217-95" ...
>  $ type     : chr [1:501] "C" "C" "C" "T" ...
>  $ year     : int [1:501] 2006 2006 2015 1995 2015 2015 2015 2004 2002 2019 ...
>  $ topic    : chr [1:501] "DERECHOS DE LAS VICTIMAS EN LEY DE JUSTICIA Y PAZ-Protección especial debe brindarse con el consentimiento de la víctima" "DERECHOS DE LAS VICTIMAS EN LEY DE JUSTICIA Y PAZ-Representación judicial en juicio" "DERECHOS DE LAS VICTIMAS EN MATERIA DE RESTITUCION DE TIERRAS DENTRO DEL PROCESO DE JUSTICIA Y PAZ-No existe vulneración" "DERECHOS DE LOS MENORES A LA INTEGRIDAD FAMILIAR Y A LA PAZ" ...
>  $ path     : chr [1:501] "/relatoria/2006/C-575-06.htm" "/relatoria/2006/C-370-06.htm" "/relatoria/2015/C-694-15.htm" "/relatoria/1995/T-217-95.htm" ...

tema <- ccc_tema('"paz" AND "jep"')
> Total de Registros: 4  [0, 0]
str(tema)
> tibble [4 × 5] (S3: tbl_df/tbl/data.frame)
>  $ sentencia: chr [1:4] "SU139-19" "SU139-19" "A512-17" "C-674-17"
>  $ type     : chr [1:4] "SU" "SU" "A" "C"
>  $ year     : int [1:4] 2019 2019 2017 2017
>  $ topic    : chr [1:4] "ACCION DE TUTELA CONTRA LA JURISDICCION ESPECIAL PARA LA PAZ JEP-Improcedencia para acceder a la JEP en calidad"| __truncated__ "ACCION DE TUTELA CONTRA LA JURISDICCION ESPECIAL PARA LA PAZ JEP-Improcedencia para activar competencia prevale"| __truncated__ "CONFLICTO NEGATIVO DE COMPETENCIA SUSCITADO ENTRE JUZGADO DEL CIRCUITO Y LA JURISDICCION ESPECIAL PARA LA PAZ J"| __truncated__ "INTERVENCION DE JURISTAS EXTRANJEROS EN LA JURISDICCION ESPECIAL PARA LA PAZ-Altera de manera sustantiva las di"| __truncated__
>  $ path     : chr [1:4] "/relatoria/2019/SU139-19.htm" "/relatoria/2019/SU139-19.htm" "/relatoria/autos/2017/A512-17.htm" "/relatoria/2017/C-674-17.htm"
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
> # A tibble: 3 x 5
>   sentencia type   year path               texto                                
>   <chr>     <chr> <int> <chr>              <chr>                                
> 1 SU139-19  SU     2019 /relatoria/2019/S… "Sentencia SU139/19 ACCION DE TUTELA…
> 2 A512-17   A      2017 /relatoria/autos/… "Auto 512/17 CONFLICTO NEGATIVO DE C…
> 3 C-674-17  C      2017 /relatoria/2017/C… "Sentencia C-674/17 REFORMA A LA EST…
```

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
>  C-094-93  C-597-00  C-183-98  C-333-93  C-341-98  C-080-96  C-556-93  C-286-96 
>        16        11         6         6         6         5         5         4 
>  C-349-95  C-511-96  C-643-02  C-925-00 C-1144-00 C-1383-00  C-335-94  C-702-99 
>         4         4         4         4         3         3         3         3 
>  C-007-02  C-009-03 C-1064-01  C-150-97  C-228-93  C-238-97  C-364-93  C-405-97 
>         2         2         2         2         2         2         2         2 
>  C-419-95  C-421-95  C-445-95  C-485-03  C-506-02  C-674-99  C-711-01  C-734-02 
>         2         2         2         2         2         2         2         2 
>  C-866-99  T-426-92  C-025-93  C-070-94  C-084-95 C-1052-01 C-1144-01 C-1215-01 
>         2         2         1         1         1         1         1         1 
>  C-153-03  C-157-02  C-158-97  C-194-98  C-233-02  C-251-97  C-261-02  C-275-96 
>         1         1         1         1         1         1         1         1 
>  C-308-94  C-352-98  C-430-95  C-442-01  C-478-98  C-505-99  C-508-01  C-564-96 
>         1         1         1         1         1         1         1         1 
>  C-566-95  C-583-96  C-690-96  C-700-99  C-733-03  C-737-01  C-804-01  C-809-01 
>         1         1         1         1         1         1         1         1 
>  C-897-99 SU-111-97 SU-747-98  T-015-95  T-208-99  T-299-03  T-401-92  T-532-92 
>         1         1         1         1         1         1         1         1 
>  T-533-92  T-595-02  T-604-92 
>         1         1         1
```

## Extraer leyes citas

``` r
leyes_citadas <- ccc_leyes_citadas(texto_pp)
table(leyes_citadas) %>% sort(decreasing = TRUE)
> leyes_citadas
> Ley 788 de 2002 Ley 488 de 1998 Ley 223 de 1995  Ley 49 de 1990 Ley 489 de 1998 
>             123              14              10               6               5 
> Ley 633 de 2000  Ley 50 de 1984 Ley 383 de 1997 Ley 100 de 1993 ley 788 de 2002 
>               5               4               3               2               2 
>  Ley 80 de 1993 ley 080 de 2002 Ley 080 de 2002 Ley 101 de 1993 Ley 160 de 1994 
>               2               1               1               1               1 
> Ley 300 de 1996  Ley 34 de 1993  Ley 38 de 1969 Ley 401 de 1997 ley 599 de 2000 
>               1               1               1               1               1 
> Ley 599 de 2000  Ley 69 de 1993 Ley 715 de 2000  Ley 75 de 1986  Ley 89 de 1993 
>               1               1               1               1               1
```
