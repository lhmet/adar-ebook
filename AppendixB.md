# Funções nativas do R para importar e exportar dados



## Amostras pequenas de dados

### scan() {#scan}

Nós podemos informar os números de um vetor a partir do teclado, um de cada vez usando e quando terminar teclar enter:


```r
# Exemplo: vetor
v1 <- scan()
# digite os números do v1, ao terminar, tecle enter
```

A função `scan()` também pode ler dados de arquivos, mas a sua saída é um vetor, ou seja ela não mantém a estrutura dos dados contidos no arquivo.

Vamos baixar um arquivo de dados do site com os dados do livro para ilustrar o uso da `scan()`.


```r
# download dados de exemplo
aq_url <- "https://raw.githubusercontent.com/lhmet/adar-ufsm/master/data/airquality.txt"
# arquivo temporário, você pode substituir tempfile() por um caminho de seu computador, p.ex. "~/Downloads"
(aq_dest_file <- tempfile())
#> [1] "/tmp/RtmpHYq9t7/file3452451d27b6"
download.file(aq_url, destfile = aq_dest_file)
```


```r
# Exemplo: vetor
vetor_aq <- scan(aq_dest_file)
# parte inicial dos dados
head(vetor_aq, 100)
#>   [1]   41.0  190.0    7.4   67.0    5.0    1.0   36.0  118.0    8.0   72.0
#>  [11]    5.0    2.0   12.0  149.0   12.6   74.0    5.0    3.0   18.0  313.0
#>  [21]   11.5   62.0    5.0    4.0  -99.9  -99.9   14.3   56.0    5.0    5.0
#>  [31]   28.0  -99.9   14.9   66.0    5.0    6.0   23.0  299.0    8.6   65.0
#>  [41]    5.0    7.0   19.0   99.0   13.8   59.0    5.0    8.0    8.0   19.0
#>  [51]   20.1   61.0    5.0    9.0  -99.9  194.0    8.6   69.0    5.0   10.0
#>  [61]    7.0 -999.0    6.9   74.0    5.0   11.0   16.0  256.0    9.7   69.0
#>  [71]    5.0   12.0   11.0  290.0    9.2   66.0    5.0   13.0   14.0  274.0
#>  [81]   10.9   68.0    5.0   14.0   18.0   65.0   13.2   58.0    5.0   15.0
#>  [91]   14.0  334.0   11.5   64.0    5.0   16.0   34.0  307.0   12.0   66.0
# parte final
tail(vetor_aq, 100)
#>   [1]  24.0  10.9  71.0   9.0  14.0  13.0 112.0  11.5  71.0   9.0  15.0
#>  [12]  46.0 237.0   6.9  78.0   9.0  16.0  18.0 224.0  13.8  67.0   9.0
#>  [23]  13.0  27.0  10.3  76.0   9.0  18.0  24.0 238.0  10.3  68.0   9.0
#>  [34]  19.0  16.0 201.0   8.0  82.0   9.0  20.0  13.0 238.0  12.6  64.0
#>  [45]   9.0  21.0  23.0  14.0   9.2  71.0   9.0  22.0  36.0 139.0  10.3
#>  [56]  81.0   9.0  23.0   7.0  49.0  10.3  69.0   9.0  24.0  14.0  20.0
#>  [67]  16.6  63.0   9.0  25.0  30.0 193.0   6.9  70.0   9.0  26.0 -99.9
#>  [78] 145.0  13.2  77.0   9.0  27.0  14.0 191.0  14.3  75.0   9.0  28.0
#>  [89]  18.0 131.0   8.0  76.0   9.0  29.0  20.0 223.0  11.5  68.0   9.0
#> [100]  30.0
# dados são importados como vetor
is.vector(vetor_aq)
#> [1] TRUE
mode(vetor_aq)
#> [1] "numeric"
```


Vimos que `dataframes` são geralmente criados pela função `data.frame`, conforme o exemplo abaixo.


```r
# Exemplo: dataframe
dados <- data.frame(
  dates = c("2013-01-01", "2013-01-01", "2013-01-01"),
  cidade = c("Santa Maria", "Sao Sepe", "Caçapava"),
  temperatura = c(31, 35, 21),
  chuva = c(3, 10, 14)
)
dados
#>        dates      cidade temperatura chuva
#> 1 2013-01-01 Santa Maria          31     3
#> 2 2013-01-01    Sao Sepe          35    10
#> 3 2013-01-01    Caçapava          21    14
```

### readline()

Para ler apenas uma linha de dados a partir do teclado como `character` usamos a função **`readline()`**:


```r
sentenca <- readline(prompt = "digite alguma coisa e tecle enter para continuar: ")
#> digite alguma coisa e tecle enter para continuar:
sentenca
#> [1] ""
```

Esta função pode ser utilizada como uma forma de controlar um *looping*. Esse exemplo ilustra o uso da função `lapply()` para execução de laços ou *loopings* ao longo de um vetor de índices. Essa função será vista futuramente no curso.


```r
# para reprodutibilidade
set.seed(123)
# looping ao longo da sequência de 1 a 5
l <- sapply(
  1:5,
  function(i) {
    # cria vetor com números aleatórios com distribuição uniforme
    x <- runif(n = 100, min = 1, max = 50)
    # anomalia acumulada
    y <- cumsum(x - mean(x))
    plot(y, type = "o")
    abline(h = 0, lty = 2)
    # leitura de linha, só após teclar enter vai gerar próximo gráfico
    readline(prompt = "tecle <enter> para continuar: ")
  }
)
l
```

### Impressão na tela

No modo interativo do R podemos imprimir os valores de um objeto na tela digitando o nome do objeto.


```r
x <- 1:3
y <- x ^ 2
y
#> [1] 1 4 9
# ou
print(x ^ 2)
#> [1] 1 4 9
```

Entretanto isso não é possível quando precisamos mostrar o valor de uma variável dentro do corpo de uma função ou dentro de um laço (*looping*). Nesse caso podemos usar a função `print()`:


```r
# dentro de uma função
# digitando o nome do objeto não imprimi na tela
fcubo <- function(x) {
  classe <- class(x)
  # intenção de mostrar objeto de entrada
  classe
  x ^ 3
}
fcubo(2)
#> [1] 8
# adicionando print
cubo <- function(x) {
  # mostra objeto de entrada
  classe <- class(x)
  print(classe)
  x ^ 3
}
fcubo(-3) # não imprime classe do objeto de entrada
#> [1] -27
cubo(-3) # imprime classe do objeto de entrada
#> [1] "numeric"
#> [1] -27
```

#### `cat()` ao invés de `print()`

É melhor usar a função `cat()` ao invés da função `print()`, já que a `print()` permite a impressão de apenas um único objeto enquanto a `cat()` não. Compare os resultados das duas funções:


```r
print("abc")
#> [1] "abc"
cat("abc\n") # \n indica quebra de linha
#> abc
x
#> [1] 1 2 3
cat("os elementos de x são: ", x, "\n")
#> os elementos de x são:  1 2 3
cat("os elementos de x são: ", x, sep = "")
#> os elementos de x são: 123
cat("os elementos de x são: ", x, sep = "\n")
#> os elementos de x são: 
#> 1
#> 2
#> 3
k <- c(5, 12, 13, 8, 88)
cat(k, sep = c(".", "___", " ---> ", "\n", "\n"))
#> 5.12___13 ---> 8
#> 88
```

### textConnection()

Imagine que você tivesse recebido essa amostra de dados por e-mail:
   
    dates      cidade temperatura chuva
    2013-01-01 SM          13     3
    2013-01-01 SS          30    10
    2013-01-01 CV          22    12

Para converter essa pequena amostra de dados em um *dataframe* nós podemos selecionar, copiar e colar o texto no primeiro argumento da função `textConnection`, e então usar a função `read.table`. 


```r
texto <- "       dates      cidade temperatura chuva
    2013-01-01 SM          31     3
    2013-01-01 SS          35    10
    2013-01-01 CV          21    14"
# conexão de texto
tc <- textConnection(object = texto)
tc
#> A connection with                            
#> description "texto"         
#> class       "textConnection"
#> mode        "r"             
#> text        "text"          
#> opened      "opened"        
#> can read    "yes"           
#> can write   "no"
x <- read.table(file = tc, header = TRUE)
x
#>        dates cidade temperatura chuva
#> 1 2013-01-01     SM          31     3
#> 2 2013-01-01     SS          35    10
#> 3 2013-01-01     CV          21    14
```


## Exportando e recuperando objetos do R no formato textual

### `dput()`, `dget`, `dump` e `source`.

Uma função útil para compartilhar dados com alguém que precisa reproduzi-los é a função `dput()` (que pode ser traduzido como \"despejar\"). Ela escreve uma representação textual de um objeto R que pode ser escrita em um arquivo. Para recriar o objeto basta usar a função `dget()`.


```r
x
#>        dates cidade temperatura chuva
#> 1 2013-01-01     SM          31     3
#> 2 2013-01-01     SS          35    10
#> 3 2013-01-01     CV          21    14
# representação textual do objeto x
dput(x)
#> structure(list(dates = structure(c(1L, 1L, 1L), .Label = "2013-01-01", class = "factor"), 
#>     cidade = structure(c(2L, 3L, 1L), .Label = c("CV", "SM", 
#>     "SS"), class = "factor"), temperatura = c(31L, 35L, 21L), 
#>     chuva = c(3L, 10L, 14L)), class = "data.frame", row.names = c(NA, 
#> -3L))
# salva representação textual de x em um arquivo temporário, você pode substituir tempfile() por um caminho de seu computador, p.ex. "~/Downloads"
(aq_dest_file <- tempfile())
#> [1] "/tmp/RtmpHYq9t7/file34527962a29"
(x_dest_file <- tempfile())
#> [1] "/tmp/RtmpHYq9t7/file3452583e3278"
dput(x, file = x_dest_file)
# recuperando x a partir do arquivo
y <- dget(x_dest_file)
# alterar valores de y
y <- y[, 3:4] - sqrt(2)
y
#>   temperatura     chuva
#> 1    29.58579  1.585786
#> 2    33.58579  8.585786
#> 3    19.58579 12.585786
# verificar existência de x e y
ls()
#>  [1] "aq_dest_file" "aq_url"       "cubo"         "dados"       
#>  [5] "fcubo"        "k"            "pcks"         "rblue"       
#>  [9] "sentenca"     "tc"           "texto"        "vetor_aq"    
#> [13] "x"            "x_dest_file"  "y"
# listando variáveis que começam com x ou y
ls(pattern = "^[xy]")
#> [1] "x"           "x_dest_file" "y"
# salvando mais de um objeto em um arquivo
(xy_dest_file <- tempfile())
#> [1] "/tmp/RtmpHYq9t7/file345252277c01"
dump(ls(pattern = "^[xy]"), file = xy_dest_file)
# vamos apagar x e y do espaco de trabalho
rm(x, y)
# x e y não existem mais
ls()
#>  [1] "aq_dest_file" "aq_url"       "cubo"         "dados"       
#>  [5] "fcubo"        "k"            "pcks"         "rblue"       
#>  [9] "sentenca"     "tc"           "texto"        "vetor_aq"    
#> [13] "x_dest_file"  "xy_dest_file"
# recuperando os objetos x e y salvos em xy.R
source(xy_dest_file)
ls()
#>  [1] "aq_dest_file" "aq_url"       "cubo"         "dados"       
#>  [5] "fcubo"        "k"            "pcks"         "rblue"       
#>  [9] "sentenca"     "tc"           "texto"        "vetor_aq"    
#> [13] "x"            "x_dest_file"  "xy_dest_file" "y"
x
#>        dates cidade temperatura chuva
#> 1 2013-01-01     SM          31     3
#> 2 2013-01-01     SS          35    10
#> 3 2013-01-01     CV          21    14
y
#>   temperatura     chuva
#> 1    29.58579  1.585786
#> 2    33.58579  8.585786
#> 3    19.58579 12.585786
```

Portanto diferente da escrita dos dados em si para um arquivo texto as funções `dump()` e `dput()` armazenam os **dados** e os **metadados**, assim outro usuário não precisa especificá-los novamente. Assim o usuário que recebe a saída do `dput()` em um arquivo, pode recriar os dados pelo comando `dget("nomedoarquivo")`. 


```r
# representação textual de um data.frame
dados3est <- structure(
  list(
    dates = c("2013-01-01", "2013-01-01", "2013-01-01"),
    cidade = c("SM", "SS", "CV"),
    temperatura = c(31L, 35L, 21L),
    chuva = c(3L, 10L, 14L)
  ),
  .Names = c("dates", "cidade", "temperatura", "chuva"),
  class = "data.frame",
  row.names = c(NA, -3L)
)
dados3est
#>        dates cidade temperatura chuva
#> 1 2013-01-01     SM          31     3
#> 2 2013-01-01     SS          35    10
#> 3 2013-01-01     CV          21    14
```

**Vantagens:**

- armazena os **dados e os metadados**
- recuperação rápida e fácil dos dados 

**Desvantagens:**

- armazenamento de dados nesse formato não é muito eficiente em termos de espaço em disco
- pouca legibilidade dos dados 

Esse procedimento é geralmente recomendado para fornecer pequenas amostras de dados (e-mails por exemplo)

## Dados de pacotes do R

O `R` possui diversos conjuntos de dados internos que são automaticamente carregados quando iniciado. Esses dados são usados nos exemplos do `help()` de diversas funções para ilustrar o uso e a aplicação delas. Esses dados podem ser carregados com a função `data()`.


```r
# lista de dados disponíveis
data()
# Annual Precipitation in US Cities, p/ mais informações "?precip"
data(precip)
# primeiros 30 elementos dos dados precip
head(precip, n = 30)
#>              Mobile              Juneau             Phoenix 
#>                67.0                54.7                 7.0 
#>         Little Rock         Los Angeles          Sacramento 
#>                48.5                14.0                17.2 
#>       San Francisco              Denver            Hartford 
#>                20.7                13.0                43.4 
#>          Wilmington          Washington        Jacksonville 
#>                40.2                38.9                54.5 
#>               Miami             Atlanta            Honolulu 
#>                59.8                48.3                22.9 
#>               Boise             Chicago              Peoria 
#>                11.5                34.4                35.1 
#>        Indianapolis          Des Moines             Wichita 
#>                38.7                30.8                30.6 
#>          Louisville         New Orleans            Portland 
#>                43.1                56.8                40.8 
#>           Baltimore              Boston             Detroit 
#>                41.8                42.5                31.0 
#>    Sault Ste. Marie              Duluth Minneapolis/St Paul 
#>                31.7                30.2                25.9
# New York Air Quality Measurements, , p/ mais informações "?airquality"
data(airquality)
# primeiras linhas dos dados
head(airquality, n = 10)
#>    Ozone Solar.R Wind Temp Month Day
#> 1     41     190  7.4   67     5   1
#> 2     36     118  8.0   72     5   2
#> 3     12     149 12.6   74     5   3
#> 4     18     313 11.5   62     5   4
#> 5     NA      NA 14.3   56     5   5
#> 6     28      NA 14.9   66     5   6
#> 7     23     299  8.6   65     5   7
#> 8     19      99 13.8   59     5   8
#> 9      8      19 20.1   61     5   9
#> 10    NA     194  8.6   69     5  10
```


## Leitura de arquivos texto com funções da base do R {#readtable}

A função nativa do <img src="images/logo_r.png" width="20"> mais usada para leitura de dados de um arquivo texto é a `read.table()`. Os dados lidos são armazenados em um dataframe. 

Essa função possui diversos parâmetros para especificar a importação de acordo com as peculiaridades do formato de dados do arquivo. 

O valor *default* do parâmetro `sep` é um ou mais caracteres de `espaço` e `tabs`. Devido as diversas opções de separadores existem outras funções envelopes da `read.table()`, com a diferença no separador, por exemplo as funções: `read.csv(), read.csv2(), read.delim()` que chamam a `read.table()`, dentro corpo da função, com o argumento `sep` definido como `,`, `;` e `\t`, respectivamente. Para detalhes sobre essas funções o *help* de cada uma. Uma vez que essas funções aceitam qualquer argumento da `read.table()` elas são mais convenientes que usar a `read.table()` e configurar os argumentos apropriados manualmente.


Alguns argumentos da função `read.table()` são:

* `file` nome do arquivo
* `header` lógico (TRUE ou FALSE) indicando se o arquivo tem ou não linha de cabeçalho
* `sep` um caractere indicando como as colunas são separadas
* `colClasses`, um vetor caractere indicando as classes de cada coluna no conjunto de dados
* `nrows`, número de linhas no conjunto de dados
* `comment.char`, um caractere indicando o caractere usado como comentário (para ignorar essas linhas)
* `skip`, o número de linhas que devem ser "puladas" desde o início do arquivo
* `stringsAsFactors`, lógico, as variáveis do tipo `character` devem ser codificadas como `factor`?

Esse último argumento pode ser definido também através da configuração global de opções no R pelo comando: `options(stringsAsFactors=FALSE)`.

Quando se faz a leitura de dados com `read.table("nome_do_arquivo")` o R automaticamente: 

+ pula linhas que começam com '#'
+ descobre quantas linhas tem o arquivo e quanta memória precisa ser alocada
+ descobre qual o tipo de variável em cada coluna

Vamos ver alguns exemplos de leitura de dados hidrometeorológicos no formato texto amplamente usados em aplicações da Meteorologia.


### Dados hidrometeorológicos brasileiros

#### [hidroweb-ANA](http://hidroweb.ana.gov.br/)

O sistema hidroweb é o maior base de dados hidrológicos brasileira. No trecho de código a seguir baixamos um arquivo de dados de precipitação obtidos no sistema hidroweb que foi salvo no site do livro.


```r
# arquivo de exemplo disponível no GitHub
hidroweb_url_file <- "https://raw.github.com/lhmet/adar-ufsm/master/data/CHUVAS.TXT"
#arquivo temporário, você pode substituir tempfile() por um caminho de seu computador, p.ex. "~/Downloads/CHUVAS.TXT"
hidroweb_dest_file <- tempfile()
download.file(
  url = hidroweb_url_file, 
  destfile = hidroweb_dest_file
)
```

Antes de importar os dados você precisa visualizar o arquivo para extrair as informações básicas necessárias para sua importação. Você pode abri-lo em um editor de texto ou 


```r
# caracteres não devem tratados como fatores
options(stringsAsFactors = FALSE)
# leitura de dados da ANA
dprec <- read.csv2(file = hidroweb_url_file, 
                   skip = 15, 
                   head = TRUE, 
                   fill = TRUE)
# primeiras linhas
head(dprec)
#>   X..EstacaoCodigo NivelConsistencia       Data TipoMedicaoChuvas Maxima
#> 1          3054002                 1 01/01/1934                 1     NA
#> 2          3054002                 1 01/02/1934                 1   66.3
#> 3          3054002                 1 01/03/1934                 1   55.0
#> 4          3054002                 1 01/04/1934                 1   54.5
#> 5          3054002                 1 01/05/1934                 1   30.5
#> 6          3054002                 1 01/06/1934                 1   42.5
#>   Total DiaMaxima NumDiasDeChuva MaximaStatus TotalStatus
#> 1    NA        NA             NA            0           0
#> 2 174.7         6             10            1           1
#> 3 160.7         9             10            1           1
#> 4  98.4         1              4            1           1
#> 5 119.4        29              8            1           1
#> 6 191.6        13             11            1           1
#>   NumDiasDeChuvaStatus TotalAnual TotalAnualStatus Chuva01 Chuva02 Chuva03
#> 1                    0         NA                0      NA      NA      NA
#> 2                    0         NA                0    15.5     3.5     0.0
#> 3                    0         NA                0     0.0     0.0     0.0
#> 4                    0         NA                0    54.5     0.0     0.0
#> 5                    1         NA                0     0.0    19.0    26.7
#> 6                    0         NA                0     0.0     0.0    21.5
#>   Chuva04 Chuva05 Chuva06 Chuva07 Chuva08 Chuva09 Chuva10 Chuva11 Chuva12
#> 1      NA    10.5     3.0    11.1     0.0       0     0.0     0.0     0.0
#> 2     0.0    11.9    66.3     1.0    40.0       0     0.0     0.0     1.1
#> 3     0.0     0.0     0.0     0.0     0.0      55    11.7     5.0     0.0
#> 4     0.0     0.0    18.5     0.0    19.5       0     0.0     0.0     0.0
#> 5     0.0     3.2     4.2     0.0     0.0       0     0.0     0.0     0.0
#> 6    12.7     8.7     0.0     0.0     0.0       0     0.0    27.3    37.5
#>   Chuva13 Chuva14 Chuva15 Chuva16 Chuva17 Chuva18 Chuva19 Chuva20 Chuva21
#> 1     0.0     0.0       0    37.6       0    18.4    12.5     0.0     0.0
#> 2    24.7     0.0       0     0.0       0     0.0     0.0     0.0     0.0
#> 3     7.5     9.5       0     3.0       1    23.0     0.0     0.0     0.0
#> 4     0.0     0.0       0     0.0       0     0.0     0.0     0.0     0.0
#> 5     0.0     0.0       0     0.0       0     0.0     0.0     0.0    20.5
#> 6    42.5     0.0       0     0.0       0     0.0     0.0     0.7     3.2
#>   Chuva22 Chuva23 Chuva24 Chuva25 Chuva26 Chuva27 Chuva28 Chuva29 Chuva30
#> 1    67.5    12.3     0.0     0.0       0       0       0     0.0     0.0
#> 2     0.0     0.0     8.2     2.5       0       0       0      NA      NA
#> 3     0.0     0.0     0.0     0.0       0       0       0     0.0    23.5
#> 4     0.0     0.0     0.0     5.9       0       0       0     0.0     0.0
#> 5     0.0     0.0     0.0     1.3       0       0      14    30.5     0.0
#> 6     3.0     0.0    33.5     0.0       0       0       1     0.0     0.0
#>   Chuva31 Chuva01Status Chuva02Status Chuva03Status Chuva04Status
#> 1     0.0             0             0             0             0
#> 2      NA             1             1             1             1
#> 3    21.5             1             1             1             1
#> 4      NA             1             1             1             1
#> 5     0.0             1             1             1             1
#> 6      NA             1             1             1             1
#>   Chuva05Status Chuva06Status Chuva07Status Chuva08Status Chuva09Status
#> 1             1             1             1             1             1
#> 2             1             1             1             1             1
#> 3             1             1             1             1             1
#> 4             1             1             1             1             1
#> 5             1             1             1             1             1
#> 6             1             1             1             1             1
#>   Chuva10Status Chuva11Status Chuva12Status Chuva13Status Chuva14Status
#> 1             1             1             1             1             1
#> 2             1             1             1             1             1
#> 3             1             1             1             1             1
#> 4             1             1             1             1             1
#> 5             1             1             1             1             1
#> 6             1             1             1             1             1
#>   Chuva15Status Chuva16Status Chuva17Status Chuva18Status Chuva19Status
#> 1             1             1             1             1             1
#> 2             1             1             1             1             1
#> 3             1             1             1             1             1
#> 4             1             1             1             1             1
#> 5             1             1             1             1             1
#> 6             1             1             1             1             1
#>   Chuva20Status Chuva21Status Chuva22Status Chuva23Status Chuva24Status
#> 1             1             1             1             1             1
#> 2             1             1             1             1             1
#> 3             1             1             1             1             1
#> 4             1             1             1             1             1
#> 5             1             1             1             1             1
#> 6             1             1             1             1             1
#>   Chuva25Status Chuva26Status Chuva27Status Chuva28Status Chuva29Status
#> 1             1             1             1             1             1
#> 2             1             1             1             1             0
#> 3             1             1             1             1             1
#> 4             1             1             1             1             1
#> 5             1             1             1             1             1
#> 6             1             1             1             1             1
#>   Chuva30Status Chuva31Status  X
#> 1             1             1 NA
#> 2             0             0 NA
#> 3             1             1 NA
#> 4             1             0 NA
#> 5             1             1 NA
#> 6             1             0 NA
# últimas linhas
tail(dprec)
#>      X..EstacaoCodigo NivelConsistencia       Data TipoMedicaoChuvas
#> 1279          3054002                 2 01/07/2005                 1
#> 1280          3054002                 2 01/08/2005                 1
#> 1281          3054002                 2 01/09/2005                 1
#> 1282          3054002                 2 01/10/2005                 1
#> 1283          3054002                 2 01/11/2005                 1
#> 1284          3054002                 2 01/12/2005                 1
#>      Maxima Total DiaMaxima NumDiasDeChuva MaximaStatus TotalStatus
#> 1279   44.8  69.5         4              4            1           1
#> 1280   19.9  91.4        30              9            1           1
#> 1281   49.8 149.2        24             12            1           1
#> 1282   57.2 145.3         4              6            1           1
#> 1283   14.2  36.0        24              5            1           1
#> 1284   11.2  22.0        31              6            1           1
#>      NumDiasDeChuvaStatus TotalAnual TotalAnualStatus Chuva01 Chuva02
#> 1279                    1     1123.4                1     0.0     0.0
#> 1280                    1     1123.4                1     0.0     0.0
#> 1281                    1     1123.4                1     3.8    11.3
#> 1282                    1     1123.4                1     0.0     0.0
#> 1283                    1     1123.4                1     0.0     0.0
#> 1284                    1     1123.4                1     0.0     0.0
#>      Chuva03 Chuva04 Chuva05 Chuva06 Chuva07 Chuva08 Chuva09 Chuva10
#> 1279       0    44.8     0.0     0.0     0.0       0     0.0     0.0
#> 1280       0     0.0     0.0     0.0     0.5       0     0.1     0.0
#> 1281       0     0.0     0.0     0.0     0.0       0     8.9    24.7
#> 1282       0    57.2    19.6     0.0     0.0       0     0.0     0.0
#> 1283       0     0.0    13.2     6.3     0.0       0     0.0     0.0
#> 1284       0     2.1     1.9     0.0     0.0       0     0.0     0.0
#>      Chuva11 Chuva12 Chuva13 Chuva14 Chuva15 Chuva16 Chuva17 Chuva18
#> 1279     0.0       0       0     0.0     0.0    12.9     9.7     0.0
#> 1280     0.0       0       0     0.0     0.0     0.0     0.0    14.1
#> 1281     9.7       0       0     0.2    15.6     0.1     0.0     3.2
#> 1282     0.0       0       0    46.3     0.0     3.9     0.2     0.0
#> 1283     0.0       0       0     0.0     1.4     0.0     0.9     0.0
#> 1284     0.0       0       0     0.0     0.0     0.0     2.2     0.0
#>      Chuva19 Chuva20 Chuva21 Chuva22 Chuva23 Chuva24 Chuva25 Chuva26
#> 1279     0.0       0     0.0     2.1     0.0     0.0     0.0       0
#> 1280     0.0       0     6.3    19.7     6.4    17.1     0.0       0
#> 1281     4.5       0     0.0     0.0     0.0    49.8     0.0       0
#> 1282     0.0       0     0.0     0.0     0.0     0.0    18.1       0
#> 1283     0.0       0     0.0     0.0     0.0    14.2     0.0       0
#> 1284     0.7       0     0.0     0.0     0.0     0.0     0.0       0
#>      Chuva27 Chuva28 Chuva29 Chuva30 Chuva31 Chuva01Status Chuva02Status
#> 1279       0       0     0.0     0.0     0.0             1             1
#> 1280       0       0     7.3    19.9     0.0             1             1
#> 1281       0       0     0.0    17.4      NA             1             1
#> 1282       0       0     0.0     0.0     0.0             1             1
#> 1283       0       0     0.0     0.0      NA             1             1
#> 1284       0       0     0.0     3.9    11.2             1             1
#>      Chuva03Status Chuva04Status Chuva05Status Chuva06Status Chuva07Status
#> 1279             1             1             1             1             1
#> 1280             1             1             1             1             1
#> 1281             1             1             1             1             1
#> 1282             1             1             1             1             1
#> 1283             1             1             1             1             1
#> 1284             1             1             1             1             1
#>      Chuva08Status Chuva09Status Chuva10Status Chuva11Status Chuva12Status
#> 1279             1             1             1             1             1
#> 1280             1             1             1             1             1
#> 1281             1             1             1             1             1
#> 1282             1             1             1             1             1
#> 1283             1             1             1             1             1
#> 1284             1             1             1             1             1
#>      Chuva13Status Chuva14Status Chuva15Status Chuva16Status Chuva17Status
#> 1279             1             1             1             1             1
#> 1280             1             1             1             1             1
#> 1281             1             1             1             1             1
#> 1282             1             1             1             1             1
#> 1283             1             1             1             1             1
#> 1284             1             1             1             1             1
#>      Chuva18Status Chuva19Status Chuva20Status Chuva21Status Chuva22Status
#> 1279             1             1             1             1             1
#> 1280             1             1             1             1             1
#> 1281             1             1             1             1             1
#> 1282             1             1             1             1             1
#> 1283             1             1             1             1             1
#> 1284             1             1             1             1             1
#>      Chuva23Status Chuva24Status Chuva25Status Chuva26Status Chuva27Status
#> 1279             1             1             1             1             1
#> 1280             1             1             1             1             1
#> 1281             1             1             1             1             1
#> 1282             1             1             1             1             1
#> 1283             1             1             1             1             1
#> 1284             1             1             1             1             1
#>      Chuva28Status Chuva29Status Chuva30Status Chuva31Status  X
#> 1279             1             1             1             1 NA
#> 1280             1             1             1             1 NA
#> 1281             1             1             1             0 NA
#> 1282             1             1             1             1 NA
#> 1283             1             1             1             0 NA
#> 1284             1             1             1             1 NA
 # corrigindo nome da primeira coluna
 names(dprec)[1] <- "EstacaoCodigo"
 # removendo última coluna que só tem NAs
 dprec <- dprec[ , -ncol(dprec)]
  # estrutura dos dados
  str(dprec)
#> 'data.frame':	1284 obs. of  75 variables:
#>  $ EstacaoCodigo       : int  3054002 3054002 3054002 3054002 3054002 3054002 3054002 3054002 3054002 3054002 ...
#>  $ NivelConsistencia   : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Data                : chr  "01/01/1934" "01/02/1934" "01/03/1934" "01/04/1934" ...
#>  $ TipoMedicaoChuvas   : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Maxima              : num  NA 66.3 55 54.5 30.5 42.5 10.5 30.3 36.8 69.2 ...
#>  $ Total               : num  NA 174.7 160.7 98.4 119.4 ...
#>  $ DiaMaxima           : int  NA 6 9 1 29 13 6 30 19 5 ...
#>  $ NumDiasDeChuva      : int  NA 10 10 4 8 11 7 8 4 7 ...
#>  $ MaximaStatus        : int  0 1 1 1 1 1 1 1 1 1 ...
#>  $ TotalStatus         : int  0 1 1 1 1 1 1 1 1 1 ...
#>  $ NumDiasDeChuvaStatus: int  0 0 0 0 1 0 0 0 0 0 ...
#>  $ TotalAnual          : num  NA NA NA NA NA NA NA NA NA NA ...
#>  $ TotalAnualStatus    : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ Chuva01             : num  NA 15.5 0 54.5 0 0 0 0 0 0 ...
#>  $ Chuva02             : num  NA 3.5 0 0 19 0 0 0 0 0 ...
#>  $ Chuva03             : num  NA 0 0 0 26.7 21.5 0 0 0 0 ...
#>  $ Chuva04             : num  NA 0 0 0 0 12.7 0 0 0 20.8 ...
#>  $ Chuva05             : num  10.5 11.9 0 0 3.2 8.7 0 27.5 0 69.2 ...
#>  $ Chuva06             : num  3 66.3 0 18.5 4.2 0 10.5 0 5 6.1 ...
#>  $ Chuva07             : num  11.1 1 0 0 0 0 4 2.9 0 0 ...
#>  $ Chuva08             : num  0 40 0 19.5 0 0 0 5.4 0 0 ...
#>  $ Chuva09             : num  0 0 55 0 0 0 0 0 0 0 ...
#>  $ Chuva10             : num  0 0 11.7 0 0 0 0 13.6 0 0 ...
#>  $ Chuva11             : num  0 0 5 0 0 27.3 0 0 34.5 0 ...
#>  $ Chuva12             : num  0 1.1 0 0 0 37.5 0 0 0 0 ...
#>  $ Chuva13             : num  0 24.7 7.5 0 0 42.5 1.2 0 0 0 ...
#>  $ Chuva14             : num  0 0 9.5 0 0 0 0.7 0 0 0 ...
#>  $ Chuva15             : num  0 0 0 0 0 0 0 0 0 0 ...
#>  $ Chuva16             : num  37.6 0 3 0 0 0 0 1.8 0 0 ...
#>  $ Chuva17             : num  0 0 1 0 0 0 0 17 0 0 ...
#>  $ Chuva18             : num  18.4 0 23 0 0 0 7.2 0 0 0 ...
#>  $ Chuva19             : num  12.5 0 0 0 0 0 0 0 36.8 0 ...
#>  $ Chuva20             : num  0 0 0 0 0 0.7 0 0 17.7 0 ...
#>  $ Chuva21             : num  0 0 0 0 20.5 3.2 0 0 0 0 ...
#>  $ Chuva22             : num  67.5 0 0 0 0 3 0 0 0 0 ...
#>  $ Chuva23             : num  12.3 0 0 0 0 0 0 0 0 14 ...
#>  $ Chuva24             : num  0 8.2 0 0 0 33.5 0 0 0 40 ...
#>  $ Chuva25             : num  0 2.5 0 5.9 1.3 0 0 0 0 1 ...
#>  $ Chuva26             : num  0 0 0 0 0 0 1.1 0 0 5.4 ...
#>  $ Chuva27             : num  0 0 0 0 0 0 5.9 0 0 0 ...
#>  $ Chuva28             : num  0 0 0 0 14 1 0 0 0 0 ...
#>  $ Chuva29             : num  0 NA 0 0 30.5 0 0 0 0 0 ...
#>  $ Chuva30             : num  0 NA 23.5 0 0 0 0 30.3 0 0 ...
#>  $ Chuva31             : num  0 NA 21.5 NA 0 NA 0 1.8 NA 0 ...
#>  $ Chuva01Status       : int  0 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva02Status       : int  0 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva03Status       : int  0 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva04Status       : int  0 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva05Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva06Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva07Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva08Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva09Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva10Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva11Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva12Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva13Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva14Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva15Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva16Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva17Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva18Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva19Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva20Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva21Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva22Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva23Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva24Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva25Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva26Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva27Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva28Status       : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Chuva29Status       : int  1 0 1 1 1 1 1 1 1 1 ...
#>  $ Chuva30Status       : int  1 0 1 1 1 1 1 1 1 1 ...
#>  $ Chuva31Status       : int  1 0 1 0 1 0 1 1 0 1 ...
# Fazendo a mesma leitura com read.table
dprec2 <- read.table(file = hidroweb_url_file, 
                   skip = 15, 
                   head = T, 
                   stringsAsFactors = FALSE,
                   fill = T,
                   sep = ";",
                   dec = ",")
head(dprec2)
#>   X..EstacaoCodigo NivelConsistencia       Data TipoMedicaoChuvas Maxima
#> 1          3054002                 1 01/01/1934                 1     NA
#> 2          3054002                 1 01/02/1934                 1   66.3
#> 3          3054002                 1 01/03/1934                 1   55.0
#> 4          3054002                 1 01/04/1934                 1   54.5
#> 5          3054002                 1 01/05/1934                 1   30.5
#> 6          3054002                 1 01/06/1934                 1   42.5
#>   Total DiaMaxima NumDiasDeChuva MaximaStatus TotalStatus
#> 1    NA        NA             NA            0           0
#> 2 174.7         6             10            1           1
#> 3 160.7         9             10            1           1
#> 4  98.4         1              4            1           1
#> 5 119.4        29              8            1           1
#> 6 191.6        13             11            1           1
#>   NumDiasDeChuvaStatus TotalAnual TotalAnualStatus Chuva01 Chuva02 Chuva03
#> 1                    0         NA                0      NA      NA      NA
#> 2                    0         NA                0    15.5     3.5     0.0
#> 3                    0         NA                0     0.0     0.0     0.0
#> 4                    0         NA                0    54.5     0.0     0.0
#> 5                    1         NA                0     0.0    19.0    26.7
#> 6                    0         NA                0     0.0     0.0    21.5
#>   Chuva04 Chuva05 Chuva06 Chuva07 Chuva08 Chuva09 Chuva10 Chuva11 Chuva12
#> 1      NA    10.5     3.0    11.1     0.0       0     0.0     0.0     0.0
#> 2     0.0    11.9    66.3     1.0    40.0       0     0.0     0.0     1.1
#> 3     0.0     0.0     0.0     0.0     0.0      55    11.7     5.0     0.0
#> 4     0.0     0.0    18.5     0.0    19.5       0     0.0     0.0     0.0
#> 5     0.0     3.2     4.2     0.0     0.0       0     0.0     0.0     0.0
#> 6    12.7     8.7     0.0     0.0     0.0       0     0.0    27.3    37.5
#>   Chuva13 Chuva14 Chuva15 Chuva16 Chuva17 Chuva18 Chuva19 Chuva20 Chuva21
#> 1     0.0     0.0       0    37.6       0    18.4    12.5     0.0     0.0
#> 2    24.7     0.0       0     0.0       0     0.0     0.0     0.0     0.0
#> 3     7.5     9.5       0     3.0       1    23.0     0.0     0.0     0.0
#> 4     0.0     0.0       0     0.0       0     0.0     0.0     0.0     0.0
#> 5     0.0     0.0       0     0.0       0     0.0     0.0     0.0    20.5
#> 6    42.5     0.0       0     0.0       0     0.0     0.0     0.7     3.2
#>   Chuva22 Chuva23 Chuva24 Chuva25 Chuva26 Chuva27 Chuva28 Chuva29 Chuva30
#> 1    67.5    12.3     0.0     0.0       0       0       0     0.0     0.0
#> 2     0.0     0.0     8.2     2.5       0       0       0      NA      NA
#> 3     0.0     0.0     0.0     0.0       0       0       0     0.0    23.5
#> 4     0.0     0.0     0.0     5.9       0       0       0     0.0     0.0
#> 5     0.0     0.0     0.0     1.3       0       0      14    30.5     0.0
#> 6     3.0     0.0    33.5     0.0       0       0       1     0.0     0.0
#>   Chuva31 Chuva01Status Chuva02Status Chuva03Status Chuva04Status
#> 1     0.0             0             0             0             0
#> 2      NA             1             1             1             1
#> 3    21.5             1             1             1             1
#> 4      NA             1             1             1             1
#> 5     0.0             1             1             1             1
#> 6      NA             1             1             1             1
#>   Chuva05Status Chuva06Status Chuva07Status Chuva08Status Chuva09Status
#> 1             1             1             1             1             1
#> 2             1             1             1             1             1
#> 3             1             1             1             1             1
#> 4             1             1             1             1             1
#> 5             1             1             1             1             1
#> 6             1             1             1             1             1
#>   Chuva10Status Chuva11Status Chuva12Status Chuva13Status Chuva14Status
#> 1             1             1             1             1             1
#> 2             1             1             1             1             1
#> 3             1             1             1             1             1
#> 4             1             1             1             1             1
#> 5             1             1             1             1             1
#> 6             1             1             1             1             1
#>   Chuva15Status Chuva16Status Chuva17Status Chuva18Status Chuva19Status
#> 1             1             1             1             1             1
#> 2             1             1             1             1             1
#> 3             1             1             1             1             1
#> 4             1             1             1             1             1
#> 5             1             1             1             1             1
#> 6             1             1             1             1             1
#>   Chuva20Status Chuva21Status Chuva22Status Chuva23Status Chuva24Status
#> 1             1             1             1             1             1
#> 2             1             1             1             1             1
#> 3             1             1             1             1             1
#> 4             1             1             1             1             1
#> 5             1             1             1             1             1
#> 6             1             1             1             1             1
#>   Chuva25Status Chuva26Status Chuva27Status Chuva28Status Chuva29Status
#> 1             1             1             1             1             1
#> 2             1             1             1             1             0
#> 3             1             1             1             1             1
#> 4             1             1             1             1             1
#> 5             1             1             1             1             1
#> 6             1             1             1             1             1
#>   Chuva30Status Chuva31Status  X
#> 1             1             1 NA
#> 2             0             0 NA
#> 3             1             1 NA
#> 4             1             0 NA
#> 5             1             1 NA
#> 6             1             0 NA
```



#### [BDMEP-INMET](http://www.inmet.gov.br/portal/index.php?r=bdmep/bdmep)

O Banco de Dados Meteorológicos para Ensino e Pesquisa do INMET é uma das principais fonte de dados climáticos brasileiros. Abaixo veremos como importar um arquivo de dados diários de uma estação meteorológica convencional. Os dados foram obtidos no BDMEP e salvos no site do livro. 

No trecho de código a seguir baixamos o arquivo de dados da estação 83004.


```r
# arquivo de exemplo disponível no GitHub
bdmep_url_file <- "https://raw.githubusercontent.com/lhmet/adar-ufsm/master/data/83004.txt"
#arquivo temporário, você pode substituir tempfile() por um caminho de seu computador, p.ex. "~/Downloads/CHUVAS.TXT"
bdmep_dest_file <- tempfile()
download.file(
  url = bdmep_url_file, 
  destfile = bdmep_dest_file
)
```


```r
x <- read.csv2(file = bdmep_dest_file, 
               header = FALSE, 
               skip = 16,
               stringsAsFactors = FALSE,
               na.strings = ""
               )
head(x)
#>      V1         V2   V3   V4   V5   V6   V7   V8 V9   V10  V11 V12  V13
#> 1 83004 02/08/1993    0 <NA> <NA> <NA> <NA> <NA> NA  <NA> <NA>  NA <NA>
#> 2 83004 01/01/1995    0 <NA> <NA> <NA> 26.8 <NA> NA  <NA> <NA>  NA <NA>
#> 3 83004 01/01/1995 1200 21.2 22.5   20 <NA> 19.5 80 924.6 <NA>  32    4
#> 4 83004 01/01/1995 1800 <NA> 25.2 21.5 <NA> <NA> 73 922.9 <NA>  32    2
#> 5 83004 02/01/1995    0 <NA> 20.7 20.3 28.9 <NA> 97 924.2 <NA>   0    0
#> 6 83004 02/01/1995 1200  3.2 23.8 20.6 <NA> 19.9 76 924.7 <NA>  32    3
#>    V14  V15  V16   V17   V18      V19 V20
#> 1 <NA> <NA>  1.4  <NA>  <NA>     <NA>  NA
#> 2  1.5 <NA>  1.6 22.04 86.75        2  NA
#> 3 <NA>   10 <NA>  <NA>  <NA>     <NA>  NA
#> 4 <NA>   10 <NA>  <NA>  <NA>     <NA>  NA
#> 5  1.3   10  1.1 23.32    83 2.666667  NA
#> 6 <NA>   10 <NA>  <NA>  <NA>     <NA>  NA
str(x)
#> 'data.frame':	5863 obs. of  20 variables:
#>  $ V1 : chr  "83004" "83004" "83004" "83004" ...
#>  $ V2 : chr  "02/08/1993" "01/01/1995" "01/01/1995" "01/01/1995" ...
#>  $ V3 : int  0 0 1200 1800 0 1200 1800 0 1200 1800 ...
#>  $ V4 : chr  NA NA "21.2" NA ...
#>  $ V5 : chr  NA NA "22.5" "25.2" ...
#>  $ V6 : chr  NA NA "20" "21.5" ...
#>  $ V7 : chr  NA "26.8" NA NA ...
#>  $ V8 : chr  NA NA "19.5" NA ...
#>  $ V9 : int  NA NA 80 73 97 76 66 95 86 94 ...
#>  $ V10: chr  NA NA "924.6" "922.9" ...
#>  $ V11: chr  NA NA NA NA ...
#>  $ V12: int  NA NA 32 32 0 32 32 0 0 5 ...
#>  $ V13: chr  NA NA "4" "2" ...
#>  $ V14: chr  NA "1.5" NA NA ...
#>  $ V15: chr  NA NA "10" "10" ...
#>  $ V16: chr  "1.4" "1.6" NA NA ...
#>  $ V17: chr  NA "22.04" NA NA ...
#>  $ V18: chr  NA "86.75" NA NA ...
#>  $ V19: chr  NA "2" NA NA ...
#>  $ V20: logi  NA NA NA NA NA NA ...
```

Os dados lidos não incluíram a linha de cabeçalho com os nomes das variáveis. Nós pulamos essa linha porque o nome das variáveis está de acordo como número de colunas do arquivo. Então se tentarmos ler um arquivo de dados que contém linhas com número de registros diferentes ocorrerá um erro pois os dados não são tabulares. 

Outro aspecto nos dados lidos é que aparecem vários `<NA>`, que é o símbolo para dados do tipo `character` faltantes. A razão dos terem sido interpretados dessa forma deve-se a um caractere (`</pre>`) encontrado na última linha do arquivo. 

Para que os dados numéricos não sejam interpretados como caractere nós poderíamos executar a função `read.table(..., nrows = 5878)`, que ignoraria a última linha do arquivo e os dados seriam interpretados como `numeric`.


```r
x1 <- read.csv2(file=bdmep_dest_file, 
               header = FALSE, 
               skip = 16,
               stringsAsFactors = FALSE,
               dec = ".",
               na.strings = "",
               nrows = 5878 
)
head(x1)
#>      V1         V2   V3   V4   V5   V6   V7   V8 V9   V10 V11 V12 V13 V14
#> 1 83004 02/08/1993    0   NA   NA   NA   NA   NA NA    NA  NA  NA  NA  NA
#> 2 83004 01/01/1995    0   NA   NA   NA 26.8   NA NA    NA  NA  NA  NA 1.5
#> 3 83004 01/01/1995 1200 21.2 22.5 20.0   NA 19.5 80 924.6  NA  32   4  NA
#> 4 83004 01/01/1995 1800   NA 25.2 21.5   NA   NA 73 922.9  NA  32   2  NA
#> 5 83004 02/01/1995    0   NA 20.7 20.3 28.9   NA 97 924.2  NA   0   0 1.3
#> 6 83004 02/01/1995 1200  3.2 23.8 20.6   NA 19.9 76 924.7  NA  32   3  NA
#>   V15 V16   V17   V18      V19 V20
#> 1  NA 1.4    NA    NA       NA  NA
#> 2  NA 1.6 22.04 86.75 2.000000  NA
#> 3  10  NA    NA    NA       NA  NA
#> 4  10  NA    NA    NA       NA  NA
#> 5  10 1.1 23.32 83.00 2.666667  NA
#> 6  10  NA    NA    NA       NA  NA
str(x1)
#> 'data.frame':	5863 obs. of  20 variables:
#>  $ V1 : chr  "83004" "83004" "83004" "83004" ...
#>  $ V2 : chr  "02/08/1993" "01/01/1995" "01/01/1995" "01/01/1995" ...
#>  $ V3 : int  0 0 1200 1800 0 1200 1800 0 1200 1800 ...
#>  $ V4 : num  NA NA 21.2 NA NA 3.2 NA NA 4.4 NA ...
#>  $ V5 : num  NA NA 22.5 25.2 20.7 23.8 26.4 22 23 23.4 ...
#>  $ V6 : num  NA NA 20 21.5 20.3 20.6 21.6 21.4 21.3 22.6 ...
#>  $ V7 : num  NA 26.8 NA NA 28.9 NA NA 25.4 NA NA ...
#>  $ V8 : num  NA NA 19.5 NA NA 19.9 NA NA 20.7 NA ...
#>  $ V9 : int  NA NA 80 73 97 76 66 95 86 94 ...
#>  $ V10: num  NA NA 925 923 924 ...
#>  $ V11: num  NA NA NA NA NA NA NA NA NA NA ...
#>  $ V12: int  NA NA 32 32 0 32 32 0 0 5 ...
#>  $ V13: num  NA NA 4 2 0 3 5 0 0 3 ...
#>  $ V14: num  NA 1.5 NA NA 1.3 NA NA 0.2 NA NA ...
#>  $ V15: num  NA NA 10 10 10 10 10 10 10 10 ...
#>  $ V16: num  1.4 1.6 NA NA 1.1 NA NA 1.3 NA NA ...
#>  $ V17: num  NA 22 NA NA 23.3 ...
#>  $ V18: num  NA 86.8 NA NA 83 ...
#>  $ V19: num  NA 2 NA NA 2.67 ...
#>  $ V20: logi  NA NA NA NA NA NA ...
```

Outra alternativa seria converter as colunas de interesse (todas exceto as de 1 a 3) para `numeric` através da função `as.numeric()` usando a função `apply` ao longo das colunas:


```r
# corrigindo classe dos dados
# convertendo de character para numeric
x[, -c(1:3)] <- apply(x[,-c(1:3)], 2, as.numeric)
str(x)
#> 'data.frame':	5863 obs. of  20 variables:
#>  $ V1 : chr  "83004" "83004" "83004" "83004" ...
#>  $ V2 : chr  "02/08/1993" "01/01/1995" "01/01/1995" "01/01/1995" ...
#>  $ V3 : int  0 0 1200 1800 0 1200 1800 0 1200 1800 ...
#>  $ V4 : num  NA NA 21.2 NA NA 3.2 NA NA 4.4 NA ...
#>  $ V5 : num  NA NA 22.5 25.2 20.7 23.8 26.4 22 23 23.4 ...
#>  $ V6 : num  NA NA 20 21.5 20.3 20.6 21.6 21.4 21.3 22.6 ...
#>  $ V7 : num  NA 26.8 NA NA 28.9 NA NA 25.4 NA NA ...
#>  $ V8 : num  NA NA 19.5 NA NA 19.9 NA NA 20.7 NA ...
#>  $ V9 : num  NA NA 80 73 97 76 66 95 86 94 ...
#>  $ V10: num  NA NA 925 923 924 ...
#>  $ V11: num  NA NA NA NA NA NA NA NA NA NA ...
#>  $ V12: num  NA NA 32 32 0 32 32 0 0 5 ...
#>  $ V13: num  NA NA 4 2 0 3 5 0 0 3 ...
#>  $ V14: num  NA 1.5 NA NA 1.3 NA NA 0.2 NA NA ...
#>  $ V15: num  NA NA 10 10 10 10 10 10 10 10 ...
#>  $ V16: num  1.4 1.6 NA NA 1.1 NA NA 1.3 NA NA ...
#>  $ V17: num  NA 22 NA NA 23.3 ...
#>  $ V18: num  NA 86.8 NA NA 83 ...
#>  $ V19: num  NA 2 NA NA 2.67 ...
#>  $ V20: num  NA NA NA NA NA NA NA NA NA NA ...
# razão dos avisos
#as.numeric("NA")
```

Mas e o nome das variáveis? Nós ignoramos a linha de cabeçalho por que nos dados do INMET ocorre uma variável denominada `VelocidadeVentoInsolacao`. Essa *string* deveria ser separada em duas. Vamos fazer essa adequação aos dados.


```r
# lendo somente o nome das variaveis
vnames <- read.csv2(file=bdmep_dest_file, 
                    header = FALSE, 
                    skip = 15,
                    stringsAsFactors = FALSE,
                    dec = ".",
                    na.strings = "",
                    nrows = 1)
# convertendo de dataframe para vetor
vnames <- c(t(vnames))
vnames
#>  [1] "Estacao"                   "Data"                     
#>  [3] "Hora"                      "Precipitacao"             
#>  [5] "TempBulboSeco"             "TempBulboUmido"           
#>  [7] "TempMaxima"                "TempMinima"               
#>  [9] "UmidadeRelativa"           "PressaoAtmEstacao"        
#> [11] "PressaoAtmMar"             "DirecaoVento"             
#> [13] "VelocidadeVentoInsolacao"  "Nebulosidade"             
#> [15] "Evaporacao Piche"          "Temp Comp Media"          
#> [17] "Umidade Relativa Media"    "Velocidade do Vento Media"
#> [19] NA
# número de variáveis é diferente do número de colunas do arquivo
length(vnames) == ncol(x)
#> [1] FALSE
# corrigindo nomes das variaveis
#   substitui "VelocidadeVentoInsolacao" por "VelocidadeVento"
vnames[13] <- "VelocidadeVento"
# acresenta na 14a posição dos nomes a variável "insolacao" e
# desloca os elementos orginais do vetor 
vnames <- c(vnames[1:13], "insolacao", vnames[14:length(vnames)])
length(vnames)
#> [1] 20
ncol(x)
#> [1] 20
names(x) <- vnames
head(x)
#>   Estacao       Data Hora Precipitacao TempBulboSeco TempBulboUmido
#> 1   83004 02/08/1993    0           NA            NA             NA
#> 2   83004 01/01/1995    0           NA            NA             NA
#> 3   83004 01/01/1995 1200         21.2          22.5           20.0
#> 4   83004 01/01/1995 1800           NA          25.2           21.5
#> 5   83004 02/01/1995    0           NA          20.7           20.3
#> 6   83004 02/01/1995 1200          3.2          23.8           20.6
#>   TempMaxima TempMinima UmidadeRelativa PressaoAtmEstacao PressaoAtmMar
#> 1         NA         NA              NA                NA            NA
#> 2       26.8         NA              NA                NA            NA
#> 3         NA       19.5              80             924.6            NA
#> 4         NA         NA              73             922.9            NA
#> 5       28.9         NA              97             924.2            NA
#> 6         NA       19.9              76             924.7            NA
#>   DirecaoVento VelocidadeVento insolacao Nebulosidade Evaporacao Piche
#> 1           NA              NA        NA           NA              1.4
#> 2           NA              NA       1.5           NA              1.6
#> 3           32               4        NA           10               NA
#> 4           32               2        NA           10               NA
#> 5            0               0       1.3           10              1.1
#> 6           32               3        NA           10               NA
#>   Temp Comp Media Umidade Relativa Media Velocidade do Vento Media NA
#> 1              NA                     NA                        NA NA
#> 2           22.04                  86.75                  2.000000 NA
#> 3              NA                     NA                        NA NA
#> 4              NA                     NA                        NA NA
#> 5           23.32                  83.00                  2.666667 NA
#> 6              NA                     NA                        NA NA
```

Finalmente vamos escrever os dados do INMET corretamente organizados.


```r
bdmep_dest_file_clean <- file.path(tempdir(), "83004_clean.txt")
write.csv2(x,
           file = bdmep_dest_file_clean, 
           na = "-9999",
           row.names = FALSE)
```


### Arquivos formatados com largura fixa

Alguns arquivos texto com dados tabulares podem não conter separadores (para p.ex. economizar espaço de disco). Outros arquivos podem ser formatados usando largura fixa para reservar o espaço de cada variável, o que aumenta a legibilidade dos dados em editor de texto. 

Nesses casos a função `read.fwf()` é conveniente. Vamos usar como exemplo o arquivo de dados do Índice de Oscilação Sul (SOI) obtido no site do [National Weather Service - Climate Prediction Center (NWS-CPC)](http://www.cpc.ncep.noaa.gov).


```r
# link para os dados do SOI
noaa_url_file <- "http://www.cpc.ncep.noaa.gov/data/indices/soi"
```

Abrindo o link dos dados no navegador para visualização dos dados.


```r
browseURL(url = noaa_url_file)
```

Leitura dos dados: 


```r
#soi <- read.fwf(file = link,                           # nome do arquivo ou link
soi <- read.fwf(file = noaa_url_file,                       # sem internet, usar esse arquivo
                skip = 4,                               # pula 4 linhas
                header = FALSE,                             # sem cabeçalho
                nrows = 70,                             # num. de linhas
                widths = c(4, rep(6,12)),                # largura dos campos das variáveis
                na.strings = "-999.9",                  # string para dados faltantes
                col.names = scan(noaa_url_file,             # varredura do arquivo
                #col.names = scan(link,             # varredura do arquivo
                                 what = "character",    # tipo dos dados a serem lidos
                                 skip = 3,              # pula 3 linhas
                                 nmax = 13)             # num. max de registros a serem lidos
                )
head(soi)
#>   YEAR  JAN  FEB  MAR  APR  MAY JUN  JUL  AUG  SEP  OCT  NOV  DEC
#> 1 1951  2.5  1.5 -0.2 -0.5 -1.1 0.3 -1.7 -0.4 -1.8 -1.6 -1.3 -1.2
#> 2 1952 -1.5 -1.0  0.9 -0.4  1.2 1.2  0.8  0.1 -0.4  0.6  0.0 -2.0
#> 3 1953  0.5 -0.8 -0.3  0.3 -2.8 0.2  0.0 -2.0 -2.1  0.1 -0.5 -0.8
#> 4 1954  1.1 -0.5  0.4  1.1  0.8 0.2  0.7  1.8  0.3  0.4  0.2  2.3
#> 5 1955 -0.9  3.1  1.1 -0.2  1.7 2.2  2.6  2.4  2.2  2.5  2.0  1.6
#> 6 1956  2.2  2.7  2.2  1.5  2.3 1.8  1.8  2.0  0.1  2.9  0.2  1.8
```

Vamos alterar a estrutura dos dados: ao invés dos dados serem distribuídos ao longo das colunas, vamos estruturá-los como série temporal, ou seja cada valor mensal corresponderá a uma linha. 


```r
# converte a matriz de dados para um vetor (em sequencia cronológica)
soi_v <- c(t(soi[, -1]))
# criando um dataframe com valores de SOI, mes e ano
soi_df <- data.frame(ano = rep(soi$YEAR, each = 12),
                     mes = rep(1:12, length(soi[,1])),
                     soi = soi_v)
# escrevendo dados SOI em um arquivo CSV
soi_csv_file <- file.path(tempdir(), "SOI.csv")
write.csv(x = soi_df, 
          file = soi_csv_file, 
          na = "-999.9", 
          row.names = FALSE)
```

Vamos ler os dados reestruturados que foram salvos no formato [csv](http://en.wikipedia.org/wiki/Comma-separated_values) usando uma função que permite a escolha do arquivo de forma iterativa.


```r
# leitura de dados com escolha interativa do arquivo
soi.df <- read.csv(file = file.choose(),
                   # file.choose só é válido em sistema *unix
                   # no windows é choose.file()
                   header = TRUE,
                   na.strings = "-999.9")
```

Navegue até o diretório do arquivo `SOI.csv` e clique duas vezes sobre ele.


```r
soi.df <- read.csv(file = soi_csv_file,
                   header = TRUE,
                   na.strings = "-999.9")
```


```r
head(soi.df)
#>    ano mes  soi
#> 1 1951   1  2.5
#> 2 1951   2  1.5
#> 3 1951   3 -0.2
#> 4 1951   4 -0.5
#> 5 1951   5 -1.1
#> 6 1951   6  0.3
str(soi.df)
#> 'data.frame':	840 obs. of  3 variables:
#>  $ ano: int  1951 1951 1951 1951 1951 1951 1951 1951 1951 1951 ...
#>  $ mes: int  1 2 3 4 5 6 7 8 9 10 ...
#>  $ soi: num  2.5 1.5 -0.2 -0.5 -1.1 0.3 -1.7 -0.4 -1.8 -1.6 ...
```

A função `read.fortran()` é uma função similar à `read.fwf()` e permite usar especificações de colunas no estilo [Fortran](http://en.wikipedia.org/wiki/Fortran).


