---
output:
  html_document: default
---

# Entrada e saída de dados {#io}



O R é capacidade de importar dados de uma diversidade de fontes, formatos e tamanhos. Neste capítulo será visto como importar dados nos formatos mais comuns em aplicações ambientais, como: 

- importar dados tabulares aramzenados em arquivos texto (ASCII)
- dados em formatos binários 
- arquivos de dados meteorológicos de agências brasileiras

Para uma descrição mais abrangente sobre importação e exportação de dados no R consulte a documentação de cada função e o manual [R Data Import/Export](http://cran.r-project.org/doc/manuals/r-release/R-data.html).


## Diretório de trabalho

O R possui uma variedade de funções para se obter informações sobre arquivos, diretórios, permissões de acesso e etc.

Quando abrimos uma sessão no R, ela é associada a um diretório de trabalho (*working directory*, `wd`). Esse local é a primeiro diretório onde o R irá salvar ou ler um arquivo de dados, se o caminho completo até o arquivo não for especificado. Para saber qual é o diretório de trabalho usamos a função `getwd()`. Para alterar o `wd` usamos `setwd()`. Para listar o conteúdo de um diretório usamos a função `dir()`.


```r
# variável do tipo character com nome do diretório
(wd <- getwd())
#> [1] "/home/hidrometeorologista/Dropbox/github/my_reps/lhmet/adar-ebook"
class(wd)
#> [1] "character"
# altere o caminho para "/home/lci"
setwd(file.path("/home", Sys.getenv()[["LOGNAME"]]))
getwd()
#> [1] "/home/hidrometeorologista"
# volta para o wd
setwd(wd)
getwd()
#> [1] "/home/hidrometeorologista/Dropbox/github/my_reps/lhmet/adar-ebook"
```

Para saber o diretório de instalação do R, usamos `R.home()`. O local de instalação dos pacotes é obtido via `.libPaths()`.



