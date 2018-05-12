# Entrada e saída de dados {#io}



O <img src="images/logo_r.png" width="20"> é capaz de importar dados de uma diversidade de fontes, formatos e tamanhos. Neste capítulo será visto como importar dados nos formatos mais comuns em aplicações ambientais, como: 

- dados tabulares armazenados em arquivos texto ([ASCII](https://pt.wikipedia.org/wiki/ASCII))
- arquivos de dados meteorológicos de agências brasileiras
- dados binários e netCDF
- dados espaciais em formato GIS

## Diretório de trabalho

O <img src="images/logo_r.png" width="20"> possui uma variedade de funções para se obter informações sobre arquivos, diretórios, permissões de acesso e etc.

Quando abrimos uma sessão no <img src="images/logo_r.png" width="20">, ela é vinculada a um diretório de trabalho (*working directory*, `wd`). A função `getwd()` retorna o diretório de trabalho da sua sessão do <img src="images/logo_r.png" width="20">.


```r
getwd()
# salvando em uma variável
wd <- getwd()
```

O local *default* geralmente é o home do usuário \"/home/usuario\" no linux e \"C:\\Usuarios\\usuario\\" no Windows.

Você obtém essa informação com a instrução abaixo:


```r
Sys.getenv("HOME")
```

É neste local onde o <img src="images/logo_r.png" width="20"> e o RStudio irão salvar gráficos, documentos, ler e escrever dados,  quando você não especificar o caminho completo para o arquivo de saída.

Para alterar seu `wd` você pode usar a função `setwd()`. 


```r
# define o wd em "/home/user"
setwd("~/Documents")
getwd()
# volta para o wd inicial
setwd(wd)
getwd()
```

O conteúdo de um diretório pode ser listado com a função `dir()`.


## Para saber mais

Para uma descrição mais abrangente sobre importação e exportação de dados no <img src="images/logo_r.png" width="20"> consulte o manual [R Data Import/Export](http://cran.r-project.org/doc/manuals/r-release/R-data.html) e a documentação de ajuda das funções citadas naquele documento.

