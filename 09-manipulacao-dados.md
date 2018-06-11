# (PART) Ferramentas modernas do R {-}


# Processamento de dados {#data-wrangle}



Neste capítulo veremos:

- um *data frame* aperfeiçoado, denominado *tibble*

- como arrumar seus dados em uma estrutura conveniente para a análise e visualização de dados

- como reestruturar os dados de uma forma versátil e fácil de entender

- como manipular os dados com uma ferramenta intuitiva e padronizada

Existem diversas ferramentas da base do <img src="images/logo_r.png" width="20"> para a execução dessas operações. Entretanto, elas são um pouco confusas, não seguem uma codificação consistente e não possuem uma capacidade de fluirem juntas no processamento de dados. 

Muitas coisas no R que foram desenvolvidas e eram úteis há 20 anos, podem não ser a melhor forma de abordar um problema hoje. Mudanças nos códigos da base do R é uma tarefa complicado devido a cadeia de dependências do código fonte e dos pacotes de contribuidores. Então, grande parte das inovações estão ocorrendo na forma de pacotes.

Suprindo a necessidade de uma abordagem efetiva e integrada para ciência de dados (Figura \@ref(fig:tidy-workflow)) um conjunto de pacotes foram desenvolvidos e denominado [*tidyverse*](https://www.tidyverse.org/).



<div class="figure">
<img src="images/workflowtidy.png" alt="Modelo de ferramentas empregadas em ciência de dados. Adaptado de @Wickham2017." width="100%" />
<p class="caption">(\#fig:tidy-workflow)Modelo de ferramentas empregadas em ciência de dados. Adaptado de @Wickham2017.</p>
</div>

O termo *tidyverse* pode ser traduzido como 'universo arrumado' e consiste em um pacote do R que agrupa pacotes (Figura \@ref(fig:tidy-workflow)) que compartilham uma filosofia comun de *design*, gramática [@Wickham-dplyr] e estrutura de dados [@Wickham2014]. Consequentemente, o *tidyverse* tem sido amplamente utilizado pela comunidade de usuários e desenvolvedores do R. Além de uma abordagem mais coesa e consistente de realizar as tarefas de processamento de dados, os códigos são mais eficientes (que a base do R), legíveis e a sintaxe mais fácil de lembrar.

<div class="figure">
<img src="images/tidyverse_components.png" alt="Coleção de pacotes do *tidyverse*." width="80%" />
<p class="caption">(\#fig:tidyverse-components)Coleção de pacotes do *tidyverse*.</p>
</div>
  

## Pré-requisitos

O pacote tidyverse torna fácil de instalar e carregar os pacotes do *tidyverse* em apenas um comando.


```r
install.packages("tidyverse")
```

Agora você pode carregar os pacotes.


```r
library(tidyverse)
#> ── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──
#> ✔ ggplot2 2.2.1     ✔ purrr   0.2.5
#> ✔ tibble  1.4.2     ✔ dplyr   0.7.5
#> ✔ tidyr   0.8.1     ✔ stringr 1.3.1
#> ✔ readr   1.1.1     ✔ forcats 0.3.0
#> ── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
```

Outros pacotes:


```r
pacotes <- c("openair", "lubridate", "scales")
easypackages::libraries(pacotes)
```


Dados climatológicos:


```r
library(rio)
#> 
#> Attaching package: 'rio'
#> The following object is masked from 'package:openair':
#> 
#>     import
clima_file_url <- "https://github.com/lhmet/adar-ufsm/blob/master/data/clima-rs.RDS?raw=true"
# dados de exemplo
clima_rs <- rio:::import(clima_file_url, format = "RDS")
clima_rs
#>    codigo                 estacao uf   prec tmax
#> 1   83931                Alegrete RS 1492.2 25.4
#> 2   83980                    Bagé RS 1299.9 24.1
#> 3   83941         Bento Gonçalves RS 1683.7 23.0
#> 4   83919               Bom Jesus RS 1807.3 20.3
#> 5   83963        Cachoeira do Sul RS 1477.1 25.1
#> 6   83942           Caxias do Sul RS 1823.0 21.8
#> 7   83912               Cruz Alta RS 1630.7 24.5
#> 8   83964     Encruzilhada do Sul RS 1510.8 22.5
#> 9   83915                 Guaporé RS 1758.7 24.7
#> 10  83881                    Iraí RS 1806.7 27.1
#> 11  83929                  Itaqui RS 1369.4 26.2
#> 12  83916          Lagoa Vermelha RS 1691.1 23.0
#> 13  83880    Palmeira das Missões RS 1747.8 24.0
#> 14  83914             Passo Fundo RS 1803.1 23.6
#> 15  83967            Porto Alegre RS 1320.2 24.8
#> 16  83995              Rio Grande RS 1233.6 21.7
#> 17  83936             Santa Maria RS 1616.8 24.9
#> 18  83997 Santa Vitória do Palmar RS 1228.9 21.8
#> 19  83957             São Gabriel RS 1313.9 25.0
#> 20  83907        São Luiz Gonzaga RS 1770.9 26.1
#> 21  83966                   Tapes RS 1349.8 23.8
#> 22  83948                  Torres RS 1363.2 22.3
#> 23  83927              Uruguaiana RS 1647.4 25.8
```

Dados de estação meteorológicas:


```r
meteo_df <- data.frame(site = c(
  "A001", "A001", "A002", "A002", "A002", "A003", "A803", "A803"
  ),
  ano  = c(2000:2001, 2000:2002, 2004, 2005, 2006),
  prec = c(1800, 1400, 1750, 1470, 1630, 1300, 1950, 1100)
  )
meteo_df
#>   site  ano prec
#> 1 A001 2000 1800
#> 2 A001 2001 1400
#> 3 A002 2000 1750
#> 4 A002 2001 1470
#> 5 A002 2002 1630
#> 6 A003 2004 1300
#> 7 A803 2005 1950
#> 8 A803 2006 1100
```



## *tibbles*: *data frames* aperfeiçoado

*Data frames* são unidade fundamental de armazenamento de dados retangulares no R. O pacote **tibble** define uma nova classe de data frame para o R, o *tbl_df* ('*tibble diffs*'). Uma *tibble* é uma extensão da classe de dados *data.frame* da base do R, que inclui aperfeiçoamentos relacionados a impressão de dados (mais amigável e versátil), a seleção de dados e a manipulação de dados do tipo *factor*.

Para criar um *tibble* nós usamos a função *tibble()*. Para ilustrar algumas vantagens do *tibble* vamos recriar o *data frame* `meteo_df` incluindo uma nova variável `int prec`(intensidade da precipitação):


```r
meteo_tbl <- tibble(site = c(
  "A001", "A001", "A002", "A002", "A002", "A003", "A803", "A803"
  ),
  ano  = c(2000:2001, 2000:2002, 2004, 2005, 2006),
  prec = c(1800, 1400, 1750, 1470, 1630, 1300, 1950, 1100),
  `int prec` = prec/365
  )
meteo_tbl
#> # A tibble: 8 x 4
#>   site    ano  prec `int prec`
#>   <chr> <dbl> <dbl>      <dbl>
#> 1 A001  2000. 1800.       4.93
#> 2 A001  2001. 1400.       3.84
#> 3 A002  2000. 1750.       4.79
#> 4 A002  2001. 1470.       4.03
#> 5 A002  2002. 1630.       4.47
#> 6 A003  2004. 1300.       3.56
#> 7 A803  2005. 1950.       5.34
#> 8 A803  2006. 1100.       3.01
```

No exemplo acima, as principais diferenças entre o tibble e o data frame ficam evidentes:

- quando impresso no console do R, o *tibble* mostra a classe de cada variável, enquanto objetos *data.frame* não.

- vetores caracteres não são interpretados como *factors* quando incorparados em um *tibble*, em contraste, `data.frame()` faz a coerção de caracteres para *factors*, o que pode causar problemas nas etapas de processamento futuras.

- o nome das variáveis nunca são modificados

```r
data.frame("nome esquisito" = 1)
#>   nome.esquisito
#> 1              1
```

- permite usar seus próprios argumentos prévios para definir variáveis durante a criação do *tibble*. 

- nunca adiciona nome às linhas (`row.names`)

Quando um *tibble* é impresso na tela, somente as dez primeiras linhas são mostradas. O número de colunas mostradas depende do tamanho da janela.

Outras diferenças do tibble podem ser consultada no página de ajuda da função `tibble()` (`?tibble`) e na vinheta do referido pacote (`vignette("tibble")`).

A conversão de um `data.frame` para tibble pode ser feita simplesmente com a função `as_tibble()`:

```r
meteo_tbl_conv <- as_tibble(meteo_df)
meteo_tbl_conv
#> # A tibble: 8 x 3
#>   site    ano  prec
#>   <fct> <dbl> <dbl>
#> 1 A001  2000. 1800.
#> 2 A001  2001. 1400.
#> 3 A002  2000. 1750.
#> 4 A002  2001. 1470.
#> 5 A002  2002. 1630.
#> 6 A003  2004. 1300.
#> 7 A803  2005. 1950.
#> 8 A803  2006. 1100.
```

As opções de controle *default* da impressão de *tibbles* na tela são controladas através da função de opções de configuração:


```r
options(
  tibble.print_max = n, 
  tibble.print_min = m)
```

Onde se o número de linhas do *tibble* for maior que `m` linhas, a impressão será somente até `n` linhas. 

Você pode usar `options(dplyr.print_min = Inf)` se deseja que sempre sejam mostradas todas linhas de seus dados.

Finalmente é bom lembrar da opção de visualização completa dos dados do RStudio através da função `View()`.


## Restruturação de dados

> Até 80% do tempo da análise dados é dedicada ao processo de limpeza e preparação dos dados [(Dasu e Johnson 2003)](http://onlinelibrary.wiley.com/doi/10.1002/0471448354.ch4/summary).


### Dados arrumados

O conceito 'dados arrumados' foi estabelecido por @Wickham2014 e representauma forma padronizada de conectar a estrutura de um conjunto de dados com (formato) com a sua semântica (significado). 

Dados bem estruturados servem para:
- fornecer dados propícios para o processamento e análise de dados por softwares;
- revelar informações e facilitar a percepção de padrões

Para rearranjar um conjunto de dados no formato arrumado vocẽ deve seguir os seguintes critérios:

1. colocar seus dados em formato retangular

2. cada variável corresponde a uma coluna 

3. cada observação corresponde a uma linha

4. cada valor corresponde a uma célula

5. cada tipo de unidade observacional deve formar uma tabela

![Estrura de dados padronizados](http://garrettgman.github.io/images/tidy-1.png)

Um exemplo de unidade observacional refere-se a tabela de dados meteorológicos de um conjunto de estações de superfície com medidas das variáveis meteorológicas ao longo do tempo. Outro tipo de unidade observacional refere-se aos metadados das estações de superfície que são armazenados em uma tabela separada contendo atributos que caracterizam o local de medida (localização, altitude, nome, município e etc.). Por isso essas tabelas são geralmente distribuídas separadamente.




A estrutura de dados arrumados parece óbvia, mas nas ciências ambientais dados neste formatos são raros de serem encontrados. As razões para isso incluem:

- as pessoas que projetam a coleta e o registro de dados nem sempre são aquelas que gastam tempo trabalhando sobre os dados.

- a organização dos dados buscar tornar o registro de dados o mais fácil possível

Então dados reais sempre precisarão ser arrumados. O primeiro passo é identifica as variáveis e as observações. O passo seguinte é resolver os seguintes problemas comuns (@Wickham2017):

- uma variável deve ser distribuída ao longo das colunas

- uma observação deve ser distribuída ao longo das linhas

Conjuntos de dados meteorológicos brasileiros tipicamente sofrem de ambos problemas. Felizmente você agora saberá como resolver isso com as principais funções do pacote **tidyr**: `gather()` e `spread()`.

O formato de dados arrumado pode ser ideal para muitas operações no R que envolvem *data frames* (aggregation, plotting, fitting statistical models), it is not the optimal structure for every case. As an example, community ecology analyses often start from a matrix of counts where rows and columns correspond to species and sites.

### tidyr

O pacote **tidyr** é a extensão do R que fornece um conjunto de funções designadas para reestruturar seus dados entre diferentes formatos. Os principais formatos são o de tabelas longas (na sentidoo vertical ou das linhas) e largas (no sentido horizontal ou das colunas).

#### Formato de dados longo

Para exemplificar o formato longo vamos o converter os dados `meteo_tbl`, que já estão na estrutura de dados arrumados, para o formato longo. 


```r
dim(meteo_tbl)
#> [1] 8 4
meteo_long <- gather(
  data = meteo_tbl,
  key = "variavel",
  value = "valor",
  -(site:ano)
)
dim(meteo_long)
#> [1] 16  4
kable(meteo_long)
```



site     ano  variavel          valor
-----  -----  ---------  ------------
A001    2000  prec        1800.000000
A001    2001  prec        1400.000000
A002    2000  prec        1750.000000
A002    2001  prec        1470.000000
A002    2002  prec        1630.000000
A003    2004  prec        1300.000000
A803    2005  prec        1950.000000
A803    2006  prec        1100.000000
A001    2000  int prec       4.931507
A001    2001  int prec       3.835616
A002    2000  int prec       4.794520
A002    2001  int prec       4.027397
A002    2002  int prec       4.465753
A003    2004  int prec       3.561644
A803    2005  int prec       5.342466
A803    2006  int prec       3.013699

O código acima demostra três argumentos requeridos pela função `gather`:

- `data`, um *data frame* no qual os nomes das colunas tornar-se-ão valores nas linhas.
- `key`, nome da variável categórica na qual os nomes das colunas no *data frame* original serão convertidas.

- `value`, o nome da coluna que conterá os valores das células do *data frame* original.

Como em outras funções do *tiverse* note que os argumentos não são especificados como caracteres e como nomes das variáveis. O 2º e 3º argumentos podem ser especificados pelo usuário e não te relação com os dados existentes. O argumento adicional informado através da expressão `-(site:ano)` foi usado para remover as variáveis do processo de coleta das variáveis para distribuição nas linhas. Este procedimento assegura que os valores nestas colunas sejam as primeiras colunas na saída.

Se não fosse usado o argumento `-(site:ano)` todas colunas seriam usadas no argumento `key` e os resultados simplismente conteria todos os pares de  32 pares de coluna/valor resulting dos dados de entrada com 4 colunas por 8 linhas:


```r
meteo_longo <- gather(meteo_tbl)
kable(meteo_longo)
```



key        value            
---------  -----------------
site       A001             
site       A001             
site       A002             
site       A002             
site       A002             
site       A003             
site       A803             
site       A803             
ano        2000             
ano        2001             
ano        2000             
ano        2001             
ano        2002             
ano        2004             
ano        2005             
ano        2006             
prec       1800             
prec       1400             
prec       1750             
prec       1470             
prec       1630             
prec       1300             
prec       1950             
prec       1100             
int prec   4.93150684931507 
int prec   3.83561643835616 
int prec   4.79452054794521 
int prec   4.02739726027397 
int prec   4.46575342465753 
int prec   3.56164383561644 
int prec   5.34246575342466 
int prec   3.01369863013699 


#### Formato de dados largo

Utilizando os dados `meteo_long`, vamos reestruturá-lo no formato largo usando a função `spread()`.


```r
meteo_larg <- spread(
  data = meteo_long,
  key = variavel,
  value = valor
  ) 
meteo_larg
#> # A tibble: 8 x 4
#>   site    ano `int prec`  prec
#>   <chr> <dbl>      <dbl> <dbl>
#> 1 A001  2000.       4.93 1800.
#> 2 A001  2001.       3.84 1400.
#> 3 A002  2000.       4.79 1750.
#> 4 A002  2001.       4.03 1470.
#> 5 A002  2002.       4.47 1630.
#> 6 A003  2004.       3.56 1300.
#> 7 A803  2005.       5.34 1950.
#> 8 A803  2006.       3.01 1100.
```




## Manipulação de dados

Gramática de manipulação de dados implementada no pacote **dplyr**.

* Os 5 verbos básicos são: 

  - `select()`, para selecionar variáveis
  - `filter()`, para filtrar observações
  - `arrange()`, para ordenar variáveis
  - `mutate()`, para transformat variáveis
  - `group_by()` e `summarise()` , para agrupar observações e obter resumos estatísticos

### Operador Pipe `%>%`

Isso leva a uma dificuldade de ler funções aninhadas e um código desordenado.

Embora não requerido os pacotes tidyr e dplyr usam o operador pipe `%>%` que quando combinado com vários funções forma uma cadeia de processamento de dados, ao invés do aninhamento de funções que limita a legibilidade do código. 


```r
# exemplo simples para aplicar uma função 
quadrado <- function(x) x^2
a <- 1:4
quadrado(a)
[1]  1  4  9 16
a %>% quadrado
[1]  1  4  9 16
```

Este operador irá transmitir um valor, ou o resultado de uma expressão, para a próxima função/expressão  chamada. Por exemplo, uma função para filtrar os dados pode ser escrito como:


```r
# exemplo com um dataframe
data(airquality)
filter(airquality, Ozone == 23)
  Ozone Solar.R Wind Temp Month Day
1    23     299  8.6   65     5   7
2    23      13 12.0   67     5  28
3    23     148  8.0   82     6  13
4    23     115  7.4   76     8  18
5    23     220 10.3   78     9   8
6    23      14  9.2   71     9  22
# ou
airquality %>% filter(Ozone == 23)
  Ozone Solar.R Wind Temp Month Day
1    23     299  8.6   65     5   7
2    23      13 12.0   67     5  28
3    23     148  8.0   82     6  13
4    23     115  7.4   76     8  18
5    23     220 10.3   78     9   8
6    23      14  9.2   71     9  22
```

Ambas funções realizam a mesma tarefa e o benefício de usar `%>%' não é evidente. Entretanto, quando desejamos realizar várias funções sua vantagem torna-se evidente. Vamos utilizar o conjunto de dados `airquality` do R, para selecionar algumas variáveis, filtrar algum dados e obter a média da temperatura do ar:


```r
# opção aninhada
res_anin <- summarize(filter(select(airquality, Ozone, Temp), Ozone > 23), tmed = mean(Temp))
res_anin
#>       tmed
#> 1 82.72059
# opção por etapas
etapa1 <- select(airquality, Ozone, Temp)
etapa2 <- filter(etapa1, Ozone > 23)
res_etapas <- summarise(etapa2, tmed = mean(Temp))

# opção usando pipe
res_pipe <- airquality %>%
  select(Ozone, Temp) %>%
  filter(Ozone > 23) %>%
  summarise(tmed = mean(Temp))
res_pipe
#>       tmed
#> 1 82.72059
```

Quando as suas tarefas aumentam o operador pipe `%>%` torna-se mais útil e o seu código fica mais legível.


## Exemplo de manipulação de dados 

Nesta seção vamos fazer um estudo de caso para demostrar diversas funções do tidyverse aplicadas ao conjunto de dados de precipitação horária de Santa Maria-RS.

Objetivos:

- determinar a quantidade de dados de chuva horária faltantes em termos absolutos (número de casos) e relativos (% do total);

- visualizar por meio de um gráfico a variação temporal da chuva horária com a identificação das falhas

- determinar o número de dados faltantes por ano e verifique se o seu resultado confere com aquele da inspeção visual do gráfico;

- determinar o valor da chuva máxima horária e a data de ocorrência do evento;

- determinar a chuva máxima diária e a data de ocorrência do evento;

- fazer o pluviograma mensal climatológico (médias dos totais mensais de precipitação);

- plotar os totais anuais de chuva para cada ano;

- determinar a frequência de ocorrência da chuva para cada ano;

- determinar a intensidade média da chuva (em mm/dia) em Santa Maria;

- determinar a frequência de ocorrência de chuva (ou seja, o número de casos em que choveu) para cada hora do dia (das 0 às 23 h)

- determinar a frequência de ocorrência (%) de precipitação para cada dia da semana;

**Dados**


```r
# definindo os horários como UTC para essa sessão do R
Sys.setenv(TZ = "UTC")

hprec_url <- "https://github.com/lhmet/adar-ufsm/blob/master/data/hprec_sm.RDS?raw=true"
# importa dados, hprec: precipitação horária da EMA de SM
hprec <- rio::import(
  file = hprec_url,
  format = "RDS"
)
str(hprec)
#> 'data.frame':	96428 obs. of  3 variables:
#>  $ site: chr  "A803" "A803" "A803" "A803" ...
#>  $ date: chr  "2004-01-01 00:00:00" "2004-01-01 01:00:00" "2004-01-01 02:00:00" "2004-01-01 03:00:00" ...
#>  $ prec: num  0 0 0 0 0 0 0 0 0 0 ...
summary(hprec)
#>      site               date                prec        
#>  Length:96428       Length:96428       Min.   :-9999.0  
#>  Class :character   Class :character   1st Qu.:    0.0  
#>  Mode  :character   Mode  :character   Median :    0.0  
#>                                        Mean   : -425.8  
#>                                        3rd Qu.:    0.0  
#>                                        Max.   :   48.0
```

Conversão para `tibble` e atribuição de dados faltantes:


```r
hprec <- as_tibble(hprec) %>%
  mutate(prec = ifelse(prec < 0, NA, prec))
hprec
#> # A tibble: 96,428 x 3
#>    site  date                 prec
#>    <chr> <chr>               <dbl>
#>  1 A803  2004-01-01 00:00:00    0.
#>  2 A803  2004-01-01 01:00:00    0.
#>  3 A803  2004-01-01 02:00:00    0.
#>  4 A803  2004-01-01 03:00:00    0.
#>  5 A803  2004-01-01 04:00:00    0.
#>  6 A803  2004-01-01 05:00:00    0.
#>  7 A803  2004-01-01 06:00:00    0.
#>  8 A803  2004-01-01 07:00:00    0.
#>  9 A803  2004-01-01 08:00:00    0.
#> 10 A803  2004-01-01 09:00:00    0.
#> # ... with 96,418 more rows
summary(hprec)
#>      site               date                prec       
#>  Length:96428       Length:96428       Min.   : 0.000  
#>  Class :character   Class :character   1st Qu.: 0.000  
#>  Mode  :character   Mode  :character   Median : 0.000  
#>                                        Mean   : 0.192  
#>                                        3rd Qu.: 0.000  
#>                                        Max.   :48.000  
#>                                        NA's   :4108
```


**1. Disponibilidade de dados.**

  a. Determine a quantidade de dados de chuva horária faltantes em termos absolutos (número de casos) e relativos (% do total).


```r
# converte data e horas para POSIX
hprec <- mutate(hprec, date = as.POSIXct(date))
# número de casos faltantes
sum(is.na(hprec$prec))
#> [1] 4108
# porcentagem de casos faltantes
sum(is.na(hprec$prec)) / nrow(hprec) * 100
#> [1] 4.260173
```

  
  b. Faça um gráfico da chuva horária no tempo que permita identificar os períodos de falhas e que os anos sejam visíveis no eixo x. O gráfico deve ter aspecto similar ao mostrado na Figura abaixo. 
  

```r
# dados para plot; adiciona uma prec modificada, para mostrar dados faltantes
hprec_plot <- mutate(
  hprec
  , faltante = ifelse(is.na(prec), -2, NA)
)
hprec_plot <- as.data.frame(hprec_plot)
# plot da chuva no tempo
# tp <- timePlot(selectByDate(hprec_plot, year = 2014)
tp <- timePlot(
  hprec_plot
  , c("prec", "faltante")
  , group = TRUE
  , plot.type = "h"
  , lty = 1
  , col = c(1, 2)
  , ylab = "Prec (mm/h)"
  , date.format = "%Y\n%b"
)
```

<img src="images/chunck1b-1.png" width="672" />

  c. Baseado na inspeção visual do seu gráfico qual o ano que tem mais falhas? Calcule o número de dados faltantes por ano e verifique se o seu resultado confere com aquele da inspeção visual do gráfico. Apresente esses resultados em uma tabela.


```r
######
# R: por inpeção visual sugere o ano de 2005 devido a sequência de falhas consecutivas
# Por meio do calculo verifica-se que foi 2011, uma falha longa contínua
######
tab_falt <- hprec %>%
  # agrupa os dados por anos
  group_by(year = lubridate::year(date)) %>%
  # resumo estatístico (soma, porcentagem) da prec para cada componente do grupo
  summarise(
    n_falt = sum(is.na(prec))
    , perc_falt = round(sum(is.na(prec)) / n() * 100, 1)
  )
tab_falt
#> # A tibble: 11 x 3
#>     year n_falt perc_falt
#>    <dbl>  <int>     <dbl>
#>  1 2004.    155     1.80 
#>  2 2005.    816     9.30 
#>  3 2006.    427     4.90 
#>  4 2007.    290     3.30 
#>  5 2008.     50     0.600
#>  6 2009.     42     0.500
#>  7 2010.     62     0.700
#>  8 2011.   1120    12.8  
#>  9 2012.    313     3.60 
#> 10 2013.     15     0.200
#> 11 2014.    818     9.30
```

- - - 

**2. Estatísticas básicas. Desconsidere os registros faltantes em seus cálculos.** 
  
  (a) Qual o valor da chuva máxima horária? Em que data ocorreu o evento?


```r
######
# (2a)
######
max(hprec$prec, na.rm = TRUE)
#> [1] 48
hprec %>% slice(which.max(prec)) %>% select(date)
#> # A tibble: 1 x 1
#>   date               
#>   <dttm>             
#> 1 2004-03-13 22:00:00
```

  (b) Qual a chuva máxima diária? Em que data ocorreu o evento?



```r
######
# (2b)
######
dprec <- 
  # agrupando os dados por data (dias)
  group_by(hprec, date = as.character(as.Date(date))) %>%
  # resumo estatístico (soma) da prec para cada componente do grupo
  dplyr::summarise(prec = sum(prec, na.rm = TRUE)) %>%
  # seleciona do resultado somente as colunas date e prec
  dplyr::select(date, prec) %>%
  # converte date para classe POSIX
  mutate(date = as.POSIXct(date))

# calcula máximo diário
max(dprec$prec)
#> [1] 130.4
# timePlot(dprec, "prec", plot.type = "h")
# encontra quando ocorreu o máximo
posicao <- which.max(dprec$prec)
dprec$date[posicao]
#> [1] "2010-01-16 UTC"
```


**3. Pluviograma mensal climatológico.**


```r
######
# (3a) e (3b)
######
(n_anos <- length(unique(year(hprec$date))))
#> [1] 11
# tabela com médias dos totais mensais, média do num. horas com prec
# usando os dados HORÁRIOS
tab_mon_h <- 
  # agrupa dados por mês
  group_by(hprec, month = lubridate::month(date)) %>%
  # reumo estatístico para cada componente do grupo
  summarise(prec_med = sum(prec, na.rm = TRUE)/n_anos
            # total de horas com prec
            ,n_horas_tot = sum(prec > 0, na.rm = TRUE)
            # num. horas médio mensal (horas)
            ,n_horas_med = sum(prec > 0, na.rm = TRUE)/n_anos
            # num. horas médio mensal (dias)
            ,n_horas_med_d = (sum(prec > 0, na.rm = TRUE)/n_anos)/24)
#tab_mon_h
```

  (a) Faça um gráfico com as médias dos totais mensais de chuva.


```r
g0 <- ggplot(tab_mon_h, aes(x = factor(month), y = prec_med))
ggp1 <- g0 + geom_bar(stat = "identity") + 
        ylab("Prec(mm/mês)") + 
        xlab("mês")+
        scale_y_continuous(expand = c(0.01, 0.01), 
                           breaks = pretty_breaks(10)) +
        theme(text = element_text(size=15), axis.text.x = element_text(angle=0))
ggp1
```

<img src="images/chunck3ab2-1.png" width="672" style="display: block; margin: auto;" />
  
  (b) Utilizando a série horária de chuva, determine o número médio de horas com chuva para cada mês. Converta a número de horas em dias para melhor comparação com o item (c).


```r
tab_mon_h
#> # A tibble: 12 x 5
#>    month prec_med n_horas_tot n_horas_med n_horas_med_d
#>    <dbl>    <dbl>       <int>       <dbl>         <dbl>
#>  1    1.     145.         474        43.1          1.80
#>  2    2.     124.         570        51.8          2.16
#>  3    3.     115.         469        42.6          1.78
#>  4    4.     128.         617        56.1          2.34
#>  5    5.     106.         679        61.7          2.57
#>  6    6.     121.         833        75.7          3.16
#>  7    7.     116.         740        67.3          2.80
#>  8    8.     106.         785        71.4          2.97
#>  9    9.     179.         947        86.1          3.59
#> 10   10.     173.         683        62.1          2.59
#> 11   11.     141.         543        49.4          2.06
#> 12   12.     156.         475        43.2          1.80
```
  
  (c) Utilizando a série de totais diários de chuva, determine o número médio de dias com chuva para cada mês. Compare com os resultados do item (b) e discuta os resultados. 


```r
######
# (3c)
######
# tabela com médias dos totais mensais, média do num. horas com prec
# usando os dados DIÁRIOS
tab_mon_d <- 
  # agrupa dados por mês
  group_by(dprec, month = lubridate::month(date)) %>%
  # resumo estatístico para cada componente do grupo
  summarise(prec_med = sum(prec, na.rm = TRUE)/n_anos
            ,n_dias = sum(prec > 0, na.rm = TRUE)
            ,n_dias_med = (sum(prec > 0, na.rm = TRUE)/n_anos))
tab_mon_d
#> # A tibble: 12 x 4
#>    month prec_med n_dias n_dias_med
#>    <dbl>    <dbl>  <int>      <dbl>
#>  1    1.     145.    125       11.4
#>  2    2.     124.    131       11.9
#>  3    3.     115.    133       12.1
#>  4    4.     128.    185       16.8
#>  5    5.     106.    203       18.5
#>  6    6.     121.    220       20.0
#>  7    7.     116.    168       15.3
#>  8    8.     106.    182       16.5
#>  9    9.     179.    166       15.1
#> 10   10.     173.    140       12.7
#> 11   11.     141.    110       10.0
#> 12   12.     156.    115       10.5
```
  
  (d) Compare a intensidade média da chuva para cada mês do ano obtida nos dois itens. Qual a importância das medidas horárias? 


```r
######
# (3d)
######
# insere coluna com intensidade baseada nos dados horários e diários
tab_mon_h <- mutate(tab_mon_h, intens_d = prec_med/n_horas_med_d)
tab_mon_d <- mutate(tab_mon_d, intens_d = prec_med/n_dias_med)
tab_intens <- data.frame(month = tab_mon_h$month,
                         #prec = tab_mon_h$prec_mon,
                         #nh_d = tab_mon_h$n_d,
                         #n_d =  tab_mon_d$n_d,
                         intens_d = tab_mon_d$intens_d,
                         intens_h = tab_mon_h$intens_d )
tab_intens
#>    month  intens_d intens_h
#> 1      1 12.798400 81.00253
#> 2      2 10.412214 57.43158
#> 3      3  9.476692 64.49808
#> 4      4  7.591351 54.62820
#> 5      5  5.734975 41.14993
#> 6      6  6.050909 38.35390
#> 7      7  7.605952 41.44216
#> 8      8  6.412088 35.67898
#> 9      9 11.881928 49.98691
#> 10    10 13.620000 67.00322
#> 11    11 14.081818 68.46409
#> 12    12 14.923478 86.71326
```

**4. Pluviograma anual.** 

  (a) Faça um gráfico com os totais anuais de chuva para cada ano.


```r
######
# Solução geral (4a-c)
######
# tabela de resultados anuais
tab_year_h <- 
  # agrupa dados por ano
  group_by(hprec, year = lubridate::year(date)) %>%
  summarise(prec_tot = sum(prec, na.rm = TRUE)
            # num. total de horas com chuva por ano (em horas)
            ,n_horas_tot = sum(prec > 0, na.rm = TRUE)) %>%
            # num. total de horas com chuva por ano (em dias)
  mutate(n_horas_tot_d = round(n_horas_tot/24, 2)
         # intensidade por ano
         ,intens = prec_tot/n_horas_tot * 24
         # num. médio de "dias" (convertidos das horas) com chuva
         ,n_d_med = mean(n_horas_tot_d)
         # chuva total média anual
         ,prec_tot_med = mean(prec_tot)
         # instensidade média anual
         ,intens_med_d = prec_tot_med/n_d_med)
select(tab_year_h, year, prec_tot)
#> # A tibble: 11 x 2
#>     year prec_tot
#>    <dbl>    <dbl>
#>  1 2004.    1083.
#>  2 2005.    1353.
#>  3 2006.    1244.
#>  4 2007.    1660.
#>  5 2008.    1508.
#>  6 2009.    2187.
#>  7 2010.    1921.
#>  8 2011.    1148.
#>  9 2012.    1656.
#> 10 2013.    1680.
#> 11 2014.    2274.
```


```r
######
# (4a)
######
# pluviograma anual
g4a <- ggplot(tab_year_h, aes(x = factor(year), y = prec_tot))
g4a + geom_bar(stat = "identity") + 
     ylab("Prec (mm)") + 
     xlab("Ano")+
     geom_hline(yintercept = mean(tab_year_h$prec_tot)) +
     geom_hline(yintercept = 1100, colour = "red") +
     scale_y_continuous(expand = c(0.01, 0.01), 
                        breaks = pretty_breaks(10)) +
     theme(text = element_text(size=15), axis.text.x = element_text(angle=0))+
     annotate("text", 
              x = 9, 
              y = 1100-50, 
              label = "Prec. média global (continentes)",
              colour = "red", size = 4)
```

<img src="images/chunck4a2-1.png" width="672" style="display: block; margin: auto;" />

  (b) Determine a frequência de ocorrência da chuva para cada ano. O gráfico deve apresentar a frequência de ocorrência em dias. 

*Para determinar a frequência de ocorrência de chuva para cada ano, devem ser contados o número horas de chuva (`prec > 0`) (`n_horas_tot`) e então multiplicar por 24 h para obtê-la a em dias (`n_horas_tot_d`).*
 

```r
select(tab_year_h, year, n_horas_tot, n_horas_tot_d, n_d_med)
#> # A tibble: 11 x 4
#>     year n_horas_tot n_horas_tot_d n_d_med
#>    <dbl>       <int>         <dbl>   <dbl>
#>  1 2004.         550          22.9    29.6
#>  2 2005.         715          29.8    29.6
#>  3 2006.         561          23.4    29.6
#>  4 2007.         797          33.2    29.6
#>  5 2008.         764          31.8    29.6
#>  6 2009.         831          34.6    29.6
#>  7 2010.         839          35.0    29.6
#>  8 2011.         569          23.7    29.6
#>  9 2012.         595          24.8    29.6
#> 10 2013.         715          29.8    29.6
#> 11 2014.         879          36.6    29.6
```


```r
# freq ocorrência
g4b <- ggplot(tab_year_h, aes(x = factor(year), y = n_horas_tot_d))
g4b + geom_bar(stat = "identity") + 
     ylab("Freq. ocorrência (dias)") + 
     xlab("Anos")+
     geom_hline(yintercept = mean(tab_year_h$n_d_med)) +
     geom_hline(yintercept = 27, colour = "red") +
     scale_y_continuous(expand = c(0.01, 0.01), 
                        breaks = pretty_breaks(10)) +
     theme(text = element_text(size=15), axis.text.x = element_text(angle=0))+
     annotate("text", 
              x = 10, 
              y = 28, 
              label = "Trenberth et al. (2003)",
              colour = "red", size = 4)
```

<img src="images/chunck4b2-1.png" width="672" style="display: block; margin: auto;" />
 
*Para fins de comparação, abaixo mostra-se o resultado obtido a partir da série de totais de precipitação. Note que a frequência de ocorrência é superestimada em relação a frequência obtida com a série horária e tais valores são imcomparáveis ao valor de [Trenberth et al. 2003](http://journals.ametsoc.org/doi/abs/10.1175/BAMS-84-9-1205) (~27 dias por ano)*
 

```r
# tabela de resultados anuais com dados diarios
tab_year_d <- 
  # agrupa dados por ano
  group_by(dprec, year = lubridate::year(date)) %>%
  summarise(prec_tot = sum(prec, na.rm = TRUE)
            # num. total de horas com chuva por ano (em horas)
            ,n_tot_d = sum(prec > 0, na.rm = TRUE)) %>%
            # num. total de horas com chuva por ano (em dias)
  mutate(
         # intensidade por ano
         intens = prec_tot/n_tot_d
         # num. médio de "dias" (convertidos das horas) com chuva
         ,n_d_med = mean(n_tot_d)
         # chuva total média anual
         ,prec_tot_med = mean(prec_tot)
         # instensidade média anual
         ,intens_med_d = mean(intens))
select(tab_year_d, year, n_tot_d, n_d_med) 
#> # A tibble: 11 x 3
#>     year n_tot_d n_d_med
#>    <dbl>   <int>   <dbl>
#>  1 2004.     135    171.
#>  2 2005.     159    171.
#>  3 2006.     162    171.
#>  4 2007.     184    171.
#>  5 2008.     180    171.
#>  6 2009.     183    171.
#>  7 2010.     174    171.
#>  8 2011.     149    171.
#>  9 2012.     149    171.
#> 10 2013.     195    171.
#> 11 2014.     208    171.
```
 
  
  (c) Qual a intensidade média da chuva (em mm/dia) em Santa Maria? Faça a média das frequências de ocorrência e das intensidade obtidas para cada ano.


```r
select(tab_year_h, year, prec_tot, n_horas_tot_d, intens, intens_med_d)
#> # A tibble: 11 x 5
#>     year prec_tot n_horas_tot_d intens intens_med_d
#>    <dbl>    <dbl>         <dbl>  <dbl>        <dbl>
#>  1 2004.    1083.          22.9   47.3         54.4
#>  2 2005.    1353.          29.8   45.4         54.4
#>  3 2006.    1244.          23.4   53.2         54.4
#>  4 2007.    1660.          33.2   50.0         54.4
#>  5 2008.    1508.          31.8   47.4         54.4
#>  6 2009.    2187.          34.6   63.2         54.4
#>  7 2010.    1921.          35.0   54.9         54.4
#>  8 2011.    1148.          23.7   48.4         54.4
#>  9 2012.    1656.          24.8   66.8         54.4
#> 10 2013.    1680.          29.8   56.4         54.4
#> 11 2014.    2274.          36.6   62.1         54.4
```


```r
# intensdade anual
g4c <- ggplot(tab_year_h, aes(x = factor(year), y = intens))
g4c + geom_bar(stat = "identity") + 
     ylab("Intensidade (mm/dia)") + 
     xlab("Ano")+
     geom_hline(yintercept = mean(tab_year_h$intens_med_d)) +
     geom_hline(yintercept = 45, colour = "red") +
     scale_y_continuous(expand = c(0.01, 0.01), 
                        breaks = pretty_breaks(10)) +
     theme(text = element_text(size=15), axis.text.x = element_text(angle=0)) +
     annotate("text", 
              x = 10, 
              y = 47, 
              label = "Trenberth et al. (2003)",
              colour = "red", size = 4)
```

<img src="images/chunck4c2-1.png" width="672" style="display: block; margin: auto;" />

- - - 

**5. Frequência de ocorrência de chuva horária.**

  (a) Determine a frequência de ocorrência de chuva (ou seja, o número de casos em que choveu) para cada hora do dia (das 0 às 23 h). Apresente os resultados na forma de um gráfico de barras com a frequência de ocorrência de chuva (eixo y, em %)  em cada hora (eixo x). Descreva se há algum padrão no gráfico? Chove mais de dia ou à noite?


```r
tab_h <-
group_by(filter(hprec, !is.na(prec)), 
         hour = lubridate::hour(date)) %>%
  summarise(n_h = sum(prec > 0)
            #N = n()
            ) %>%
  mutate(n_h_perc = round(n_h/sum(n_h) * 100, 2)
         #n_h_perc_all = round((n_h/sum(N)) * 100, 2)
         )
tab_h
#> # A tibble: 24 x 3
#>     hour   n_h n_h_perc
#>    <int> <int>    <dbl>
#>  1     0   304     3.89
#>  2     1   290     3.71
#>  3     2   319     4.08
#>  4     3   334     4.27
#>  5     4   365     4.67
#>  6     5   399     5.11
#>  7     6   400     5.12
#>  8     7   405     5.18
#>  9     8   370     4.73
#> 10     9   340     4.35
#> # ... with 14 more rows
```


```r
# gráfico
g2 <- ggplot(tab_h, aes(x = factor(hour), y = n_h_perc))
g2 + geom_bar(stat = "identity") + 
     ylab("Freq. ocorrência (%)") + 
     xlab("Hora")+
     scale_y_continuous(expand = c(0.01, 0.01), 
                        breaks = pretty_breaks(10)) +
     theme(text = element_text(size=15), axis.text.x = element_text(angle=0))
```

<img src="images/chunck5a2-1.png" width="672" style="display: block; margin: auto;" />

- - - 

**6. Frequência de ocorrência semanal.**

(a) Determine a frequência de ocorrência (%) de precipitação para cada dia da semana. Qual o dia da semana é mais provável de ocorra precipitação?


```r
tab_week <-
group_by(filter(hprec, !is.na(prec)), 
         dia = lubridate::wday(date, label = TRUE)) %>%
  summarise(n_prec = sum(prec > 0),
            N = n()) %>%
  mutate(n_prec_perc = round(n_prec/sum(n_prec) * 100, 2),
         n_all = round((n_prec/sum(N)) * 100, 2))
tab_week
#> # A tibble: 7 x 5
#>   dia   n_prec     N n_prec_perc n_all
#>   <ord>  <int> <int>       <dbl> <dbl>
#> 1 Sun     1129 13163        14.4  1.22
#> 2 Mon     1109 13154        14.2  1.20
#> 3 Tue     1088 13183        13.9  1.18
#> 4 Wed     1014 13215        13.0  1.10
#> 5 Thu      980 13220        12.5  1.06
#> 6 Fri     1170 13182        15.0  1.27
#> 7 Sat     1325 13203        17.0  1.44
```


```r
# gráfico
g3 <- ggplot(tab_week, aes(x = factor(dia), y = n_prec_perc))
g3 + geom_bar(stat = "identity") + 
     ylab("Freq. ocorrência (%)") + 
     xlab("dia da semana") +
     scale_y_continuous(expand = c(0.01, 0.01), 
                        breaks = pretty_breaks(10)) +
     theme(text = element_text(size=15), axis.text.x = element_text(angle=0))
```

<img src="images/chunck6a2-1.png" width="672" />

- - - 

**7. A Prefeitura Municipal de Santa Maria precisa definir uma data (mês, dia da semana e horário) para realização de um grande evento de entretenimento que requer um período de 3 horas sem chuva, independente do turno.** 

  (a) Com base nos seus resultados que data você recomendaria?

> Em março, numa quinta-feira, entre 21 e 23 horas.
