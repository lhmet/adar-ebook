---
output:
  html_document: default
  pdf_document: default
---



# Visualização de dados {#data-vis}





> \"Uma imagem vale mais que mil palavras\"

é uma expressão popular atribuída ao filósofo chinês [Confúcio](https://en.wikipedia.org/wiki/Confucius) utilizada para transmitir a ideia do poder da comunicação através das imagens.

Gráficos são uma forma efetiva de representar visualmente seus dados. Eles servem para ressaltar padrões nos dados, frequentemente levam a novas idéias e descobertas, além de fornecer evidências notáveis de quaisquer problemas com os dados. Uma apresentação visual também costuma ser o meio mais eficaz de comunicar informações, seja em infográficos, *dashboards*, aplicações *web* e visualizações interativas.

O <img src="images/logo_r.png" width="20"> possui ferramentas muito poderosas para visualização de dados. Provavelmente o <img src="images/logo_r.png" width="20"> tem mais ferramentas do que você realmente precisa. Existem vários sistemas gráficos para visualizar dados no <img src="images/logo_r.png" width="20"> e  geralmente eles são incompatíveis entre si. Portanto, você não pode combinar facilmente as gráficos de diferentes sistemas.


Neste capítulo, abordamos como fazer gráficos no `R`. É impossível cobrir todas as funcionalidades gráficas disponíveis no <img src="images/logo_r.png" width="20">, confira a [Galeria de Gráficos do R](https://www.r-graph-gallery.com/) para você ter uma noção. Aqui vou me concentrar em algumas abordagens. Primeiro, a estrutura gráfica básica que vem com o próprio <img src="images/logo_r.png" width="20">. Não é algo que eu uso frequentemente ou recomendo, mas é o padrão em muitos pacotes. Então, você precisa ter uma base sobre ele para se virar. Em segundo lugar, discutimos a estrutura **ggplot2**, que baseia-se na [gramática de gráficos](http://amzn.to/2ef1eWp). Ela é minha abordagem preferida para visualizar dados. Ela define uma pequena linguagem de domínio específico para construir gráficos e é perfeita para explorar dados armazenados em quadro de dados. Com um pouco mais de trabalho, você consegue customizar seus gráficos e deixá-los prontos para publicação.

A visualização de dados espaciais também é contemplada no R por vários pacotes específicos. Os links a seguir permitem ter uma ideia das funcionalidades disponíveis:

- https://cran.r-project.org/web/views/Spatial.html;

- https://bhaskarvk.github.io/user2017.geodataviz/;

- http://spatial.ly/r/;

- https://data.cdrc.ac.uk/tutorial/an-introduction-to-spatial-data-analysis-and-visualisation-in-r;


A visualização interativa de dados também é possível e há vários pacotes. Um dos mais interessantes é o **`{plotly}`** que permite a criação de gráficos interativos a partir de gráficos do **`{ggplot2}`**. Dê uma conferida na galeria de gráfico do [plotly-R](https://plot.ly/r/).

A visualização interativa faz mais sentido quando usada para aplicações Web. Para este fim os seguintes pacotes podem ser úteis:

- [plotly](https://plot.ly/r/)

- [highcharter](http://jkunst.com/highcharter/)

- [googleVis](https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.html)

- [rCharts](https://ramnathv.github.io/rCharts/)

- [leaflet](https://rstudio.github.io/leaflet/)

- [iplots](http://rosuda.org/software/iPlots/)

- [rgl](https://cran.r-project.org/web/packages/rgl/vignettes/rgl.html)

- [animation](https://yihui.name/animation/)


<!-- 
Citando @Tufte2001. 
-->


## Pré-requisitos

### Pacotes 

O pacote **`{ggplot2}`** faz parte do **`{tidyverse}`**, mas além dele precisaremos de outros pacotes com funcionalidades que complementam o **`{ggplot2}`**.


```r
pacotes <- c(
  "openair",
  "lubridate",
  "scales",
  "rio",
  "tidyverse",
  #"ggrepel",
  #"ggthemes",
  #"viridis",
  #"ggpubr",
  #"ggmap",
  "psych",
  "grid",
  "lattice",
  "gcookbook"
)
easypackages::libraries(pacotes)
```





### Dados 


  + dados simulados de uma oscilação com amplitude variável
  

```r
x1 <- seq(
  from = -100,
  to = 100,
  by = 0.05
)
A <- seq(
  from = -1,
  to = 1,
  length.out = length(x1)
) %>%
  sin(x = .)
y1 <- exp(-0.07 * A * x1) * cos(x1 + pi / 2)
onda <- tibble(x1, y1)
onda
#> # A tibble: 4,001 x 2
#>        x1       y1
#>     <dbl>    <dbl>
#>  1 -100   -0.00140
#>  2 -100.  -0.00153
#>  3  -99.9 -0.00165
#>  4  -99.8 -0.00177
#>  5  -99.8 -0.00188
#>  6  -99.8 -0.00199
#>  7  -99.7 -0.00210
#>  8  -99.6 -0.00221
#>  9  -99.6 -0.00231
#> 10  -99.6 -0.00240
#> # … with 3,991 more rows
```

  + Dados de qualidade do ar em NY


```r
#help(airquality)
head(airquality)
#>   Ozone Solar.R Wind Temp Month Day
#> 1    41     190  7.4   67     5   1
#> 2    36     118  8.0   72     5   2
#> 3    12     149 12.6   74     5   3
#> 4    18     313 11.5   62     5   4
#> 5    NA      NA 14.3   56     5   5
#> 6    28      NA 14.9   66     5   6
# conversão da Temp de Farenheith para Celsius
aq <- airquality %>%
  mutate(Temp = (Temp - 32)/5,
        # adicionando coluna date criada das colunas Day e Month
        # o ano das medidas é 1973, conforme help
         date = as.Date(
           paste(Day, Month, "1973"),
           format = "%d %m %Y")
         ) %>%
  # removendo as colunas Month e Day e reordenando as colunas
  dplyr::select(., date, Ozone:Temp, -c(Month, Day))
head(aq)
#>         date Ozone Solar.R Wind Temp
#> 1 1973-05-01    41     190  7.4  7.0
#> 2 1973-05-02    36     118  8.0  8.0
#> 3 1973-05-03    12     149 12.6  8.4
#> 4 1973-05-04    18     313 11.5  6.0
#> 5 1973-05-05    NA      NA 14.3  4.8
#> 6 1973-05-06    28      NA 14.9  6.8
```

  

  + Precipitação climatológica mensal das estações climatológicas do [INMET](http://www.inmet.gov.br/portal/index.php?r=clima/normaisClimatologicas) 


```r
# importando dados
prec <- import(
  "https://www.dropbox.com/s/9ym0845apcj38wq/PrecAccInmet_61_90.rds?dl=1", 
  format = "rds"
)
head(prec)
#>   codigo            nome estado mes value
#> 1  82704 Cruzeiro do Sul     AC jan 257.9
#> 2  82915      Rio Branco     AC jan 289.0
#> 3  82807        Tarauacá     AC jan 286.6
#> 4  83098        Coruripe     AL jan  21.6
#> 5  82994          Maceió     AL jan  78.1
#> 6  82988     Mata Grande     AL jan  62.1
```

 + Dados de precipitação anual de algumas capitais do mundo


```r
## dados rain
rain <- import(
  file = "https://www.dropbox.com/s/z873gcyjouegspk/cityrain.csv?dl=1", 
  format = "csv", 
  header = TRUE
)
head(rain)
#>   Month Tokyo NewYork London Berlin
#> 1   Jan  49.9    83.6   48.9   42.4
#> 2   Feb  71.5    78.8   38.8   33.2
#> 3   Mar 106.4    98.5   39.3   34.5
#> 4   Apr 129.2    93.4   42.4   39.7
#> 5   May 144.0   106.0   47.0   52.6
#> 6   Jun 176.0    84.5   48.3   70.5
```

  + anomalias de temperatura do ar global Global de 1800 a 2011


```r
data(climate, package = "gcookbook")
#help(climate,package = "gcookbook")
head(climate)
#>     Source Year Anomaly1y Anomaly5y Anomaly10y Unc10y
#> 1 Berkeley 1800        NA        NA     -0.435  0.505
#> 2 Berkeley 1801        NA        NA     -0.453  0.493
#> 3 Berkeley 1802        NA        NA     -0.460  0.486
#> 4 Berkeley 1803        NA        NA     -0.493  0.489
#> 5 Berkeley 1804        NA        NA     -0.536  0.483
#> 6 Berkeley 1805        NA        NA     -0.541  0.475
```

-  Metadados das estações meteorológicas automáticas (EMA) do INMET;


```r
# dados de estações com localização, alt e tmed
sulbr_md <- import(
  "https://www.dropbox.com/s/3ddxq5v5a8i7dnw/info_sumary_tair_sul.rds?dl=1",
  format = "rds"
) %>%
  mutate(.,
    tmed = (tmax_med + tmin_med) / 2
  )
sulbr_md
#> # A tibble: 82 x 18
#>    site  tmax_med tmin_med dtr_med sdate      edate      period max_tair
#>    <chr>    <dbl>    <dbl>   <dbl> <date>     <date>      <dbl>    <dbl>
#>  1 A801      24.8     16.1    8.66 2000-09-22 2015-12-31   15.3       40
#>  2 A802      22.1     15.3    6.77 2001-11-16 2015-12-31   14.1       38
#>  3 A803      24.8     14.8    9.94 2001-11-26 2015-12-31   14.1       40
#>  4 A805      24.7     15.1    9.60 2001-12-05 2015-12-31   14.1       36
#>  5 A806      24.5     18.0    6.49 2003-01-22 2015-12-31   12.9       39
#>  6 A807      22.9     14.3    8.65 2003-01-28 2015-12-31   12.9       34
#>  7 A808      22.2     16.3    5.87 2006-06-01 2015-12-31    9.6       41
#>  8 A809      25.5     15.0   10.5  2006-09-28 2015-12-31    9.3       40
#>  9 A810      26.5     15.3   11.2  2006-11-15 2015-12-31    9.1       39
#> 10 A811      20.9     13.0    7.84 2007-01-24 2015-12-31    8.9       37
#> # … with 72 more rows, and 10 more variables: min_tair <dbl>, missing <dbl>,
#> #   long_gap <dbl>, sdate_lg <dttm>, name <chr>, state <chr>, lon <dbl>,
#> #   lat <dbl>, alt <dbl>, tmed <dbl>
```


- dados meteorológicos horários das EMAs


```r
# dados com séries temporais
sulbr_dh <- import("https://www.dropbox.com/s/iesn64ij633rofp/data_inmet_sul_RS.rds?dl=1",
  format = "rds"
) %>%
  #filter(year(date) >= 2008, year(date) <= 2015) %>%
  select(site:tair, rh, prec, rg, wd, ws, wsmax) %>% as_tibble()
```


```r
glimpse(sulbr_dh)
#> Rows: 2,806,728
#> Columns: 9
#> $ site  <chr> "A801", "A801", "A801", "A801", "A801", "A801", "A801", "A801",…
#> $ date  <dttm> 2000-09-22 00:00:00, 2000-09-22 01:00:00, 2000-09-22 02:00:00,…
#> $ tair  <dbl> NA, NA, NA, NA, 15.5, 15.3, 15.1, 14.8, 14.5, 14.4, 14.4, 15.3,…
#> $ rh    <dbl> NA, NA, NA, NA, 94, 95, 94, 95, 94, 85, 86, 84, 76, 62, 49, 45,…
#> $ prec  <dbl> NA, NA, NA, NA, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ rg    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 16.944444, 141.111111, …
#> $ wd    <dbl> NA, NA, NA, NA, 231, 255, 245, 246, 239, 177, 217, 166, 159, 18…
#> $ ws    <dbl> NA, NA, NA, NA, 1.2, 2.2, 1.9, 1.5, 1.7, 1.7, 1.8, 2.2, 2.2, 2.…
#> $ wsmax <dbl> NA, NA, NA, NA, 4.4, 4.2, 4.1, 3.9, 3.3, 6.7, 7.6, 5.3, 6.1, 4.…
#range(sulbr_dh$date)
```

Vamos obter a média da `tair` para cada dia do ano na EMA de POA.


```r
tair_poa_dly <- sulbr_dh %>%
  filter(site == "A801") %>%
  select(site:tair) %>%
  group_by(date = as.Date(date)) %>%
  summarise(tair = mean(tair, na.rm = TRUE)) %>%
  mutate(tair = ifelse(is.nan(tair), NA, tair))
#> `summarise()` ungrouping output (override with `.groups` argument)

glimpse(tair_poa_dly)
#> Rows: 5,579
#> Columns: 2
#> $ date <date> 2000-09-22, 2000-09-23, 2000-09-24, 2000-09-25, 2000-09-26, 200…
#> $ tair <dbl> 17.12000, 17.60417, 14.99583, 10.70417, 11.83333, 14.52917, 18.5…
```


```r
tair_poa_clim <- tair_poa_dly %>%
  group_by(doy = lubridate::yday(date)) %>%
  summarise(med = mean(tair, na.rm = TRUE),
            max = max(tair, na.rm = TRUE),
            min = min(tair, na.rm = TRUE),
            q5 = quantile(tair, p = 0.05, na.rm = TRUE),
            q95 = quantile(tair, p = 0.95, na.rm = TRUE),
            n_anos = n(),
            n_obs = sum(!is.na(tair))
            ) %>% 
  ungroup()
#> `summarise()` ungrouping output (override with `.groups` argument)
tair_poa_clim
#> # A tibble: 366 x 8
#>      doy   med   max   min    q5   q95 n_anos n_obs
#>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>  <int> <int>
#>  1     1  24.3  27.5  19.6  20.0  27.4     15    15
#>  2     2  24.2  28.4  20.2  20.3  28.1     15    15
#>  3     3  23.5  27.3  16.0  19.8  27.3     15    15
#>  4     4  24.4  27.3  19.2  21.5  27.1     15    15
#>  5     5  24.9  27.8  20.9  21.7  26.9     15    15
#>  6     6  25.5  28.6  22.5  23.6  27.9     15    15
#>  7     7  25.8  28.8  21.8  23.1  28.2     15    15
#>  8     8  25.6  28.5  23.4  23.5  27.9     15    15
#>  9     9  26.0  29.5  21.9  23.8  28.5     15    15
#> 10    10  25.8  29.4  22.3  22.8  28.6     15    15
#> # … with 356 more rows
```




```r
#timePlot(filter(sulbr_dh, site == "A801"), "tair")
```


  
## Sistemas Gráficos 

O <img src="images/logo_r.png" width="20"> possui uma poderosa [plataforma de ferramentas gráficas](http://cran.r-project.org/web/views/Graphics.html) para visualização de dados. 


Os sistemas gráficos nativos do <img src="images/logo_r.png" width="20"> são: 

- **Sistema Básico**: é um modelo similar ao de uma tela de pintura, se errar algo, tem que refazer tudo novamente numa nova tela. A principal função é a `plot()`. 

+ **[sistema de grade](https://www.stat.auckland.ac.nz/~paul/grid/grid.html)**: fornece funções gráficas mais flexíveis para o *layout* de gráficos, como a criação de múltiplas regiões (*viewports*) em uma mesma página;
   
   - requer especificações detalhadas de onde plotar os pontos, linhas, retângulos e consequentemente um gráfico é elaborado a partir de várias linhas de código. 
    
## Pacotes Gráficos 

### graphics

O sistema básico de gráficos do <img src="images/logo_r.png" width="20"> está implementado no pacote **`{graphics}`**. Ele é carregado quando iniciamos o R. Veja a saída da função `sessionInfo()` para verificar nas informações de sua sessão os pacotes carregados. 
Para ver exemplos de gráficos básicos digite `demo("graphics")` e `library(help = "graphics")` para listar as funções disponíveis no **`{graphics}`**.



```r
# lista de funções do pacote graphics
library(help = "graphics")
# exemplos de gráficos
demo("graphics")
```

Um exemplo simples de uso da função `graphics::plot()` é mostrado abaixo:


```r
with(
  sulbr_md,
  plot(x = alt, y = tmax_med)
)
```

<img src="images/unnamed-chunk-15-1.png" width="672" style="display: block; margin: auto;" />

Para ilustrar os diferentes sistemas gráficos disponíveis no <img src="images/logo_r.png" width="20">, vamos mostrar como gerar este mesmo gráfico usando o sistema **`{grid}`**, **`{lattice}`** e **`{ggplot2}`**.

### grid

  O sistema **{grid}** também faz parte da distribuição básica do <img src="images/logo_r.png" width="20">, mas o pacote precisa ser carregado (`library(grid)`)

    

```r
library(grid)
## define tamanho da região para plot (viewport)
pushViewport(plotViewport(c(5, 4, 2, 2)))
## define intervalos de variação das escalas x e y
pushViewport(
  dataViewport(
    xData = sulbr_md$alt,
    yData = sulbr_md$tmed
  )
)
## retângulo em torno da região do plot
grid.rect()
## eixos x e y
grid.xaxis()
grid.yaxis()
## labels dos eixos x e y
grid.text("Altitude (m)", y = unit(-3, "lines"))
grid.text("Temperatura (°C)", x = unit(-3, "lines"), rot = 90)
## símbolos dos dados
grid.points(
  x = sulbr_md$alt,
  y = sulbr_md$tmed,
  name = "dataSymbols"
)
```

<img src="images/unnamed-chunk-16-1.png" width="672" style="display: block; margin: auto;" />

    
### [lattice](http://lattice.r-forge.r-project.org/)

É baseado no sistema *grid* e os gráficos são armazenados como variáveis (objetos que podem ser salvos). Isto possibilita plotar, fazer alterações e atualizações no objeto.
    
Um grande atrativo do **{`lattice`}** são os gráficos multipainel para análise de dados multivariados.
    


```r
# exemplo lattice
library(lattice)
# interface usando fórmula
 xyplot(tmed ~ alt, data = sulbr_md)
```

<img src="images/unnamed-chunk-17-1.png" width="672" style="display: block; margin: auto;" />


### [ggplot2](http://ggplot2.org/)

Assim como lattice também foi construído baseado no sistema *grid*. É um sistema poderoso de gráficos que torna mais fácil a produção de gráficos complexos com multicamadas. Usa os aspectos bons de ambos sistemas **base** e **lattice**. O principal fator da popularidade do **`{ggplot2}`** é o seu modelo mental mais claro e ser altamente customizável, apesar de um processamento mais lento.


```r
## exemplo ggplot2
library(ggplot2)
 qplot(x = alt, y = tmed, data = sulbr_md)
```

<img src="images/unnamed-chunk-18-1.png" width="672" style="display: block; margin: auto;" />


### Terminologia: funções de alto e baixo nível

**Funções de alto nível** produzem um gráfico completo. Por exemplo:


```r
# exemplo função gráfica de alto nível
plot(x1, y1, las = 1)
```

<img src="images/unnamed-chunk-19-1.png" width="672" style="display: block; margin: auto;" />

**Funções de baixo nível** adicionam saídas a um plot existente, logo vão sobrepor o que estiver na tela gráfica. Considere o gráfico da onda abaixo:


```r
# exemplo função gráfica de alto nível
plot(x1, y1, las = 1)
```

<img src="images/plot-alto-nivel-1.png" width="672" style="display: block; margin: auto;" />

As expressões a seguir adicionam pontos, linhas de grade, uma linha horizontal de referência em `y = 0`, título e uma borda ao gráfico básico gerado no código anterior. Todas estas funções são de baixo nível.


```r
plot(x1, y1, las = 1)
# exemplo funções gráficas de baixo nível
points(x1, y1,                    # adiciona pontos com cor e símbolo
       col = 2,                   # cor do ponto
       pch = 20,                  # tipo (círculo preenchido)
       cex = 0.8)                 # tamanho relativo do símbolo (default =1) 
grid()                            # adiciona linhas de grade
abline(h = 0,col = "gray")        # linhade referência (y = 0)
title(main = "Gráfico a partir de funções de baixo nível")      # adiciona título ao gráfico
box(lwd = 2)                      # adiciona retângulo em torna da região do gráfico, com linha mais larga
```

<img src="images/funcoes-baixo-nivel-1.png" width="672" style="display: block; margin: auto;" />

Ambos os Sistemas Básico e de Grade fornecem funções gráficas de baixo nível. O Sistema de Grade também oferece funções para interação com os gráficos de saída (como a edição, extração, remoção de partes de uma imagem). A Maioria das funções em pacotes gráficos produz gráficos completos e geralmente oferecem gráficos específicos para um tipo de análise ou campo de estudo.
  
Neste capítulo será dado foco a produção de gráficos usando o Sistema Básico do <img src="images/logo_r.png" width="20">.

## Funções gráficas básicas

### Diferentes entradas de dados na `plot()`

A função `plot()` é o carro chefe do Sistema Básico do <img src="images/logo_r.png" width="20">. Quando especificamos apenas um vetor é plotado seus valores no eixo y em função de seu tamanho `1:length(x)` no eixo x.


```r
plot(y1)
```

<img src="images/unnamed-chunk-20-1.png" width="672" style="display: block; margin: auto;" />

Você também pode especificar os parâmetros x e y. 


```r
plot(x = x1, y = y1)
```

<img src="images/unnamed-chunk-21-1.png" width="672" style="display: block; margin: auto;" />
  

Também podemos especificar no primeiro argumento da `plot()` uma fórmula, p.ex.: `y ~ x` que pode ser interpretada como y (variável) em função de x.


```r
plot(y1 ~ x1)
```

<img src="images/unnamed-chunk-22-1.png" width="672" style="display: block; margin: auto;" />

Se você tem seus dados em um quadro de dados, utilize o argumento `data` e o nome das variáveis que deseja plotar na fórmula.


```r
plot(tmed ~ alt,  data = sulbr_md)
```

<img src="images/unnamed-chunk-23-1.png" width="672" style="display: block; margin: auto;" />

Aplicando a `plot()` a um *quadro de dados* com duas variáveis resulta um gráfico equivalente ao caso anterior.


```r
plot(onda)
```

<img src="images/unnamed-chunk-24-1.png" width="672" style="display: block; margin: auto;" />

#### Gráficos de dispersão

Aplicando a `plot()` a um quadro de dados com mais de duas variáveis resulta um gráfico de dispersão entre todas as variáveis do *quadro de dados*.


```r
## plot de todas colunas de aq, exceto a 1a coluna
plot(select(aq, -date))
```

<img src="images/unnamed-chunk-25-1.png" width="672" style="display: block; margin: auto;" />

Cada gráfico desses é chamado de gráfico de dispersão. Através dele pode-se visualizar a relação entre duas variáveis. Nesse caso o gráfico resultante é uma matriz de gráficos de dispersão.

Existe uma função gráfica específica para produção deste tipo de gráfico: a função `pairs()`. 


```r
# plote de pares
pairs(select(aq, -date))
```

<img src="images/unnamed-chunk-26-1.png" width="672" style="display: block; margin: auto;" />

A função `pairs.panels()` do pacote `psych` fornece um gráfico de pares bastante informativo e foi expandida a partir da função `pairs()`.


```r
pairs.panels(x = select(aq, -date))
```

<img src="images/unnamed-chunk-27-1.png" width="672" style="display: block; margin: auto;" />

Para fechar as janelas gráficas abertas:


```r
graphics.off()
```


## Parâmetros gráficos

Podemos personalizar muitas características de um gráfico (cores, eixos, títulos) através de opções chamadas **parâmetros gráficos**.

As opções são especificadas através da função `par()`. Os parâmetros assim definidos terão efeito até o fim da sessão ou até que eles sejam mudados.

Digitando `par()` sem parâmetros produz uma lista das configurações gráficas atuais. A diversidade de parâmetros pode ser vista pela estrutura da `par()`.



```r
str(par())
#> List of 72
#>  $ xlog     : logi FALSE
#>  $ ylog     : logi FALSE
#>  $ adj      : num 0.5
#>  $ ann      : logi TRUE
#>  $ ask      : logi FALSE
#>  $ bg       : chr "white"
#>  $ bty      : chr "o"
#>  $ cex      : num 1
#>  $ cex.axis : num 1
#>  $ cex.lab  : num 1
#>  $ cex.main : num 1.2
#>  $ cex.sub  : num 1
#>  $ cin      : num [1:2] 0.15 0.2
#>  $ col      : chr "black"
#>  $ col.axis : chr "black"
#>  $ col.lab  : chr "black"
#>  $ col.main : chr "black"
#>  $ col.sub  : chr "black"
#>  $ cra      : num [1:2] 28.8 38.4
#>  $ crt      : num 0
#>  $ csi      : num 0.2
#>  $ cxy      : num [1:2] 0.026 0.0633
#>  $ din      : num [1:2] 7 5
#>  $ err      : int 0
#>  $ family   : chr ""
#>  $ fg       : chr "black"
#>  $ fig      : num [1:4] 0 1 0 1
#>  $ fin      : num [1:2] 7 5
#>  $ font     : int 1
#>  $ font.axis: int 1
#>  $ font.lab : int 1
#>  $ font.main: int 2
#>  $ font.sub : int 1
#>  $ lab      : int [1:3] 5 5 7
#>  $ las      : int 0
#>  $ lend     : chr "round"
#>  $ lheight  : num 1
#>  $ ljoin    : chr "round"
#>  $ lmitre   : num 10
#>  $ lty      : chr "solid"
#>  $ lwd      : num 1
#>  $ mai      : num [1:4] 1.02 0.82 0.82 0.42
#>  $ mar      : num [1:4] 5.1 4.1 4.1 2.1
#>  $ mex      : num 1
#>  $ mfcol    : int [1:2] 1 1
#>  $ mfg      : int [1:4] 1 1 1 1
#>  $ mfrow    : int [1:2] 1 1
#>  $ mgp      : num [1:3] 3 1 0
#>  $ mkh      : num 0.001
#>  $ new      : logi FALSE
#>  $ oma      : num [1:4] 0 0 0 0
#>  $ omd      : num [1:4] 0 1 0 1
#>  $ omi      : num [1:4] 0 0 0 0
#>  $ page     : logi TRUE
#>  $ pch      : int 1
#>  $ pin      : num [1:2] 5.76 3.16
#>  $ plt      : num [1:4] 0.117 0.94 0.204 0.836
#>  $ ps       : int 12
#>  $ pty      : chr "m"
#>  $ smo      : num 1
#>  $ srt      : num 0
#>  $ tck      : num NA
#>  $ tcl      : num -0.5
#>  $ usr      : num [1:4] 0 1 0 1
#>  $ xaxp     : num [1:3] 0 1 5
#>  $ xaxs     : chr "r"
#>  $ xaxt     : chr "s"
#>  $ xpd      : logi FALSE
#>  $ yaxp     : num [1:3] 0 1 5
#>  $ yaxs     : chr "r"
#>  $ yaxt     : chr "s"
#>  $ ylbias   : num 0.2
```

O parâmetro `no.readonly = TRUE` produz uma lista das configurações atuais que podem ser modificadas posteriormente.


```r
# cópia das configurações atuais
old_par <- par(no.readonly = TRUE)
# tipo de linha pontilhada, largura da linha, símbolo para plot (triângulo sólido)
par(lty = 3, pch = 17)
with(
  aq,
  plot(
    x = date,
    y = Wind,
    type = "b"
  )
) # linha e ponto desconectados
```

<img src="images/unnamed-chunk-30-1.png" width="672" style="display: block; margin: auto;" />

```r
# restabelecendo parâmetros originais
par(old_par)
```

Podemos definir `par()` quantas vezes forem necessárias.
  
A segunda forma de especificar parâmetros é `parametro = valor` diretamente na função gráfica de alto nível.
  
Mas nesse caso, as opções terão efeito (local) apenas para aquele gráfico específico , portanto diferindo da primeira forma em que a definição pode ser para toda sessão (global).
  
Poderíamos gerar o mesmo gráfico anterior  da seguinte forma:


```r
with(
  aq,
  plot(
    x = date,
    y = Wind,
    type = "b",
    lty = 3,
    pch = 17
  )
)
```

<img src="images/unnamed-chunk-31-1.png" width="672" style="display: block; margin: auto;" />

Nem todas funções de alto nível permitem especificar todos parâmetros gráficos. Veja  o `help(plot)` para determinar quais parâmetros gráficos podem configurados dessa forma.


```r
?plot
```

A seguir veremos alguns importantes parâmetros gráficos que podemos configurar.

### Símbolos e linhas

Vimos que podemos especificar símbolos e linhas nos gráficos. Os parâmetros relevantes para essas opções são mostradas na tabela a seguir.

| Parâmetro | Descrição                                                                                                                                       |
|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| **pch**       | define o símbolo a ser usado para pontos                                                                                                        |
| **cex**       | tamanho do símbolo, cex é um nº indicando a quantidade pela qual símbolos devem ser relativos, Default = 1, 1.5 é 50 % maior, 0.5 é 50 % menor. |
| **lty**       | tipo de linha                                                                                                                                   |
| **lwd**       | largura da linha, expresso em relação ao default (=1), então lwd = 2 gera uma linha com o dobro de largura da linha default.                    |

Os símbolos são especificados conforme numeração indicada no gráfico abaixo.

<img src="images/unnamed-chunk-33-1.png" width="672" style="display: block; margin: auto;" />

As opções de tipo de linha são mostradas abaixo.


```r
# linhas
op <- par(lwd = 3,
          cex = 1.5,
          cex.axis = 1, 
          cex.lab = 1, 
          font = 2, 
          font.axis = 2, 
          font.lab = 2)
plot(
  x = c(0, 10),
  y = c(1, 6),
  type = "n",
  xlab = "",
  ylab = "",
  main = "Amostra de tipo de linhas",
  axes = FALSE,
  frame.plot = FALSE
)
axis(
  side = 2,
  lwd = 3,
  at = seq(1, 6, by = 1),
  cex = 1.25,
  font = 2,
  col = "white"
)
mtext(
  "Nº do tipo de linha (lty = )",
  side = 2,
  line = 2,
  cex = 1.5,
  font = 2
)
abline(h = 1:6, lty = 1:6)
```

<img src="images/Chunk611-1.png" width="672" style="display: block; margin: auto;" />

```r
par(op)
```

Exemplo com as opções.


```r
with(
  aq,
  plot(
    x = date,
    y = Temp,
    type = "b",
    lty = 3,
    pch = 15,
    cex = 2
  )
)
```

<img src="images/unnamed-chunk-34-1.png" width="672" style="display: block; margin: auto;" />


### Cores

Há diversos parâmetros relacionados a cores no <img src="images/logo_r.png" width="20">. A tabela abaixo mostra os mais comuns.

| Parâmetro | Descrição                                                                                                  |
|-----------|------------------------------------------------------------------------------------------------------------|
| `col`       | cor default do gráfico. Algumas funções como `lines()` e `pie()` aceitam um vetor de cores que são recicladas |
| `col.axis`  | cor do texto (título) nos eixos                                                                            |
| `col.lab`   | cor dos rótulos dos eixos                                                                                     |
| `col.main`  | cor do texto do título do gráfico                                                                          |
| `col.sub`  | cor do sub-título                                                                                          |
| `fg`        | cor do primeiro plano                                                                                      |
| `bg`       | cor do plano de fundo                                                                                      |


Podemos especificar as cores no <img src="images/logo_r.png" width="20"> por índice, nome, hexadecimal, RGB ou HSV. Por exemplo `col = 0`, `col = "white"`, `col =FFFFF`, `col = rgb(1,1,1)` e `col = hsv(1,1,1)` são formas equivalentes de especificar a cor branca.

A função `colors()` retorna o nome de todas as cores disponíveis.


```r
colors()[1:20]
#>  [1] "white"         "aliceblue"     "antiquewhite"  "antiquewhite1"
#>  [5] "antiquewhite2" "antiquewhite3" "antiquewhite4" "aquamarine"   
#>  [9] "aquamarine1"   "aquamarine2"   "aquamarine3"   "aquamarine4"  
#> [13] "azure"         "azure1"        "azure2"        "azure3"       
#> [17] "azure4"        "beige"         "bisque"        "bisque1"
n <- length(colors())
op <- par(bg = "gray60")
plot(
  x = onda$x1[1:n], 
  y = onda$y1[1:n],
  type = "n",
  xlab = "x",
  ylab = "y",
  main = "Várias cores",
  sub = "Onda colorida",
  col.axis = "green",
  col.lab = "green",
  col.axis = "yellow",
  col.sub = "red"
)
usr <- par("usr")
rect(usr[1], usr[3], usr[2], usr[4], col = "snow", border = "black", lwd = 2)
points(
  x = onda$x1[1:n], 
  y = onda$y1[1:n],
  col = colors()[1:n],
  pch = 20,
  cex = (1:n) / 60 * 4
)
```

<img src="images/unnamed-chunk-35-1.png" width="672" style="display: block; margin: auto;" />

```r
par(op)
```

Para visualizar as cores e os nomes associados a cada uma veja [http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf).

O <img src="images/logo_r.png" width="20"> também possui diversas funções para criar vetores de cores contínuas (paletas):


```r
# lista com vetor de diferentes paletas de cores
paletas <- list(
  rainbow(n),
  heat.colors(n),
  terrain.colors(n),
  topo.colors(n),
  cm.colors(n)
)
for (ipal in seq_along(paletas)) {
  plot(
    x = onda$x1[1:n],
    y = onda$y1[1:n],
    type = "p",
    xlab = "x",
    ylab = "y",
    main = "Várias cores",
    sub = "Onda colorida",
    col = paletas[[ipal]], # função para paleta arco-íris
    pch = 20,
    cex = (1:n) / 60 * 4
  )
}
```

<img src="images/unnamed-chunk-36-1.png" width="672" style="display: block; margin: auto;" /><img src="images/unnamed-chunk-36-2.png" width="672" style="display: block; margin: auto;" /><img src="images/unnamed-chunk-36-3.png" width="672" style="display: block; margin: auto;" /><img src="images/unnamed-chunk-36-4.png" width="672" style="display: block; margin: auto;" /><img src="images/unnamed-chunk-36-5.png" width="672" style="display: block; margin: auto;" />

### Características de texto

Parâmetros especificando tamanho do texto.

| Parâmetro | Descrição                                                                                            |
|-----------|------------------------------------------------------------------------------------------------------|
| cex       | nº indicando a quantidade pela qual o texto plotado deve ser escalonado em relação ao default (=1).  |
| cex.axis  | magnificação do texto dos eixos (títulos).                                                           |
| cex.lab   | magnificação dos rótulos em relação ao cex.                                                          |
| cex.main  | magnificação dos títulos em relação ao cex.                                                          |
| cex.sub   | cor do sub-título                                                                                    |

Parâmetros especificando família, tamanho e estilo da fonte.

| Parâmetro | Descrição                                                                                                                   |
|-----------|-----------------------------------------------------------------------------------------------------------------------------|
| font      | inteiro especificando a fonte a ser usada. 1 = normal, 2 = negrito, 3 = itálico, 4 = negrito e itálico, 5 = símbolo (adobe) |
| font.axis | fonte para o texto do eixo                                                                                                  |
| font.lab  | fonte para o rótulo do eixo                                                                                                 |
| font.main | fonte para o título                                                                                                         |
| font.sub  | fonte para o sub-título                                                                                                     |
| ps        | tamanho do ponto da fonte (ps = 1/72 *cex)                                                                                  |
| family    |                                                                                                                             |



```r
op <- par(font.lab = 3, cex.lab = 2, font.main = 4, cex.main = 2)
plot(x = onda$x1[1:n], 
     y = onda$y1[1:n], 
     type = "p",
     xlab = "x",
     ylab = "y",
     main = "Várias cores",
     sub = "Onda colorida",
     col = gray.colors(n), 
     pch = 20, 
     cex = (1:n)/60 * 4)
```

<img src="images/unnamed-chunk-37-1.png" width="672" style="display: block; margin: auto;" />

```r
par(op)
```

#### Tipos de Gráficos 

Até aqui já vimos como criar gráficos de dispersão com a função `plot()`. Mas existe uma ampla variedade de gráficos, além daqueles: gráficos de barra, *boxplots*, histogramas, gráficos de pizza, gráficos de imagens, gráficos 3D. Alguns exemplos são mostrados a seguir.

A seguir podemos ver como construir um gráfico da amplitude térmica diária (ATD) de cada EMA. As EMAs serão apresentadas em ordem crescente de ATD.


```r
# ordenando amplitudes térmicas
atd_ord <- sort(sulbr_md$dtr_med)
# vetor do nome das EMAS ordenados
nms_ema <- sulbr_md$site[order(sulbr_md$dtr_med)]
#filter(sulbr_md, site %in% c("A866", "A874"))
# gráfico de barras
  barplot(
    height = atd_ord,
    names.arg = nms_ema,
    col = 1, # cor das barras
    border = "red", # cor das bordas das barras
    las = 2, # orientação dos labels dos eixos
    cex.names = 0.75, # tamnho relativo labels eixo x
    cex.axis = 0.75, # tamnho relativo labels eixo y
    xlab = "EMA", # label do eixo x
    ylab = "Amplitude térmica (°C)" # labels do eixo y
  )
box()
```

<img src="images/unnamed-chunk-38-1.png" width="960" style="display: block; margin: auto;" />

Para ilustrar um histograma usaremos os dados de temperatura horária de Santa Maria.


```r
# dados de temp de SM
th_sm <- filter(sulbr_dh, site == "A803") %>%
  pull(tair)
hist(x = th_sm)
```

<img src="images/unnamed-chunk-39-1.png" width="672" />

O número de classes para discretização dos dados pode ser especificado no parâmetro `breaks`.


```r
hist(x = th_sm, breaks = 10)
```

<img src="images/unnamed-chunk-40-1.png" width="672" />

Usando a interface de fórmula podemos fazer facilmente um boxplot da temperatura do ar horária de Santa Maria-RS, para cada mês.


```r
boxplot(tair ~ month(date),
  data = filter(sulbr_dh, site == "A803")
)
```

<img src="images/unnamed-chunk-41-1.png" width="672" />


Funções matemáticas podem ser visualizadas com a função `curve()`.


```r
# Curvas
curve(x ^ 3 - 5 * x, from = -4, to = 4)
```

<img src="images/unnamed-chunk-42-1.png" width="672" />

```r
# plot de uma função criada
fun_curvilinea <- function(xvar) {
  1 / (1 + exp(-xvar + 10))
}
curve(fun_curvilinea(x), from = 0, to = 20)
# Add a line:
curve(1 - fun_curvilinea(x), add = TRUE, col = "red")
```

<img src="images/unnamed-chunk-42-2.png" width="672" />

Para mostrar como fazer um gráfico do tipo imagem, vamos criar uma matriz com temperatura média mensal horária em que as linhas são os meses e as colunas as horas.


```r
  tar_mes_hora <- sulbr_dh %>%
    group_by(mes = month(date), hora = hour(date)) %>%
    summarise(tmed = mean(tair, na.rm = TRUE)) %>%
    ungroup() %>%
    pivot_wider(names_from = "hora",
                values_from = "tmed")
  #View(tar_mes_hora)
  tar_mat <- as.matrix(tar_mes_hora[, -1])
  dim(tar_mat)
#> [1] 12 24
```



```r
x <- 1:nrow(tar_mat) 
y <- 1:ncol(tar_mat) - 1
image(
  x, # eixo x
  y, # eixo y
  z = tar_mat, # matriz de dados
  col = topo.colors(n = 32), # paleta de cores
  axes = FALSE,
  xlab = "mês",
  ylab = "hora"
)

# intervalo de variação
int_var <- range(tar_mat)
limites <- c(trunc(int_var[1]), ceiling(int_var[2]))

contour(
  x,
  y,
  tar_mat,
  levels = seq(limites[1], limites[2], by = 3),
  add = TRUE,
  col = "peru"
)
axis(1, at = x)
axis(2, at = y[c(TRUE, FALSE)])
box()
title(
  main = "Variação sazonal horária da Tar \n no Sul do Brasil",
  cex.main = 0.9
)
```

<img src="images/unnamed-chunk-44-1.png" width="672" />



#### Telas gráficas 

A executar a função `plot()` o RStudio automaticamente abre uma tela gráfica e plota o gráfico. Para remover o gráfico gerado é executar `dev.off()`. 


```r
plot(y1)
# fechar a tela gráfica
dev.off()
```

Eventualmente você pode exibir um gráfico fora do painel de gráficos do RStudio. Para isso antes de gerar o gráfico, rode a função `x11()` ou `dev.new()`.


```r
x11()
```


```r
plot(y1)
```

<img src="images/unnamed-chunk-47-1.png" width="672" style="display: block; margin: auto;" />

Seu gráfico aparecerá em uma janela gráfica fora do ambiente do RStudio. Você abrir mais janelas gráficas repetindo a expressão `x11()` (`dev.new()`). Abaixo nós abriremos uma janela para fazer outro plot.


```r
x11()
```


```r
plot(y1^2)
```

Você poderia fechar um gráfico de cada vez digitando `dev.off()`, mas se houver muitos gráficos você tem a opção de usar a função `graphics.off()`. Ela fechará todas as telas gráficas abertas, inclusive as qu estiverem no painel de gráficos do RStudio. 


```r
graphics.off()
```

O Rstudio permite que você visualize um gráfico com mais detalhe e ajustando a janela de acordo com sua preferência através do botão zoom no painel de gráficos.

#### Salvando gráficos

O <img src="images/logo_r.png" width="20"> pode exportar um gráfico para diferentes saídas gráficas (*png, pdf, ps, jpeg* e etc). Uma lista completa das opções disponíveis está disponível em `?device`.


```r
plot(y1)
```

<img src="images/unnamed-chunk-51-1.png" width="672" style="display: block; margin: auto;" />

Vamos usar o exemplo do gráfico com diferentes paleta de cores para demonstrar  como salvar vários gráficos em um único arquivo **pdf**.


```r
## fechando qualquer tela gráfica aberta
graphics.off()
## abrindo saída gráfica
arquivo <- file.path(tempdir(), "5plots-1arquivo.pdf")
pdf(
  file = arquivo,
  onefile = TRUE,
  width = 7, 
  height = 4
)

for (ipal in seq_along(paletas)) {
  plot(
    x = onda$x1[1:n],
    y = onda$y1[1:n],
    type = "p",
    xlab = "x",
    ylab = "y",
    main = "Várias cores",
    sub = "Onda colorida",
    col = paletas[[ipal]], # função para paleta arco-íris
    pch = 20,
    cex = (1:n) / 60 * 4
  )
}
dev.off()
```

Você pode abrir o arquivo salvo digitando `file.show(arquivo)`.


Para salvar cada gráfico em um arquivo separado a chamada da função `pdf()` precisa ser feita antes de cada gráfico e dentro do laço do `for()`.


```r
## fechando qualquer tela gráfica aberta
graphics.off()
## looping em cada coluna da matriz mat
for (ipal in seq_along(paletas)) {
  ## mostra tela o índice do looping em execução
  cat(ipal, "\n")
  ## criando nome do arquivo
  arquivo <- file.path(
    tempdir(),
    paste0("plot", ipal, "_arquivo", ipal, ".pdf")
  )
  ## abrindo saída gráfica
  pdf(file = arquivo, width = 7, height = 4)
  # plot da variável de cada coluna da matriz
  plot(
    x = onda$x1[1:n],
    y = onda$y1[1:n],
    type = "p",
    xlab = "x",
    ylab = "y",
    main = "Várias cores",
    sub = "Onda colorida",
    col = paletas[[ipal]], # função para paleta arco-íris
    pch = 20,
    cex = (1:n) / 60 * 4
  )
  ## fechando pdf
  dev.off()
}
#file.show(arquivo)
```



### Plotando vários gráficos em uma mesma página



```r
par(mfrow = c(2, 3), las =1, cex.lab = 1.2, cex.axis = 1.2)

with(sulbr_md, {
plot(x = seq_along(site), 
     y = period,
     type = "o",
     xlab = "#site",
     ylab = "Período (anos)"
     ) # linha e ponto conectados

plot(x = seq_along(site), 
     y = missing, 
     type = "h",
     xlab = "#site",
     ylab = "Dados faltantes (%)"
     ) # linha

plot(x = period, 
     y = long_gap/24,
     log = "y",
     type = "p",
     pch = 9,
     ylab = "Log. Tamanho da falha (dias)",
     xlab = "Período de dados") # linha e ponto desconectados
plot(x = sdate, 
     y = dtr_med, 
     col = recode(state, RS = "green", SC = "blue", PR = "red"),
     cex = 1.2,
     pch = recode(state, RS = 20, SC = 6, PR = 3),
     xlab = "#site"
     )
hist(max_tair, 
     xlab = "Tmax absoluta (°C)",
     border = "black",
     col = "salmon",
     ylab = "Frequência"
     ) # linha e ponto
box()
plot(1:10, 
     1:10, 
     type = "n", 
     frame = F, 
     axes = F, 
     xlab = "", 
     ylab = "")
text(5, 5, "5 gráficos \n em uma \n página", cex = 3)
})
```

<img src="images/Chunk1011-1.png" width="1440" style="display: block; margin: auto;" />

```r


#par()
```

### Gráfico com 2 eixos


```r
plot(
  x = aq$date,
  y = aq$Ozone,
  type = "l",
  lwd = 2,
  ylab = "",
  xlab = "Data"
)
par(new = T)
plot(
  x = aq$date,
  y = aq$Temp,
  type = "l",
  col = 2,
  lwd = 2,
  axes = FALSE,
  ylab = "",
  xlab = ""
)
# eixo secundário
axis(
  side = 4,
  col = 2,
  col.axis = 2
)
# anotação das variáveis
mtext(
  text = "Ozônio",
  line = -2,
  adj = 0.2
)
mtext(
  text = "Temperatura",
  col = 2,
  line = -1,
  adj = 0.2
)
```

<img src="images/unnamed-chunk-54-1.png" width="672" style="display: block; margin: auto;" />



### Adicionando legenda


```r
plot(
  rain$Tokyo,
  type = "l",
  col = "red",
  ylim = c(0, 300),
  main = "Chuva mensal em grandes cidades",
  xlab = "Mês do ano",
  ylab = "Chuva (mm)",
  lwd = 2
)
lines(
  rain$NewYork,
  type = "l",
  col = "blue",
  lwd = 2
)
lines(
  rain$London,
  type = "l",
  col = "green",
  lwd = 2
)
lines(
  rain$Berlin,
  type = "l",
  col = "orange",
  lwd = 2
)
## legenda
legend(
  "topright",
  legend = c("Tokyo", "NewYork", "London", "Berlin"),
  col = c("red", "blue", "green", "orange"),
  lty = 1,
  lwd = 2,
  bty = "n"
)
```

<img src="images/unnamed-chunk-55-1.png" width="672" style="display: block; margin: auto;" />


<!-- ```{r} -->
<!-- knitr::knit_exit() -->
<!-- ``` -->


## ggplot2

<!-- 
https://bookdown.org/aschmi11/RESMHandbook/data-visualization-with-ggplot.html 
-->

O ggplot2 é uma implementação para o <img src="images/logo_r.png" width="20"> da **G**ramática de **G**ráficos [@Wilkinson2005] (GG). A GG estabelece princípios fundamentais para a construção de gráficos. Um gráfico consiste no mapeamento dos dados a partir de atributos estéticos (posição, cor, forma, tamanho) de objetos geométricos (pontos, linhas, barras, caixas). Os principais aspectos de um gráfico são os dados, o sistema de coordenadas, os rótulos e as anotações, os quais podem ser combinados em camadas para elaboração do gráfico. Esse é a ideia central do **`{ggplot2}`**.

A documentação do ggplot2 está disponível [aqui](https://ggplot2.tidyverse.org/reference/index.html).

Para conhecer mais extensões do **`{ggplot2}`** consulte a galeria https://exts.ggplot2.tidyverse.org/gallery/.

<!--
 https://exts.ggplot2.tidyverse.org/ 
 
https://www.curso-r.com/material/ggplot/ 

http://r-statistics.co/ggplot2-Tutorial-With-R.html

http://blog.revolutionanalytics.com/2015/01/a-beautiful-story-about-nyc-weather.html

https://rc2e.com/graphics

# gráfico clássico 
https://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=00014g

https://weatherspark.com/y/30268/Average-Weather-in-S%C3%A3o-Paulo-Brazil-Year-Round

https://weatherspark.com/compare/y/147567~144671/Comparison-of-the-Average-Weather-at-Salgado-Filho-International-Airport-and-Brisbane
-->

### Exemplo de aplicação



### Dados


Como exemplo de aplicação usaremos os dados históricos do INMET da estação meteorológica convencional (EMC) de Santa Maria-RS. Os dados utilizados podem ser acessados carregando o pacote **`{ADARdata}`**.


```r
#devtools::install_github("lhmet/ADARdata")
library(ADARdata)
```
O pacote disponibiliza os seguinte conjunto de dados formado por 3 quadro de dados que serão usados a seguir:

- `clima_sm` contém estatísticas e as observações históricas de temperatura do ar (`tar`) e precipitação diária (`prec`) para cada dia do ano em Santa Maria-RS

- `tempo_sm` contém os dados meteorológicos do último ano

- `recordes_atual_sm` contém os recordes de temperatura e precipitação do último ano

Você pode obter mais informações sobre cada  um dos quadro de dados consultado o *help*.


```r
?dados_sm
```

Para construção do gráfico precisaremos das posições dos dia 15 e do último dia de cada mês. Esta informação será útil para especificar onde colocar os nomes dos meses no eixo x. Por isso vamos criar abaixo um `tibble` com o dia do ano correspondente aquelas datas.


```r
ultimo_ano <- unique(year(tempo_sm$date))
datas_atual <- seq(
  from = as.Date(paste0(ultimo_ano, '-01-01')), 
  to = as.Date(paste0(ultimo_ano, '-12-31')), 
  by = "day"
)

library(scales)

# dda do meio do mês
meio_mes <- yday(datas_atual)[day(datas_atual) == 15]

# dda do final do mês
fim_mes <- tibble(datas_atual, 
       mes = month(datas_atual), 
       day = day(datas_atual),
       yday = yday(datas_atual)) %>%
  group_by(mes) %>%
  summarise(ult_dia = yday[which.max(day)], .groups = "drop") %>%
  pull(ult_dia)

# junção em tibble
marcas_x <- tibble(
  metade = meio_mes,
  final = fim_mes,
  labels = c(
    "Janeiro", "Fevereiro", "Março", "Abril",
    "Maio", "Junho", "Julho", "Agosto", "Setembro",
    "Outubro", "Novembro", "Dezembro"
  )
)
marcas_x
#> # A tibble: 12 x 3
#>    metade final labels   
#>     <dbl> <dbl> <chr>    
#>  1     15    31 Janeiro  
#>  2     46    60 Fevereiro
#>  3     75    91 Março    
#>  4    106   121 Abril    
#>  5    136   152 Maio     
#>  6    167   182 Junho    
#>  7    197   213 Julho    
#>  8    228   244 Agosto   
#>  9    259   274 Setembro 
#> 10    289   305 Outubro  
#> 11    320   335 Novembro 
#> 12    350   366 Dezembro
```
> PAREI AQUI

### Gráfico do tempo de Santa Maria-RS em 2020

Para ilustrar a abordagem de construção de gráficos por camadas do **`{ggplot2}`** vamos visualizar a variação temperatura diária do ar para o ano corrente e compará-la com a climatologia e estatísticas baseadas em 58 anos de dados. Nós vamos explorar diferentes geometrias (linhas, pontos, intervalos)


Nós criamos um gráfico a partir da função `ggplot()`, especificando os dados de entrada.


```r
ggplot(data = clima_sm)
```

<img src="images/unnamed-chunk-59-1.png" width="960" />

O resultado é um painel em branco. A construção de um gráfico com o **`{ggplot2}`** envolve a especificação de atributos estéticos (eixos x e y), adição de elementos geométricos aos nossos dados, operações estatísticas, escalas, coordenadas e várias utras componentes. 

Podemos adicionar geometrias usando o operador `+`, conforme mostrado abaixo. Para criar o gráfico da temperatura do ar (`tar`) de Santa Maria-RS, precisamos mapear as variáveis de interesse dos dados de entrada para o eixo y e x. 

O mapeamento das variáveis nos eixos é feito pela função `aes()` (de *aesthetics*, estética em inglês). Ela indica a relação entre os dados, a variável que será representada no eixo x, a que será representada no eixo y, a cor, o tamanho dos componentes geométricos etc. 



Os aspectos que podem ou devem ser mapeados dependem do tipo de gráfico que você está construindo.

Nossa 1ª camada de geometria será uma linha vertical que se estende dos valores mínimo até o máximo absoluto de `tar` (variáveis `tar_min` e `tar_max`) registrado no dia do ano (`dda`). 

O `dda` é especificado no eixo x. Para inserir uma linha vertical a `geom_linerange()` requer os argumentos `x`, `ymin` e `ymax`.



```r
ggplot(data = clima_sm) +
  geom_linerange(
    mapping = aes(x = dda, ymin = tar_min, ymax = tar_max),
    color = "wheat2"
   # alpha = .1
  ) 
```

<img src="images/unnamed-chunk-60-1.png" width="960" />

Além de identificar as variáveis de cada eixo nós adicionamos o argumento `color` para distinguir os intervalos variação entre os máximos e mínimos absolutos registrados.

Uma versatilidade do **`{ggplot2}`** é de podermos armazenar os gráficos em objetos. Então o gráfico básico acima pode ser armazenado numa váriavel. A estrutura do gráfico é uma lista com todas componentes necessárias para construção do gráfico.



```r
graf_base <- 
  ggplot( data = clima_sm) +
  #geom_point(size = 0.01, colour = "green") +
  geom_linerange(
    mapping = aes(x = dda, ymin = tar_min, ymax = tar_max),
    color = "wheat2"
   # alpha = .1
  ) +
   theme_void()

#glimpse(graf_base, max.level = 1)
graf_base
```

<img src="images/unnamed-chunk-61-1.png" width="960" />

```r

 # ggplot( data = clima_sm) +
 #  #geom_point(size = 0.01, colour = "green") +
 #  geom_linerange(
 #    mapping = aes(x = dda, ymin = tar_min, ymax = tar_max),
 #    color = "wheat2"
 #   # alpha = .1
 #  ) +
 #   #theme_void()
 #   theme(#plot.background = element_blank(),
 #          panel.grid.minor.x = element_blank(),
 #          panel.grid.major.y = element_blank(),
 #          panel.border = element_blank(),
 #          panel.background = element_blank(),
 #          axis.ticks = element_blank(),
 #          #axis.text = element_blank(),  
 #          axis.title = element_blank()
 #  )
```

Na sequência vamos adicionar uma segunda camada com os dados que representam o intervalo de confiança de 95% da temperatura média diária para o período de 1952-2019.


```r
ggp_sm <- graf_base + 
geom_linerange(
    mapping = aes(x = dda, ymin = tar_med_min, ymax = tar_med_max),
    color = "wheat4"
  )
ggp_sm
```

<img src="images/unnamed-chunk-62-1.png" width="960" />

Agora vamos incorporar ao gráfico os dados de temperatura do ano atual e uma linha vertical (`geom_vline`) na borda esquerda do eixo y.


```r
ggp_sm <- ggp_sm +
  geom_line(
    data = tempo_sm,
    mapping = aes(x = dda, y = tar),
    # size = 1
  ) +
  geom_vline(
    xintercept = 0,
    color = "wheat4",
    linetype = 1,
    size = 1
  )
ggp_sm
```

<img src="images/unnamed-chunk-63-1.png" width="960" />

Agora vamos ajustar a escala do eixo y ao intervalo de variação da dos extremos e definir 8 marcas para os labels.



```r
int_var <- range(c(clima_sm$tar_max, clima_sm$tar_min))
int_var <- c(floor(int_var[1]), ceiling(int_var[2]))
int_var
#> [1]  3 35
ggp_sm <- ggp_sm +
  scale_y_continuous(
    limits = int_var,
    breaks = scales::pretty_breaks(n = 8),
    labels = scales::label_number(suffix = " °C", accuracy = 5)
  ) + 
  scale_x_continuous(expand = c(0, 0), 
                     breaks = marcas_x$metade, 
                     labels = marcas_x$labels,
                     )
ggp_sm
```

<img src="images/unnamed-chunk-64-1.png" width="960" />

Podemos adicionar linhas de grade horizontais e verticais como referência. As linhas verticais serão adicionadas no último dia de cada mês. As horizontais serão espaçadas de 5°C.



```r
ggp_sm <- ggp_sm + 
  geom_hline(
    yintercept = seq(int_var[1], int_var[2], by = 5), 
    color = "white", 
    linetype = 1
    ) + 
  geom_vline(
    xintercept = marcas_x$final, 
    color = "wheat4", 
    linetype = 3,
    size = 0.5
    ) 
ggp_sm
```

<img src="images/unnamed-chunk-65-1.png" width="960" />

Neste ponto, vamos identificar os dias que em 2020 ultrapassaram os recordes históricos de temperatura. 


```r
ggp_sm <- ggp_sm + 
   geom_point(
     data = filter(recordes_atual_sm, record_min == "S"),
     aes(x = dda, y = tar), color = "blue3") + 
   geom_point(
     data = filter(recordes_atual_sm, record_max == "S"),
     aes(x = dda, y = tar), color = "firebrick3")
ggp_sm
```

<img src="images/unnamed-chunk-66-1.png" width="960" />

Com todos dados plotados agora podemos incrementá-lo com texto apropriado. Primeiramente vamos adicionar um título e subtítulo.


```r
ggp_sm <- ggp_sm +
  ggtitle("Tempo em Santa Maria, 2020") +
  theme(
    plot.title = element_text(
      face = "bold",
      hjust = .012,
      vjust = .8,
      colour = "#3C3C3C",
      size = 20
    )
  ) +
  annotate("text",
    x = 138,
    y = 36,
    label = "Temperatura",
    size = 4,
    fontface = "bold"
  ) 
ggp_sm
#> Warning: Removed 1 rows containing missing values (geom_text).
```

<img src="images/unnamed-chunk-67-1.png" width="960" />

Nós podemos adicionar um parágrafo abaixo do subtítulo para dar uma pequena explanação dobre os dados. O texto será separado em 4 anotações.



```r
texto <- "Os dados representam as médias diárias de temperatura. Os dados iniciam efetivamente em 1951. Dados para 2020 são disponíveis somente até Julho. A Temperatura média anual até este mês foi de 22°C, caracterizando 2020 como o 8° ano mais quente."

ggp_sm <- ggp_sm +
  annotate("text",
    x = 120,
    y = 32.5,
    label = str_wrap(texto, width = 70),
    size = 3,
    colour = "gray30",
    hjust = 0
  )
ggp_sm
#> Warning: Removed 1 rows containing missing values (geom_text).
```

<img src="images/unnamed-chunk-68-1.png" width="960" />

Anotações que explicam os pontos representando os dias nos quais ocorreram recordes de temperatura máxima e mínima.


```r
x_rec_tmin <- filter(recordes_atual_sm, record_min == "S") %>% 
  pull(dda)
y_rec_tmin <- filter(recordes_atual_sm, record_min == "S") %>% 
  pull(tar_min)

x_rec_tmax <- filter(recordes_atual_sm, record_max == "S") %>% 
  pull(dda) %>% 
  nth(3)
y_rec_tmax <- filter(recordes_atual_sm, record_max == "S") %>% 
  pull(tar_max) %>%
  nth(3)


ggp_sm <- ggp_sm +
  annotate("segment",
           x = x_rec_tmin - 2, xend = x_rec_tmin - 12,
           y = y_rec_tmin - 1, yend = y_rec_tmin - 3,
           color = "blue3"
           ) + 
  annotate("text", 
           x = x_rec_tmin - 12, 
           y = y_rec_tmin - 3 -0.5, 
           label = "Recorde de Tmin",
           size=2.9, 
           colour="blue3"
           ) +
    annotate("segment",
           x = x_rec_tmax + 2, xend = x_rec_tmax + 12,
           y = y_rec_tmax + 1, yend = y_rec_tmax + 2,
           color = "firebrick3"
           ) + 
  annotate("text", 
           x = x_rec_tmax + 13, 
           y = y_rec_tmax + 3, 
           label = "Recordes de Tmax",
           size = 2.9, 
           colour="firebrick3"
           )
ggp_sm
#> Warning: Removed 1 rows containing missing values (geom_text).
```

<img src="images/unnamed-chunk-69-1.png" width="960" />


```r
leg_dados <- data.frame(x = seq(53, 61), y = rnorm(9, mean = 12, 1))

ggp_sm +
  # limites extremos
  annotate("segment",
    x = marcas_x$final[2],
    xend = marcas_x$final[2],
    y = 9,
    yend = 15,
    colour = "wheat2",
    size = 3
  ) +
  # intervalo intermediário
  annotate("segment",
    x = marcas_x$final[2],
    xend = marcas_x$final[2],
    y = 10.5,
    yend = 13.5,
    colour = "wheat4",
    size = 3
  ) +
  geom_line(data = leg_dados, aes(x = x, y = y)) +
  # labels intermediários
  annotate("text",
    x = 36,
    y = 12,
    label = "TEMPERATURA 2020",
    size = 2,
    colour = "gray30"
  ) +
  annotate("text",
    x = 84,
    y = 12,
    label = "INTERVALO NORMAL",
    size = 2,
    colour = "gray30"
  ) +
  # labels extremos
  annotate("text",
    x = 70,
    y = 15,
    label = "MÁXIMO",
    size = 2,
    colour = "gray30"
  ) +
  annotate("text",
    x = 70,
    y = 9.5,
    label = "MÌNIMO",
    size = 2,
    colour = "gray30"
  ) +
  # segmentos do intervalo normal
  annotate("segment", 
           x = 63, 
           xend = 65, 
           y = 10.5,
           yend = 10.5,
           colour = "wheat4", 
           size=.5
           ) +
  annotate("segment", 
           x = 63, 
           xend = 65, 
           y = 13.5,
           yend = 13.5,
           colour = "wheat4", 
           size=.5
           ) +
  annotate("segment", 
           x = 65, 
           xend = 65, 
           y = 10.5,
           yend = 13.5,
           colour = "wheat4", 
           size=.5
           )
#> Warning: Removed 1 rows containing missing values (geom_text).
```

<img src="images/unnamed-chunk-70-1.png" width="960" />


### Histograma e colunas



### Imagem 2D


### Facetas


<!-- 
earthdatascience.org/courses/earth-analytics/lidar-raster-data-r/ggmap-basemap/ 
-->


