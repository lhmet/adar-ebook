# Tipos básicos de dados {#datatype}


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

Uma conjunto de um ou elementos formam um vetor[^vetor-escalar]  (**`vector`** no idioma <img src="images/logo_r.png" width="20">). Vetor é a estrutura básica de dados do <img src="images/logo_r.png" width="20"> e podem ser de dois tipos: **vetores atômicos** e **listas**[^listas]. 

[^vetor-escalar]: Diferente de outras linguagens de programação no R, um **escalar** é um vetor com um elemento. Então, vetores são o menor tipo de dados no R.

Um vetor atômico tem elementos só de um mesmo tipo de dado. Os quatro tipos básicos de vetores atômicos (tabela \@ref(tab:classes-r)) são: 

- **`double`** (real)

- **`integer`** (inteiro)

- **`character`** (caracteres)

- **`logical`** (lógico)
 

A relação entre estes tipos de dados é mostrada na Figura \@ref(fig:data-types-rel). 

[^listas]: Lista é um tipo de vetor chamado `list` que é capaz de armazenar dados de diferentes tipos (heterogêneos), o que será visto na seção \@ref(listas). 


Table: (\#tab:classes-r)Principais tipos de dados do R.

  Tipo de dados      Classe no R       exemplo     
------------------  -------------  ----------------
 Números inteiros      integer          2, 11      
  Números reais        double       0.1234, 1.23e4 
    Caracteres        character         "adar"     
     Lógicos           logical       TRUE, FALSE   



<div class="figure" style="text-align: center">
<img src="images/6-data-types-relation.png" alt="Relação entre os diferentes tipos de vetores atômicos." width="50%" />
<p class="caption">(\#fig:data-types-rel)Relação entre os diferentes tipos de vetores atômicos.</p>
</div>


<div class="rmdtip">
<p>Embora existam dois tipos de vetores o termo &quot;vetor&quot; é em geral usado para se referir ao do tipo atômico.</p>
</div>



### Construindo vetores {#build-vectors}


**Vetores atômicos** são geralmente criados com a função `c()`, abreviatura para **combinar ou concatenar**. Os argumentos dessa função podem ser especificados separados por vírgula. Por exemplo, para criar um vetor com números reais chamado `vetor_dbl`, escrevemos:



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

O tipo de dados mais usado no <img src="images/logo_r.png" width="20"> é chamado *numeric*. Este tipo inclui números inteiros, decimais, positivos, negativos e zero. Um dado do tipo numérico pode ser real (`double`) ou inteiro (`integer`) (Figura \@ref(fig:data-types-rel)).

**Números inteiros**: são geralmente usados para contagem (n° habitantes, n° de palavras, quantidade de eventos de um dado fenômeno). São números sem a parte fracionária.  

**Números reais**: podem ter uma parte fracionária e uma inteira. Estes resultam de medidas que podem assumir qualquer valor: 3.5 horas, 10.4 mm, 18.1 °C.


<div class="rmdimportant">
<p>Medidas são compostas de um número e uma escala. Você pode estar trabalhando com valores de poluação na escala de milhões de habitantes, mas o valor pode ser apenas 1.7. Para garantir consistência nos seus cálculos, em termos de unidades, é recomendado nomear sua variável com alguma referência à sua unidade de medida. Erros de unidades podem ter consequências catastróficas como o exemplo do <a href="https://pt.wikipedia.org/wiki/Mars_Climate_Orbiter#Resultados">Caso do Orbitador Climático de Marte</a>.</p>
</div>


Como todo n° inteiro pode ser representado como real, por padrão números (ou operações envolvendo números) são definidos como **`double`** ([dupla precisão no formato de ponto flutuante](https://pt.wikipedia.org/wiki/Dupla_precis%C3%A3o_no_formato_de_ponto_flutuante)) no <img src="images/logo_r.png" width="20">. Por exemplo o vetor `vetor_num` é numérico:


```r
(vetor_num <- c(-1, 0, 1, 2, NA_real_))
#> [1] -1  0  1  2 NA
class(vetor_num)
#> [1] "numeric"
```

Podemos determinar se uma variável é do tipo real ou inteiro com a função `typeof()`:


```r
typeof(vetor_num)
#> [1] "double"
```


Para definirmos um vetor como do tipo **`integer`** é necessário usar o sufixo `L` em cada elemento numérico do vetor. 



```r
(vetor_int <- c(1L, 6L, 10L, NA_integer_))
#> [1]  1  6 10 NA
typeof(vetor_int)
#> [1] "integer"
```
 

Há outra forma, bem mais prática, de criar vetores de inteiros: a partir da conversão de uma variável do tipo real (`double`) usando a função `as.integer()`:


```r
vetor_num_fi <- as.integer(vetor_num)
typeof(vetor_num_fi)
#> [1] "integer"
```

Na exemplo acima nós forçamos a conversão da variável `vetor_num` do tipo real para inteiro e vericamos qual seu tipo.

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

O número de letras em cada elemento de um vetor do tipo **`character`** podemos determinar com `nchar()`.
        

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
   
Valores lógicos são um tipo de vetores atômicos extremamente úteis simples, pois só podem assumir os valores `TRUE` (verdadeiro), `FALSE` (falso) e `NA`. No <img src="images/logo_r.png" width="20"> eles são da classe de dados do tipo `logical`.


```r
# variável lógica
vetor_log <- c(FALSE, NA, FALSE, TRUE)
vetor_log
#> [1] FALSE    NA FALSE  TRUE
class(vetor_log)
#> [1] "logical"
```



O <img src="images/logo_r.png" width="20"> aceita as abreviaturas `T` e `F` para representar `TRUE` e `FALSE`. Entretanto, esta não é uma prática recomendável, pois `T` e `F` não fazem parte das palavras reservadas do <img src="images/logo_r.png" width="20">. Consequentemente isso pode levar a confusão, como no exemplo abaixo.


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
c(T, F)
#> [1] 10  0
```

Vetores lógicos resultam de comparações e são amplamente usados em estruturas de controle condicional do código (como por exemplo nas funções `if()` e `ifelse()`). 


## Testes sobre tipos de dados

Além função `typeof()`, a família de funções `is.**{tipo_de_dados}**()` também permite descobrir o tipo de dado de uma variável. Por exemplo, para testar se a variável `vetor_num` é do tipo `character`, substituímos `{tipo_de_dados}` por `character`: 


```r
is.character(vetor_num)
#> [1] FALSE
```

O mesmo processo vale para `integer`, `numeric`, `double`, `logical`.


```r
is.integer(vetor_num)
is.numeric(vetor_num)
is.double(vetor_num)
is.logical(vetor_num)
```

Essa é uma forma de verificação do tipo de uma variável mais legível que `typeof(vetor_num) == "double"`. O operador `==` é um operador relacional para verificar se dois objetos são iguais.

## Conversão entre tipos de dados

Em algumas circunstâncias precisamos alterar o tipo de uma variável. A maioria das funções `is.{tipo_de_dados}()` possui uma função `as.{tipo_de_dados}()` correspondente que faz a conversão para aquele tipo de dado. No este tipo de operação é chamada de **coersão**.

<!-- 
COLOCAR TUDO EM UMA TABELA SÓ 
-->

Então, a coersão da variável `vetor_num` para inteiro pode ser feita com:


```r
vetor_num
#> [1] -1  0  1  2 NA
as.integer(vetor_num)
#> [1] -1  0  1  2 NA
# verificação do resultado
typeof(as.integer(vetor_num))
#> [1] "integer"
```

Já a sua coersão para lógico 


```r
as.logical(vetor_num)
#> [1]  TRUE FALSE  TRUE  TRUE    NA
# verificação do resultado
typeof(as.logical(vetor_num))
#> [1] "logical"
```

converte `0` para `FALSE` e os números $\geq \; 1$  para `TRUE`.


A coersão da variável `vetor_log` para numérica 


```r
vetor_log
#> [1] FALSE    NA FALSE  TRUE
as.numeric(vetor_log)
#> [1]  0 NA  0  1
# verificação do resultado
typeof(as.numeric(vetor_log))
#> [1] "double"
```

converte os valores `FALSE` para `0` e `TRUE` para `1`. 


A coersão da variável `vetor_char` para numérica ou inteiro


```r
vetor_char
#> [1] "ae" NA   "ou"
as.integer(vetor_char)
#> Warning: NAs introduced by coercion
#> [1] NA NA NA
# verificação do resultado
typeof(as.integer(vetor_char))
#> Warning in typeof(as.integer(vetor_char)): NAs introduced by coercion
#> [1] "integer"
```

gera `NA`.



## Outros tipos de dados

- **factor**

- **`date`** (datas)

- **`POSIX`** (data e horários).

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
#> [1] "2012-06-28 17:42:00 -03"
class(data2)
#> [1] "POSIXct" "POSIXt"
as.numeric(data2)
#> [1] 1340916120
```

A manipulação de dados da classe de datas e horários (`Date-time`) torna-se mais versátil através dos pacotes `lubridate` e `chron`, o que será visto posteriormente no curso.

Funções como `as.numeric()` e `as.Date()` não apenas mudam o formato de um objeto mas muda realmente a classe original do objeto.


```r
class(data1)
#> [1] "Date"
class(as.numeric(data1))
#> [1] "numeric"
```


