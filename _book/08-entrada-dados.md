# Entrada e saída de dados {#io}



O <img src="images/logo_r.png" width="20"> é capaz de importar dados de uma diversidade de fontes, formatos e tamanhos. Neste capítulo será visto como importar dados nos formatos mais comuns em aplicações ambientais, como: 

- dados tabulares armazenados em arquivos texto ([ASCII](https://pt.wikipedia.org/wiki/ASCII))
- arquivos de dados meteorológicos de agências brasileiras
- dados binários e netCDF
- dados espaciais em formato GIS

Serão utilizados diversos pacotes para lidar com os diferentes formatos de dados. Iremos começar com o pacote **rio** que permite importar com facilidade uma diversidade de tipos de dados. Arquivos CSV serão tratados com os pacotes **readr** e **data.table**. Formatos binários diminuem substancialmente o tamanho, o tempo de leitura e escrita de arquivos. Entre os formatos binários, veremos funções nativas do R (`readRDS()`, `load()`) e funções de pacotes específicos para importar arquivos no formato netCDF.

## Pré-requisitos

Para reproduzir os códigos deste capítulo você precisará dos seguintes pacotes:


```r
pacotes <- c("easypackages","rio", "readr", "feather") 
```

Para instalá-los já com as dependências utilize a instrução abaixo:


```r
install.packages(
   pacotes,
   dependencies = TRUE
)
```

Agora você pode carregar os pacotes.


```r
library("easypackages")
library("rio")
library("readr")
```


<div class="rmdtip">
<p>Para carregar diversos pacotes de uma vez só, você pode usar a função <code>libraries()</code> do pacote <strong>easypackages</strong>. Então o trecho de código anterior poderia ser substituído por:</p>
<p><code>library(easypackages)</code></p>
<p><code>libraries(pacotes)</code></p>
<p>ou simplesmente</p>
<p><code>easypackages::libraries(pacotes)</code></p>
</div>



## Diretório de trabalho

Antes de lidar com arquivos, você precisa conhecer o seu diretório de trabalho; o local para o qual sua sessão do R importará ou exportará dados por *default*.

O <img src="images/logo_r.png" width="20"> possui uma variedade de funções para se obter informações do sistema, como arquivos, diretórios, e etc. Uma informação importante é diretório de trabalho atual. 

Importar ou exportar dados é mais fácil quando você não precisa digitar caminhos longos de diretórios para os arquivos. Por isso, quando abrimos uma sessão no <img src="images/logo_r.png" width="20">, ela é vinculada a um diretório de trabalho (*working directory*, `wd`). A função `getwd()` retorna o diretório de trabalho da sua sessão do <img src="images/logo_r.png" width="20">.


```r
getwd()
```

O local *default* geralmente é o home do usuário \"/home/usuario\" no linux e \"C:\\Usuarios\\usuario\\" no Windows. Você obtém essa informação com a instrução abaixo:


```r
Sys.getenv("HOME")
```

É neste local onde o <img src="images/logo_r.png" width="20"> e o RStudio irão salvar gráficos, documentos, ler e escrever dados,  quando você não especificar o caminho completo para o arquivo de saída.

Ocasionalmente pode ser conveniente alterar seu `wd` e para isso você pode usar a função `setwd()`.


```r
wd <- getwd()
# define o wd em "/home/user"
setwd("~/Documents")
getwd()
# volta para o wd original
setwd(wd)
getwd()
```

<div class="rmdtip">
<p>Você pode configurar o diretório de trabalho pelo menu do Rstudio <em>Session &gt; Set Working Directory</em>. Você terá as opções:</p>
<ul>
<li><p><em>To Source File Location</em>: definirá o diretório de trabalho como o mesmo do arquivo atualmente aberto no RStudio</p></li>
<li><p><em>To Files Pane Location</em>: definirá o diretório de trabalho como aquele atualmente aberto no painel de arquivos</p></li>
<li><p><em>To Files Pane Location</em>: definirá o diretório de trabalho como o mesmo do projeto atualmente aberto no RStudio</p></li>
<li><p><em>Choose Directory</em>: permite você navegar até o diretório de interesse</p></li>
</ul>
</div>

O conteúdo de um diretório pode ser listado com a função `dir()`, ou se estiver usando o Rstudio você pode clicar na aba *Files* do painel de direito inferior e depois em *More > Go To Working Directory*.


## Arquivos texto

Dados armazenados em um arquivo texto (do tipo [ASCII](http://pt.wikipedia.org/wiki/ASCII])) podem ser facilmente importados no R.

O formato mais comum de armazenar dados é o retangular, ou seja, uma tabela de dados com as observações ao longo das linhas e as variáveis ao longo das colunas. 

Os valores de cada coluna de uma linha são separados por um caractere separador: vírgula, espaço, tab e etc; as linhas são separadas por quebras de linha (`\n` no Linux ou `\r\n` no Windows).


## Arquivos binários 


Existem diversas funções nativas do R para ler este formato de dados.

versão completa da tabela na [vinheta do pacote **rio**](https://cran.r-project.org/web/packages/rio/vignettes/rio.html)

| Formato | Extensão | Pacote de importação | Pacote de exportação | Instalado por *default* |
| ------ | --------- | -------------- | -------------- | -------------------- |
| Valores separados por vírgula | .csv | [**data.table**](https://cran.r-project.org/package=data.table) | [**data.table**](https://cran.r-project.org/package=data.table) | Sim |
| dados separados por tab | .tsv | [**data.table**](https://cran.r-project.org/package=data.table) | [**data.table**](https://cran.r-project.org/package=data.table) | Sim |
| Excel | .xls | [**readxl**](https://cran.r-project.org/package=readxl) |  | Sim |
| Excel | .xlsx | [**readxl**](https://cran.r-project.org/package=readxl) | [**openxlsx**](https://cran.r-project.org/package=openxlsx) | Sim |
| script R | .R | **base** | **base** | Sim |
| objetos salvos no R | .RData, .rda | **base** | **base** | Sim |
| objetos do R serializados | .rds | **base** | **base** | Sim |
| dados Fortran | Sem extensão reconhecida | **utils** |  | Sim |
| Formato de dados com largura fixa | .fwf | **utils** | **utils** | Sim |
| dados separados por vírgula compactados com gzip | .csv.gz | **utils** | **utils** | Sim |
| Feather R/Python interchange format | .feather | [**feather**](https://cran.r-project.org/package=feather) | [**feather**](https://cran.r-project.org/package=feather) | Não |
| Armazenamento rápido (Fast Storage) | .fst | [**fst**](https://cran.r-project.org/package=fst) | [**fst**](https://cran.r-project.org/package=fst) | Não |
| JSON | .json | [**jsonlite**](https://cran.r-project.org/package=jsonlite) | [**jsonlite**](https://cran.r-project.org/package=jsonlite) | Não |
| Matlab | .mat | [**rmatio**](https://cran.r-project.org/package=rmatio) | [**rmatio**](https://cran.r-project.org/package=rmatio) | Não |
| Planilha OpenDocument | .ods | [**readODS**](https://cran.r-project.org/package=readODS) | [**readODS**](https://cran.r-project.org/package=readODS) | Não |
| tabelas HTML | .html | [**xml2**](https://cran.r-project.org/package=xml2) | [**xml2**](https://cran.r-project.org/package=xml2) | Não |
| documentos XML | .xml | [**xml2**](https://cran.r-project.org/package=xml2) | [**xml2**](https://cran.r-project.org/package=xml2) | Não |
| YAML | .yml | [**yaml**](https://cran.r-project.org/package=yaml) | [**yaml**](https://cran.r-project.org/package=yaml) | Não |
| Área de transferência | *default* é tsv | [**clipr**](https://cran.r-project.org/package=clipr) | [**clipr**](https://cran.r-project.org/package=clipr) | Não |
| [planilhas Google](https://www.google.com/sheets/about/) | como valores separados por vírgula |  |  |  |

**A função mais importante para leitura de dados de um arquivo texto é a `read.table()` que  armazena os dados no formato de uma dataframe**. Essa função possui diversos parâmetros para ajustar a importação de acordo com as peculiaridades do formato de dados do arquivo. O valor *default* do parâmetro `sep` é um ou mais caracteres de `espaço` e `tabs`. Devido as diversas opções de separadores existem outras funções essencialmente iguais a `read.table()` com a diferença no separador, por exemplo as funções: `read.csv(), read.csv2(), read.delim()` usam como o argumento separador `,`, `;` e `\t` . Para detalhes sobre essas funções o *help* de cada uma. Uma vez que essas funções aceitam qualquer argumento da `read.table()` elas são mais convenientes que usar a `read.table()` e configurar os argumentos apropriados manualmente.


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

Para arquivos de tamanho moderado a pequeno essa forma de especificar os argumentos funciona satisfatoriamente. Vamos ver alguns exemplos de leitura de dados hidrometeorológicos no formato texto amplamente usados em aplicações da Meteorologia.


### Arquivos textos de bases de dados hidrometeorológicos brasileiras

#### [hidroweb-ANA](http://hidroweb.ana.gov.br/)



```r
# arquivo de exemplo disponível no GitHub
file_hidroweb <- "https://raw.github.com/lhmet/adar-ufsm/master/data/CHUVAS.TXT"
```



```r
# definindo interpretação de caracteres: caracteres não devem ser tratados como fatores
options(stringsAsFactors = FALSE)
# leitura de dados pluviométricos diários da ANA
dprec <- read.csv2(file = file_hidroweb, 
                   skip = 15, 
                   head = TRUE, 
                   fill = TRUE)
# primeiras linhas
head(dprec)
# últimas linhas
tail(dprec)
 # corrigindo nome da primeira coluna
 names(dprec)[1] <- "EstacaoCodigo"
 # removendo última coluna que só tem NAs
 dprec <- dprec[ , -ncol(dprec)]
  # estrutura dos dados
  str(dprec)
# Fazendo a mesma leitura com read.table
dprec2 <- read.table(file = "data/CHUVAS.TXT", 
                   skip = 15, 
                   head = T, 
                   stringsAsFactors = FALSE,
                   fill = T,
                   sep = ";",
                   dec = ",")
head(dprec2)
```



### [BDMEP-INMET](http://www.inmet.gov.br/portal/index.php?r=bdmep/bdmep)


```r
x <- read.csv2(file = "data/83004.txt", 
               header = FALSE, 
               skip = 16,
               stringsAsFactors = FALSE,
               na.strings = ""
               )
head(x)
str(x)
```

Os dados lidos não incluíram a linha de cabeçalho com os nomes das variáveis. Nós pulamos essa linha porque o nome das variáveis está de acordo como número de colunas do arquivo. Então se tentarmos ler um arquivo de dados que contém linhas com número de registros diferentes ocorrerá um erro pois os dados não são tabulares. 

Outro aspecto nos dados lidos é que aparecem vários `<NA>`, que é o símbolo para dados do tipo `character` faltantes. A razão dos terem sido interpretados dessa forma deve-se a um caractere (`</pre>`) encontrado na última linha do arquivo. Digite na linha de um terminal linux o comando:

    tail data/83004.txt 
    
para imprimir na tela apenas a parte final do arquivo. 
Para que os dados numéricos não sejam interpretados como caractere nós poderíamos executar a função `read.table(..., nrows = 5878)`, que ignoraria a última linha do arquivo e os dados seriam interpretados como `numeric`.


```r
x1 <- read.csv2(file="data/83004.txt", 
               header = FALSE, 
               skip = 16,
               stringsAsFactors = FALSE,
               dec = ".",
               na.strings = "",
               nrows = 5878              
)
head(x1)
str(x1)
```

Outra alternativa seria converter as colunas de interesse (todas exceto as de 1 a 3) para `numeric` através da função `as.numeric()` usando a função `apply` ao longo das colunas:


```r
# corrigindo classe dos dados
# convertendo de character para numeric
x[, -c(1:3)] <- apply(x[,-c(1:3)], 2, as.numeric)
str(x)
# razão dos avisos
as.numeric("NA")
```

Mas e o nome das variáveis?

Nós ignoramos a linha de cabeçalho por que nos dados do INMET ocorre uma variável denominada `VelocidadeVentoInsolacao`. Essa *string* deveria ser separada em duas.


```r
# lendo somente o nome das variaveis
vnames <- read.csv2(file="data/83004.txt", 
                    header = FALSE, 
                    skip = 15,
                    stringsAsFactors = FALSE,
                    dec = ".",
                    na.strings = "",
                    nrows = 1)
vnames
# convertendo de dataframe para vetor
vnames <- c(t(vnames))
# número de variáveis é diferente do número de colunas do arquivo
length(vnames) == ncol(x)
# corrigindo nomes das variaveis
#   substitui "VelocidadeVentoInsolacao" por "VelocidadeVento"
vnames[13] <- "VelocidadeVento"
# acresenta na 14a posição dos nomes a variável "insolacao" e
# desloca os elementos orginais do vetor 
vnames <- c(vnames[1:13], "insolacao", vnames[14:length(vnames)])
length(vnames)
ncol(x)
names(x) <- vnames
head(x)
```

Finalmente vamos escrever os dados do INMET corretamente organizados.


```r
write.csv2(x,
           file = "data/83004_clean.txt", 
           na = "-9999",
           row.names = FALSE)
```


### Arquivos formatados com largura fixa

Alguns arquivos texto com dados tabulares podem não conter separadores (para p.ex. economizar espaço de disco). Outros arquivos podem ser formatados usando largura fixa para reservar o espaço de cada variável, o que facilita a legibilidade dos dados. Nesses casos usamos a função `read.fwf()`. Vamos usar como exemplo o arquivo de dados do Índice de Oscilação Sul (SOI) obtido no site do [National Weather Service - Climate Prediction Center (NWS-CPC)](http://www.cpc.ncep.noaa.gov).


```r
# link para os dados do SOI
link <- "http://www.cpc.ncep.noaa.gov/data/indices/soi"
```

Abrindo o link dos dados no navegador para visualização do formato.


```r
browseURL(url = link)
```

Leitura dos dados: 


```r
#soi <- read.fwf(file = link,                           # nome do arquivo ou link
soi <- read.fwf(file = "data/SOI.txt",                       # sem internet, usar esse arquivo
                skip = 4,                               # pula 4 linhas
                header = FALSE,                             # sem cabeçalho
                nrows = 70,                             # num. de linhas
                widths = c(4, rep(6,12)),                # largura dos campos das variáveis
                na.strings = "-999.9",                  # string para dados faltantes
                col.names = scan("data/SOI.txt",             # varredura do arquivo
                #col.names = scan(link,             # varredura do arquivo
                                 what = "character",    # tipo dos dados a serem lidos
                                 skip = 3,              # pula 3 linhas
                                 nmax = 13)             # num. max de registros a serem lidos
                )
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
write.csv(x = soi_df, 
          file = "data/SOI.csv", 
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

Clique duas vezes sobre o arquivo `SOI.csv`.


```r
soi.df <- read.csv(file = "data/SOI.csv",
                   header = TRUE,
                   na.strings = "-999.9")
```


```r
head(soi.df)
str(soi.df)
```

A função `read.fortran()` é uma função similar à `read.fwf()` e permite usar especificações de colunas no estilo [Fortran](http://en.wikipedia.org/wiki/Fortran).








## Para saber mais

Para uma descrição mais abrangente sobre importação e exportação de dados no <img src="images/logo_r.png" width="20"> consulte o manual [R Data Import/Export](http://cran.r-project.org/doc/manuals/r-release/R-data.html) e a documentação de ajuda das funções citadas naquele documento.

