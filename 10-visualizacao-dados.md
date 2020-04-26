---
output:
  html_document: default
  pdf_document: default
---



# Visualização de dados {#data-vis}


<!-- 
earthdatascience.org/courses/earth-analytics/lidar-raster-data-r/ggmap-basemap/ 
-->



> \"Uma imagem vale mais que mil palavras\"

é uma expressão popular atribuída ao filósofo chinês [Confúcio](https://en.wikipedia.org/wiki/Confucius) utilizada para transmitir a idéia do poder da comunicação através das imagens.

Gráficos são uma forma efetiva de olhar os seus dados e servem para apresentar informações.

Figura \@ref(fig:tidy-workflow)


Neste capítulo veremos como produzir gráficos usando o pacote ggplot2 que baseia-se na [gramática de gráficos](http://amzn.to/2ef1eWp).

<!-- 
Citando @Tufte2001 e @Wilkinson2005. 
-->


## Pré-requisitos

O pacote **ggplot2** faz parte do **tidyverse**, mas além dele precisaremos de outros pacotes com funcionalidades que complementam o **ggplot2**.


```r
pacotes <- c("openair", "lubridate",
             "scales", "rio", 
             "tidyverse", 
             "ggrepel", "ggthemes",
             "viridis")
easypackages::libraries(pacotes)
```


### Dados 



## *ggplot2*



