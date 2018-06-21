# Entrada e saída de dados {#io}




O <img src="images/logo_r.png" width="20"> é capaz de importar dados de uma diversidade de fontes, formatos e tamanhos. Neste capítulo será visto como importar e exportar dados nos formatos mais comuns em aplicações ambientais, como: 

- dados retangulares armazenados em arquivos de texto puro
- dados binários e netCDF
- dados espaciais em formato GIS

Nós estamos em uma era digital e a quantidade de dados disponíveis na internet está aumentando monstruosamente. Para você estar preparado para o futuro, além de aprender como importar arquivos locais, veremos também como baixar e importar dados da *web*.

Serão utilizados diversos pacotes para lidar com os diferentes formatos de dados. Começaremos com o pacote **rio** que permite importar uma diversidade de tipos de dados com muita facilidade.

Arquivos texto com valores separados por vírgula (*CSV*) serão tratados com os pacotes **readr** e **data.table**. Dados em formato texto puro tem desvantagens e por isso também veremos formatos binários, entre eles, as funções nativas do R (`readRDS()`, `load()`) e funções de pacotes específicos para importar arquivos no formato netCDF.

## Pré-requisitos

Para reproduzir os códigos deste capítulo você precisará dos seguintes pacotes:


```r
pacotes <- c(
  "easypackages",
  "rio",
  "readr",
  "feather",
  "readxl",
  "writexl",
  "dplyr",
  "microbenchmark",
  "openxlsx"
)
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
library("writexl")
library("dplyr")
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library("microbenchmark")
library("openxlsx")
```


<div class="rmdtip">
<p>Para carregar diversos pacotes de uma vez só, você pode usar a função <code>libraries()</code> do pacote <strong>easypackages</strong>. Então o trecho de código anterior poderia ser substituído por:</p>
<p><code>library(easypackages)</code></p>
<p><code>libraries(pacotes)</code></p>
<p>ou simplesmente</p>
<p><code>easypackages::libraries(pacotes)</code></p>
</div>

Para ter acesso a todos pacotes suportados pelo pacote **rio**, após sua instalação precisamos executar o comando abaixo.


```r
install_formats()
```




## Diretório de trabalho

Antes de lidar com arquivos locais, você precisa conhecer o seu diretório de trabalho; o local para o qual sua sessão do R importará ou exportará dados por *default*.

O <img src="images/logo_r.png" width="20"> possui uma variedade de funções para se obter informações do sistema, como arquivos, diretórios, e etc. Uma informação importante é diretório de trabalho atual. 

Importar ou exportar dados é mais fácil quando você não precisa digitar caminhos longos de diretórios para os arquivos. Por isso, quando abrimos uma sessão no <img src="images/logo_r.png" width="20">, ela é vinculada a um diretório de trabalho (*working directory*, `wd`). A função `getwd()` retorna o diretório de trabalho da sua sessão do <img src="images/logo_r.png" width="20">.


```r
getwd()
```

O local *default* geralmente é o home do usuário \"/home/usuario\" no linux e \"C:\\Users\\usuario\\" no Windows. Você obtém essa informação com a instrução abaixo:


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

## Boas práticas para importação e exportação de dados

Para uma importação e exportação eficiente de dados recomenda-se [@Gillespie2017]:

>1. Mantenha o nome original dos arquivos locais baixados da internet ou copiados da fonte provedora. Isso o ajudará a rastrear a proveniência dos dados no futuro.  
2. Para um armazenamento eficinte utilize o formato binário nativo do R *.Rds* para importar (`readRDS()`) e exportar (`saveRDS()`) dados processados.  
3. Use funções equivalentes a read.table() dos pacotes **readr** ou **data.table** para importar arquivos de texto grandes.  
4. Use as funções `file.size()` e `object.size()` para saber o tamanho de arquivos e objetos no R e analisar como proceder se eles ficarem muito grandes.  

## Arquivos texto

Dados armazenados em um arquivo de [texto puro ou simples](https://pt.wikipedia.org/wiki/Texto_simples) podem ser facilmente importados no R. 

O formato mais comum de armazenar dados é o retangular, ou seja, uma tabela de dados com as observações ao longo das linhas e as variáveis ao longo das colunas. As vezes as variáveis são referentes a locais diferentes em cada linha.


Os valores de cada coluna de uma linha são separados por um caractere separador: vírgula, espaço, tab e etc; as linhas são separadas por quebras de linha (`\n` no Linux, `\r\n` no Windows).

Dados em arquivo texto podem conter caracteres latinos, como palavras com acentos no caso do Português. Para lidar com esta peculiaridade, as funções de importação de dados, possuem um argumento relacionado a codificação (*encoding*) dos caracteres. Arquivos texto em Português geralmente usam a codificação [ISO 8859-1](https://pt.wikipedia.org/wiki/ISO/IEC_8859-1) ou equivalente *Latin1*. Portanto, para importação com formatação correta de caracteres latinos a especificação com esta codificação deve ser explícita.

O R utiliza o alfabeto [Unicode](https://pt.wikipedia.org/wiki/Unicode) para identificação de caracteres. Para associação unívoca de cada caractere (de mais 1 milhão de caracteres do alfabeto Unicode) a uma sequência de bits, o R usa o esquema de codificação [UTF-8](https://pt.wikipedia.org/wiki/UTF-8). Assim, recomenda-se utilizar essa codificação de caracteres como padrão em seus códigos e na construção e aquisição de dados. No RStudio a especificação da codificação de caracteres pode ser feita através do menu: *Tools > Global Options > Code > Saving > Default Text Encoding*.





### **rio** {#Rio}

O pacote [rio](https://cran.r-project.org/web/packages/rio/vignettes/rio.html), nas palavras do próprio autor do pacote é  \"um canivete suíço para entrada e saída de dados\" nos formatos mais frequentemente usados.

A grande funcionalidade do **rio** é simplificar estes processos que podem confundir a cabeça de quem  está aprendendo R, devido a vastidão de opções disponíveis no <img src="images/logo_r.png" width="20"> (veja o [Manual de Importação e Exportação do R](https://cran.r-project.org/doc/manuals/r-release/R-data.htmlpara ter noção)).

Esta facilidade deve-se as premissas feitas pelo **rio** sobre o formato do arquivo. Ao importar um arquivo o pacote descobre o formato (pela extensão) e então aplica a função apropriada para ler aquele formato.

Desta forma, com o **rio**, você precisa saber duas funções para ler e escrever uma variedade de formatos de arquivos (Tabela \@ref(tab:rio-table)): `import()` e `export()`, respectivamente.

Os formatos importados e exportados pelo **rio** são apresentados na Tabela \@ref(tab:rio-table). Para uma versão completa desta tabela confira a [vinheta do pacote](https://cran.r-project.org/web/packages/rio/vignettes/rio.html).



Table: (\#tab:rio-table)Versão resumida da tabela com os formatos suportados pelo pacote **rio**.

               Formato                          Extensão                                 Pacote.de.importação                                               Pacote.de.exportação                          Instalado.por..default. 
-------------------------------------  --------------------------  -----------------------------------------------------------------  -----------------------------------------------------------------  -------------------------
    Valores separados por vírgula                 .csv              [**data.table**](https://cran.r-project.org/package=data.table)    [**data.table**](https://cran.r-project.org/package=data.table)              Sim           
       dados separados por tab                    .tsv              [**data.table**](https://cran.r-project.org/package=data.table)    [**data.table**](https://cran.r-project.org/package=data.table)              Sim           
                Excel                             .xls                  [**readxl**](https://cran.r-project.org/package=readxl)                                                                                     Sim           
                Excel                            .xlsx                  [**readxl**](https://cran.r-project.org/package=readxl)          [**openxlsx**](https://cran.r-project.org/package=openxlsx)                Sim           
         objetos salvos no R                  .RData, .rda                                     **base**                                                           **base**                                          Sim           
      objetos do R serializados                   .rds                                         **base**                                                           **base**                                          Sim           
            dados Fortran               Sem extensão reconhecida                               **utils**                                                                                                            Sim           
  Formato de dados com largura fixa               .fwf                                         **utils**                                                          **utils**                                         Sim           
 Feather R/Python interchange format            .feather               [**feather**](https://cran.r-project.org/package=feather)          [**feather**](https://cran.r-project.org/package=feather)                 Não           
 Armazenamento rápido (Fast Storage)              .fst                     [**fst**](https://cran.r-project.org/package=fst)                  [**fst**](https://cran.r-project.org/package=fst)                     Não           
                JSON                             .json                [**jsonlite**](https://cran.r-project.org/package=jsonlite)        [**jsonlite**](https://cran.r-project.org/package=jsonlite)                Não           
               Matlab                             .mat                  [**rmatio**](https://cran.r-project.org/package=rmatio)            [**rmatio**](https://cran.r-project.org/package=rmatio)                  Não           
        Planilha OpenDocument                     .ods                 [**readODS**](https://cran.r-project.org/package=readODS)          [**readODS**](https://cran.r-project.org/package=readODS)                 Não           
            tabelas HTML                         .html                    [**xml2**](https://cran.r-project.org/package=xml2)                [**xml2**](https://cran.r-project.org/package=xml2)                    Não           
           documentos XML                         .xml                    [**xml2**](https://cran.r-project.org/package=xml2)                [**xml2**](https://cran.r-project.org/package=xml2)                    Não           
        Área de transferência               *default* é tsv              [**clipr**](https://cran.r-project.org/package=clipr)              [**clipr**](https://cran.r-project.org/package=clipr)                   Não           


#### Como usar

Vamos  baixar um arquivo de dados em formato texto para importá-lo com o pacote **rio**. Os dados são de precipitação diária e foram obtidos no sistema [hidroweb](http://www.snirh.gov.br/hidroweb/publico/medicoes_historicas_abas.jsf) da [Agência Nacional das Águas](http://www.ana.gov.br/).

A extensão do arquivo é `.TXT` e não se encaixa em nenhuma das extensões esperadas pelo **rio**. Mas se você visualizar o arquivo no navegador (`browseURL(url="https://raw.github.com/lhmet/adar-ufsm/master/data/CHUVAS.TXT")`) perceberá que os dados estão estruturados como CSV2, ou seja, com valores delimitados por \";\" e o separador decimal \",\". 

Vamos então baixar o arquivo e salvá-lo em diretório temporário do computador.


```r
# arquivo de exemplo disponível no GitHub
hidroweb_url_file <- "https://raw.github.com/lhmet/adar-ufsm/master/data/CHUVAS.TXT"
# arquivo temporário, você pode substituir tempfile() 
# por um caminho de seu computador, p.ex. "~/Downloads/CHUVAS.TXT"
# caminho de destino para o aquivo baixado
# alterando a extensão de TXT para csv
(arq_temp <- tempfile())
#> [1] "/tmp/RtmpWID01A/file3b3e471681c8"
(hidroweb_dest_file <- paste0(arq_temp, ".csv"))
#> [1] "/tmp/RtmpWID01A/file3b3e471681c8.csv"
download.file(
  url = hidroweb_url_file, 
  destfile = hidroweb_dest_file
)
hidroweb_dest_file
#> [1] "/tmp/RtmpWID01A/file3b3e471681c8.csv"
```

Agora podemos importar os dados de precipitação baixados.


```r
# Importa o arquivo 
dprec <- import(hidroweb_dest_file, 
                # se fread = TRUE (default usa função fread do pacote data.table)
                fread = FALSE,  
                skip = 15, # pula linhas com metadados
                header = TRUE, # com cabeçalho
                sep = ";", # delimitador entre os valores
                dec = ",", # separador decimal
                na.strings = "") # rótulo para dados faltantes
# primeiras 10 colunas e linhas dos dados
head(dprec[, 1:10])
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
```

Para saber quais argumentos devem ser especificados na função `import()` você precisar ler a documentação de ajuda da função (`?import`), principalmente a sessão *Details*. Os argumentos usados no exemplo acima, estão implícitos no argumento da função `import()` representado pela reticência (`...`). Conforme descrito na sessão *Details*, o parâmetro `fread = FALSE` implica no uso da função `read.table()` da base do R (descrita no Apêndice \@ref(readtable)) para importar o arquivo; então a descrição dos argumentos especificados encontra-se na ajuda da função `read.table()`, facilmente acessada pelo *link* na ajuda da função `import`.


Quando os nomes dos arquivos incluem uma extensão reconhecida pelo **rio** (Tabela \@ref(tab:rio-table)), não há necesidade de especificar o argumento `format` nas funções `import()` e `export()`. O formato dos arquivos é inferido da extensão do arquivo (csv, no exemplo acima). No exemplo acima, a extensão do arquivo original do *site* é desconhecida (ex.: \".TXT\", \".dat\", etc). Nesta situação você deve especificar o formato do arquivo através do argumento `format` da `import()`.

Para exportar os dados importados anteriormente, vamos criar um nome para salvar o arquivo com a função `export()`. Vamos salvá-lo usando um formato diferente do original, como *tsv* (valores separados por *tab*), para explorar a funcionalidade do **rio**.


```r
# exporta para arquivo texto separado por tab
(arq_temp <- tempfile())
#> [1] "/tmp/RtmpWID01A/file3b3e41d56410"
(dprec_file <- paste0(arq_temp, ".tsv"))
#> [1] "/tmp/RtmpWID01A/file3b3e41d56410.tsv"
export(dprec, file = dprec_file, na = "-999")
```


#### Arquivos formatados com largura fixa {#arquivos-fwf}

Alguns arquivos texto com dados tabulares podem não conter separadores para economizar espaço de disco. Outros arquivos podem ser formatados usando largura fixa para reservar o espaço de cada variável, o que facilita a legibilidade dos dados. 

Vamos usar como exemplo o arquivo de dados do Índice de Oscilação Sul (SOI) obtido no site do [National Weather Service - Climate Prediction Center (NWS-CPC)](http://www.cpc.ncep.noaa.gov).


```r
# link para os dados do SOI
link_soi <- "http://www.cpc.ncep.noaa.gov/data/indices/soi"
```

Vamos visualizar os dados SOI no navegador para reconhecer o formato.


```r
browseURL(url = link_soi)
```

Ao inspecionar cuidadosamente os dados até o fim da página no navegador, percebe-se os seguintes aspectos sobre estes dados:

- temos duas tabelas de dados do SOI, uma de anomalias absolutas (da linha 4 até 74) e outra de anomalias normalizadas (da linha 79 à 148);

- os valores da coluna `YEAR` ocupam 4 campos (ou espaços), ou seja, vão desde a 1ª até a 4 coluna; os valores da coluna `JAN` ocupam os campos da 5ª à 10ª coluna e este padrão é repetido para as colunas restantes.

- dados faltantes são representados pelo rótulo `-999.9`

- os dados incluem os nomes das variáveis (cabeçalho)

- o cabeçalho ocupa um número de campos diferentes daqueles ocuppados pelos valores de SOI (note o sinal de menos que antecede os valores)

Nosso interesse é na 1ª tabela de dados. Uma estratégia possível de importar estes dados é começar lendo o cabeçalho.


```r
nome_vars <- scan(
    link_soi, # varredura do arquivo
    what = "character", # tipo dos dados
    skip = 3, # pula 3 linhas
    nmax = 13 # num. max. de campos a serem lidos
)
nome_vars
#>  [1] "YEAR" "JAN"  "FEB"  "MAR"  "APR"  "MAY"  "JUN"  "JUL"  "AUG"  "SEP" 
#> [11] "OCT"  "NOV"  "DEC"
```

A seguir, podemos usar o cabeçalho obtido acima, como argumento na `import()` através do argumento `col.names`. As informações da inspeção dos dados são utilizadas para definir os outros argumentos.


```r
soi <- import(
  file = link_soi,
  format = "fwf", # formato de largura fixa
  skip = 4, # pula 4 linhas
  header = FALSE, # sem cabeçalho
  nrows = 70, # num. de linhas
  widths = c(4, rep(6, 12)), # largura dos campos das variáveis
  na.strings = "-999.9", # string para dados faltantes
  col.names = nome_vars
)
str(soi)
#> 'data.frame':	70 obs. of  13 variables:
#>  $ YEAR: int  1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 ...
#>  $ JAN : num  2.5 -1.5 0.5 1.1 -0.9 2.2 1 -3.1 -1.5 0.2 ...
#>  $ FEB : num  1.5 -1 -0.8 -0.5 3.1 2.7 -0.1 -0.8 -2.3 0.2 ...
#>  $ MAR : num  -0.2 0.9 -0.3 0.4 1.1 2.2 0.3 0.4 2.1 1.7 ...
#>  $ APR : num  -0.5 -0.4 0.3 1.1 -0.2 1.5 0.4 0.6 0.7 1.3 ...
#>  $ MAY : num  -1.1 1.2 -2.8 0.8 1.7 2.3 -1.1 -0.8 0.8 0.9 ...
#>  $ JUN : num  0.3 1.2 0.2 0.2 2.2 1.8 0.3 0.5 -0.2 0.2 ...
#>  $ JUL : num  -1.7 0.8 0 0.7 2.6 1.8 0.4 0.7 -0.4 0.8 ...
#>  $ AUG : num  -0.4 0.1 -2 1.8 2.4 2 -0.8 1.5 -0.2 1.3 ...
#>  $ SEP : num  -1.8 -0.4 -2.1 0.3 2.2 0.1 -1.5 -0.5 0 1.1 ...
#>  $ OCT : num  -1.6 0.6 0.1 0.4 2.5 2.9 0.1 0.1 0.8 0.2 ...
#>  $ NOV : num  -1.3 0 -0.5 0.2 2 0.2 -1.6 -0.7 1.5 0.9 ...
#>  $ DEC : num  -1.2 -2 -0.8 2.3 1.6 1.8 -0.5 -1 1.5 1.3 ...
tail(soi)
#>    YEAR  JAN  FEB  MAR  APR  MAY  JUN  JUL  AUG  SEP  OCT  NOV  DEC
#> 65 2015 -1.4  0.4 -1.2 -0.1 -1.2 -0.9 -1.9 -2.4 -2.7 -2.8 -0.8 -0.9
#> 66 2016 -3.6 -3.2 -0.1 -2.0  0.7  1.1  0.7  1.2  2.0 -0.4 -0.2  0.5
#> 67 2017  0.3 -0.1  1.5 -0.3  0.4 -0.7  1.3  0.9  1.0  1.5  1.5 -0.2
#> 68 2018  1.8 -0.8  2.4  0.8  0.6   NA   NA   NA   NA   NA   NA   NA
#> 69 2019   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 70 2020   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
```

A documentação de ajuda da função `import()` do **rio** nos diz que no arquivo acima foi usada a função `read.fwf()` do <img src="images/logo_r.png" width="20"> para ler os dados. Os argumentos usados foram:

- `format = "fwf"` significa formato de largura fixa
- `skip = 4` especifica que os dados iniciam após as 4 primeiras linhas do arquivo
- `header = FALSE` especifica que estamos lendo diretamente os dados
- `nrows = 70` é o número de linhas lidas desde o começo dos dados, isto é, `74 - 4`.
- `widths = c(4, rep(6, 12))` especifica a largura dos campos das variáveis; 4 campos para 1ª coluna e 6 campos para as 12 colunas seguintes;
- `na.strings = "-999.9"` indica o rótulo para os dados faltantes
- `col.names = nome_vars` especifica o nome das variáveis que será usado no *data frame*.


Por fim, salvaremos as anomalias absolutas do SOI em um arquivo CSV.


```r
# nome para o arquivo CSV
(soi_file <- paste0(tempdir(), "SOI.csv"))
#> [1] "/tmp/RtmpWID01ASOI.csv"
# exportação com rio
export(soi,
  file = soi_file,
  na = "-999.9"
)
# verificar se o arquivo foi gerado
file.exists(soi_file)
#> [1] TRUE
```


Vamos importar o arquivo `SOI.csv` através da função `file.choose()` (ou `choose.file()` no Windows) que permite selecionar o arquivo de forma iterativa.


```r
# leitura de dados com escolha interativa do arquivo
soi.df <- import(file.choose(),
  # file.choose só é válido em sistema *unix
  # no windows é choose.file()
  header = TRUE,
  na.strings = "-999.9"
)
```

Navegue até o diretório do arquivo `SOI.csv` e clique duas vezes sobre o arquivo ele.




```r
head(soi.df)
#>   YEAR  JAN  FEB  MAR  APR  MAY JUN  JUL  AUG  SEP  OCT  NOV  DEC
#> 1 1951  2.5  1.5 -0.2 -0.5 -1.1 0.3 -1.7 -0.4 -1.8 -1.6 -1.3 -1.2
#> 2 1952 -1.5 -1.0  0.9 -0.4  1.2 1.2  0.8  0.1 -0.4  0.6  0.0 -2.0
#> 3 1953  0.5 -0.8 -0.3  0.3 -2.8 0.2  0.0 -2.0 -2.1  0.1 -0.5 -0.8
#> 4 1954  1.1 -0.5  0.4  1.1  0.8 0.2  0.7  1.8  0.3  0.4  0.2  2.3
#> 5 1955 -0.9  3.1  1.1 -0.2  1.7 2.2  2.6  2.4  2.2  2.5  2.0  1.6
#> 6 1956  2.2  2.7  2.2  1.5  2.3 1.8  1.8  2.0  0.1  2.9  0.2  1.8
```

### Arquivos texto não estruturados

Em alguns casos é necessário ler arquivos textos sem uma estrutura definida como no caso de arquivos delimitados. Se o arquivo não é bem estruturado é mais fácil ler cada linha de texto separadamente e depois decompor e manipular o conteúdo do texto. 
A função `readLines()` é adequada para isso. Cada linha é tratada como um elemento de um vetor do tipo `character`.

Vamos importar os dados do INMET, mas dessa vez vamos focar no cabeçalho, onde estão as informações da estação meteorológica.

Obtendo os dados


```r
# arquivo de exemplo disponível no GitHub
bdmep_url_file <- "https://raw.githubusercontent.com/lhmet/adar-ufsm/master/data/83004.txt"
# leitura do cabecalho do arquivo de dados de uma estação do inmet
cab <- readLines(bdmep_url_file)
head(cab)
#> [1] "--------------------"                                 
#> [2] "BDMEP - INMET"                                        
#> [3] "--------------------"                                 
#> [4] "Estação           : SAO PAULO  IAG  - SP (OMM: 83004)"
#> [5] "Latitude  (graus) : -23.65"                           
#> [6] "Longitude (graus) : -46.61"
# somente linhas com coordenadas da estação
cab[5:7]
#> [1] "Latitude  (graus) : -23.65" "Longitude (graus) : -46.61"
#> [3] "Altitude  (metros): 800.00"
is.vector(cab[5:7])
#> [1] TRUE
# arranjando em coluna
cbind(cab[5:7])
#>      [,1]                        
#> [1,] "Latitude  (graus) : -23.65"
#> [2,] "Longitude (graus) : -46.61"
#> [3,] "Altitude  (metros): 800.00"
# selecionando somente os dados e o nome das variáveis
cab[-c(1:15)][1:10]
#>  [1] "Estacao;Data;Hora;Precipitacao;TempBulboSeco;TempBulboUmido;TempMaxima;TempMinima;UmidadeRelativa;PressaoAtmEstacao;PressaoAtmMar;DirecaoVento;VelocidadeVentoInsolacao;Nebulosidade;Evaporacao Piche;Temp Comp Media;Umidade Relativa Media;Velocidade do Vento Media;"
#>  [2] "83004;02/08/1993;0000;;;;;;;;;;;;;1.4;;;;"                                                                                                                                                                                                                              
#>  [3] "83004;01/01/1995;0000;;;;26.8;;;;;;;1.5;;1.6;22.04;86.75;2;"                                                                                                                                                                                                            
#>  [4] "83004;01/01/1995;1200;21.2;22.5;20;;19.5;80;924.6;;32;4;;10;;;;;"                                                                                                                                                                                                       
#>  [5] "83004;01/01/1995;1800;;25.2;21.5;;;73;922.9;;32;2;;10;;;;;"                                                                                                                                                                                                             
#>  [6] "83004;02/01/1995;0000;;20.7;20.3;28.9;;97;924.2;;0;0;1.3;10;1.1;23.32;83;2.666667;"                                                                                                                                                                                     
#>  [7] "83004;02/01/1995;1200;3.2;23.8;20.6;;19.9;76;924.7;;32;3;;10;;;;;"                                                                                                                                                                                                      
#>  [8] "83004;02/01/1995;1800;;26.4;21.6;;;66;921.5;;32;5;;10;;;;;"                                                                                                                                                                                                             
#>  [9] "83004;03/01/1995;0000;;22;21.4;25.4;;95;922.7;;0;0;0.2;10;1.3;22.54;93.5;1;"                                                                                                                                                                                            
#> [10] "83004;03/01/1995;1200;4.4;23;21.3;;20.7;86;923.6;;0;0;;10;;;;;"
```

A função `writeLines()` escreve os elementos do vetor de caracteres em um arquivo texto. Essa é uma forma de escrever os dados mantendo a formatação original dos dados.


```r
# dados sem as linhas com metadados
dados_limpos <- cab[-c(1:15)]
# arquivo para salvar os dados limpos
file_83004_limpo <- paste0(tempfile(), ".txt")
# escrevendo dados limpos
writeLines(
  text =  dados_limpos, 
  con = file_83004_limpo
)
```


## Arquivos binários 

Arquivo texto favorecem a legibilidade humana dos dados mas tem limitada precisão numérica limitada. Formatos binários diminuem substancialmente o tamanho, o tempo de leitura e escrita de arquivos. Por isso, vários softwares armazenam dados no formato binário.
 
Após a leitura e o processamento de dados brutos você provavelmente os salvará para uso futuro. Este procedimento é recomendado para evitar de ter que repetir todo processamento novamente. Para dados que ocupam espaço significativo (por exemplo com mais de 1 milhão de linhas) é mais eficiente salvar os dados em um formato binário, uma vez que dessa forma os tempos de escrita e leitura dos dados é menor.


### Formatos binários nativos do R

#### Rdata 

Para mostrar como usar as funções `save()` e `load()` vamos utilizar os dados pluviométricos lidos anteriormente (`dprec`) e selecionar as colunas de interesse. O dataframe será salvo em um arquivo binário do R com a extensão `.RData`.


```r
# primeiras linhas
head(dprec[, 1:10])
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
# selecionando somente dados diarios do dia 1 a 31 de cada ano
chuva_df <- dprec[, c(3, 14:44)]
# arquivo binario do R
file_chuva_df <- paste0(tempfile(), ".RData")
save(chuva_df, file = file_chuva_df)
#save(chuva_df, file = "../output-adar/chuva_df.RData")
# verificando se arquivo foi salvo no diretório
file.exists(file_chuva_df)
#> [1] TRUE
```

Como o objeto `chuva_df` foi salvo em um arquivo, vamos removê-lo e então recuperá-lo carregando os dados armazenado no arquivo `chuva_df.RData`.


```r
# apagando chuva_df do ambiente de trabalho
rm(chuva_df)
# verifica existência de objeto
exists(chuva_df)
#> Error in exists(chuva_df): object 'chuva_df' not found
# carregando chuva_df
load(file = file_chuva_df)
ls()
#>  [1] "arq_temp"           "bdmep_url_file"     "cab"               
#>  [4] "chuva_df"           "cols_exclud"        "dados_limpos"      
#>  [7] "dprec"              "dprec_file"         "file_83004_limpo"  
#> [10] "file_chuva_df"      "hidroweb_dest_file" "hidroweb_url_file" 
#> [13] "link_soi"           "nome_vars"          "pacotes"           
#> [16] "pcks"               "rblue"              "soi"               
#> [19] "soi.df"             "soi_file"           "tab_rio"
# para carregar os dados e saber o nome com que foram salvos
print(load(file = file_chuva_df))
#> [1] "chuva_df"
head(chuva_df[, 1:10])
#>         Data Chuva01 Chuva02 Chuva03 Chuva04 Chuva05 Chuva06 Chuva07
#> 1 01/01/1934      NA      NA      NA      NA    10.5     3.0    11.1
#> 2 01/02/1934    15.5     3.5     0.0     0.0    11.9    66.3     1.0
#> 3 01/03/1934     0.0     0.0     0.0     0.0     0.0     0.0     0.0
#> 4 01/04/1934    54.5     0.0     0.0     0.0     0.0    18.5     0.0
#> 5 01/05/1934     0.0    19.0    26.7     0.0     3.2     4.2     0.0
#> 6 01/06/1934     0.0     0.0    21.5    12.7     8.7     0.0     0.0
#>   Chuva08 Chuva09
#> 1     0.0       0
#> 2    40.0       0
#> 3     0.0      55
#> 4    19.5       0
#> 5     0.0       0
#> 6     0.0       0
```

Um **vantagem desse formato** é que os objetos criados podem ser lidos pelo R independente do sistema operacional e da arquitetura do computador, tornando muito prático o acesso aos dados. 
Cada vez que uma sessão do R é finalizada, uma janela surge perguntando se deseja salvar o espaço de trabalho (`save the workspace image`), que nada mais é do que um arquivo binário chamado `.RData` no diretório de trabalho. Assim quando iniciar a sessão se o arquivo `.RData` estiver no diretório de trabalho ele será automaticamente carregado tornando todos os objetos da última sessão disponíveis novamente. 
Se você deseja salvar o espaço de trabalho em outro momento use a função `save.image()`.

Quando desejamos salvar só uma parte dos dados uma opção é usar a função `rm()` (uma abreviação de **remove**) para remover objetos que não são de interesse antes de finalizar a sessão do R. A função `save()`permite salvar *mais de um objeto* em um mesmo arquivo. 


```r
file_dados_prec <- paste0(tempfile(), ".Rdata")
save(cab, chuva_df, file = file_dados_prec)
#save(cab, chuva_df, file = "../output-adar/dados_prec.RData")
ls()
#>  [1] "arq_temp"           "bdmep_url_file"     "cab"               
#>  [4] "chuva_df"           "cols_exclud"        "dados_limpos"      
#>  [7] "dprec"              "dprec_file"         "file_83004_limpo"  
#> [10] "file_chuva_df"      "file_dados_prec"    "hidroweb_dest_file"
#> [13] "hidroweb_url_file"  "link_soi"           "nome_vars"         
#> [16] "pacotes"            "pcks"               "rblue"             
#> [19] "soi"                "soi.df"             "soi_file"          
#> [22] "tab_rio"
rm(cab, chuva_df)
ls()
#>  [1] "arq_temp"           "bdmep_url_file"     "cols_exclud"       
#>  [4] "dados_limpos"       "dprec"              "dprec_file"        
#>  [7] "file_83004_limpo"   "file_chuva_df"      "file_dados_prec"   
#> [10] "hidroweb_dest_file" "hidroweb_url_file"  "link_soi"          
#> [13] "nome_vars"          "pacotes"            "pcks"              
#> [16] "rblue"              "soi"                "soi.df"            
#> [19] "soi_file"           "tab_rio"
# carrega e imprime na tela nome dos dados carregados
print(load(file_dados_prec))
#> [1] "cab"      "chuva_df"
ls()
#>  [1] "arq_temp"           "bdmep_url_file"     "cab"               
#>  [4] "chuva_df"           "cols_exclud"        "dados_limpos"      
#>  [7] "dprec"              "dprec_file"         "file_83004_limpo"  
#> [10] "file_chuva_df"      "file_dados_prec"    "hidroweb_dest_file"
#> [13] "hidroweb_url_file"  "link_soi"           "nome_vars"         
#> [16] "pacotes"            "pcks"               "rblue"             
#> [19] "soi"                "soi.df"             "soi_file"          
#> [22] "tab_rio"
```


#### RDS

As funções `readRDS()` e `writeRDS()` são similares a `load()` e `save()`, respectivamente, exceto que elas lidam com **um único objeto**. Em contrapartida elas possuem a flexibilidade nomear o objeto lido com um nome diferente do qual ele foi salvo.
Vamos alterar o formato da data do *dataframe* `chuva_df` e salvá-lo no arquivo `chuva_df.rds`.


```r
# salvar dados em um arquivo rds
head(chuva_df[, 1:10])
#>         Data Chuva01 Chuva02 Chuva03 Chuva04 Chuva05 Chuva06 Chuva07
#> 1 01/01/1934      NA      NA      NA      NA    10.5     3.0    11.1
#> 2 01/02/1934    15.5     3.5     0.0     0.0    11.9    66.3     1.0
#> 3 01/03/1934     0.0     0.0     0.0     0.0     0.0     0.0     0.0
#> 4 01/04/1934    54.5     0.0     0.0     0.0     0.0    18.5     0.0
#> 5 01/05/1934     0.0    19.0    26.7     0.0     3.2     4.2     0.0
#> 6 01/06/1934     0.0     0.0    21.5    12.7     8.7     0.0     0.0
#>   Chuva08 Chuva09
#> 1     0.0       0
#> 2    40.0       0
#> 3     0.0      55
#> 4    19.5       0
#> 5     0.0       0
#> 6     0.0       0
# alterando formato de datas da coluna Data
chuva_df$Data <- as.Date(x = chuva_df$Data, format = "%d/%m/%Y")
file_rds_chuva_df <- paste0(tempfile(), ".RDS")
saveRDS(object = chuva_df, file = file_rds_chuva_df)
file.exists(file_rds_chuva_df)
#> [1] TRUE
```

Após salvar o *dataframe* `chuva_df` vamos removê-lo do ambiente da sessão e recuperá-lo com a função `readRDS()`.


```r
# removendo chuva_df do ambiente
rm(chuva_df)
# recuperando dados do arquivo em uma variável com nome diferente do original
prec_ana <- readRDS(file_rds_chuva_df)
head(prec_ana[, 1:10])
#>         Data Chuva01 Chuva02 Chuva03 Chuva04 Chuva05 Chuva06 Chuva07
#> 1 1934-01-01      NA      NA      NA      NA    10.5     3.0    11.1
#> 2 1934-02-01    15.5     3.5     0.0     0.0    11.9    66.3     1.0
#> 3 1934-03-01     0.0     0.0     0.0     0.0     0.0     0.0     0.0
#> 4 1934-04-01    54.5     0.0     0.0     0.0     0.0    18.5     0.0
#> 5 1934-05-01     0.0    19.0    26.7     0.0     3.2     4.2     0.0
#> 6 1934-06-01     0.0     0.0    21.5    12.7     8.7     0.0     0.0
#>   Chuva08 Chuva09
#> 1     0.0       0
#> 2    40.0       0
#> 3     0.0      55
#> 4    19.5       0
#> 5     0.0       0
#> 6     0.0       0
```


### NetCDF (Network Common Data Form) 

NetCDF é um formato binário, auto-descritivo e independente do SO criado para criar e distribuir arranjos multidimensionais de dados gradeados. Originalmente foi desenvolvido para o armazenamento e distribuição de dados climáticos, tais como os gerados por modelos climáticos e sistemas de assimilação de dados como as [reanálises](http://en.wikipedia.org/wiki/Meteorological_reanalysis).

As bibliotecas NetCDF são mantidas pelo [Unidata](http://www.unidata.ucar.edu/software/netcdf/). Dados no formato NetCDF são acessíveis no R pelos pacotes [ncdf4](http://cran.r-project.org/web/packages/ncdf4/index.html) [@Pierce2017] e [raster](http://cran.r-project.org/web/packages/raster/index.html) [@Hijmans2017]. Esses pacotes fornecem o suporte necessário para leitura e escrita de arquivos NetCDF. 

O pacote [ncdf](https://cran.r-project.org/src/contrib/Archive/ncdf/) foi um dos primeiros pacotes de interface com dados NetCDF, mas com suporte somente para versão 3. O pacote que o substituiu foi o [ncdf4](https://cran.r-project.org/web/packages/ncdf4/index.html) e suporta tanto arquivos no formato NetCDF 3 como 4. O pacote **raster** baseia-se no **ncdf4** para fornecer através da função `brick()` uma importação e exportação fácil de dados NetCDF com o R.


#### Pré-requisitos

Para utilizar o pacote `ncdf4` é necessário instalar os pacotes linux mostrados abaixo.

```bash
## Install pacotes NetCDF
$ sudo apt-get install libnetcdf-dev libudunits2-dev
```

Pacotes necessários:


```r
library(ncdf4)
```


```r
library(raster)
library(RColorBrewer)
library(fields)
```

#### Arquivo exemplo

Os exemplos a seguir usam o pacote [ncdf4](https://cran.r-project.org/web/packages/ncdf4/index.html) para ler arquivo NetCDF com dados climáticos do *Climate Research Unit [CRU](http://www.cru.uea.ac.uk/data)*, consistindo de valores médios de longo prazo (1961-1990) da  temperatura do ar próximo à superfície  com resolução espacial de 0,5 º na área continental. As dimensões da *array* são: 720 (longitudes) x 360 (latitudes) x 12 (meses).



```r
dados_cru_url <- "https://www.dropbox.com/s/ynp9i42is1flg43/cru10min30_tmp.nc?dl=1"
dest_file_nc <- file.path(tempdir(), "cru10min30_tmp.nc")
download.file(dados_cru_url, dest_file_nc)
```

Abrindo arquivo NetCDF e obtendo informações básicas.


```r
dest_file_nc
#> [1] "/tmp/RtmpWID01A/cru10min30_tmp.nc"
file.exists(dest_file_nc)
#> [1] TRUE
```


```r
# variável de interesse, tmp: temperatura do ar
dname <- "tmp"  
# abre o arquivo NetCDF
ncin <- nc_open(dest_file_nc)
print(ncin)
#> File /tmp/RtmpWID01A/cru10min30_tmp.nc (NC_FORMAT_CLASSIC):
#> 
#>      2 variables (excluding dimension variables):
#>         float climatology_bounds[nv,time]   
#>         float tmp[lon,lat,time]   
#>             long_name: air_temperature
#>             units: degC
#>             _FillValue: -99
#>             source: E:\Projects\cru\data\cru_cl_2.0\nc_files\cru10min_tmp.nc
#> 
#>      4 dimensions:
#>         lon  Size:720
#>             standard_name: longitude
#>             long_name: longitude
#>             units: degrees_east
#>             axis: X
#>         lat  Size:360
#>             standard_name: latitude
#>             long_name: latitude
#>             units: degrees_north
#>             axis: Y
#>         time  Size:12
#>             standard_name: time
#>             long_name: time
#>             units: days since 1900-01-01 00:00:00.0 -0:00
#>             axis: T
#>             calendar: standard
#>             climatology: climatology_bounds
#>         nv  Size:2
#> 
#>     7 global attributes:
#>         data: CRU CL 2.0 1961-1990 Monthly Averages
#>         title: CRU CL 2.0 -- 10min grid sampled every 0.5 degree
#>         institution: http://www.cru.uea.ac.uk/
#>         source: http://www.cru.uea.ac.uk/~markn/cru05/cru05_intro.html
#>         references: New et al. (2002) Climate Res 21:1-25
#>         history: P.J. Bartlein, 19 Jun 2005
#>         Conventions: CF-1.0
# estrutura dos dados
#str(ncin)
# classe
class(ncin)
#> [1] "ncdf4"
# modo
mode(ncin)
#> [1] "list"
```

Agora, vamos ler as coordenadas de longitude e latitude. 


```r
lon <- ncvar_get(ncin, "lon")
nlon <- dim(lon)
head(lon)
lat <- ncvar_get(ncin, "lat", verbose = FALSE)
nlat <- dim(lat)
head(lat)
c(nlon, nlat)
```

Vamos obter a variável temporal e seus atributos usando as funções `ncvarget()` e `ncatt_get`. Depois fechamos o acesso ao arquivo NetCDF.


```r
tempo <- ncvar_get(ncin, "time")
(tunits <- ncatt_get(ncin, "time", "units"))
(nt <- dim(tempo))
tmp.array <- ncvar_get(ncin, dname)
# resumo da estrutura dos dados
str(tmp.array)
# nome longo da variável
(dlname <- ncatt_get(ncin, dname, "long_name"))
# unidades da variável
(dunits <- ncatt_get(ncin, dname, "units"))
# valor definido para valores faltantes
(fillvalue <- ncatt_get(ncin, dname, "_FillValue"))
# fechando arquivo
nc_close(ncin)
```

As variáveis do arquivo NetCDF são lidas e escritas como vetores (p.ex.: longitudes), *arrays* bidimensionais (matrizes, campo espacial de um momento), ou *arrays* multidimensionais (campos espaciais de uma variável em diversos tempos).

Vamos extrair o campo espacial de um passo de tempo (1 dia), criar um dataframe onde cada linha será um ponto de grade e a coluna representa uma variável, por exemplo: longitude, latitude e temperatura. 


```r
m <- 1
# campo espacial do primeiro dia de dados
tmp.slice <- tmp.array[, , m]
str(tmp.slice)
# outra função para visualizar dados com 3D
image.plot(lon, lat, tmp.slice, col = rev(brewer.pal(10, "RdBu")))
```

##### Forma fácil de importar NetCDF

O pacote [raste](https://cran.r-project.org/web/packages/raster/index.html) fornece uma função para fácil importação de arquivos NetCDF. Os dados importados são retornados no formato específico do pacote (classe de dados *RasterBrick*). Esta classe de dados, corresponde a uma estrutura de dados espaciais gradeados, regularmente espaçados, podendo ter uma ou mais dimensões. 

Quando o dados gradeados possuem somente uma variável em um único tempo, como por exemplo a altitude do terreno (z), temos 2 dimensões espaciais *x* (longitude), *y* (latitude) e *z*. Neste caso, o dado é um [raster](https://docs.qgis.org/2.8/pt_BR/docs/gentle_gis_introduction/raster_data.html) e sua classe de dados é denominada `RasterLayer` no pacote **raster**, ou seja os dados possuem somente uma camada. Quando os dados possuem mais de uma camada, como no casos de campos espaciais de temperatura em diferentes meses (cada mês é uma camada) a classe de dados é denominada `Rasterbrick`. 

Para importar dados em formato NetCDF que tenham mais uma camada no R, usamos a função `brick()` do pacote **raster**.


```r
brick_tar_cru <- brick(dest_file_nc)
brick_tar_cru
```

O resultado da importação de um `RasterBrick` mostra no console do R informações sobre as dimensões dos dados, a resolução espacial, os limites do domínio espacial, o sistema de coordenadas de referência, o arquivo fonte dos dados, o nome das camadas, eventualmente as datas e nome da variável importada do arquivo NetCDF. 

Quando o arquivo NetCDF possui mais de uma variável é necessário definir o nome da variável de interesse através do argumento `varname`. No exemplo acima poderíamos ter chamado a função brick com `brick(dest_file_nc, varname = "tmp")`. Mas como há somente uma variável no arquivo NetCDF deste exemplo a especificação deste argumento é opcional.

Os nomes das camadas, são acessados e alterados com função `names()`, da mesma forma que em *data frames*.


```r
# substituindo a letra "X" dos nomes por "Mes_"
names(brick_tar_cru) <- gsub("X", "Mes_", names(brick_tar_cru))
names(brick_tar_cru)
```

Um gráfico pode ser gerado através da funções `plot()`. Por default são mostrados no máximo 16 camadas de um `RasteBrick`.


```r
plot(brick_tar_cru, col = rev(brewer.pal(10, "RdBu")))
```

Os dados em formato `RasterBrick`, RasterStack ou RasterLayer podem ser convertidos para classe `data.frame` pela função `as.data.frame()`.


```r
df_tar_cru <- as.data.frame(
  x = brick_tar_cru,
  xy = TRUE, 
  na.rm = TRUE,
  #long = TRUE
)
str(df_tar_cru)
head(df_tar_cru)
```

Os argumentos usados na função `as.dataframe()` correspondem a:

- `x` é o objeto Raster* (onde \* significa  `RasterBrick`, `RasterStack` ou `RasterLayer`)

- `xy` é um argumento lógico, se `TRUE` (verdadeiro) inclui as coordenadas espaciais (longitude e altitude) das células do Raster como colunas no *data frame* de saída

- `na.rm` é um argumento opcional lógico, tal que se for `TRUE` remove linhas com valores `NA`. Isto é particularmente útil para grandes conjuntos de dados com muitos valores `NA`s e em regiões oceânicas, como no arquivo de exemplo, onde não há dados medidos. Note que se `na.rm = FALSE` (`TRUE`) o *data frame* resultante terá (poderá ter) um número de linhas igual ao (menor que o) número de células do `RasterBrick`.


```r
nrow(df_tar_cru) < ncell(brick_tar_cru)
```

- `long` é um argumento opcional lógico. Se for `TRUE` (verdadeiro) os valores são reestruturados de um formato amplo para um formato longo (veja a seção \@ref(formatos-dados) para definição de dados no formato longo e amplo).

Como exercício, rode novamente o trecho de código anterior, mudando os valores dos argumentos lógicos e observe as mudanças nas dimensões do `data frame` resultante.

## Arquivos Excel

O armazenamento de dados em formato Excel (arquivos com extensões `.xls` e `.xlsx`) é uma prática muito popular, principalmente em empresas privadas. Entretanto, arquivos em formato Excel tem problemas de interação com [sistemas de controle de versões](https://pt.wikipedia.org/wiki/Sistema_de_controle_de_vers%C3%B5es). Se a rastreabilidade das mudanças em seus dados é importante, trabalhar com arquivo texto é uma boa  opção. O formato CSV é facilmente importado no Excel e por isso é um formato texto amplamente utilizado. Uma solução é converter as planilhas Excel para `csv` usando algum programa.

Mas caso isso não seja viável, você verá as opções mais eficientes para processar arquivos Excel no R.

Importar ou exportar dados neste formato para o R era trabalhoso devido a dependências dos pacotes em programas externos (Excel, Java, Perl, etc). Mas nos últimos esta tarefa deixou de ser um obstáculo. 

Há uma variedade de pacotes para processar dados em Excel, entre eles estão: [gdata](https://cran.r-project.org/web/packages/gdata/index.html), 
[XLConnect](https://cran.r-project.org/web/packages/XLConnect/index.html), [xlsx](https://cran.r-project.org/web/packages/xlsx/index.html), [openxlsx](https://cran.r-project.org/web/packages/openxlsx/index.html), [readxl](https://readxl.tidyverse.org/), [writexl](https://github.com/ropensci/writexl) e [WriteXLS](https://cran.r-project.org/web/packages/WriteXLS/index.html). 


Na seção \@ref(Rio) vimos que o pacote **rio** importa diversos formatos de arquivos, inclusive Excel (Tabela \@ref(tab:rio-table)). A função `import()` utiliza a função `read_excel()`do pacote **readr** para importar arquivos excel. A função `export()`, por outro lado, utiliza a função `write.xlsx()` do pacote **openxlsx**. 

Além do uso do pacote **rio** para exportar arquivos `xlsx`, veremos também o pacote [writexl](https://github.com/ropensci/writexl) por ter uma exportação mais rápida que a usada no pacote **rio**.


### Como usar

Vamos baixar um arquivo `.xls` para usar com a função `import()` do pacote **rio**. 


```r
excel_file_url <- "https://github.com/lhmet/adar-ufsm/blob/master/data/Esta%C3%A7%C3%B5es%20Normal%20Climato%C3%B3gica%201981-2010.xls?raw=true"
dest_file_excel <- file.path(tempdir(), "Estacoes-Normal-Climatologica-1981-2010.xls")
download.file(excel_file_url, dest_file_excel)
```

Agora podemos importar o arquivo baixado com o pacote **rio**.


```r
inmet_estacoes <- import(
  file = dest_file_excel,
  col_names = TRUE, 
  skip = 3)
head(inmet_estacoes)
#>   Nº Código Nome da Estação UF  Latitude Longitude Atitude Inicio Operação
#> 1  1  82704 CRUZEIRO DO SUL AC -7.600000 -72.66667  170.00           10228
#> 2  2  82915      RIO BRANCO AC -9.950000 -67.86667  160.00           10594
#> 3  3  82807        TARAUACA AC -8.166667 -70.76667  190.00           24264
#> 4  4  82989     AGUA BRANCA AL -9.283333 -37.90000  605.34           10353
#> 5  5  82995       ARAPIRACA AL -9.733333 -36.76667  247.00           10594
#> 6  6  82994          MACEIO AL -9.666667 -35.70000   64.50            3289
#>   Fim Operação   Situação
#> 1   2016-02-01 Desativada
#> 2         <NA>       <NA>
#> 3         <NA>       <NA>
#> 4         <NA>       <NA>
#> 5         <NA>       <NA>
#> 6         <NA>       <NA>
```

### Escrita de arquivos excel no formato `.xls` {#export-xls}

Vamos alterar os nomes das variáveis para minúsculo e escrever o *data frame* em novo arquivo `.xls`. 


```r
names(inmet_estacoes) <- tolower(names(inmet_estacoes))
head(inmet_estacoes)
#>   nº código nome da estação uf  latitude longitude atitude inicio operação
#> 1  1  82704 CRUZEIRO DO SUL AC -7.600000 -72.66667  170.00           10228
#> 2  2  82915      RIO BRANCO AC -9.950000 -67.86667  160.00           10594
#> 3  3  82807        TARAUACA AC -8.166667 -70.76667  190.00           24264
#> 4  4  82989     AGUA BRANCA AL -9.283333 -37.90000  605.34           10353
#> 5  5  82995       ARAPIRACA AL -9.733333 -36.76667  247.00           10594
#> 6  6  82994          MACEIO AL -9.666667 -35.70000   64.50            3289
#>   fim operação   situação
#> 1   2016-02-01 Desativada
#> 2         <NA>       <NA>
#> 3         <NA>       <NA>
#> 4         <NA>       <NA>
#> 5         <NA>       <NA>
#> 6         <NA>       <NA>
```


Peraí! Mas o **rio** não suporta a opção de exportar arquivos no formato `.xls` (confira na Tabela \@ref(tab:rio-table)). Uma alternativa, caso você ainda realmente precise escrever os dados no formato `xls`, é o pacote [WriteXLS](https://cran.r-project.org/web/packages/WriteXLS/index.html), no entanto ele possui dependência da linguagem [PERL](https://www.perl.org/).



```r
library(WriteXLS)
arq_xls_temp <- file.path(tempdir(), basename(dest_file_excel))
WriteXLS(x = inmet_estacoes, ExcelFileName = arq_xls_temp)
file.exists(arq_xls_temp)
# conferindo
head(
  import(
    file = arq_xls_temp,
    col_names = TRUE
  )
)
```


### Escrita de arquivos excel no formato `.xlsx`

Se algum dia, você precisa entregar uma penca de arquivos em formato Excel, então valerá a pena saber qual das opções de escrita de arquivos `xlsx` é mais eficiente.

No trecho de código abaixo vamos fazer essa comparação usando os mesmos dados da seção \@ref(export-xls)m `inmet_estacoes`. As funções avaliadas são a `writexl::write_xlsx` e a `openxlsx::write.xlsx`.


```r
tempos_escrita_xlsx <- microbenchmark(
  writexl = write_xlsx(inmet_estacoes, tempfile()),
  openxlsx = write.xlsx(inmet_estacoes, tempfile()),
  times = 5
)
tempos_escrita_xlsx
#> Unit: milliseconds
#>      expr       min        lq       mean    median       uq       max
#>   writexl  6.957211  7.109921   8.608231  7.646552  8.12389  13.20358
#>  openxlsx 41.273377 41.784236 122.395354 43.195738 86.52689 399.19653
#>  neval cld
#>      5   a
#>      5   a
```

A função `microbenckmar::microbenckmark` usada acima toma os tempos das expressões que foram avaliadas arbitrariamente 5 vezes. 



O resultado é que a `writexl::write_xlsx()` foi cerca de 14 vezes mais rápida na escrita dos dados que a `openxlsx::write.xlsx`.


### Estrutura de dados não tabulares

Dados em arquivos Excel estão geralmente sujeitos a manipulação mais frequente de forma que sua estrutura pode não ser tabular, com mais de uma tabela por planilha, comentários em células vizinhas aos valores, células aninhadas, células formatadas e etc. Se você precisa arrumar dados nessas condições, vale a pena conferir os pacotes [tidyxl](https://cran.r-project.org/web/packages/tidyxl/index.html) e 
[unpivotr](https://cran.r-project.org/web/packages/unpivotr/index.html).

## Para saber mais

Para uma descrição mais abrangente sobre importação e exportação de dados no <img src="images/logo_r.png" width="20"> usando as funções da base do R, consulte o manual [R Data Import/Export](http://cran.r-project.org/doc/manuals/r-release/R-data.html) e a documentação de ajuda das funções citadas naquele documento.

## Exercícios



1. a. Importe da *web* diretamente para o <img src="images/logo_r.png" width="20"> os dados do índice multivariado em tempo real da Oscilação de Madden-Julian disponível em http://www.bom.gov.au/climate/mjo/graphics/rmm.74toRealtime.txt.



    b. Defina o nome das variáveis como:  year,  month,  day,  RMM1,  RMM2,  phase,  amplitude, status. Tente obter os nomes das variáveis do próprio link para os dados (Releia a seção \@ref(arquivos-fwf) e a seção \@ref(scan) para detalhes). Mostre os 10 primeiros valores da variável `RMM1`.



    c. Escreva os dados importados em um arquivo excel no **formato `xls`** e nomeado `mjo.xls`. Dê uma olhada na seção \@ref(export-xls).
    

    
    d. Importe no R o arquivo excel nomeado `mjo.xlsx` e mostre qual a classe dos dados importados.


    e. Mostre as primeiras e as últimas 10 linhas dos dados.

  
    
    f. Qual o código para mostrar quantas linhas e colunas possui a tabela de dados.


    g. Interprete a saída da `glimpse()` do pacote **dplyr** aplicada aos dados importados. O resultado parece com o de alguma outra função que você já conhece, qual?




2. Importe as anomalias padronizadas dos dados do [SOI]("http://www.cpc.ncep.noaa.gov/data/indices/soi") (2ª tabela ou a tabela mais abaixo na página do *link*). Veja a seção \@ref(arquivos-fwf) para detalhes. Mostre as últimas linhas dos dados importados.





3. Importe no R o arquivo excel com a climatologia das temperaturas mínimas do INMET no período de 1981-2010, disponível neste
[link](http://www.inmet.gov.br/webcdp/climatologia/normais2/imagens/normais/planilhas/1961-1990/Temperatura-Minima_NCB_1961-1990.xls). Mostre a estrutura dos dados e certifique-se de as colunas dos meses e ano são numéricas.



4. Faça *download* de dados gradeados de precipitação diário para todo Brasil com resolução horizontal de 0,25° (arquivo `prec_daily_UT_Brazil_v2.2_20100101_20151231.nc`), disponível em https://utexas.app.box.com/v/Xavier-etal-IJOC-DATA. Navegue pelas páginas até encontrar o arquivo NetCDF. (a) Importe os dados para o R, converta-os para *data frame* e verifique o número de colunas e linhas resultantes. (b) Compare as dimensões do *data frame* com as dimensões do objeto importado. O número de linhas e de colunas do *data frame* correpondem a quais propriedades ou dimensões do objeto importado?







