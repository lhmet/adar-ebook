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

Dados climatológicos:


```r
library(rio)
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

## Operador Pipe `%>%`


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

Ambas funções realizam a mesma tarefa e o benefício de usar  `%>%'não é evidente. Entretanto, quando desejamos realizar várias funções sua vantagem torna-se evidente. 

## Restruturação de dados


### Dados arrumados

asd

### tidyr

asd

## Manipulação de dados

Gramática de manipulação de dados.

### dplyr

* 5 verbos básicos: 

  - `select()`
  - `filter()`
  - `arrange()`
  - `mutate()`
  - `group_by()` e `summarise()` 
