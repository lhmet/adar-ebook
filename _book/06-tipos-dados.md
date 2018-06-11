# Tipos de dados {#datatype}


Neste capítulo vamos:

- conhecer os tipos de dados mais usados no R
- descobrir qual é o tipo de dado de uma variável
- aprender a fazer testes com operadores lógicos
- saber como converter uma variável de um tipo para outro










## Classes de dados

Existem vários classes de dados no R. As mais utilizadas são mostradas na  \@ref(tab:classes-r). A classe de um objeto é obtida com a função `class()`.


```r
x <- 51
class(x)
#> [1] "numeric"
```



Table: (\#tab:classes-r)Principais classes de dados do R.

 Classes de dados    Classes no R          exemplo       
------------------  --------------  ---------------------
     Números           numeric             2.5, 2        
    Caracteres        character               a          
     Lógicos           logical           TRUE, FALSE     
      Datas              Date            2010-01-01      
 Datas e horários       POSIX        2010-01-01 00:00:00 



 
### Números

É a classe de objeto mais usada. Essa classe é chamada *numeric* no <img src="images/logo_r.png" width="20"> e é similar a *float* ou *double* em outras linguagens. Ela trata de inteiros, decimais, positivos, negativos e zero. Um valor numérico armazenado em um objeto é automaticamente assumido ser numérico. Para testar se um objeto é numérico usa-se a função `is.numeric()`.


```r
is.numeric(x)
#> [1] TRUE
is.numeric(pi)
#> [1] TRUE
```

Outro tipo é o `integer` (inteiro), ou seja não há parte decimal. Para definir um objeto como inteiro é necessário acrescentar ao valor numérico um `L`. Analogamente, uma forma de verificação se o objeto é inteiro é através função `is.integer()`.



```r
i <- 3L
is.integer(i)
#> [1] TRUE
is.integer(pi)
#> [1] FALSE
```
 
Mesmo com o objeto `i` sendo inteiro, ele também passa na verificação `is.numeric()`.


```r
is.numeric(i)
#> [1] TRUE
```

O R converte inteiros para numéricos quando necessário. Vamos usar a função `typeof()` para determinar o tipo de dado e as conversões que o R faz. Por exemplo:


```r
## integer * numeric
typeof(5L)
#> [1] "integer"
typeof(4.5)
#> [1] "double"
(prod_i <- 5L * 4.5)
#> [1] 22.5
typeof(prod_i)
#> [1] "double"
## integer/integer
typeof(5L)
#> [1] "integer"
typeof(2L)
#> [1] "integer"
typeof(5L/2L)
#> [1] "double"
# número complexo
typeof(3 + 2i)
#> [1] "complex"
```


### Caractere

O tipo de dado caractere (do termo em inglês *character* ou *string*) é bastante utilizado e deve ser manipulado com cuidado. Há duas principais formas de lidar com caracteres: a função `character()` e a `factor()`. Embora pareçam similares eles são tratados de forma diferente.


```r
(char <- "Vai chover hoje?")
#> [1] "Vai chover hoje?"
charf <- factor("Vai chover hoje?")
charf
#> [1] Vai chover hoje?
#> Levels: Vai chover hoje?
levels(charf)
#> [1] "Vai chover hoje?"
ordered(charf)
#> [1] Vai chover hoje?
#> Levels: Vai chover hoje?
```

`char` contém as palavras  \"Vai chover hoje?\", enquanto, `charf` tem as mesmas palavras porém sem as aspas e a segunda linha de informação sobre os níveis (*levels*) de `charf`. Nós veremos esse tipos de dado futuramente em vetores.


> **Lembre-se que caracteres em letras minúsculas e maiúsculas são coisas diferentes no R.**

Para encontrar o tamanho de um `character` usamos a função `nchar()`.
        

```r
nchar(char)
#> [1] 16
nchar("abc")
#> [1] 3
```

Esta função não funcionará para um objeto do tipo `factor`.


```r
nchar(charf)
#> Error in nchar(charf): 'nchar()' requires a character vector
```

### Lógico {#logico}
   
Valores lógicos (`logical` no <img src="images/logo_r.png" width="20">) são uma forma de representar dados que podem assumir valores booleanos, isto é, **TRUE** (verdadeiro) ou **FALSE** (falso). O <img src="images/logo_r.png" width="20"> aceita as abreviaturas T e F para representar TRUE e FALSE,


```r
# variável lógica
vl <- c(FALSE, T, F, TRUE)
vl
#> [1] FALSE  TRUE FALSE  TRUE
```

 Entretanto, esta não é uma prática recomendável, conforme exemplo abaixo.


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

Valores lógicos podem ser usados em operações aritméticas. Neste caso, serão convertidos numericamente para 1 (TRUE) e 0 (FALSE).


```r
vl * 5
#> [1] 0 5 0 5
TRUE * 4
#> [1] 4
TRUE + TRUE
#> [1] 2
FALSE - TRUE
#> [1] -1
```

Assim como as outras classes de dados, existem funções para verificar a classe de dados lógicos.


```r
class(vl)
#> [1] "logical"
is.logical(vl)
#> [1] TRUE
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


A Tabela \@ref(tab:oper-logic) apresenta os principais operadores lógicos disponíveis no <img src="images/logo_r.png" width="20">.


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
x; typeof(x)
#> [1] 51
#> [1] "double"
vl; typeof(vl)
#> [1] FALSE  TRUE FALSE  TRUE
#> [1] "logical"
data1; typeof(data1)
#> [1] "2012-06-28"
#> [1] "double"
x; is.numeric(x)
#> [1] 51
#> [1] TRUE
#  num.real?
is.double(x/5)
#> [1] TRUE
is.double(5L)
#> [1] FALSE
is.character("12.34")
#> [1] TRUE
charf; is.factor(charf)
#> [1] Vai chover hoje?
#> Levels: Vai chover hoje?
#> [1] TRUE
i; is.integer(i)
#> [1] 3
#> [1] TRUE
is.function(sqrt)
#> [1] TRUE
is.finite(i)
#> [1] TRUE
is.nan(x)
#> [1] FALSE
is.na(x)
#> [1] FALSE
```

## Conversão entre tipos de dados

Em algumas circunstâncias precisamos alterar o tipo de uma variável. A maioria das funções `is.*()` possui uma função `as.*()` correspondente de conversão para aquele tipo de dado.


```r
# de character para numeric
as.numeric("12.34") 
#> [1] 12.34
# de factor para character
as.character(charf)
#> [1] "Vai chover hoje?"
# character para factor
as.factor("a")
#> [1] a
#> Levels: a
# de double para integer
typeof(x)
#> [1] "double"
typeof(as.integer(x))
#> [1] "integer"
as.integer(x) == 51L
#> [1] TRUE
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


