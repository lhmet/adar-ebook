---
output:
  html_document: default
---

# Entrada e saída de dados {#io}



O <img src="images/logo_r.png" width="20"> é capaz de importar dados de uma diversidade de fontes, formatos e tamanhos. Neste capítulo será visto como importar dados nos formatos mais comuns em aplicações ambientais, como: 

- importar dados tabulares aramzenados em arquivos texto (ASCII)
- arquivos de dados meteorológicos de agências brasileiras
- dados binários 


## Diretório de trabalho

O <img src="images/logo_r.png" width="20"> possui uma variedade de funções para se obter informações sobre arquivos, diretórios, permissões de acesso e etc.

Quando abrimos uma sessão no <img src="images/logo_r.png" width="20">, ela é vinculada a um diretório de trabalho (*working directory*, `wd`). Para saber o diretório de trabalho da sua sessão do <img src="images/logo_r.png" width="20"> use a função `getwd()`.


```r
getwd()
# salvando em uma variável
wd <- getwd()
```

O local *default* geralmente é o home do usuário \"/home/usuario\" no linux e \"C:\Users\username\" no Windows.

Essa informação pode ser obtida do <img src="images/logo_r.png" width="20"> com a instrução abaixo:


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

