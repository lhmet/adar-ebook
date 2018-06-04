# (PART) Ferramentas modernas do R {-}


# Processamento de dados {#manip}




O <img src="images/logo_r.png" width="20"> é capaz de importar dados de uma diversidade de fontes, formatos e tamanhos. Neste capítulo será visto como importar e exportar dados nos formatos mais comuns em aplicações ambientais, como: 

- dados retangulares armazenados em arquivos de texto puro
- dados binários e netCDF
- dados espaciais em formato GIS

Nós estamos em uma era digital e a quantidade de dados disponíveis na internet está aumentando monstruosamente. Para você estar preparado para o futuro, além de aprender como importados arquivos locais, veremos também como baixar e importar dados da *web*.

Serão utilizados diversos pacotes para lidar com os diferentes formatos de dados. Iremos começar com o pacote **rio** que permite importar uma diversidade de tipos de dados com muita facilidade. Arquivos texto com valores separados por vírgula (*CSV*) serão tratados com os pacotes **readr** e **data.table**. Dados em formato texto puro tem desvantagens e por isso veremos também formatos binários, entre eles, as funções nativas do R (`readRDS()`, `load()`) e funções de pacotes específicos para importar arquivos no formato netCDF.


## Pré-requisitos

Para reproduzir os códigos deste capítulo você precisará dos seguintes pacotes:


```r
pacotes <- c("easypackages","rio", "readr", "feather", "readxl") 
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

asd
