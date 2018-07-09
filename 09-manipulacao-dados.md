---
output:
  html_document: default
  pdf_document: default
---
# (PART) Ferramentas modernas do R {-}


# Processamento de dados {#data-wrangle}



Neste capítulo veremos:

- um *data frame* aperfeiçoado, denominado *tibble*

- como arrumar seus dados em uma estrutura conveniente para a análise e visualização de dados

- como reestruturar os dados de uma forma versátil e fácil de entender

- como manipular os dados com uma ferramenta intuitiva e padronizada

Existem diversas ferramentas da base do <img src="images/logo_r.png" width="20"> para realizar as operações listadas acima. Entretanto, elas não foram construídas para um objetivo comum e foram feitas por diferentes desenvolvedores e em diferentes fases da evolução do R. Por isso, elas podem parecer confusas, não seguem uma codificação consistente e não foram construídas pensando em uma interface integrada para o processamento de dados. Conseqüentemente, para usá-las é necessários um esforço significativo para entender a estrutura de dados de entrada de cada uma. A seguir, precisamos padronizar suas saídas para que sirvam de entrada para outra função (às vezes de outro pacote) que facilita a realização de uma próxima etapa do fluxo de trabalho.

Muitas coisas no <img src="images/logo_r.png" width="20"> que foram desenvolvidas há 20 anos atrás são úteis até hoje. Mas as mesmas ferramentas podem não ser a melhor solução para os problemas contemporâneos. Alterar os códigos da base do <img src="images/logo_r.png" width="20"> é uma tarefa complicada devido a cadeia de dependências do código fonte e dos pacotes dos milhares de contribuidores. Então, grande parte das inovações no <img src="images/logo_r.png" width="20"> estão ocorrendo na forma de pacotes. Um exemplo é o conjunto de pacotes [*tidyverse*](https://www.tidyverse.org/) desenvolvido para suprir a necessidade de ferramentas efetivas e integradas para ciência de dados (Figura \@ref(fig:tidy-workflow)).




<div class="figure">
<img src="images/workflowtidy.png" alt="Modelo de ferramentas empregadas em ciência de dados. Adaptado de @Wickham2017." width="100%" />
<p class="caption">(\#fig:tidy-workflow)Modelo de ferramentas empregadas em ciência de dados. Adaptado de @Wickham2017.</p>
</div>

O termo *tidyverse* pode ser traduzido como 'universo arrumado' e consiste em um pacote do <img src="images/logo_r.png" width="20"> que agrupa pacotes (Figura \@ref(fig:tidyverse-components)) que compartilham uma filosofia comum de *design*, gramática [@Wickham-dplyr] e estrutura de dados [@Wickham2014]. Consequentemente, o *tidyverse* tem sido amplamente utilizado pela comunidade de usuários e desenvolvedores do <img src="images/logo_r.png" width="20">. Além de uma abordagem mais coesa e consistente para realizar as tarefas envolvidas no processamento de dados, os códigos são mais eficientes (que a base do <img src="images/logo_r.png" width="20">), legíveis e com sintaxe mais fácil de lembrar.

<div class="figure">
<img src="images/tidyverse_components.png" alt="Coleção de pacotes do *tidyverse*." width="80%" />
<p class="caption">(\#fig:tidyverse-components)Coleção de pacotes do *tidyverse*.</p>
</div>


## Pré-requisitos

O pacote **tidyverse** torna fácil de instalar e carregar os pacotes do *tidyverse* com apenas uma chamada à função:


```r
install.packages("tidyverse")
```

E da mesma forma carregamos o conjunto de pacotes com:


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

<div class="rmdnote">
<p>Ao carregar o pacote <strong>tidyverse</strong> é mostrado no console os pacotes que foram carregados. À direita são mostradas as configurações e informações sobre o seu sistema operacional. Na parte inferior, há uma mensagem sobre os conflitos entre as funções da base do R (ou de outros pacotes) que tem mesmo nome que as de algum pacote do <em>tidyverse</em>. A função do pacote carregado mais recentemente terá prioridade de uso. No caso acima, a função <code>filter()</code> do <strong>dplyr</strong> sobrepôs a função <code>filter()</code> do pacote <strong>stats</strong> da base do R. Em situações como esta é melhor deixar explícito no seu código a chamada à função usando <code>pacote::funcao()</code>.</p>
</div>




Neste capítulo além do **tidyverse** usaremos outros pacotes que já podemos instalar:


```r
pacotes <- c("openair", "lubridate", "scales", "rio")
easypackages::libraries(pacotes)
```


### Dados 

Para este capítulo utilizaremos diversos conjuntos de dados para exemplificar o uso das principais ferramentas de manipulação de dados do *tidyverse*.

1. Dados climatológicos de precipitação e temperatura máxima anual de estações meteorológicas do [INMET](http://www.inmet.gov.br/portal/index.php?r=bdmep/bdmep) localizadas no estado do Rio Grande do Sul.


```r
clima_file_url <- "https://github.com/lhmet/adar-ufsm/blob/master/data/clima-rs.RDS?raw=true"
# dados de exemplo
clima_rs <- import(clima_file_url, format = "RDS")
clima_rs
```


 codigo            estacao            uf     prec     tmax 
--------  -------------------------  ----  --------  ------
 83931            Alegrete            RS    1492.2    25.4 
 83980              Bagé              RS    1299.9    24.1 
 83941         Bento Gonçalves        RS    1683.7    23.0 
 83919            Bom Jesus           RS    1807.3    20.3 
 83963        Cachoeira do Sul        RS    1477.1    25.1 
 83942          Caxias do Sul         RS    1823.0    21.8 
 83912            Cruz Alta           RS    1630.7    24.5 
 83964       Encruzilhada do Sul      RS    1510.8    22.5 
 83915             Guaporé            RS    1758.7    24.7 
 83881              Iraí              RS    1806.7    27.1 
 83929             Itaqui             RS    1369.4    26.2 
 83916         Lagoa Vermelha         RS    1691.1    23.0 
 83880      Palmeira das Missões      RS    1747.8    24.0 
 83914           Passo Fundo          RS    1803.1    23.6 
 83967          Porto Alegre          RS    1320.2    24.8 
 83995           Rio Grande           RS    1233.6    21.7 
 83936           Santa Maria          RS    1616.8    24.9 
 83997     Santa Vitória do Palmar    RS    1228.9    21.8 
 83957           São Gabriel          RS    1313.9    25.0 
 83907        São Luiz Gonzaga        RS    1770.9    26.1 
 83966              Tapes             RS    1349.8    23.8 
 83948             Torres             RS    1363.2    22.3 
 83927           Uruguaiana           RS    1647.4    25.8 


2. Metadados das estações meteorológicas do [INMET](http://www.inmet.gov.br/portal/index.php?r=bdmep/bdmep) relacionadas a tabela de dados `clima_rs`.


```r
metadados_url <- "https://github.com/lhmet/adar-ufsm/blob/master/data/clima_rs_metadata_61_90.rds?raw=true"
# dados de exemplo
metadados_rs <- import(metadados_url, format = "RDS")
metadados_rs
```


 codigo       lon          lat         alt   
--------  -----------  -----------  ---------
 83931     -55.51667    -29.68333    120.91  
 83980     -54.10000    -31.33333    242.31  
 83941     -51.51667    -29.15000    640.00  
 83919     -50.43333    -28.66667    1047.50 
 83959     -53.48333    -30.51667    450.00  
 83963     -52.88333    -30.03333     72.71  
 83942     -51.20000    -29.16667    759.60  
 83912     -53.60000    -28.63333    472.50  
 83964     -52.51667    -30.53333    427.75  
 83915     -51.90000    -28.91667    471.51  
 83881     -53.23333    -27.18333    247.10  
 83929     -56.53333    -29.11667     76.00  
 83916     -51.50000    -28.21667    840.00  
 83885     -51.90000    -27.45000    414.17  
 83880     -53.43333    -27.88333    634.00  
 83914     -52.40000    -28.21667    684.05  
 83985     -52.41667    -31.78333     13.00  
 83983     -53.10000    -31.43333    345.00  
 83967     -51.16667    -30.05000     46.97  
 83995     -52.10000    -32.03333     2.46   
 83936     -53.70000    -29.70000     95.00  
 83997     -53.35000    -33.51667     24.01  
 83953     -55.60000    -30.83333    328.00  
 83909     -54.25000    -28.30000    284.50  
 83957     -54.31667    -30.33333    124.00  
 83907     -55.01667    -28.40000    245.11  
 83966     -51.58333    -30.83333     5.00   
 83948     -49.71667    -29.35000     4.66   
 83927     -57.08333    -29.75000     62.31  
 83918     -50.70000    -28.55000    954.60  

3. Um exemplo minimalista de dados referentes a séries temporais de precipitação anual observada em estações meteorológicas.


```r
prec_anual <- data.frame(
  site = c(
    "A001", "A001", "A002", "A002", "A002", "A003", "A803", "A803"
  ),
  ano = c(2000:2001, 2000:2002, 2004, 2005, 2006),
  prec = c(1800, 1400, 1750, 1470, 1630, 1300, 1950, 1100)
)
prec_anual
```


 site    ano     prec 
------  ------  ------
 A001    2000    1800 
 A001    2001    1400 
 A002    2000    1750 
 A002    2001    1470 
 A002    2002    1630 
 A003    2004    1300 
 A803    2005    1950 
 A803    2006    1100 



## *tibble*: um *data frame* aperfeiçoado

*Data frames* são a unidade fundamental de armazenamento de dados retangulares no R. O pacote **tibble** estende a classe *data frame* da base do <img src="images/logo_r.png" width="20"> com aperfeiçoamentos relacionados a impressão de dados (mais amigável e versátil), a seleção de dados e a manipulação de dados do tipo *factor*. O novo objeto é chamado de *tibble* e sua classe de `tbl_df`. 

### Funcionalidades do *tibble*

Para ilustrar algumas vantagens do *tibble*, vamos usar o *data frame* `prec_anual`. A criação destes dados como *tibble* é feita com a função de mesmo nome do pacote: `tibble::tibble()`.


```r
prec_anual_tbl <- tibble(
  site = c(
    "A001", "A001", "A002", "A002", "A002", "A003", "A803", "A803"
  ),
  ano = c(2000:2001, 2000:2002, 2004, 2005, 2006),
  prec = c(1800, 1400, 1750, 1470, 1630, 1300, 1950, 1100)
)
```

O exemplo acima é ilustrativo, pois um *data frame* pode ser convertido em um *tibble* simplesmente com a função `tibble::as_tibble()`:


```r
prec_anual_tbl <- as_tibble(prec_anual)
prec_anual_tbl
#> # A tibble: 8 x 3
#>   site    ano  prec
#>   <fct> <dbl> <dbl>
#> 1 A001   2000  1800
#> 2 A001   2001  1400
#> 3 A002   2000  1750
#> 4 A002   2001  1470
#> 5 A002   2002  1630
#> 6 A003   2004  1300
#> 7 A803   2005  1950
#> 8 A803   2006  1100
```


Com o *tibble* acima, as principais diferenças entre um *tibble* e um *data frame* podem ser enfatizadas.

- quando impresso no console do R, o *tibble* já mostra a classe de cada variável.

- vetores caracteres não são interpretados como *factors* em um *tibble*, em contraste a `base::data.frame()` que faz a coerção para *factor* e não conserva o nome das variáveis. Este comportamento padrão pode causar problemas aos usuários desavisados em análises posteriores. 


```r
str(data.frame("temp. do ar" = "18"))
#> 'data.frame':	1 obs. of  1 variable:
#>  $ temp..do.ar: Factor w/ 1 level "18": 1
```

- permite usar seus próprios argumentos prévios para definir variáveis durante a criação do *tibble*; veja o exemplo abaixo, onde a `int prec`(intensidade da precipitação) é baseada na razão da precipitação (`prec`) pelo número de dias no ano.


```r
prec_anual_tbl <- tibble(
  site = c(
    "A001", "A001", "A002", "A002", "A002", "A003", "A803", "A803"
  ),
  ano = c(2000:2001, 2000:2002, 2004, 2005, 2006),
  prec = c(1800, 1400, 1750, 1470, 1630, 1300, 1950, 1100),
  "int prec" = prec / 365.25
)
prec_anual_tbl
#> # A tibble: 8 x 4
#>   site    ano  prec `int prec`
#>   <chr> <dbl> <dbl>      <dbl>
#> 1 A001   2000  1800       4.93
#> 2 A001   2001  1400       3.83
#> 3 A002   2000  1750       4.79
#> 4 A002   2001  1470       4.02
#> 5 A002   2002  1630       4.46
#> 6 A003   2004  1300       3.56
#> 7 A803   2005  1950       5.34
#> 8 A803   2006  1100       3.01
```


- nunca adiciona nomes às linhas (`row.names`)


```r
# nomes das linhas de um data frame são carregados adiante
subset(prec_anual, ano == 2001)
#>   site  ano prec
#> 2 A001 2001 1400
#> 4 A002 2001 1470
# tibble não possui nome de linhas (rownames)
subset(prec_anual_tbl, ano == 2001)
#> # A tibble: 2 x 4
#>   site    ano  prec `int prec`
#>   <chr> <dbl> <dbl>      <dbl>
#> 1 A001   2001  1400       3.83
#> 2 A002   2001  1470       4.02
```


- a impressão de um *tibble* mostra as dez primeiras linhas e a quantidade de colunas mostradas é ajustada ao tamanho da janela do console.


As opções de controle *default* da impressão de *tibbles* no console pode ser configuradas através da função de opções de configuração global do R:


```r
m <- 15
n <- 3
options(
  tibble.print_max = m,
  tibble.print_min = n
)
```

Com a configuração acima, será impresso no console do R `n = 3` linhas do *tibble* se ele tiver mais de `m = 15` linhas. 


```r
nrow(clima_rs) > 15
#> [1] TRUE
# coersão do data.frame clima_rs para tibble
clima_rs_tbl <- as_tibble(clima_rs)
```

Para restaurar as opções *default* use:


```r
options(
  tibble.print_max = NULL,
  tibble.print_min = NULL
)
clima_rs_tbl
#> # A tibble: 23 x 5
#>    codigo estacao             uf     prec  tmax
#>  * <chr>  <chr>               <chr> <dbl> <dbl>
#>  1 83931  Alegrete            RS    1492.  25.4
#>  2 83980  Bagé                RS    1300.  24.1
#>  3 83941  Bento Gonçalves     RS    1684.  23  
#>  4 83919  Bom Jesus           RS    1807.  20.3
#>  5 83963  Cachoeira do Sul    RS    1477.  25.1
#>  6 83942  Caxias do Sul       RS    1823   21.8
#>  7 83912  Cruz Alta           RS    1631.  24.5
#>  8 83964  Encruzilhada do Sul RS    1511.  22.5
#>  9 83915  Guaporé             RS    1759.  24.7
#> 10 83881  Iraí                RS    1807.  27.1
#> # ... with 13 more rows
```


Uma alternativa útil para inspecionar mais detalhadamente os dados é a função `tibble::glimpse()`.


```r
glimpse(clima_rs)
#> Observations: 23
#> Variables: 5
#> $ codigo  <chr> "83931", "83980", "83941", "83919", "83963", "83942", ...
#> $ estacao <chr> "Alegrete", "Bagé", "Bento Gonçalves", "Bom Jesus", "C...
#> $ uf      <chr> "RS", "RS", "RS", "RS", "RS", "RS", "RS", "RS", "RS", ...
#> $ prec    <dbl> 1492.2, 1299.9, 1683.7, 1807.3, 1477.1, 1823.0, 1630.7...
#> $ tmax    <dbl> 25.4, 24.1, 23.0, 20.3, 25.1, 21.8, 24.5, 22.5, 24.7, ...
```


Lembre-se também, da função `utils::View()` para visualizar os dados no RStudio.


```r
View(clima_rs)
```


Outros aspectos diferencias do *tibble* podem consultados na vinheta do referido pacote (`vignette("tibble")`).


## Restruturação de dados retangulares

> Até 80% do tempo da análise dados é dedicada ao processo de limpeza e preparação dos dados [@Dasu-Johnson, [New York Times 2014/08/18](https://www.nytimes.com/2014/08/18/technology/for-big-data-scientists-hurdle-to-insights-is-janitor-work.html)].



### Dados arrumados

O conceito \"dados arrumados\" foi estabelecido por @Wickham2014 e representa uma forma padronizada de conectar a estrutura (formato) de um conjunto de dados a sua semântica (significado).

Dados bem estruturados servem para:

- fornecer dados propícios para o processamento e análise de dados por *softwares*;

- revelar informações e facilitar a percepção de padrões

Dados no \"formato arrumado\" atendem as seguintes regras para dados retangulares:

1. cada **variável** está em uma coluna 

2. cada **observação** corresponde a uma linha

3. cada **valor** corresponde a uma célula

4. cada tipo de unidade observacional deve compor uma tabela

<div class="rmdnote">
<p>Como sinônimo de observações você pode encontrar os termos: registros, casos, exemplos, instâncias ou amostras dependendo da área de aplicação.</p>
</div>

 
![Estrutura de dados padronizados](http://garrettgman.github.io/images/tidy-1.png)

Um exemplo de dados no formato arrumado é o *tibble* `prec_anual_tbl` mostrado abaixo:


 site    ano     prec    intensidade 
------  ------  ------  -------------
 A001    2000    1800     4.928131   
 A001    2001    1400     3.832991   
 A002    2000    1750     4.791239   
 A002    2001    1470     4.024641   
 A002    2002    1630     4.462697   
 A003    2004    1300     3.559206   
 A803    2005    1950     5.338809   
 A803    2006    1100     3.011636   

Os dados acima tem duas variáveis: precipitação (`prec`) e intensidade da precipitação (`intensidade`). As unidades observacionais são as colunas `site` e `ano`. A primeira unidade observacional informa o ponto de amostragem espacial e a segunda o ponto de amostragem temporal.

Uma **variável** contém todos valores que medem um mesmo atributo ao longo das unidades observacionais. Uma **observação** contém todos valores medidos na mesma unidade observacional ao longo dos atributos.
Cada **valor** (número ou caractere) pertence a uma variável e uma observação.

Exemplo de diferentes **tipos de unidades observacionais** são a tabela com a séries temporais dos elementos meteorológicos (exemplo acima) e a tabela com os metadados das estações de superfície que contém atributos das estações meteorológicas (`site` no exemplo acima), tais como: longitude, latitude, altitude, nome, município, estado e etc.

A estrutura de dados \"arrumados\" parece óbvia, mas na prática, dados neste formatos são raros de serem encontrados. As razões para isso incluem:

- quem projeta a coleta e o registro de dados nem sempre é aquele que gasta tempo trabalhando sobre os dados;

- a organização dos dados busca tornar o registro de dados o mais fácil possível;

Consequente, dados reais sempre precisarão ser arrumados. O primeiro passo é identificação das variáveis e das observações. O passo seguinte é resolver os seguintes problemas mais comuns [@Wickham2017]:

- uma variável deve ser distribuída ao longo das colunas

- uma observação deve ser distribuída ao longo das linhas

Essas duas operações são realizadas com as principais funções do pacote **tidyr**: 

- `gather()`, que pode ser traduzida como reunir (nas linhas);

- `spread()` que pode ser traduzida como espalhar (nas colunas)






### Formatos de dados mais comuns

O pacote **tidyr** é a extensão do <img src="images/logo_r.png" width="20"> que fornece funcionalidades para reestruturar os dados entre diferentes formatos.

Os principais formatos de dados são: 

- dados longos, são tabelas com mais valores ao longo das linhas; geralmente mistura variáveis com observações;

- dados amplos, são tabelas com valores mais distribuídos nas colunas, geralmente contém pelo menos uma unidade observacional misturada com variáveis;


#### Formato de dados longo {#formatos-dados}

Para exemplificar o formato de dados longo vamos partir dos \"dados arrumados\" do exemplo, `prec_anual_tbl`. Primeiro vamos renomear a variável `int prec` para `intensidade` para  seguir um o padrão de nome das variáveis mais conveniente para o seu processamento no R.


```r
prec_anual_tbl <- rename(
  prec_anual_tbl,
  "intensidade" = `int prec`
) 
prec_anual_tbl
#> # A tibble: 8 x 4
#>   site    ano  prec intensidade
#>   <chr> <dbl> <dbl>       <dbl>
#> 1 A001   2000  1800        4.93
#> 2 A001   2001  1400        3.83
#> 3 A002   2000  1750        4.79
#> 4 A002   2001  1470        4.02
#> 5 A002   2002  1630        4.46
#> 6 A003   2004  1300        3.56
#> 7 A803   2005  1950        5.34
#> 8 A803   2006  1100        3.01
```

Vamos usar a função `tidyr::gather()` para reestruturar os dados `prec_anual_tbl` em uma nova tabela de dados que chamaremos `prec_anual_long`.

Na nova tabela, manteremos as colunas `site`, `ano` e   teremos dois novos pares de variáveis: `variavel` e `valor`. Na coluna `variavel` será distribuído o nome das variáveis `prec` e `intensidade`. A coluna `valor`reunirá os valores das variáveis `prec` e `intensidade`.


```r
prec_anual_long <- gather(
  data = prec_anual_tbl,
  key = variavel,
  value = medida,
  prec, intensidade
)
prec_anual_long
#> # A tibble: 16 x 4
#>    site    ano variavel     medida
#>    <chr> <dbl> <chr>         <dbl>
#>  1 A001   2000 prec        1800   
#>  2 A001   2001 prec        1400   
#>  3 A002   2000 prec        1750   
#>  4 A002   2001 prec        1470   
#>  5 A002   2002 prec        1630   
#>  6 A003   2004 prec        1300   
#>  7 A803   2005 prec        1950   
#>  8 A803   2006 prec        1100   
#>  9 A001   2000 intensidade    4.93
#> 10 A001   2001 intensidade    3.83
#> 11 A002   2000 intensidade    4.79
#> 12 A002   2001 intensidade    4.02
#> 13 A002   2002 intensidade    4.46
#> 14 A003   2004 intensidade    3.56
#> 15 A803   2005 intensidade    5.34
#> 16 A803   2006 intensidade    3.01
```

O código acima demonstra os principais argumentos requeridos pela função `gather`:

- `data = prec_anual_tbl`, o *data frame* ou *tibble* que será reestruturado;

- `key = variavel`, nome que nós escolhemos para dar à nova coluna que distribuirá os **nomes das variáveis** dos dados de entrada.

- `value = medida`, nome que nós escolhemos para dar à nova coluna que reunirá os **valores das variáveis** dos dados de entrada;

- `...`, lista com o nome das variáveis, no código acima corresponde à `prec, intensidade`;

As demais colunas dos dados (`site` e `ano`) serão mantidas inalteradas e seus valores serão repetidos quando necessário.

Como em outras funções dos pacotes do **tidyverse** você perceberá que os argumentos **não são especificados como caracteres** e sim como nomes (ou seja o nome da variável sem aspas), como aqueles usados quando definimos variáveis (p.ex.: `nome_var <- 10`). Os argumentos `key` e `value` podem ser especificados à gosto do usuário e não precisam ter relação com os dados existentes.

Se nós desejássemos que todas colunas do *data frame* fossem reunidas em uma nova coluna `atributo` e os seus valores em uma nova coluna `valor`, isso poderia ser feito simplesmente sem especificar variáveis de interesse (`prec, intensidade`) no trecho de código anterior. A tabela de dados resultante conterá todos os 32 pares de valores, formados pelas 4 colunas por 8 linhas, dos dados originais:


```r
prec_anual_longo <- gather(
  prec_anual_tbl, 
  key = atributo,
  value = valor
)
prec_anual_longo
#> # A tibble: 32 x 2
#>    atributo valor
#>    <chr>    <chr>
#>  1 site     A001 
#>  2 site     A001 
#>  3 site     A002 
#>  4 site     A002 
#>  5 site     A002 
#>  6 site     A003 
#>  7 site     A803 
#>  8 site     A803 
#>  9 ano      2000 
#> 10 ano      2001 
#> # ... with 22 more rows
```

Se não forem especificados nomes para os argumentos `key` e `value` na chamada da função `tidyr::gather()`, serão atribuídos os valores *default*: `key` e `value`.


```r
gather(prec_anual_tbl)
#> # A tibble: 32 x 2
#>    key   value
#>    <chr> <chr>
#>  1 site  A001 
#>  2 site  A001 
#>  3 site  A002 
#>  4 site  A002 
#>  5 site  A002 
#>  6 site  A003 
#>  7 site  A803 
#>  8 site  A803 
#>  9 ano   2000 
#> 10 ano   2001 
#> # ... with 22 more rows
```


#### Formato de dados amplo

Utilizando os dados `meteo_long`, vamos reestruturá-lo no formato amplo para demostrar a funcionalidade da função `tidyr::spread()`. Esta função é complementar à `tidyr::gather()`.


```r
prec_anual_long
#> # A tibble: 16 x 4
#>    site    ano variavel     medida
#>    <chr> <dbl> <chr>         <dbl>
#>  1 A001   2000 prec        1800   
#>  2 A001   2001 prec        1400   
#>  3 A002   2000 prec        1750   
#>  4 A002   2001 prec        1470   
#>  5 A002   2002 prec        1630   
#>  6 A003   2004 prec        1300   
#>  7 A803   2005 prec        1950   
#>  8 A803   2006 prec        1100   
#>  9 A001   2000 intensidade    4.93
#> 10 A001   2001 intensidade    3.83
#> 11 A002   2000 intensidade    4.79
#> 12 A002   2001 intensidade    4.02
#> 13 A002   2002 intensidade    4.46
#> 14 A003   2004 intensidade    3.56
#> 15 A803   2005 intensidade    5.34
#> 16 A803   2006 intensidade    3.01
```

Nosso objetivo é então gerar uma nova tabela de dados reestruturada, de forma que os nomes das variáveis (contidos na coluna `variavel`) sejam distribuídos em duas colunas. Estas colunas receberão os nomes `prec` e `intensidade` e serão preenchidas com os valores armazenados na coluna `medida`. Para fazer isso usamos o seguinte código:


```r
prec_anual_amplo <- spread(
  data = prec_anual_long,
  key = variavel,
  value = medida
)
prec_anual_amplo
#> # A tibble: 8 x 4
#>   site    ano intensidade  prec
#>   <chr> <dbl>       <dbl> <dbl>
#> 1 A001   2000        4.93  1800
#> 2 A001   2001        3.83  1400
#> 3 A002   2000        4.79  1750
#> 4 A002   2001        4.02  1470
#> 5 A002   2002        4.46  1630
#> 6 A003   2004        3.56  1300
#> 7 A803   2005        5.34  1950
#> 8 A803   2006        3.01  1100
```

Esta operação serviu para colocar os dados originais (`prec_anual_long`) no formato \"arrumado\" (`prec_anual_amplo`).


### Funções adicionais do **tidyr**

Você pode unir duas colunas inserindo um separador entre elas com a função `tidyr::unite()`:


```r
(prec_anual_long_u <- unite(
  prec_anual_long,
  col = site_ano,
  site, ano,
  sep = "_"
))
#> # A tibble: 16 x 3
#>    site_ano  variavel     medida
#>    <chr>     <chr>         <dbl>
#>  1 A001_2000 prec        1800   
#>  2 A001_2001 prec        1400   
#>  3 A002_2000 prec        1750   
#>  4 A002_2001 prec        1470   
#>  5 A002_2002 prec        1630   
#>  6 A003_2004 prec        1300   
#>  7 A803_2005 prec        1950   
#>  8 A803_2006 prec        1100   
#>  9 A001_2000 intensidade    4.93
#> 10 A001_2001 intensidade    3.83
#> 11 A002_2000 intensidade    4.79
#> 12 A002_2001 intensidade    4.02
#> 13 A002_2002 intensidade    4.46
#> 14 A003_2004 intensidade    3.56
#> 15 A803_2005 intensidade    5.34
#> 16 A803_2006 intensidade    3.01
```

Se ao contrário, você quer separar uma coluna em duas variáveis, utilize a função `tidyr::separate()`:


```r
separate(
  prec_anual_long_u,
  col = site_ano,
  sep = "_",
  into = c("site", "ano")
)
#> # A tibble: 16 x 4
#>    site  ano   variavel     medida
#>    <chr> <chr> <chr>         <dbl>
#>  1 A001  2000  prec        1800   
#>  2 A001  2001  prec        1400   
#>  3 A002  2000  prec        1750   
#>  4 A002  2001  prec        1470   
#>  5 A002  2002  prec        1630   
#>  6 A003  2004  prec        1300   
#>  7 A803  2005  prec        1950   
#>  8 A803  2006  prec        1100   
#>  9 A001  2000  intensidade    4.93
#> 10 A001  2001  intensidade    3.83
#> 11 A002  2000  intensidade    4.79
#> 12 A002  2001  intensidade    4.02
#> 13 A002  2002  intensidade    4.46
#> 14 A003  2004  intensidade    3.56
#> 15 A803  2005  intensidade    5.34
#> 16 A803  2006  intensidade    3.01
```

Para completar valores das variáveis para unidades observacionais faltantes podemos utilizar a função `tidyr::complete()`:


```r
prec_anual
#>   site  ano prec
#> 1 A001 2000 1800
#> 2 A001 2001 1400
#> 3 A002 2000 1750
#> 4 A002 2001 1470
#> 5 A002 2002 1630
#> 6 A003 2004 1300
#> 7 A803 2005 1950
#> 8 A803 2006 1100
prec_anual_comp <- complete(
  prec_anual,
  site, ano
)
prec_anual_comp
#> # A tibble: 24 x 3
#>    site    ano  prec
#>    <fct> <dbl> <dbl>
#>  1 A001   2000  1800
#>  2 A001   2001  1400
#>  3 A001   2002    NA
#>  4 A001   2004    NA
#>  5 A001   2005    NA
#>  6 A001   2006    NA
#>  7 A002   2000  1750
#>  8 A002   2001  1470
#>  9 A002   2002  1630
#> 10 A002   2004    NA
#> # ... with 14 more rows
```




## Manipulação de dados

Com os dados arrumados, a próxima etapa é a manipulação dos dados. O pacote **dplyr** oferece um conjunto de funções que facilita as operações mais comuns para lidar com dados retangulares de uma forma bem pensada.

Os verbos fundamentais desta gramática de manipulação de dados são: 

  - `select()`, para selecionar variáveis;
  - `filter()`, para filtrar observações;
  - `arrange()`, para classificar variáveis;
  - `mutate()`, para criar e transformar variáveis;
  - `group_by()`, para agrupar observações;
  - `summarise()`, para resumir os dados com medidas estatísticas descritivas;


Estes verbos possuem uma sintaxe consistente com uma sentença gramatical:

<p style="color:DodgerBlue; font-size:1.3em; font-weight: bold;text-align:center;"> `verbo(sujeito, complemento)` </p>
 traduzindo de outra forma:
<p style="color:DodgerBlue; font-size:1.3em; font-weight: bold;text-align:center;"> `função(dados, z = x + y)` </p>

- o `verbo` é a função do **dplyr**;
- o `sujeito` (dados) é quem sofre a ação e é **sempre o primeiro argumento**, nomeado (`.data`);
- o `complemento` são expressões que podem ser usadas como argumentos (o que é representado pela reticência `...` no segundo argumento); isso ficará mais claro nos exemplos mais a frente;


<div class="rmdtip">
<p>Os verbos listados anteriormente possuem versões equivalentes na base do <code>r rblue</code>. Então, por que usar o <em>dplyr</em> ?</p>
<ul>
<li><p>é muito mais rápido de se aprender, com poucas funções (ou verbos) nomeadas intuitivamente;</p></li>
<li><p>as funções do <strong>dplyr</strong> são mais rápidas (parte dos códigos são programados em C++);</p></li>
<li><p>trabalha bem com dados arrumados e também com sistemas de banco de dados</p></li>
<li><p>as funções foram projetadas para trabalharem juntas na solução diversos problemas de processamento de dados;</p></li>
</ul>
</div>


### Códigos como fluxogramas 

A manipulação de dados requer uma organização apropriada do código. A medida que novas etapas do fluxo de trabalho vão sendo implementadas o código expande-se. As etapas vão sendo implementadas de forma sequencial, combinando funções que geram saídas que servirão de entrada para outras funções na cadeia de processamento. 

Essa é justamente a ideia do operador *pipe* `%>%`: passar a saída de uma função para outra função como a entrada dessa função por meio de uma seqüência de etapas. O operador `%>%` está disponível no <img src="images/logo_r.png" width="20"> através do pacote [magrittr](https://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html).



Os pacotes **tidyverse** integram-se muito bem com o `%>%`, por isso ele é automaticamente carregado com o **tidyverse**. Vamos ilustrar as vantagens de uso do %>% com exemplos a seguir.

#### Vantagens do %>%

O exemplo a baixo mostra uma aplicação simples do `%>%` para extrair a raiz quadrada de um número com a função `base::sqrt()`e a extração do segundo elemento de um vetor com a função `dplyr::nth()` (uma função alternativa aos colchetes `[]`).


```r
# chamada tradicional de uma função 
sqrt(4)
#> [1] 2
nth(5:1, 2)
#> [1] 4
# chamada de uma função com %>%
4 %>% sqrt()
#> [1] 2
5:1 %>% nth(2)
#> [1] 4
```

Ambas formas realizam a mesma tarefa e com mesmo resultado e o benefício do `%>%` não fica evidente. Entretanto, quando precisamos aplicar várias funções as vantagens ficam mais óbvias.

No código abaixo tente decifrar o objetivo das operações no vetor x.


```r
x <- c(1, 3, -1, 1, 4, 2, 2, -3)
x
#> [1]  1  3 -1  1  4  2  2 -3
nth(sort(cos(unique(x)), decreasing = TRUE), n = 2)
#> [1] 0.5403023
```

Talvez com o código identado fique mais claro:


```r
nth(            # 4
  sort(         # 3
    cos(        # 2
      unique(x) # 1
    ),
    decreasing = TRUE
  ),n =  2
)
```

O código acima está aninhando funções e isso leva a uma dificuldade de ler por causa da desordem. Para interpretá-lo precisamos fazer a leitura de dentro para fora:

1. mantém somente os valores únicos de x
2. calcula o cosseno do resultado de (1)
3. coloca em ordem decrescente o resultado de (2)
4. extrai o 2° elemento do resultado de (3)

Conclusão: o objetivo era obter o segundo maior número resultante do cosseno do vetor numérico x.

A versão usando pipe é:


```r
x %>%
  unique() %>%                # 1
  cos() %>%                   # 2
  sort(decreasing = TRUE) %>% # 3
  nth(n = 2)                      # 4
#> [1] 0.5403023
```

Dessa forma, o código fica mais simples, legível e explícito. Por isso, daqui para frente, nós utilizaremos extensivamente o operador `%>%` para ilustrar os verbos do **dplyr** e suas combinações.


<div class="rmdtip">
<p>No exemplo anterior nós introduzimos a função <code>dplyr::nth()</code>. Ela é equivalente ao operador colchetes <code>[</code> da base do R. Se <code>a &lt;- 5:1</code> então as instruções abaixo produzem resultados equivalentes:</p>
<p><code>a[2]; nth(a, 2)</code></p>
<p><code>#&gt; [1] 4</code> <code>#&gt; [1] 4</code></p>
</div>

#### O operador `.` como argumento

Uma representação mais explícita do código usado na cadeia de funções acima, seria com a inclusão do operador `.` e os nomes dos argumentos das funções:



```r
x %>%
  unique(x = .) %>%                  # 1
  sort(x = ., decreasing = TRUE) %>% # 2
  cos(x = .) %>%                     # 3
  nth(x = ., n = 2)                  # 4
#> [1] -0.9899925
```

O tempo a mais digitando é compensado posteriormente quando o você mesmo futuramente tiver que reler o código. Essa forma enfatiza com o `.` que o resultado à esquerda é usado como entrada para função à direita do `%>%`.

Mas nem todas funções do <img src="images/logo_r.png" width="20"> foram construídas com os dados de entrada no primeiro argumento. Essa é a deixa para outra funcionalidade do `.` que é redirecionar os dados de entrada para a posição adequada naquelas funções. Uma função que se encaixa neste caso é a `base::grep()` que detecta uma expressão regular num conjunto de caracteres (*strings*). 


```r
adverbs <- c("ontem", "hoje", "amanhã")
grep(
  pattern = "h",
  x = adverbs,
  value = TRUE
)
#> [1] "hoje"   "amanhã"
```

O código acima seve para retornar os elementos do vetor `dias` que contenham a letra `h`. No entanto os dados de entrada da `base::grep()` são esperados no 2° argumento (`x`). Para redirecioná-los para essa posição dentro de uma cadeia de funções com `%>%`, colocamos o operador `.` no 2° argumento da função:


```r
adverbs %>%
  grep(
  pattern = "h",
  x = .,
  value = TRUE
)
#> [1] "hoje"   "amanhã"
```





### Seleção de variáveis 

<img src="images/dplyr-select.png" width="20%" height="20%" style="display: block; margin: auto;" />

Para selecionar somente variáveis de interesse em uma tabela de dados podemos usar a função `dplyr::select(.data, ...)`. Nos dados `clima_rs_tbl` se desejamos selecionar apenas as colunas `estacao` e `tmax` aplicamos a `dplyr::select()` com o 2° argumento listando as colunas que desejamos selecionar:


```r
select(clima_rs_tbl, estacao, tmax)
#> # A tibble: 23 x 2
#>    estacao              tmax
#>  * <chr>               <dbl>
#>  1 Alegrete             25.4
#>  2 Bagé                 24.1
#>  3 Bento Gonçalves      23  
#>  4 Bom Jesus            20.3
#>  5 Cachoeira do Sul     25.1
#>  6 Caxias do Sul        21.8
#>  7 Cruz Alta            24.5
#>  8 Encruzilhada do Sul  22.5
#>  9 Guaporé              24.7
#> 10 Iraí                 27.1
#> # ... with 13 more rows
```

O resultado é um subconjunto dos dados originais contendo apenas as colunas nomeadas nos argumentos seguintes aos dados de entrada.

A função `dplyr::select()` possui funções auxiliares para seleção de variáveis:


```r
clima_rs_tbl %>%
  # as variáveis entre uf e tmax
  select(., uf:tmax) %>%
  head(., n = 3)
#> # A tibble: 3 x 3
#>   uf     prec  tmax
#>   <chr> <dbl> <dbl>
#> 1 RS    1492.  25.4
#> 2 RS    1300.  24.1
#> 3 RS    1684.  23

clima_rs_tbl %>%
  # todas variáveis menos as entre codigo:uf
  select(., -(codigo:uf)) %>%
  head(., n = 3)
#> # A tibble: 3 x 2
#>    prec  tmax
#>   <dbl> <dbl>
#> 1 1492.  25.4
#> 2 1300.  24.1
#> 3 1684.  23

clima_rs_tbl %>%
  # ordem inversa das variáveis
  select(., tmax:codigo) %>%
  head(., n = 3)
#> # A tibble: 3 x 5
#>    tmax  prec uf    estacao         codigo
#>   <dbl> <dbl> <chr> <chr>           <chr> 
#> 1  25.4 1492. RS    Alegrete        83931 
#> 2  24.1 1300. RS    Bagé            83980 
#> 3  23   1684. RS    Bento Gonçalves 83941

clima_rs_tbl %>%
  # nomes que contenham a letra "a"
  select(., contains("a")) %>%
  head(n = 3)
#> # A tibble: 3 x 2
#>   estacao          tmax
#>   <chr>           <dbl>
#> 1 Alegrete         25.4
#> 2 Bagé             24.1
#> 3 Bento Gonçalves  23

clima_rs_tbl %>%
  # variáveis que iniciam com "c"
  select(., starts_with("c")) %>%
  head(., n = 3)
#> # A tibble: 3 x 1
#>   codigo
#>   <chr> 
#> 1 83931 
#> 2 83980 
#> 3 83941

clima_rs_tbl %>%
  # usando um vetor de caracteres
  select(., one_of(c("estacao", "uf"))) %>%
  head(., n = 3)
#> # A tibble: 3 x 2
#>   estacao         uf   
#>   <chr>           <chr>
#> 1 Alegrete        RS   
#> 2 Bagé            RS   
#> 3 Bento Gonçalves RS

clima_rs_tbl %>%
  # combinações
  select(., -uf, ends_with("o")) %>%
  head(., n = 3)
#> # A tibble: 3 x 4
#>   codigo estacao          prec  tmax
#>   <chr>  <chr>           <dbl> <dbl>
#> 1 83931  Alegrete        1492.  25.4
#> 2 83980  Bagé            1300.  24.1
#> 3 83941  Bento Gonçalves 1684.  23

clima_rs_tbl %>%
  # variáveis que inciam com letras minúsculas e com 4 caracteres
  select(., matches("^[a-z]{4}$")) %>%
  head(., n = 3)
#> # A tibble: 3 x 2
#>    prec  tmax
#>   <dbl> <dbl>
#> 1 1492.  25.4
#> 2 1300.  24.1
#> 3 1684.  23
```

O último exemplo usa uma expressão regular ([regex](https://pt.wikipedia.org/wiki/Express%C3%A3o_regular)). *Regex* é uma linguagem para descrever e manipular caracteres de texto. Há [livros sobre este assunto](http://aurelio.net/regex/guia/) e diversos [tutorias](https://stringr.tidyverse.org/articles/regular-expressions.html) sobre *regex* no R. Para saber mais sobre isso veja  o capítulo sobre [strings](http://r4ds.had.co.nz/strings.html) do livro de @Wickham2017. Conhecendo o básico, você poupará tempo automatizando a formatação de caracteres de texto.

Veja mais funções úteis para seleção de variáveis em `?dplyr::select`. 

### Seleção de observações

<img src="images/dplyr-filter.png" width="20%" height="20%" style="display: block; margin: auto;" />

A filtragem de observações geralmente envolve uma expressão que retorna valores lógicos ou as posições das linhas selecionadas (como a função `which()`).

A função `dplyr::filter()` permite filtrar observações de um *data frame* correspondentes a alguns critérios lógicos. Estes critérios podem ser passados um de cada vez ou com um operador lógico (e: `&`, ou: `|`). Veja abaixo alguns exemplos de filtragem de observações: 

- linhas correspondentes ao `codigo` da estação 83936.


```r
clima_rs_tbl %>%
  filter(codigo == 83936)
#> # A tibble: 1 x 5
#>   codigo estacao     uf     prec  tmax
#>   <chr>  <chr>       <chr> <dbl> <dbl>
#> 1 83936  Santa Maria RS    1617.  24.9
```

- linhas da variável `estacao` que contenham o vetor caractere `litoraneas`.

```r
litoraneas <- c("Torres", 
                "Guaporé")
clima_rs_tbl %>%
  filter(estacao %in% litoraneas)
#> # A tibble: 2 x 5
#>   codigo estacao uf     prec  tmax
#>   <chr>  <chr>   <chr> <dbl> <dbl>
#> 1 83915  Guaporé RS    1759.  24.7
#> 2 83948  Torres  RS    1363.  22.3
```

- observações com `tmax` acima de 10% da média


```r
filter(clima_rs_tbl,  tmax > 1.1*mean(tmax))
#> # A tibble: 1 x 5
#>   codigo estacao uf     prec  tmax
#>   <chr>  <chr>   <chr> <dbl> <dbl>
#> 1 83881  Iraí    RS    1807.  27.1
```

- observações com `tmax` e `prec` acima de suas médias


```r
clima_rs_tbl %>%
filter(
  tmax > mean(tmax),  
  prec > mean(prec)
)
#> # A tibble: 7 x 5
#>   codigo estacao              uf     prec  tmax
#>   <chr>  <chr>                <chr> <dbl> <dbl>
#> 1 83912  Cruz Alta            RS    1631.  24.5
#> 2 83915  Guaporé              RS    1759.  24.7
#> 3 83881  Iraí                 RS    1807.  27.1
#> 4 83880  Palmeira das Missões RS    1748.  24  
#> 5 83936  Santa Maria          RS    1617.  24.9
#> 6 83907  São Luiz Gonzaga     RS    1771.  26.1
#> 7 83927  Uruguaiana           RS    1647.  25.8
# equivalente a
#clima_rs %>% 
#  filter(tmax > mean(tmax) & prec > mean(prec))
```
- observações cuja variável `estacao` tem a palavra \"Sul\" 


```r
# estações com "Sul" no nome
clima_rs_tbl %>% 
  filter(str_detect(estacao, "Sul"))
#> # A tibble: 3 x 5
#>   codigo estacao             uf     prec  tmax
#>   <chr>  <chr>               <chr> <dbl> <dbl>
#> 1 83963  Cachoeira do Sul    RS    1477.  25.1
#> 2 83942  Caxias do Sul       RS    1823   21.8
#> 3 83964  Encruzilhada do Sul RS    1511.  22.5
```


<div class="rmdtip">
<p>O exemplo acima é mais uma operação com caracteres onde foi usada a função <code>stringr::str_detect()</code> para detectar os elementos da variável do tipo caractere que contenham o termo &quot;Sul&quot;. O pacote <strong>stringr</strong> <span class="citation">[@Wickham-stringr]</span> fornece funções para casar padrões de caracteres de texto e os nomes das funções são fáceis de lembrar. Todos começam com <code>str_</code> (de string) seguido do verbo, p.ex.:</p>
<p><code>str_replace_all(</code></p>
<p><code>string = c(&quot;abc&quot;, &quot;lca&quot;),</code></p>
<p><code>pattern = &quot;a&quot;,</code></p>
<p><code>replacement =  &quot;A&quot;</code></p>
<p><code>)</code></p>
<p><code>#&gt; [1] &quot;Abc&quot; &quot;lcA&quot;</code></p>
</div>


A seleção de observações também pode ser baseada em índices passados para função `dplyr::slice()` que retorna o subconjunto de observações correspondentes. Abaixo vejamos alguns exemplos de filtragem de linhas baseada em índices ou posições:


```r
#linhas 2 e 4 
clima_rs_tbl %>%
  slice(., c(2,4))
#> # A tibble: 2 x 5
#>   codigo estacao   uf     prec  tmax
#>   <chr>  <chr>     <chr> <dbl> <dbl>
#> 1 83980  Bagé      RS    1300.  24.1
#> 2 83919  Bom Jesus RS    1807.  20.3
#última linha
clima_rs_tbl %>%
  slice(., n())
#> # A tibble: 1 x 5
#>   codigo estacao    uf     prec  tmax
#>   <chr>  <chr>      <chr> <dbl> <dbl>
#> 1 83927  Uruguaiana RS    1647.  25.8
# exlui da última à 3a linha
clima_rs_tbl %>%
  slice(., -(n():3))
#> # A tibble: 2 x 5
#>   codigo estacao  uf     prec  tmax
#>   <chr>  <chr>    <chr> <dbl> <dbl>
#> 1 83931  Alegrete RS    1492.  25.4
#> 2 83980  Bagé     RS    1300.  24.1
# linhas com tmax > 26
clima_rs_tbl %>%
  slice(., which(tmax > 26))
#> # A tibble: 3 x 5
#>   codigo estacao          uf     prec  tmax
#>   <chr>  <chr>            <chr> <dbl> <dbl>
#> 1 83881  Iraí             RS    1807.  27.1
#> 2 83929  Itaqui           RS    1369.  26.2
#> 3 83907  São Luiz Gonzaga RS    1771.  26.1
# linhas com tmax mais próxima a média de tmax
clima_rs_tbl %>%
  slice(., which.min(abs(tmax - mean(tmax))))
#> # A tibble: 1 x 5
#>   codigo estacao              uf     prec  tmax
#>   <chr>  <chr>                <chr> <dbl> <dbl>
#> 1 83880  Palmeira das Missões RS    1748.    24
```


### Reordenando dados

<img src="images/dplyr-arrange.png" width="20%" height="20%" style="display: block; margin: auto;" />

As vezes é útil reordenar os dados segundo a ordem (crescente ou decrescente) dos valores de uma variável. Por exemplo, os dados `clima_rs_tbl` podem ser arranjados em ordem decrescente da precipitação anual, conforme abaixo.


```r
clima_rs_tbl %>% 
  arrange(., desc(prec)) %>%
  head(., n = 3)
#> # A tibble: 3 x 5
#>   codigo estacao       uf     prec  tmax
#>   <chr>  <chr>         <chr> <dbl> <dbl>
#> 1 83942  Caxias do Sul RS    1823   21.8
#> 2 83919  Bom Jesus     RS    1807.  20.3
#> 3 83881  Iraí          RS    1807.  27.1
```

A função `dplyr::arrange()` por padrão ordena os dados em ordem crescente. A função `dplyr::desc()` ordena os valores da variável em ordem descendente. 

Os dados ordenados pela `tmax`, ficam da seguinte forma:


```r
clima_rs_tbl %>% 
  arrange(., tmax) %>%
  head(., n = 3)
#> # A tibble: 3 x 5
#>   codigo estacao       uf     prec  tmax
#>   <chr>  <chr>         <chr> <dbl> <dbl>
#> 1 83919  Bom Jesus     RS    1807.  20.3
#> 2 83995  Rio Grande    RS    1234.  21.7
#> 3 83942  Caxias do Sul RS    1823   21.8
```



### Criando e renomeando variáveis

<img src="images/dplyr-mutate-rename.png" width="50%" height="55%" style="display: block; margin: auto;" />


Uma nova variável pode ser adicionada aos dados através da função `dplyr::mutate()`. A `tmax` expressa em Kelvin pode ser adicionada aos dados `clima_rs_tbl`, com:



```r
clima_rs_tbl %>%
  # tmax em Kelvin
  mutate(., tmaxK = tmax + 273.15) %>%
  # só as colunas de interesse
  select(., contains("tmax")) %>%
  # 3 primeiras linhas
  head(., n = 3)
#> # A tibble: 3 x 2
#>    tmax tmaxK
#>   <dbl> <dbl>
#> 1  25.4  299.
#> 2  24.1  297.
#> 3  23    296.
```


Podemos renomear variáveis com a função `dplyr::rename()`.


```r
clima_rs_tbl %>%
rename(., 
       "id" = codigo,
       "site" = estacao,
       "temp_max" = tmax,
       "precip" = prec
       ) %>%
  head(., n = 3)
#> # A tibble: 3 x 5
#>   id    site            uf    precip temp_max
#>   <chr> <chr>           <chr>  <dbl>    <dbl>
#> 1 83931 Alegrete        RS     1492.     25.4
#> 2 83980 Bagé            RS     1300.     24.1
#> 3 83941 Bento Gonçalves RS     1684.     23
```

Podemos sobrescrever variáveis e recodificar seus valores, conforme o exemplo abaixo. A variável `site` será corrigida, de forma os valores iguais a "A803" sejam substituídos por "A003".


```r
prec_anual_corr <- prec_anual %>%
mutate(
  site = recode(site, A803 = "A003")
) 
tail(prec_anual_corr, n = 4)
#>   site  ano prec
#> 5 A002 2002 1630
#> 6 A003 2004 1300
#> 7 A003 2005 1950
#> 8 A003 2006 1100
```


Podemos preencher os valores faltantes de uma variável por um valor prescrito, por exemplo baseado na média de outras observações, ou nos valores prévios, ou posteriores. Variáveis podem ser derivadas das variáveis sendo criadas dentro da `dplyr::mutate()`. 



```r
# preenchendo prec faltante pela média
prec_anual_comp %>%
  mutate(., 
         prec = replace_na(prec,
                           mean(prec, na.rm = TRUE)
                           ),
         ndias = ifelse(ano %% 4 == 0, 
                      366, 
                      365),
         # intensidade de ndias, criada na linha acima
         intensidade = prec / ndias
         )
#> # A tibble: 24 x 5
#>    site    ano  prec ndias intensidade
#>    <fct> <dbl> <dbl> <dbl>       <dbl>
#>  1 A001   2000  1800   366        4.92
#>  2 A001   2001  1400   365        3.84
#>  3 A001   2002  1550   365        4.25
#>  4 A001   2004  1550   366        4.23
#>  5 A001   2005  1550   365        4.25
#>  6 A001   2006  1550   365        4.25
#>  7 A002   2000  1750   366        4.78
#>  8 A002   2001  1470   365        4.03
#>  9 A002   2002  1630   365        4.47
#> 10 A002   2004  1550   366        4.23
#> # ... with 14 more rows

prec_anual_comp %>%
  # preenche com  a observação prévia
  fill(prec, .direction = "down")
#> # A tibble: 24 x 3
#>    site    ano  prec
#>    <fct> <dbl> <dbl>
#>  1 A001   2000  1800
#>  2 A001   2001  1400
#>  3 A001   2002  1400
#>  4 A001   2004  1400
#>  5 A001   2005  1400
#>  6 A001   2006  1400
#>  7 A002   2000  1750
#>  8 A002   2001  1470
#>  9 A002   2002  1630
#> 10 A002   2004  1630
#> # ... with 14 more rows

prec_anual_comp %>%
  # preenche com  a observação posterior
  fill(prec, .direction = "up")
#> # A tibble: 24 x 3
#>    site    ano  prec
#>    <fct> <dbl> <dbl>
#>  1 A001   2000  1800
#>  2 A001   2001  1400
#>  3 A001   2002  1750
#>  4 A001   2004  1750
#>  5 A001   2005  1750
#>  6 A001   2006  1750
#>  7 A002   2000  1750
#>  8 A002   2001  1470
#>  9 A002   2002  1630
#> 10 A002   2004  1300
#> # ... with 14 more rows
```



### Agregando observações

<img src="images/dplyr-summarise-count.png" width="40%" height="50%" style="display: block; margin: auto;" />

A função `dplyr::summarise()` (ou `dplyr::sumarize()`) agrega valores de uma variável e os fornece para uma função que retorna um único resultado. O resultado será armazenado em um `data frame`.

Por exemplo, qual a `prec`  média anual do RS?


```r
clima_rs_tbl %>%
  summarise(
    .,
    prec_med = mean(prec)
  )
#> # A tibble: 1 x 1
#>   prec_med
#>      <dbl>
#> 1    1554.
```

Se você só quer o valor (ou o vetor), ao invés de um `data frame`, pode usar a função `dplyr::pull()`:


```r
clima_rs_tbl %>%
  summarise(
    .,
    prec_med = mean(prec)
  ) %>%
  pull()
#> [1] 1554.183
```


Podemos aplicar uma ou mais funções a mais de uma variável usando `dplyr::summarise_at()`:


```r
clima_rs_tbl %>%
  summarise_at(
    .,
    .vars = vars(prec, tmax),
    .funs = funs(min, median, max),
    na.rm = TRUE
  )
#> # A tibble: 1 x 6
#>   prec_min tmax_min prec_median tmax_median prec_max tmax_max
#>      <dbl>    <dbl>       <dbl>       <dbl>    <dbl>    <dbl>
#> 1    1229.     20.3       1617.        24.1     1823     27.1
```


Observações repetidas devem ser removidas dos dados antes de qualquer cálculo. Suponha os dados abaixo:


```r
prec_anual_comp_rep <-
  prec_anual_comp %>%
  mutate(
    site = recode(site, A803 = "A003"),
    ano = NULL
  ) %>%
  # preenche com  a observação posterior
  fill(., prec, .direction = "up")
prec_anual_comp_rep
#> # A tibble: 24 x 2
#>    site   prec
#>    <fct> <dbl>
#>  1 A001   1800
#>  2 A001   1400
#>  3 A001   1750
#>  4 A001   1750
#>  5 A001   1750
#>  6 A001   1750
#>  7 A002   1750
#>  8 A002   1470
#>  9 A002   1630
#> 10 A002   1300
#> # ... with 14 more rows
```

Para desconsiderar linhas duplicadas nos dados usamos a função `dplyr::distinct()`:


```r
# remove observações repetidas
prec_anual_comp_rep %>%
  distinct(site, prec)
#> # A tibble: 10 x 2
#>    site   prec
#>    <fct> <dbl>
#>  1 A001   1800
#>  2 A001   1400
#>  3 A001   1750
#>  4 A002   1750
#>  5 A002   1470
#>  6 A002   1630
#>  7 A002   1300
#>  8 A003   1300
#>  9 A003   1950
#> 10 A003   1100
```


A função `dplyr::count()` é útil para obter a frequência de ocorrência de uma variável ou da combinação de variáveis. 


```r
prec_anual_comp_rep %>%
  count(site)
#> # A tibble: 3 x 2
#>   site      n
#>   <fct> <int>
#> 1 A001      6
#> 2 A002      6
#> 3 A003     12
prec_anual_comp_rep %>%
  count(site, prec)
#> # A tibble: 10 x 3
#>    site   prec     n
#>    <fct> <dbl> <int>
#>  1 A001   1400     1
#>  2 A001   1750     4
#>  3 A001   1800     1
#>  4 A002   1300     3
#>  5 A002   1470     1
#>  6 A002   1630     1
#>  7 A002   1750     1
#>  8 A003   1100     1
#>  9 A003   1300     4
#> 10 A003   1950     7
```



### Agrupando observações

<img src="images/dplyr-group-by-summarise.png" width="40%" height="50%" style="display: block; margin: auto;" />

Frequentemente temos que agrupar observações em categorias ou grupos para realizar uma análise estatística. A função 
`dplyr::group_by()` é uma função silenciosa que separa (invisivelmente) as observações em categorias ou grupos.
A única mudança ao aplicar a `dplyr::group_by()` à um *data frame* é a indicação da variável agrupada e o seu número de grupos na saída do console. No exemplo a seguir vamos agrupar os dados `prec_anual_tbl` por `site` e teremos 4 grupos para esta variável.


```r
prec_anual_tbl %>%
  group_by(site)
#> # A tibble: 8 x 4
#> # Groups:   site [4]
#>   site    ano  prec intensidade
#>   <chr> <dbl> <dbl>       <dbl>
#> 1 A001   2000  1800        4.93
#> 2 A001   2001  1400        3.83
#> 3 A002   2000  1750        4.79
#> 4 A002   2001  1470        4.02
#> 5 A002   2002  1630        4.46
#> 6 A003   2004  1300        3.56
#> 7 A803   2005  1950        5.34
#> 8 A803   2006  1100        3.01
```




A grande funcionalidade da `dplyr::group_by()` surge quando combinada com a função `dplyr::summarise()`, o que nos permite obter resumos estatísticos para cada grupo da variável. 

Por exemplo a chuva anual média por `site` é obtida com o seguinte código:


```r
prec_anual_tbl %>%
  group_by(., site) %>%
  summarise(., prec_med = mean(prec))
#> # A tibble: 4 x 2
#>   site  prec_med
#>   <chr>    <dbl>
#> 1 A001     1600 
#> 2 A002     1617.
#> 3 A003     1300 
#> 4 A803     1525
```

A `prec` média para cada ano e o número de anos utilizados em seu cálculo é obtida por: 


```r
prec_anual_tbl %>%
  group_by(., ano) %>%
  summarise(
    .,
    prec_med = mean(prec),
    nobs = n()
  )
#> # A tibble: 6 x 3
#>     ano prec_med  nobs
#>   <dbl>    <dbl> <int>
#> 1  2000     1775     2
#> 2  2001     1435     2
#> 3  2002     1630     1
#> 4  2004     1300     1
#> 5  2005     1950     1
#> 6  2006     1100     1
```

A função `n()` conta quantas observações temos em um subconjunto dos dados.

Os grupos podem ser compostos de mais de uma variável. Para o exemplo com os dados `prec_anual_long`;


```r
prec_anual_long
#> # A tibble: 16 x 4
#>    site    ano variavel     medida
#>    <chr> <dbl> <chr>         <dbl>
#>  1 A001   2000 prec        1800   
#>  2 A001   2001 prec        1400   
#>  3 A002   2000 prec        1750   
#>  4 A002   2001 prec        1470   
#>  5 A002   2002 prec        1630   
#>  6 A003   2004 prec        1300   
#>  7 A803   2005 prec        1950   
#>  8 A803   2006 prec        1100   
#>  9 A001   2000 intensidade    4.93
#> 10 A001   2001 intensidade    3.83
#> 11 A002   2000 intensidade    4.79
#> 12 A002   2001 intensidade    4.02
#> 13 A002   2002 intensidade    4.46
#> 14 A003   2004 intensidade    3.56
#> 15 A803   2005 intensidade    5.34
#> 16 A803   2006 intensidade    3.01
```

podemos obter a média por `variavel` e `site`, fazendo:


```r
estats_por_site_var <- prec_anual_long %>%
  group_by(site, variavel) %>%
  summarise(
    media = mean(medida, na.rm = TRUE)
  ) %>%
  arrange(variavel, site)
estats_por_site_var
#> # A tibble: 8 x 3
#> # Groups:   site [4]
#>   site  variavel      media
#>   <chr> <chr>         <dbl>
#> 1 A001  intensidade    4.38
#> 2 A002  intensidade    4.43
#> 3 A003  intensidade    3.56
#> 4 A803  intensidade    4.18
#> 5 A001  prec        1600   
#> 6 A002  prec        1617.  
#> 7 A003  prec        1300   
#> 8 A803  prec        1525
```

Com o conjunto de verbos exemplificados você agora é capaz de realizar as tarefas mais comuns de manipulação de dados tabulares de forma clara e confiável.

Há mais funções úteis disponíveis no pacote **dplyr** e você é encorajado a descubrí-las. 




### Combinação de dados 

O processamento de dados frequentemente envolve a manipulação de diversas tabelas de dados. Ás vezes precisamos juntar dados de diferentes fontes, formar uma tabela única de dados com o período em comum à elas, ou combiná-las para compará-las.

A combinação de 2 *data frames*, com observações similares, que tem variáveis diferentes e algumas em comum é uma tarefa muito comum na manipulação de conjuntos dados. Este tipo de operação é chamada de **junção** (do termo em inglês *join*) de tabelas . O pacote **dplyr** possui uma gama de funções do tipo *join* para combinar *data frames*, genericamente representadas por `<tipo>_join()`, onde `<tipo>` pode ser substituído por `dplyr::full_join()`, `dplyr::inner_join()`, `dplyr::left_join()`, `dplyr::right_join()`.

Essas funções combinam informação em dois data frames baseada na unificação de valores entre as variáveis que ambos compartilham. 

Vamos considerar os dados `clima_rs_tbl` e `metadados_rs`. Para melhor compreensão do exemplo vamos remover algumas variáveis.


```r
# normais climatológicas das estaçõess
clima_rs_tbl <- clima_rs_tbl %>%
  select(-(estacao:uf))
head(clima_rs_tbl)
#> # A tibble: 6 x 3
#>   codigo  prec  tmax
#>   <chr>  <dbl> <dbl>
#> 1 83931  1492.  25.4
#> 2 83980  1300.  24.1
#> 3 83941  1684.  23  
#> 4 83919  1807.  20.3
#> 5 83963  1477.  25.1
#> 6 83942  1823   21.8
# metadados das estações convertidos para tibble
metadados_rs <- metadados_rs %>% 
  as_tibble()
head(metadados_rs)
#> # A tibble: 6 x 4
#>   codigo   lon   lat    alt
#>   <chr>  <dbl> <dbl>  <dbl>
#> 1 83931  -55.5 -29.7  121. 
#> 2 83980  -54.1 -31.3  242. 
#> 3 83941  -51.5 -29.2  640  
#> 4 83919  -50.4 -28.7 1048. 
#> 5 83959  -53.5 -30.5  450  
#> 6 83963  -52.9 -30.0   72.7
```

A variável comum às duas tabelas é:


```r
var_comum <- names(clima_rs_tbl) %in% names(metadados_rs)
names(clima_rs_tbl)[var_comum]
#> [1] "codigo"
```

Vamos comparar os valores da variável `codigo` em cada tabela de dados para verificar se todos valores contidos em uma tabela também estão presentes na outra e vice-versa. 

Para saber se algum valor da variável `codigo` da tabela `clima_rs_tbl` não está contido na tabela `metadados_rs` podemos usar o seguinte código:


```r
# algum codigo não está presente na tabela metadados_rs
clima_rs_tbl %>%
  filter(., ! codigo %in% metadados_rs$codigo ) %>%
  select(., codigo)
#> # A tibble: 0 x 1
#> # ... with 1 variable: codigo <chr>
```

Não há nenhum caso.

Analogamente, vamos verificar se algum valor da variável `codigo` dos `metadados_rs` não está contido em `clima_rs_tbl`.


```r
# algum codigo não está presente na tabela metadados_rs
metadados_rs %>%
  filter(., ! codigo %in% clima_rs_tbl$codigo )%>%
  select(., codigo)
#> # A tibble: 7 x 1
#>   codigo
#>   <chr> 
#> 1 83959 
#> 2 83885 
#> 3 83985 
#> 4 83983 
#> 5 83953 
#> 6 83909 
#> 7 83918
```




Obtemos que 7 valores da variável `codigo` dos `metadados_rs` que não estão presentes na tabela `clima_rs_tbl`. Portanto, não há valores de `tmax` e `prec` para essas observações.


Suponha agora que desejássemos visualizar a variação espacial da precipitação (`prec`) ou da temperatura máxima do ar (`tmax`) climatológica. Precisaríamos além dessas variáveis, as coordenadas geográficas das estações meteorológicas para plotar sua localização espacial. As coordenadas `lon` e `lat` da `metadados_rs` podem ser combinadas com `clima_rs_tbl` em uma nova tabela (`clima_rs_comb`), usando a função `dplyr::full_join()`:


```r
clima_rs_comb <- full_join(
  x = clima_rs_tbl, 
  y = metadados_rs,
  by = "codigo")
clima_rs_comb
```


codigo      prec   tmax         lon         lat       alt
-------  -------  -----  ----------  ----------  --------
83931     1492.2   25.4   -55.51667   -29.68333    120.91
83980     1299.9   24.1   -54.10000   -31.33333    242.31
83941     1683.7   23.0   -51.51667   -29.15000    640.00
83919     1807.3   20.3   -50.43333   -28.66667   1047.50
83963     1477.1   25.1   -52.88333   -30.03333     72.71
83942     1823.0   21.8   -51.20000   -29.16667    759.60
83912     1630.7   24.5   -53.60000   -28.63333    472.50
83964     1510.8   22.5   -52.51667   -30.53333    427.75
83915     1758.7   24.7   -51.90000   -28.91667    471.51
83881     1806.7   27.1   -53.23333   -27.18333    247.10
83929     1369.4   26.2   -56.53333   -29.11667     76.00
83916     1691.1   23.0   -51.50000   -28.21667    840.00
83880     1747.8   24.0   -53.43333   -27.88333    634.00
83914     1803.1   23.6   -52.40000   -28.21667    684.05
83967     1320.2   24.8   -51.16667   -30.05000     46.97
83995     1233.6   21.7   -52.10000   -32.03333      2.46
83936     1616.8   24.9   -53.70000   -29.70000     95.00
83997     1228.9   21.8   -53.35000   -33.51667     24.01
83957     1313.9   25.0   -54.31667   -30.33333    124.00
83907     1770.9   26.1   -55.01667   -28.40000    245.11
83966     1349.8   23.8   -51.58333   -30.83333      5.00
83948     1363.2   22.3   -49.71667   -29.35000      4.66
83927     1647.4   25.8   -57.08333   -29.75000     62.31
83959         NA     NA   -53.48333   -30.51667    450.00
83885         NA     NA   -51.90000   -27.45000    414.17
83985         NA     NA   -52.41667   -31.78333     13.00
83983         NA     NA   -53.10000   -31.43333    345.00
83953         NA     NA   -55.60000   -30.83333    328.00
83909         NA     NA   -54.25000   -28.30000    284.50
83918         NA     NA   -50.70000   -28.55000    954.60


Da inspeção das últimas linhas de `clima_rs_comb` verificamos que o resultado é uma tabela que contém todos valores da variável `codigo` das duas tabelas. Os valores das variáveis `prec` e `tmax`, para as observações da variável `codigo` sem valores ( na `metadados_rs`) são preenchidos com `NA`.

Se a combinação de interesse for nas observações em comum entre as tabelas, usaríamos:


```r
clima_rs_intersec <- inner_join(
  x = metadados_rs, 
  y = clima_rs_tbl,
  by = "codigo"
)
clima_rs_intersec
```


codigo          lon         lat       alt     prec   tmax
-------  ----------  ----------  --------  -------  -----
83931     -55.51667   -29.68333    120.91   1492.2   25.4
83980     -54.10000   -31.33333    242.31   1299.9   24.1
83941     -51.51667   -29.15000    640.00   1683.7   23.0
83919     -50.43333   -28.66667   1047.50   1807.3   20.3
83963     -52.88333   -30.03333     72.71   1477.1   25.1
83942     -51.20000   -29.16667    759.60   1823.0   21.8
83912     -53.60000   -28.63333    472.50   1630.7   24.5
83964     -52.51667   -30.53333    427.75   1510.8   22.5
83915     -51.90000   -28.91667    471.51   1758.7   24.7
83881     -53.23333   -27.18333    247.10   1806.7   27.1
83929     -56.53333   -29.11667     76.00   1369.4   26.2
83916     -51.50000   -28.21667    840.00   1691.1   23.0
83880     -53.43333   -27.88333    634.00   1747.8   24.0
83914     -52.40000   -28.21667    684.05   1803.1   23.6
83967     -51.16667   -30.05000     46.97   1320.2   24.8
83995     -52.10000   -32.03333      2.46   1233.6   21.7
83936     -53.70000   -29.70000     95.00   1616.8   24.9
83997     -53.35000   -33.51667     24.01   1228.9   21.8
83957     -54.31667   -30.33333    124.00   1313.9   25.0
83907     -55.01667   -28.40000    245.11   1770.9   26.1
83966     -51.58333   -30.83333      5.00   1349.8   23.8
83948     -49.71667   -29.35000      4.66   1363.2   22.3
83927     -57.08333   -29.75000     62.31   1647.4   25.8

Para obter uma tabela com as observações diferentes entre as duas tabelas, usamos:


```r
clima_rs_disj <- anti_join(
  x = metadados_rs, 
  y = clima_rs_tbl,
  by = "codigo"
)
clima_rs_disj
```


codigo          lon         lat      alt
-------  ----------  ----------  -------
83959     -53.48333   -30.51667   450.00
83885     -51.90000   -27.45000   414.17
83985     -52.41667   -31.78333    13.00
83983     -53.10000   -31.43333   345.00
83953     -55.60000   -30.83333   328.00
83909     -54.25000   -28.30000   284.50
83918     -50.70000   -28.55000   954.60

O exemplo abaixo demonstram os resultados das funções `dplyr::left_join()` e `dplyr::right_join()` para um versão reduzida dos dados `clima_rs_tbl`.


```r
clima_rs_tbl_mini <- clima_rs_tbl %>%
  slice(., 1:3) 
clima_rs_tbl_mini
#> # A tibble: 3 x 3
#>   codigo  prec  tmax
#>   <chr>  <dbl> <dbl>
#> 1 83931  1492.  25.4
#> 2 83980  1300.  24.1
#> 3 83941  1684.  23
# combina os dados baseado nas observações dos dados à esquerda (x)
left_join(
  x = clima_rs_tbl_mini, 
  y =metadados_rs, 
  by = "codigo"
)
#> # A tibble: 3 x 6
#>   codigo  prec  tmax   lon   lat   alt
#>   <chr>  <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 83931  1492.  25.4 -55.5 -29.7  121.
#> 2 83980  1300.  24.1 -54.1 -31.3  242.
#> 3 83941  1684.  23   -51.5 -29.2  640
# combina os dados baseado nas observações dos dados à direita (y)
right_join(
  x = clima_rs_tbl_mini, 
  y = metadados_rs, 
  by = "codigo"
)
#> # A tibble: 30 x 6
#>    codigo  prec  tmax   lon   lat    alt
#>    <chr>  <dbl> <dbl> <dbl> <dbl>  <dbl>
#>  1 83931  1492.  25.4 -55.5 -29.7  121. 
#>  2 83980  1300.  24.1 -54.1 -31.3  242. 
#>  3 83941  1684.  23   -51.5 -29.2  640  
#>  4 83919    NA   NA   -50.4 -28.7 1048. 
#>  5 83959    NA   NA   -53.5 -30.5  450  
#>  6 83963    NA   NA   -52.9 -30.0   72.7
#>  7 83942    NA   NA   -51.2 -29.2  760. 
#>  8 83912    NA   NA   -53.6 -28.6  472. 
#>  9 83964    NA   NA   -52.5 -30.5  428. 
#> 10 83915    NA   NA   -51.9 -28.9  472. 
#> # ... with 20 more rows
```

## Exercícios

**Pacotes necessários**


```r
pcks <- c("rio", "tidyverse")
easypackages::libraries(pcks)
```

- - -

1. Converta os dados de anomalias padronizadas do índice de oscilação sul armazenados no *data frame* `soi` (dado abaixo) para o formato \"arrumado\" e em ordem cronológica. Os nomes das variáveis na tabela de dados arrumado deve estar sempre em letras minúsculas (Converta se for necessário usando a função `tolower(names(soi_arrumado))`).


```r
soi <- structure(list(
  YEAR = 1951:1953, 
  JAN = c(1.5, -0.9, 0.3), 
  FEB = c(0.9, -0.6, -0.5), 
  MAR = c(-0.1, 0.5, -0.2), 
  APR = c(-0.3, -0.2, 0.2), 
  MAY = c(-0.7, 0.8, -1.7), 
  JUN = c(0.2, 0.7, 0.1), 
  JUL = c(-1, 0.5, 0), 
  AUG = c(-0.2, 0.1, -1.2), 
  SEP = c(-1.1, -0.2, -1.2),
  OCT = c(-1, 0.4, 0.1), 
  NOV = c(-0.8, 0, -0.3), 
  DEC = c(-0.7, -1.2, -0.5)
), .Names = c(
  "YEAR", "1", "2", "3", "4",
  "5", "6", "7", "8", "9", 
  "10", "11", "12"
), row.names = c(
  NA,
  3L
), class = "data.frame")
soi
#>   YEAR    1    2    3    4    5   6    7    8    9   10   11   12
#> 1 1951  1.5  0.9 -0.1 -0.3 -0.7 0.2 -1.0 -0.2 -1.1 -1.0 -0.8 -0.7
#> 2 1952 -0.9 -0.6  0.5 -0.2  0.8 0.7  0.5  0.1 -0.2  0.4  0.0 -1.2
#> 3 1953  0.3 -0.5 -0.2  0.2 -1.7 0.1  0.0 -1.2 -1.2  0.1 -0.3 -0.5
```





A estrutura esperada dos dados arrumados é mostrada abaixo: 


```
#> Observations: 36
#> Variables: 3
#> $ year <int> 1951, 1951, 1951, 1951, 1951, 1951, 1951, 1951, 1951, 195...
#> $ mes  <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, ...
#> $ soi  <dbl> 1.5, 0.9, -0.1, -0.3, -0.7, 0.2, -1.0, -0.2, -1.1, -1.0, ...
```

- - -

2. Os dados de precipitação diária abaixo são uma pequena amostra dos dados usados na questão 4 da lista do Capítulo 8. Converta o *tibble* fornecido abaixo para o \"formato arrumado\". No data frame arrumado, transforme as datas obtidas (na classe de caractere) para classe *date* usando a função `as.Date()`.


```r
precd_ncdf <- structure(
  list(
    x = c(
      -60.625, -60.375, -60.125, -60.625, -60.375
    ),
    y = c(
      5.125, 5.125, 5.125, 4.875, 4.875
    ),
    X2010.01.01.13.00.00 = c(
      0, 0, 0, 0, 0
    ),
    X2010.01.02.13.00.00 = c(
      0, 0, 0, 0, 0
    ),
    X2010.01.03.13.00.00 = c(
      0, 0, 0, 0, 0
    ),
    X2010.01.04.13.00.00 = c(
      0.448486328125, 0.44091796875, 0.5791015625, 0.441162109375, 0.3916015625
    ),
    X2010.01.05.13.00.00 = c(
      2.3515625, 1.189453125, 2.013671875, 1.939453125, 0.42822265625
    ),
    X2010.01.06.13.00.00 = c(
      4.49609375, 1.7568359375, 4.58984375, 3.919921875, 0.9443359375
    ),
    X2010.01.07.13.00.00 = c(
      0.1661376953125, 0.51904296875, 0.1339111328125, 0.1488037109375, 0.46240234375
    ),
    X2010.01.08.13.00.00 = c(0, 0, 0, 0, 0)
  ),
  .Names = c(
    "x",
    "y",
    "X2010.01.01",
    "X2010.01.02",
    "X2010.01.03",
    "X2010.01.04",
    "X2010.01.05",
    "X2010.01.06",
    "X2010.01.07",
    "X2010.01.08"
  ),
  row.names = c(NA, -5L),
  class = c("tbl_df", "tbl", "data.frame")
)
precd_ncdf
#> # A tibble: 5 x 10
#>       x     y X2010.01.01 X2010.01.02 X2010.01.03 X2010.01.04 X2010.01.05
#>   <dbl> <dbl>       <dbl>       <dbl>       <dbl>       <dbl>       <dbl>
#> 1 -60.6  5.12           0           0           0       0.448       2.35 
#> 2 -60.4  5.12           0           0           0       0.441       1.19 
#> 3 -60.1  5.12           0           0           0       0.579       2.01 
#> 4 -60.6  4.88           0           0           0       0.441       1.94 
#> 5 -60.4  4.88           0           0           0       0.392       0.428
#> # ... with 3 more variables: X2010.01.06 <dbl>, X2010.01.07 <dbl>,
#> #   X2010.01.08 <dbl>
```





A estrutura esperada do *tibble* resultante é mostrada abaixo:


```r
glimpse(precd_arrum)
#> Observations: 40
#> Variables: 4
#> $ x    <dbl> -60.625, -60.375, -60.125, -60.625, -60.375, -60.625, -60...
#> $ y    <dbl> 5.125, 5.125, 5.125, 4.875, 4.875, 5.125, 5.125, 5.125, 4...
#> $ date <date> 2010-01-01, 2010-01-01, 2010-01-01, 2010-01-01, 2010-01-...
#> $ prec <dbl> 0.0000000, 0.0000000, 0.0000000, 0.0000000, 0.0000000, 0....
```

- - -

3. Coloque os dados de poluição (*tibble* `poluentes`) no formato \"arrumado\".


```r
poluentes <- read.table(
  text='
  poluente   duracao    estacao                 
      ozone         1h            1
        so2         1h            1
      ozone         8h            2
        no2         1h            4
                         ',
  header = TRUE, 
  stringsAsFactors = FALSE
) %>% 
  as_tibble(.) 
poluentes
#> # A tibble: 4 x 3
#>   poluente duracao estacao
#>   <chr>    <chr>     <int>
#> 1 ozone    1h            1
#> 2 so2      1h            1
#> 3 ozone    8h            2
#> 4 no2      1h            4
```



A estrutura esperada do *tibble* resultante é mostrada abaixo:


```r
glimpse(poluentes_arrum)
#> Observations: 3
#> Variables: 4
#> $ estacao <int> 1, 2, 4
#> $ no2     <chr> NA, NA, "1h"
#> $ ozone   <chr> "1h", "8h", NA
#> $ so2     <chr> "1h", NA, NA
```

- - -

4. Coloque os dados meteorológicos diários da estação meteorológica de Santa Maria no formato arrumado. Deixe os dados ordenados cronologicamente.


```r
meteo_data <- import("https://github.com/lhmet/adar-ufsm/blob/master/data/data_sm_wide.RDS?raw=true") %>%
  as_tibble()
meteo_data
#> # A tibble: 12 x 35
#>    id    element month  year    d1    d2    d3    d4    d5    d6    d7
#>  * <chr> <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1 83936 tmax        1  2010  32.6  33.4  24.8  29.4  27    24.4  29.6
#>  2 83936 tmin        1  2010  17.9  21.4  21.6  23.4  23.2  21.8  18  
#>  3 83936 tmax        2  2010  36.8  38.4  32.6  38.6  34    36.4  29.8
#>  4 83936 tmin        2  2010  25.4  25    29.6  26.2  25    25.8  25.4
#>  5 83936 tmax        3  2010  32    32.4  33.6  32.4  32    29.6  30.2
#>  6 83936 tmin        3  2010  18.6  19    20.2  21.6  19.8  18.4  17.3
#>  7 83936 tmax        4  2010  34.4  28.6  21    24.2  23.4  24    24.6
#>  8 83936 tmin        4  2010  17.5  21    20.6  17.6  15    10.8  11.7
#>  9 83936 tmax        5  2010  27    26.4  20.2  22.8  25.4  17.4  19.6
#> 10 83936 tmin        5  2010   7.2   7    13    16.2  14.1  11.5  14.4
#> 11 83936 tmax        6  2010  19.2  23.8  17.2  18.6  21.2  20.2  17.8
#> 12 83936 tmin        6  2010   4.1   8.8   9.1  15.2  11.4   6.1   6.3
#> # ... with 24 more variables: d8 <dbl>, d9 <dbl>, d10 <dbl>, d11 <dbl>,
#> #   d12 <dbl>, d13 <dbl>, d14 <dbl>, d15 <dbl>, d16 <dbl>, d17 <dbl>,
#> #   d18 <dbl>, d19 <dbl>, d20 <dbl>, d21 <dbl>, d22 <dbl>, d23 <dbl>,
#> #   d24 <dbl>, d25 <dbl>, d26 <dbl>, d27 <dbl>, d28 <dbl>, d29 <dbl>,
#> #   d30 <dbl>, d31 <dbl>
#glimpse(meteo_data)
```


A estrutura esperada do *tibble* resultante é mostrada abaixo:
  





```r
glimpse(meteo_data_arrum)
#> Observations: 186
#> Variables: 6
#> $ id    <chr> "83936", "83936", "83936", "83936", "83936", "83936", "8...
#> $ month <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,...
#> $ year  <dbl> 2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010, 20...
#> $ day   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 1...
#> $ tmax  <dbl> 32.6, 33.4, 24.8, 29.4, 27.0, 24.4, 29.6, 29.4, 29.6, 31...
#> $ tmin  <dbl> 17.9, 21.4, 21.6, 23.4, 23.2, 21.8, 18.0, 19.4, 21.8, 22...
```






## Exemplo de manipulação de dados 

Nesta seção vamos fazer um estudo de caso para demostrar diversas funções do \"universo arrumado\" aplicadas ao conjunto de dados de precipitação horária de Santa Maria-RS.

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
#>  1 A803  2004-01-01 00:00:00     0
#>  2 A803  2004-01-01 01:00:00     0
#>  3 A803  2004-01-01 02:00:00     0
#>  4 A803  2004-01-01 03:00:00     0
#>  5 A803  2004-01-01 04:00:00     0
#>  6 A803  2004-01-01 05:00:00     0
#>  7 A803  2004-01-01 06:00:00     0
#>  8 A803  2004-01-01 07:00:00     0
#>  9 A803  2004-01-01 08:00:00     0
#> 10 A803  2004-01-01 09:00:00     0
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
#>  1  2004    155       1.8
#>  2  2005    816       9.3
#>  3  2006    427       4.9
#>  4  2007    290       3.3
#>  5  2008     50       0.6
#>  6  2009     42       0.5
#>  7  2010     62       0.7
#>  8  2011   1120      12.8
#>  9  2012    313       3.6
#> 10  2013     15       0.2
#> 11  2014    818       9.3
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
#>  1     1     145.         474        43.1          1.80
#>  2     2     124          570        51.8          2.16
#>  3     3     115.         469        42.6          1.78
#>  4     4     128.         617        56.1          2.34
#>  5     5     106.         679        61.7          2.57
#>  6     6     121.         833        75.7          3.16
#>  7     7     116.         740        67.3          2.80
#>  8     8     106.         785        71.4          2.97
#>  9     9     179.         947        86.1          3.59
#> 10    10     173.         683        62.1          2.59
#> 11    11     141.         543        49.4          2.06
#> 12    12     156.         475        43.2          1.80
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
#>  1     1     145.    125       11.4
#>  2     2     124     131       11.9
#>  3     3     115.    133       12.1
#>  4     4     128.    185       16.8
#>  5     5     106.    203       18.5
#>  6     6     121.    220       20  
#>  7     7     116.    168       15.3
#>  8     8     106.    182       16.5
#>  9     9     179.    166       15.1
#> 10    10     173.    140       12.7
#> 11    11     141.    110       10  
#> 12    12     156.    115       10.5
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
#>  1  2004    1083.
#>  2  2005    1353.
#>  3  2006    1244.
#>  4  2007    1660 
#>  5  2008    1508.
#>  6  2009    2187.
#>  7  2010    1921.
#>  8  2011    1148 
#>  9  2012    1656.
#> 10  2013    1680 
#> 11  2014    2274
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
#>  1  2004         550          22.9    29.6
#>  2  2005         715          29.8    29.6
#>  3  2006         561          23.4    29.6
#>  4  2007         797          33.2    29.6
#>  5  2008         764          31.8    29.6
#>  6  2009         831          34.6    29.6
#>  7  2010         839          35.0    29.6
#>  8  2011         569          23.7    29.6
#>  9  2012         595          24.8    29.6
#> 10  2013         715          29.8    29.6
#> 11  2014         879          36.6    29.6
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
#>  1  2004     135    171.
#>  2  2005     159    171.
#>  3  2006     162    171.
#>  4  2007     184    171.
#>  5  2008     180    171.
#>  6  2009     183    171.
#>  7  2010     174    171.
#>  8  2011     149    171.
#>  9  2012     149    171.
#> 10  2013     195    171.
#> 11  2014     208    171.
```
 
  
  (c) Qual a intensidade média da chuva (em mm/dia) em Santa Maria? Faça a média das frequências de ocorrência e das intensidade obtidas para cada ano.


```r
select(tab_year_h, year, prec_tot, n_horas_tot_d, intens, intens_med_d)
#> # A tibble: 11 x 5
#>     year prec_tot n_horas_tot_d intens intens_med_d
#>    <dbl>    <dbl>         <dbl>  <dbl>        <dbl>
#>  1  2004    1083.          22.9   47.3         54.4
#>  2  2005    1353.          29.8   45.4         54.4
#>  3  2006    1244.          23.4   53.2         54.4
#>  4  2007    1660           33.2   50.0         54.4
#>  5  2008    1508.          31.8   47.4         54.4
#>  6  2009    2187.          34.6   63.2         54.4
#>  7  2010    1921.          35.0   54.9         54.4
#>  8  2011    1148           23.7   48.4         54.4
#>  9  2012    1656.          24.8   66.8         54.4
#> 10  2013    1680           29.8   56.4         54.4
#> 11  2014    2274           36.6   62.1         54.4
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
#> 2 Mon     1109 13154        14.2  1.2 
#> 3 Tue     1088 13183        13.9  1.18
#> 4 Wed     1014 13215        13.0  1.1 
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
