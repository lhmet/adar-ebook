--- 
title: "Análise de Dados Ambientais com R"
#subtitle: "Versão preliminar"
author: "Jônatan Tatsch"
date: "2021-01-29"
site: bookdown::bookdown_site
output: bookdown::gitbook
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: lhmet/adar-ebook
cover-image: "images/TB1.jpg"
description: "Livro baseado nas notas de aula da disciplina FSC1104 do curso de graduação em Meteorologia da UFSM."
---

# Apresentação {-} 




<img src="images/TB1.jpg" width="549px" class="cover" style="display: block; margin: auto;" />

<p style="font-size: 11px; font-style: italic; background: whitesmoke; text-align="right"; color: gray; line-height: 12px;width: 650px;">Ilustração: The Project Twins</p> 

<!---
<img src="images/TB1.jpg" width="90%" style="display: block; margin: auto;" />
--->



<!-- <img src="images/TB1.jpg" style="position:absolute;top:200px;height:300px;align:center;" /> -->



Este livro é uma composição das notas de aula da disciplina
**Análise de Dados Ambientais com <img src="images/logo_r.png" width="20">** do curso de Graduação em [<span style="font-variant:small-caps;">meteorologia</span>](http://w3.ufsm.br/meteorologia/) que eu ofereço no Departamento de Física da Universidade Federal de Santa Maria ([UFSM](http://site.ufsm.br/)). 

O livro pode ser útil para qualquer um com interesse em aprender o <img src="images/logo_r.png" width="20"> e que quer alavancar a etapa de processamento de dados ambientais no seu projeto. O objetivo é prover uma material para ensinar os conceitos básicos de programação necessários para o processamento, a visualização e a análise de dados ambientais com o sistema computacional <img src="images/logo_r.png" width="20">. Estes procedimentos são potencializados com o uso do software RStudio, uma interface de desenvolvimento integrado (IDE) específica para o <img src="images/logo_r.png" width="20">.

Neste livro o leitor aprenderá a sintaxe básica da linguagem <img src="images/logo_r.png" width="20">, a importação e exportação de dados, a criação de gráficos, funções, a padronização e organização de conjunto de dados ambientais; e finalmente, a confecção de relatórios dinâmicos e reproduzíveis.

O material do livro inclui o uso de dados ambientais de diferentes áreas (meteorologia, climatologia, hidrologia, sensoriamento remoto) em exemplos práticos e em exercícios, para estimular a prática da programação. 

O texto é intercalado com trechos de códigos que podem ser reproduzidos e os resultados visualizados no computador do leitor. 

Após a introdução ao <img src="images/logo_r.png" width="20"> apresenta-se as capacidades específicas do <img src="images/logo_r.png" width="20"> para manipulação de dados. Baseado na experiência do autor são empregados os pacotes mais adequados para cada finalidade, como **dplyr** e **tidyr** para o processamento de dados e o **ggplot2** para visualização de dados.

A intenção do livro é que após a leitura, o leitor tenha o conhecimento suficiente para desenvolver códigos que automatizem tarefas repetitivas, assim reduzindo o tempo gasto na etapa de preparação de dados. Esta programação mais efetiva permitirá focar mais na análise de dados e na comunicação dos resultados, seja ela na forma de documentos acadêmicos, ou relatórios técnicos em empresas públicas e privadas.

O texto está em formato [html](https://pt.wikipedia.org/wiki/HTML) para tirar o melhor proveito de recursos de multimídia, da capacidade de busca de texto e links para websites. 

O texto é organizado em 7 capítulos:

- \@ref(intro) Introdução

- \@ref(install) Instalação do <img src="images/logo_r.png" width="20"> e RStudio

- \@ref(iu) Interface do Usuário

- \@ref(rstudio) Rstudio

- \@ref(operbasic) Operações Básicas

- \@ref(datatype) Tipos de dados

- \@ref(estrutura-dados) Estruturas de dados

- \@ref(io) Entrada de dados

- \@ref(data-wrangle) Processamento de dados

- \@ref(data-vis) Visualização de dados


<!-- 
# estrutura de conteúdo de livro ideal
# para balancear R básico e tidyverse
https://dzchilds.github.io/eda-for-bio/
https://github.com/lhmet-forks/eda-for-bio
https://tavareshugo.github.io/r-eda-gapminder/
-->




<!-- - AUTOMAÇÂO COM R  - PROCESS AUTOMATION WITH R
https://datacarpentry.org/rr-automation/ 

# The Automation of GitHub Processes in RStudio
https://rpubs.com/chrimaho/GitHubAutomation

https://towardsdatascience.com/automate-your-repetitive-reports-5ee60a53bda2

https://stackoverflow.com/questions/10204483/i-want-to-run-a-r-code-at-a-specific-time

https://stat545.com/automation-overview.html

https://towardsdatascience.com/how-to-build-an-automated-trading-system-using-r-34892b6d3320

https://nextjournal.com/eda/automated-eda

https://www.r-bloggers.com/how-to-create-automated-analysis-using-r/


https://medium.com/airbnb-engineering/using-googlesheets-and-mailr-packages-in-r-to-automate-reporting-c09579e0377f
-->




<br/>
<br/>


<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Licença Creative Commons" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />A versão on-line deste livro está licenciada com uma Licença <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons - Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional</a>.
