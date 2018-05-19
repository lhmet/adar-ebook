# Entrada e saída de dados {#io}





O <img src="images/logo_r.png" width="20"> é capaz de importar dados de uma diversidade de fontes, formatos e tamanhos. Neste capítulo será visto como importar e exportar dados nos formatos mais comuns em aplicações ambientais, como: 

- dados retangulares armazenados em arquivos de texto puro
- dados binários e netCDF
- dados espaciais em formato GIS

Nós estamos em uma era digital e a quantidade de dados disponíveis na internet está aumentando monstruosamente. Para você estar preparado para o futuro, além de aprender como importados arquivos locais, veremos também como baixar e importar dados da *web*.

Serão utilizados diversos pacotes para lidar com os diferentes formatos de dados. Iremos começar com o pacote **rio** que permite importar uma diversidade de tipos de dados com muita facilidade. Arquivos texto com valores separados por vírgula (*CSV*) serão tratados com os pacotes **readr** e **data.table**. Dados em formato texto puro tem desvantagens e por isso veremos também formatos binários, entre eles, as funções nativas do R (`readRDS()`, `load()`) e funções de pacotes específicos para importar arquivos no formato netCDF.


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

Antes de lidar com arquivos locais, você precisa conhecer o seu diretório de trabalho; o local para o qual sua sessão do R importará ou exportará dados por *default*.

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

Dados armazenados em um arquivo de [texto puro ou simples](https://pt.wikipedia.org/wiki/Texto_simples) podem ser facilmente importados no R. 

Como o computador só armazena bits, o texto do arquivo que está na nossa linguagem escrita precisa ser convertido em [bits](https://pt.wikipedia.org/wiki/Bit). Essa conversão é feita por meio de um esquema codificação ou simplesmente codificação. Tradicionalmente a codificação mais usada era o [ASCII](http://pt.wikipedia.org/wiki/ASCII]) (Padrão Americano de Codificação para Intercâmbio de Informação) de 8 bits (ou 1 *byte*) que codifica um conjunto de 128 sinais (letras, números, sinais de pontuação e símbolos matemáticos) da língua Inglesa. Por exemplo a letra R corresponde a seguinte sequência 01010010.

Da necessidade de representar caracteres de outras línguas surgiram [várias outras codificações](http://en.wikipedia.org/wiki/Character_encoding#Common_character_encodings). O [ISO 8859-1](https://en.wikipedia.org/wiki/ISO/IEC_8859-1) ou *Latin 1* é um exemplo de codificação de 8 bits que permite 256 sinais diferentes, usada nas Americas, Oeste da Europa, Oceania e grande parte da África. 
Text is represented on computers by sequences of bytes;
An encoding is used to map sequences of bytes to the written language it represents;
The unicode standard is an effort to map written language to a single, standardized encoding;
UTF-8 is the most common way of encoding unicode characters, but it is not the only way.


O formato mais comum de armazenar dados é o retangular, ou seja, uma tabela de dados com as observações ao longo das linhas e as variáveis ao longo das colunas. As vezes as variáveis são referentes a locais diferentes em cada linha.

Os valores de cada coluna de uma linha são separados por um caractere separador: vírgula, espaço, tab e etc; as linhas são separadas por quebras de linha (`\n` no Linux, `\r\n` no Windows).

- - -

https://leb-fmvz-usp.gitbooks.io/manipulacao-e-visualizacao-de-dados-no-r/content/04-arquivos.html

Embora seja possível especificar a **codificação latin1** para reconhecer caracteres do português, é preferível evitar caracteres especiais nos bancos de dados.

http://kunststube.net/encoding/

https://integrada.minhabiblioteca.com.br/books/9788577808625/pageid/271

## Arquivos binários 

Arquivo texto favorecem a legibilidade humana dos dados mas tem limitada precisão numérica limitada. Formatos binários diminuem substancialmente o tamanho, o tempo de leitura e escrita de arquivos. Por isso, vários softwares armazenam dados no formato binário.




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





```r
library(data.table)
myDT <- data.table(x = c('a', 'b', 'c', 'd', 'e'),
                   y = c(1, 2, 3, 4, 5))
# Cria um data.table com vetores A, B, C
A <- c(1, 2, 3, 4, 5)
B <- c('a', 'b', 'c', 'd', 'e')
C <- c(6, 7, 8, 9, 10)
DT <- data.table(a = A, b = B, c = C)
DT
#>    a b  c
#> 1: 1 a  6
#> 2: 2 b  7
#> 3: 3 c  8
#> 4: 4 d  9
#> 5: 5 e 10
```

<div id="left">
**`DT[ , nome_col]`**

```r
DT[ , b]
#> [1] "a" "b" "c" "d" "e"
class(DT[ , b])
#> [1] "character"
is.vector(DT[ , b])
#> [1] TRUE
```
</div>
<div id="right">
**`DT[ , .(nome_col)]`**

```r
DT[ , .(b)]
#>    b
#> 1: a
#> 2: b
#> 3: c
#> 4: d
#> 5: e
class(DT[ , .(b)])
#> [1] "data.table" "data.frame"
```
</div>


## Para saber mais

Para uma descrição mais abrangente sobre importação e exportação de dados no <img src="images/logo_r.png" width="20"> consulte o manual [R Data Import/Export](http://cran.r-project.org/doc/manuals/r-release/R-data.html) e a documentação de ajuda das funções citadas naquele documento.

