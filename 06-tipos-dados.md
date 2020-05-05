# Tipos de dados {#datatype}


Neste capítulo vamos:

- aprender a criar vetores
- conhecer os tipos de dados mais usados no R
- descobrir qual é o tipo de dado de uma variável
- aprender a fazer testes com operadores lógicos
- saber como converter uma variável de um tipo para outro






<!-- 
faltando: 
fórmulas 
factor 
-->



## Vetores e tipos de dados {#tipos-dados}

Vetor é a estrutura básica de dados do <img src="images/logo_r.png" width="20"> e consiste em uma coleção de elementos. Vetores podem ser de dois tipos: **vetores atômicos** e **listas**[^listas]. Um vetor atômico é uma coleção de elementos do mesmo tipo de dado. Os tipos de dados mais usados (tabela \@ref(tab:classes-r)) em vetores atômicos são: **`numeric`** (numérico), **`character`** (caracteres), **`logical`** (lógico), **`date`** (datas), **`POSIX`** (data e horários). A relação entre estes tipos de dados é mostrada na Figura \@ref(fig:data-types-rel). 

[^listas]: Lista é um tipo de vetor chamado `list` que é capaz de armazenar dados de diferentes tipos (heterogêneos), o que será visto na seção \@ref(listas). 


Table: (\#tab:classes-r)Principais tipos de dados do R.

  Tipo de dados      Classe no R          exemplo       
------------------  -------------  ---------------------
     Números           numeric            2.5, 2        
    Caracteres        character           "adar"        
     Lógicos           logical          TRUE, FALSE     
      Datas             Date            2010-01-01      
 Datas e horários       POSIX       2010-01-01 00:00:00 



<div class="figure" style="text-align: center">
<img src="images/6-data-types-relation.png" alt="Relação entre os diferentes tipos de vetores atômicos." width="50%" />
<p class="caption">(\#fig:data-types-rel)Relação entre os diferentes tipos de vetores atômicos.</p>
</div>


<div class="rmdtip">
<p>Embora existam dois tipos de vetores o termo &quot;vetor&quot; é em geral usado para se referir ao do tipo atômico.</p>
</div>



### Construindo vetores {#build-vectors}


**Vetores atômicos** são geralmente criados com a função `c()`, abreviatura para **combinar ou concatenar**. Os argumentos podem ser especificados separados por vírgula. Por exemplo, para criar um vetor com números reais chamado `vetor_dbl`, escrevemos:



```r
(vetor_dbl <- c(-1.51, 0.33, 1.46, 2.04))
#> [1] -1.51  0.33  1.46  2.04
```


<div class="rmdnote">
<p>A função <code>c()</code> aceita um <strong>número variado de argumentos</strong>, o que é representado por três pontos ou reticências (<code>...</code>) na sua documentação de ajuda (<code>?c</code>).</p>
</div>


Para saber qual a classe ou tipo de uma variável podemos usar a função `class()`.


```r
class(vetor_dbl)
#> [1] "numeric"
```



### Números

O tipo de dados mais usado no <img src="images/logo_r.png" width="20"> é chamado *numeric*. Este tipo inclui números inteiros, decimais, positivos, negativos e zero. Um dado do tipo numérico pode ser real (`double`) ou inteiro (`integer`) (\@ref(fig:data-types-rel)).

**Números inteiros**: são geralmente usados para contagem (n° habitantes, n° de palavras, quantidade de eventos de um dado fenômeno). São números sem a parte fracionária.  

**Números reais**: podem ter uma parte fracionária e uma inteira. Estes resultam de medidas que podem assumir qualquer valor: 3.5 horas, 10.4 mm, 18.1 °C.

Como todo n° inteiro pode ser representado como real, no <img src="images/logo_r.png" width="20"> por padrão números (ou operações envolvendo números) são definidos como **`double`** ([dupla precisão no formato de ponto flutuante](https://pt.wikipedia.org/wiki/Dupla_precis%C3%A3o_no_formato_de_ponto_flutuante)). Por exemplo o vetor `vetor_num` é numérico:


```r
(vetor_num <- c(-1, 0, 1, 2, NA_real_))
#> [1] -1  0  1  2 NA
class(vetor_num)
#> [1] "numeric"
```

Mas para sabermos se ele é real ou inteiro, usamos a função `typeof()`:


```r
typeof(vetor_num)
#> [1] "double"
```


Para definirmos um vetor como inteiro é necessário usar o sufixo `L` em cada elemento numérico. 



```r
(vetor_int <- c(1L, 6L, 10L, NA_integer_))
#> [1]  1  6 10 NA
typeof(vetor_int)
#> [1] "integer"
```
 

O R converte inteiros para numéricos automaticamete quando necessário. Vamos verificar essas conversões usar a função `typeof()` para determinar o tipo de dado e as conversões que o R faz. Por exemplo:


```r
typeof(5L)
#> [1] "integer"
typeof(4.5)
#> [1] "double"
typeof(5L * 4.5)
#> [1] "double"
typeof(10L/3L)
#> [1] "double"
```






### Caractere

Um grupo de caracteres (ou *strings*), letras ou qualquer forma de texto são dados do tipo **`character`**. Eles são identificados por aspas dupla, por exemplo:  

<!---
qualquer Dados caractere (do termo em inglês *character* ) é bastante utilizado e deve ser manipulado com cuidado. Há duas principais formas de lidar com caracteres: a função `character()` e a `factor()`. Embora pareçam similares eles são tratados de forma diferente.
-->



```r
(vetor_char <- c("ae", NA_character_, "ou"))
#> [1] "ae" NA   "ou"
class(vetor_char)
#> [1] "character"
```

<!--
`char` contém as palavras  \"Vai chover hoje?\", enquanto, `charf` tem as mesmas palavras porém sem as aspas e a segunda linha de informação sobre os níveis (*levels*) de `charf`. Nós veremos esse tipos de dado futuramente em vetores.
-->

Para obter o tamanho de caracters usamos a função `nchar()`.
        

```r
nchar(vetor_char)
#> [1]  2 NA  2
```

O <img src="images/logo_r.png" width="20"> vem com alguns vetores de caracteres pré-definidos:


```r
# alfabeto inglês em letras minúsculas
letters
#>  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s"
#> [20] "t" "u" "v" "w" "x" "y" "z"
# alfabeto inglês em letras maiúsculas
LETTERS
#>  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S"
#> [20] "T" "U" "V" "W" "X" "Y" "Z"
# nomes dos meses em inglês
month.name
#>  [1] "January"   "February"  "March"     "April"     "May"       "June"     
#>  [7] "July"      "August"    "September" "October"   "November"  "December"
# abreviatura dos nomes dos meses em inglês
month.abb
#>  [1] "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"
```



<!---
Se você precisar incluir aspas duplas em um caracter, como por exemplo, uma frase citada, você tem duas formas de fazer isso:

- Usar aspas simples no início e fim do caracter e aspas duplas em torno da parte de texto citada.


```r
(texto_citado_1 <- 'Ela disse: "Escrever na verdade é reescrever."')
#> [1] "Ela disse: \"Escrever na verdade é reescrever.\""
message(texto_citado_1)
#> Ela disse: "Escrever na verdade é reescrever."
```

- Usar aspas dupla no início e fim do caracter e aspas duplas precedidas por contrabarra (`\`) entre texto citado.


```r
(texto_citado_2 <- "Ela disse: \"Escrever na verdade é reescrever\".")
#> [1] "Ela disse: \"Escrever na verdade é reescrever\"."
message(texto_citado_2)
#> Ela disse: "Escrever na verdade é reescrever".
```
-->


### Lógico {#logico}
   
Valores lógicos são um tipo de vetores atômicos extremamente úteis simples, pois só podem assumir os valores `TRUE` (verdadeiro), `FALSE` (falso) e `NA`.  Eles são dados do tipo `logical` no <img src="images/logo_r.png" width="20">.


```r
# variável lógica
vetor_log <- c(FALSE, NA, FALSE, TRUE)
vetor_log
#> [1] FALSE    NA FALSE  TRUE
class(vetor_log)
#> [1] "logical"
```



O <img src="images/logo_r.png" width="20"> aceita as abreviaturas `T` e `F` para representar `TRUE` e `FALSE`. Entretanto, esta não é uma prática recomendável, conforme exemplo abaixo.


```r
TRUE
#> [1] TRUE
T
#> [1] TRUE
class(T)
#> [1] "logical"
T <- 10
class(T)
#> [1] "numeric"
```

Vetores lógicos resultam de comparações e são amplamente usados em estruturas de controle em programação (como por exemplo nas funções `while()` e `if()`). A Tabela \@ref(tab:oper-logic) apresenta os principais operadores lógicos para comparações.


Table: (\#tab:oper-logic)Operadores Lógicos

 Operador            Descrição        
-----------  -------------------------
     <               menor que        
    <=           menor ou igual a     
     >               maior que        
    >=            maior ou igual      
    ==               idêntico         
    !=               diferente        
    !x           não é x (negação)    
   x | y              x ou y          
   x & y               x e y          
 isTRUE(x)    teste se x é verdadeiro 
   %in%           está contido em     

Este conjunto de operadores permite diversas comparações entre vetores, por exemplo: 

- quais elementos do `vetor_dbl` (da seção \@ref{build-vectors}) são negativos?


```r
vetor_dbl < 0
#> [1]  TRUE FALSE FALSE FALSE
```

outros exemplos ÚTEIS ...


PAREI AQUI -------------------------------------------------

podem ser usados em operações aritméticas. Neste caso, serão convertidos numericamente para 1 (TRUE) e 0 (FALSE).


```r
vl * 5
TRUE * 4
TRUE + TRUE
FALSE - TRUE
```

Assim como as outras classes de dados, existem funções para verificar a classe de dados lógicos.


```r
class(vl)
is.logical(vl)
```


Valores lógicos resultam da comparação de números ou caracteres.


```r
4 == 3 # 4 é idêntico a 3?
#> [1] FALSE
teste2i2 <- 2 * 2 == 2 + 2
teste2i2
#> [1] TRUE
teste2d2 <- 2 * 2 != 2 + 2 # operador: diferente de
teste2d2
#> [1] FALSE
4 < 3
#> [1] FALSE
4 > 3
#> [1] TRUE
4 >= 3 & 4 <= 5
#> [1] TRUE
4 <= 3 | 4 <= 5
#> [1] TRUE
"abc" == "defg"
#> [1] FALSE
"abc" < "defg"
#> [1] TRUE
nchar("abc") < nchar("defg")
#> [1] TRUE
```







```r
# vetor numérico
vetor_num <- c(5, 2.5, 4.5)
# Note o sufixo L que distingue variaveis "double" de "integers"
vetor_int <- c(1L, 6L, 10L)
# Vetor logico
vetor_log <- c(TRUE, FALSE, TRUE, FALSE)
```

Generalizar is.{tipo_de_dados}


### Datas e horários

Lidar com datas e horários pode ser difícil em qualquer linguagem e pode complicar mais ainda quando há diversas opções de classes de datas disponíveis, como no <img src="images/logo_r.png" width="20">. Entre as classes mais convenientes para este tipo de informação consideram-se:

  * `Date`
  
  * `POSIXct`
  

`Date` armazena apenas a data enquanto `POSIXct` armazena a data e o horário. Ambos dados são representados como o número de dias (*Date*) ou segundos (*POSIXct*) decorridos  desde 1 de Janeiro de 1970.


```r
data1 <- as.Date("2012-06-28")
data1
#> [1] "2012-06-28"
class(data1)
#> [1] "Date"
as.numeric(data1)
#> [1] 15519
data2 <- as.POSIXct("2012-06-28 17:42")
data2
#> [1] "2012-06-28 17:42:00 UTC"
class(data2)
#> [1] "POSIXct" "POSIXt"
as.numeric(data2)
#> [1] 1340905320
```

A manipulação de dados da classe de datas e horários (`Date-time`) torna-se mais versátil através dos pacotes `lubridate` e `chron`, o que será visto posteriormente no curso.

Funções como `as.numeric()` e `as.Date()` não apenas mudam o formato de um objeto mas muda realmente a classe original do objeto.


```r
class(data1)
#> [1] "Date"
class(as.numeric(data1))
#> [1] "numeric"
```



## Testes sobre tipos de dados

Além função `typeof()`, a família `is.*()` também permite descobrir o tipo de dado, p.ex.: `is.numeric()`, `is.character()` e etc.


```r
#x; typeof(x)
vl; typeof(vl)
data1; typeof(data1)
#x; is.numeric(x)
#  num.real?
#is.double(x/5)
is.double(5L)
is.character("12.34")
charf; is.factor(charf)
i; is.integer(i)
is.function(sqrt)
is.finite(i)
#is.nan(x)
#is.na(x)
```

## Conversão entre tipos de dados

Em algumas circunstâncias precisamos alterar o tipo de uma variável. A maioria das funções `is.*()` possui uma função `as.*()` correspondente de conversão para aquele tipo de dado.


```r
# de character para numeric
as.numeric("12.34") 
#> [1] 12.34
# de factor para character
#as.character(charf)
# character para factor
as.factor("a")
#> [1] a
#> Levels: a
# de double para integer
#typeof(x)
#typeof(as.integer(x))
#as.integer(x) == 51L
as.integer("12.34")
#> [1] 12
# arredondamento
as.integer(12.34)
#> [1] 12
# lógico para inteiro
as.integer(TRUE)
#> [1] 1
# numérico para lógico
as.logical(0:2)
#> [1] FALSE  TRUE  TRUE
# character para numérico?
as.numeric("a")
#> Warning: NAs introduced by coercion
#> [1] NA
# de character para date
dt_char <- "2016-03-17"
dt <- as.Date(dt_char)
dt
#> [1] "2016-03-17"
# de character para date-time
data_hora <- as.POSIXct("2016-03-17 15:30:00")
data_hora
#> [1] "2016-03-17 15:30:00 UTC"
```


