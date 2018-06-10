# (PART) Ferramentas modernas do R {-}


# Processamento de dados {#data-wrangle}



Neste capítulo veremos:

- como arrumar seus dados em uma estrutura conveniente para a análise e visualização de dados

- um *data frame* aperfeiçoado (ou *tibble*)

- como reestruturar os dados de uma forma versátil e fácil de entender

- como manipular os dados com uma ferramenta intuitiva e padronizada

Há diversas ferramentas para a execução dessas operações no R. As ferramentas nativas do R para 


## Introdução

Introdução a ferramentas modernas de processamento de dados:

Caixa de ferramentas para manipulação de dados tabulares

    - pacote **dplyr**
  
    - pacote **tidyr**
    

## Pré-requisitos

Para reproduzir os códigos deste capítulo você precisará dos seguintes pacotes, além daqueles usados nos capítulos anteriores:


```r
pacotes <- c("tidyverse", "openair")
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
easypackages::libraries(pacotes)
#> Loading required package: tidyverse
#> + ggplot2 2.2.1        Date: 2018-06-10
#> + tibble  1.4.2           R: 3.4.4
#> + tidyr   0.8.0          OS: Ubuntu 14.04.5 LTS
#> + readr   1.1.1         GUI: X11
#> + purrr   0.2.4      Locale: en_US.UTF-8
#> + dplyr   0.7.4          TZ: America/Sao_Paulo
#> + stringr 1.3.1      
#> + forcats 0.2.0
#> ── Conflicts ────────────────────────────────────────────────────
#> * filter(),  from dplyr, masks stats::filter()
#> * lag(),     from dplyr, masks stats::lag()
#> Loading required package: openair
#> All packages loaded successfully
```



## Dados arrumados

asd

## *tibble*: um dataframe aperfeiçoado

asd

## tidyr

asd

## dplyr

asd
