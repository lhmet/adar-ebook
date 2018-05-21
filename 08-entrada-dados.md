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

Vamos instalar formatos adicionais do pacote rio.


```r
rio::install_formats()
```


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

## Boas práticas para importação e exportação de dados

Para uma importação e exportação eficiente de dados recomenda-se (Gillespie & Lovelace 2017):

1. Mantenha o nome original dos arquivos locais baixados da internet ou copiados da fonte provedora. Isso o ajudará a rastrear a proveniência dos dados no futuro.

2. Para um armazenamento eficinte utilize o formato binário nativo do R *.Rds* para importar (`readRDS()`) e exportar (`saveRDS()`) dados processados.

3. Use funções equivalentes a read.table() dos pacotes **readr** ou **data.table** para importar arquivos de texto grandes.

4. Use as funções `file.size()` e `object.size()` para saber o tamanho de arquivos e objetos no R e analisar como proceder se eles ficarem muito grandes.

## Arquivos texto

Dados armazenados em um arquivo de [texto puro ou simples](https://pt.wikipedia.org/wiki/Texto_simples) podem ser facilmente importados no R. 

O formato mais comum de armazenar dados é o retangular, ou seja, uma tabela de dados com as observações ao longo das linhas e as variáveis ao longo das colunas. As vezes as variáveis são referentes a locais diferentes em cada linha.


Os valores de cada coluna de uma linha são separados por um caractere separador: vírgula, espaço, tab e etc; as linhas são separadas por quebras de linha (`\n` no Linux, `\r\n` no Windows).

Dados em arquivo texto podem conter caracteres latinos, como palavras com acentos no caso do Português. Para lidar com esta peculiaridade, as funções de importação de dados, possuem um argumento relacionado a codificação (*encoding*) dos caracteres. Arquivos texto em Português geralmente usam a codificação [ISO 8859-1](https://pt.wikipedia.org/wiki/ISO/IEC_8859-1) ou equivalente *Latin1*. Portanto, para importação com formatação correta de caracteres latinos a especificação com esta codificação deve ser explícita.

O R utiliza o alfabeto [Unicode](https://pt.wikipedia.org/wiki/Unicode) para identificação de caracteres. Para associação unívoca de cada caractere (de mais 1 milhão de caracteres do alfabeto Unicode) a uma sequência de bits, o R usa o esquema de codificação [UTF-8](https://pt.wikipedia.org/wiki/UTF-8). Assim, recomenda-se utilizar essa codificação de caracteres como padrão em seus códigos e na construção e aquisição de dados. No RStudio a especificação da codificação de caracteres pode ser feita através do menu: *Tools > Global Options > Code > Saving > Default Text Encoding*.





### **rio**

O pacote [rio](https://cran.r-project.org/web/packages/rio/vignettes/rio.html) é um canivete suíço para leitura e escrita de dados nos formatos mais comuns. O pacote simplifica estes processos que são complexos para quem está iniciando no R, devido a vastidão de opções reportada no [Manual de Importação e Exportação do R](https://cran.r-project.org/doc/manuals/r-release/R-data.html). Com ele você só precisa saber duas funções para importar uma variedade de formatos de arquivos (ver tabela abaixo): `import()` e `export()`.
Algumas opções de formatos que podem ser importados e exportados com o **rio** são apresentados na tabela abaixo. Uma versão completa desta tabela está disponível na [vinheta do pacote](https://cran.r-project.org/web/packages/rio/vignettes/rio.html).


| Formato | Extensão | Pacote de importação | Pacote de exportação | Instalado por *default* |
| ------ | --------- | -------------- | -------------- | -------------------- |
| Valores separados por vírgula | .csv | [**data.table**](https://cran.r-project.org/package=data.table) | [**data.table**](https://cran.r-project.org/package=data.table) | Sim |
| dados separados por tab | .tsv | [**data.table**](https://cran.r-project.org/package=data.table) | [**data.table**](https://cran.r-project.org/package=data.table) | Sim |
| Excel | .xls | [**readxl**](https://cran.r-project.org/package=readxl) |  | Sim |
| Excel | .xlsx | [**readxl**](https://cran.r-project.org/package=readxl) | [**openxlsx**](https://cran.r-project.org/package=openxlsx) | Sim |
| objetos salvos no R | .RData, .rda | **base** | **base** | Sim |
| objetos do R serializados | .rds | **base** | **base** | Sim |
| dados Fortran | Sem extensão reconhecida | **utils** |  | Sim |
| Formato de dados com largura fixa | .fwf | **utils** | **utils** | Sim |
| Feather R/Python interchange format | .feather | [**feather**](https://cran.r-project.org/package=feather) | [**feather**](https://cran.r-project.org/package=feather) | Não |
| Armazenamento rápido (Fast Storage) | .fst | [**fst**](https://cran.r-project.org/package=fst) | [**fst**](https://cran.r-project.org/package=fst) | Não |
| JSON | .json | [**jsonlite**](https://cran.r-project.org/package=jsonlite) | [**jsonlite**](https://cran.r-project.org/package=jsonlite) | Não |
| Matlab | .mat | [**rmatio**](https://cran.r-project.org/package=rmatio) | [**rmatio**](https://cran.r-project.org/package=rmatio) | Não |
| Planilha OpenDocument | .ods | [**readODS**](https://cran.r-project.org/package=readODS) | [**readODS**](https://cran.r-project.org/package=readODS) | Não |
| tabelas HTML | .html | [**xml2**](https://cran.r-project.org/package=xml2) | [**xml2**](https://cran.r-project.org/package=xml2) | Não |
| documentos XML | .xml | [**xml2**](https://cran.r-project.org/package=xml2) | [**xml2**](https://cran.r-project.org/package=xml2) | Não |
| Área de transferência | *default* é tsv | [**clipr**](https://cran.r-project.org/package=clipr) | [**clipr**](https://cran.r-project.org/package=clipr) | Não |
| [planilhas Google](https://www.google.com/sheets/about/) | como valores separados por vírgula |  |  |  |


Vamos então baixar um arquivo texto de exemplo importá-lo com o pacote **rio**.


```r
# arquivo de exemplo disponível no GitHub
hidroweb_url_file <- "https://raw.github.com/lhmet/adar-ufsm/master/data/CHUVAS.TXT"
#arquivo temporário, você pode substituir tempfile() por um caminho de seu computador, p.ex. "~/Downloads/CHUVAS.TXT"
hidroweb_dest_file <- paste0(tempfile(), ".csv")
download.file(
  url = hidroweb_url_file, 
  destfile = hidroweb_dest_file
)
hidroweb_dest_file
#> [1] "/tmp/RtmpNePXrC/file1cbe4477c8eb.csv"
```



```r
# Importa o arquivo 
dprec <- import(hidroweb_dest_file, 
                # se fread = TRUE (default usa função fread do pacote data.table)
                fread = FALSE,  
                skip = 15,
                header = TRUE,
                sep = ";",
                dec = ",",
                na.strings = "")
str(dprec)
#> 'data.frame':	1284 obs. of  76 variables:
#>  $ X..EstacaoCodigo    : int  3054002 3054002 3054002 3054002 3054002 3054002 3054002 3054002 3054002 3054002 ...
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
#>  $ X                   : logi  NA NA NA NA NA NA ...
# exporta para arquivo texto separado por tab
export(dprec, file = "../output-adar/dprec.tsv", na = "-999")
```

Na há necesida de especificar o argumento `format` das funções `import()` e `export()` pois o formato é inferido da extensão do arquivo (csv, no exemplo acima). Você deve especificar o formato somente quando o arquivo estiver salvo em uma extensão não reconhecida pelo **rio** (ver tabela de formatos acima).

#### Arquivos formatados com largura fixa

Alguns arquivos texto com dados tabulares podem não conter separadores para economizar espaço de disco. Outros arquivos podem ser formatados usando largura fixa para reservar o espaço de cada variável, o que facilita a legibilidade dos dados. 

Vamos usar como exemplo o arquivo de dados do Índice de Oscilação Sul (SOI) obtido no site do [National Weather Service - Climate Prediction Center (NWS-CPC)](http://www.cpc.ncep.noaa.gov).


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
soi <- import(
  file = link,
  format = "fwf",
  skip = 4, # pula 4 linhas
  header = FALSE, # sem cabeçalho
  nrows = 70, # num. de linhas
  widths = c(4, rep(6, 12)), # largura dos campos das variáveis
  na.strings = "-999.9", # string para dados faltantes
  col.names = scan(link, # varredura do arquivo
    # col.names = scan(link,             # varredura do arquivo
    what = "character", # tipo dos dados a serem lidos
    skip = 3, # pula 3 linhas
    nmax = 13
  ) # num. max de registros a serem lidos
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
#> 68 2018  1.8 -0.8  2.4  0.8   NA   NA   NA   NA   NA   NA   NA   NA
#> 69 2019   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 70 2020   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
```


Conforme o manual de ajuda da função `import()` do **rio**, no arquivo acima foi usada a função `read.fwf()` do R para ler os dados.

Vamos alterar a estrutura dos dados: ao invés dos dados serem distribuídos ao longo das colunas, vamos estruturá-los como série temporal, ou seja cada valor mensal corresponderá a uma linha. 


```r
# converte a matriz de dados para um vetor (em sequencia cronológica)
soi_v <- c(t(soi[, -1]))
# criando um dataframe com valores de SOI, mes e ano
soi_df <- data.frame(
  ano = rep(soi$YEAR, each = 12),
  mes = rep(1:12, length(soi[, 1])),
  soi = soi_v
)
head(soi_df)
#>    ano mes  soi
#> 1 1951   1  2.5
#> 2 1951   2  1.5
#> 3 1951   3 -0.2
#> 4 1951   4 -0.5
#> 5 1951   5 -1.1
#> 6 1951   6  0.3
# escrevendo dados SOI em um arquivo CSV
export(soi_df,
  file = "../output-adar/SOI.csv",
  na = "-999.9"
)
```

Vamos ler os dados reestruturados que foram salvos no formato [csv](http://en.wikipedia.org/wiki/Comma-separated_values) usando uma função que permite a escolha do arquivo de forma iterativa.


```r
# leitura de dados com escolha interativa do arquivo
soi.df <- import(file.choose(),
  # file.choose só é válido em sistema *unix
  # no windows é choose.file()
  header = TRUE,
  na.strings = "-999.9"
)
```

Navegue ate o diretoriodo arquivo e clique duas vezes sobre o arquivo `SOI.csv`.




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
# escrevendo dados com writeLines
writeLines(text = cab[-c(1:15)] , con = "../output-adar/83004_limpo.txt")
# visualizando dados gerados sem cabeçalho usando função system
# (específico para sistema *unix)
system("head -11 ../output-adar/83004_limpo.txt", intern = TRUE)
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
#> [11] "83004;03/01/1995;1800;;23.4;22.6;;;94;922.1;;5;3;;10;;;;;"
```

A função `writeLines()` escreve os elementos do vetor de caracteres um de cada vez em um arquivo texto.



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
save(chuva_df, file = "../output-adar/chuva_df.RData")
# verificando se arquivo foi salvo no diretório
file.exists("../output-adar/chuva_df.RData")
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
load(file = "../output-adar/chuva_df.RData")
ls()
#>  [1] "bdmep_url_file"     "cab"                "chuva_df"          
#>  [4] "dprec"              "hidroweb_dest_file" "hidroweb_url_file" 
#>  [7] "link"               "pacotes"            "pcks"              
#> [10] "rblue"              "soi"                "soi_df"            
#> [13] "soi.df"             "soi_v"
# para carregar os dados e saber o nome com que foram salvos
print(load(file = "../output-adar/chuva_df.RData"))
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
save(cab, chuva_df, file = "../output-adar/dados_prec.RData")
ls()
#>  [1] "bdmep_url_file"     "cab"                "chuva_df"          
#>  [4] "dprec"              "hidroweb_dest_file" "hidroweb_url_file" 
#>  [7] "link"               "pacotes"            "pcks"              
#> [10] "rblue"              "soi"                "soi_df"            
#> [13] "soi.df"             "soi_v"
rm(cab, chuva_df)
ls()
#>  [1] "bdmep_url_file"     "dprec"              "hidroweb_dest_file"
#>  [4] "hidroweb_url_file"  "link"               "pacotes"           
#>  [7] "pcks"               "rblue"              "soi"               
#> [10] "soi_df"             "soi.df"             "soi_v"
# carrega e imprime na tela nome dos dados carregados
print(load("../output-adar/dados_prec.RData"))
#> [1] "cab"      "chuva_df"
ls()
#>  [1] "bdmep_url_file"     "cab"                "chuva_df"          
#>  [4] "dprec"              "hidroweb_dest_file" "hidroweb_url_file" 
#>  [7] "link"               "pacotes"            "pcks"              
#> [10] "rblue"              "soi"                "soi_df"            
#> [13] "soi.df"             "soi_v"
```


#### RDS


### NetCDF

```bash
sudo apt-get update 
sudo apt-get upgrade --assume-yes

## Install 3rd parties for NetCDF
sudo apt-get install libnetcdf-dev libudunits2-dev

## install 3rd parties needed for devtools + openssl git2r httr
#sudo apt-get install libssl-dev
```


## Para saber mais

Para uma descrição mais abrangente sobre importação e exportação de dados no <img src="images/logo_r.png" width="20"> consulte o manual [R Data Import/Export](http://cran.r-project.org/doc/manuals/r-release/R-data.html) e a documentação de ajuda das funções citadas naquele documento.

