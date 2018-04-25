# Operações básicas {#operbasic}

Nesta seção veremos:

- operações aritméticas básicas com R
- a atribuição de valores a uma variável
- o uso de funções matemáticas internas do R
- valores numéricos especiais do R
- os cuidados ao nomear variáveis




## Convenção

A partir deste capítulo, os códigos a serem avaliadas no <code class='sourceCode bash'><span class='ex'>R</span></code> terão o prompt do <code class='sourceCode bash'><span class='ex'>R</span></code> (`>`) omitidos. Essa convenção é para tornar mais fácil a ação de copiar e colar os códigos na linha de comando do <code class='sourceCode bash'><span class='ex'>R</span></code>. O resultado da avaliação das expressões será mostrado precedido do símbolo (`#>`). Esses valores são os resultados que esperam-se sejam reproduzidos pelo leitor na sessão do <code class='sourceCode bash'><span class='ex'>R</span></code> em seu computador. Por exemplo:


```r
1:5
#> [1] 1 2 3 4 5
```

No trecho de código acima,  a primeira linha contém o código a ser copiado pelo leitor para execução em seu computador. A segunda linha é a saída do código avaliado pelo R.


## Calculadora

O R é uma calculadora turbinada com diversas funções matemáticas disponíveis. Para quem não conhece o R, essa uma forma de familiarizar-se com a linha de comandos do R.

### Aritmética básica

Todas operações feitas em uma  calculadora podem ser realizadas na linha de comandos do R.


```r
10 + 2 + 4
#> [1] 16
# Exemplo de divisao 
(5 + 14)/2
#> [1] 9.5
# exponenciação
2^3
#> [1] 8
4^0.5
#> [1] 2
# operador artimético para se determinar o resto de uma divisao
10 %% 2
#> [1] 0
2001 %% 2
#> [1] 1
# o inteiro do quociente 
11 %/% 2
#> [1] 5
```


<div class="rmdwarning">
<p>Note que no R, o separador decimal é o ponto &quot;.&quot;, ao invés da vírgula &quot;,&quot; usada na notação brasileira. As vírgulas tem a finalidade de separar os argumentos nas chamadas de funções, tal como em <code>log(x = 10, base = 10)</code>.</p>
</div>

 

Conheça mais operadores aritméticos, digitando na linha de comando:


```r
?"Arithmetic"
```

A janela que se abrirá mostrará o texto que faz parte do manual de ajuda do <code class='sourceCode bash'><span class='ex'>R</span></code>.

### Constantes

O R possui algumas constantes pré-definidas, como o a constante pi ($\pi$).


```r
pi
#> [1] 3.141593
```

O R também tem vetores de caracteres pré-definidos, são eles:


```r
LETTERS
#>  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q"
#> [18] "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
letters
#>  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q"
#> [18] "r" "s" "t" "u" "v" "w" "x" "y" "z"
month.abb
#>  [1] "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov"
#> [12] "Dec"
month.name
#>  [1] "January"   "February"  "March"     "April"     "May"      
#>  [6] "June"      "July"      "August"    "September" "October"  
#> [11] "November"  "December"
```

Note que caracteres estão sempre entre aspas: `""`.

<p style="color:DodgerBlue; font-size:1.3em; font-weight: bold;text-align:center;"> "caracteres são entre aspas"</p>


```r
aeiou
#> Error in eval(expr, envir, enclos): object 'aeiou' not found
```


```r
"aeiou"
#> [1] "aeiou"
```


### Funções matemáticas internas

Existem diversas funções internas do R que permitem, por exemplo, sortear números aleatóriamente, arrendondar números, calcular o fatorial, calcular o seno, cosseno de um ângulo e etc. A sintaxe para chamar uma função no R é:

<p style="color:DodgerBlue; font-size:1.3em; font-weight: bold;text-align:center;"> `funcão(argumento)` </p>

Por exemplo:


```r
# funções trigonométricas
sin(pi/6)
#> [1] 0.5
cos(pi)
#> [1] -1
# raiz quadrada
sqrt(100)
#> [1] 10
# exponencial
exp(1)
#> [1] 2.718282
# fatorial
factorial(4)
#> [1] 24
```

No R você verá que parênteses são frequentemente utilizados. Eles são sempre associados à funções. Qualquer palavra antecedendo um parênteses é uma função.

Para ver a lista completa de funções trigonométricas:

```r
?"Trig"
```


### Valores numéricos especiais

Um caso particular sobre operação aritméticas no R, são os valores numéricos `Inf`e `NaN` que resultam de operações como:


```r
2/0
#> [1] Inf
-12/0
#> [1] -Inf
exp(-Inf)
#> [1] 0
log(0)
#> [1] -Inf
0/Inf
#> [1] 0
(0:3)^Inf
#> [1]   0   1 Inf Inf
log(-0.5)
#> Warning in log(-0.5): NaNs produced
#> [1] NaN
sqrt(-1)
#> Warning in sqrt(-1): NaNs produced
#> [1] NaN
0/0 
#> [1] NaN
Inf-Inf
#> [1] NaN
Inf/Inf
#> [1] NaN
mean(c(NA, NA), na.rm = TRUE)
#> [1] NaN
```

`NaN` é a abreviação para *Not a Number*. Geralmente surge quando um cálculo não tem sentido matemático ou não pode ser propriamente realizado.

A demonstração das diferentes formas de se obter essas constantes especiais é importante para entender a origem delas durante a execução de um script mais extenso.

Outra constante especial do R é o `NA` (*Not Available*) que representa valor faltante, um problema comum em análise de dados. Qualquer operação envolvendo `NA` resultará em `NA` (Tabela 1). 


Table: (\#tab:chunk19)Tabela 1. Operações com NA.

 operação    resultado 
----------  -----------
  NA + 5        NA     
 sqrt(NA)       NA     
   NA^2         NA     
  NA/NaN        NA     


### Notação científica e número de dígitos

Na maioria das vezes precisamos trabalhar com números grandes e consequentemente acabamos usando uma notação científica ou exponencial. No R há diferentes formas de representar números com expoentes:


```r
1.2e-6
#> [1] 1.2e-06
# expressões equivalentes
1.2E6; 1.2*10^6  
#> [1] 1200000
#> [1] 1200000
```

Os resultados dos cálculos no R são mostrados com 7 dígitos significativos, o que pode ser verificado pela `getOptions()`. É possível mudar para `n` dígitos usando a função `options()`, conforme exemplo abaixo.


```r
# opção de dígitos padrão
getOption("digits")
#> [1] 7
exp(1)
#> [1] 2.718282
# alterando para 14
options(digits = 14)
exp(1)
#> [1] 2.718281828459
getOption("digits")
#> [1] 14
# redefinindo para o número de casas decimais padrão
options(digits = 7)
getOption("digits")
#> [1] 7
```

## Variáveis

### Formas de atribuição 

#### Variável recebe valor

Até agora nós usamos expressões para fazer uma operação e obter um resultado. O termo \"expressão\" significa uma sentença de código que pode ser executada. Se a avaliação de uma expressão é salva usando o operador `<-`, esta combinação é chamada \"atribuição\". O resultado da \"atribuição\" é armazenado em uma variável e pode ser utilizado posteriormente. Então uma variável é um nome usado para guardar os dados. 

<p style="color:DodgerBlue; font-size:1.3em; font-weight: bold;text-align:center;"> `variavel <- valor` </p>


```r
p <- 1013
# para mostrar a variável digite o nome da variável
p
#> [1] 1013
# ou use a função print()
print(p)
#> [1] 1013
```

O R diferencia letras maiúsculas de minúsculas. Portanto `p` e `P` são variáveis diferentes.


```r
p
#> [1] 1013
P
#> Error in eval(expr, envir, enclos): object 'P' not found
```

Como criamos apenas a variável `p`, `P` não foi encontrada. 

A variável `p` pode ser utilizado para criar outras variáveis.


```r
p_pa <- p * 100
# pressão em Pascal
p_pa
#> [1] 101300
```

A seta de atribuição pode ser usada em qualquer sentido. Parênteses, além de estarem sempre acompanhando uma função, também são usados para indicar a prioridade dos cálculos.


```r
7/3 + 0.6 -> y1
 y1
#> [1] 2.933333
7/(3 + 0.6) -> y2
 y2
#> [1] 1.944444
```

Os espaços em torno do símbolo de atribuição (` <- `) não são obrigatórios mas eles ajudam na legibilidade do código.


```r
x <- 1
x < -1
# atribuição ou menor que?
x<-1 
```

Vamos criar uma variável chamada `ndias3` que recebe o nº de dias no mês de Março e `ndias4` que recebe o nº de dias no mês de Abril.


```r
nd3 <- 31
nd4 <- 30
```

O total de dias nos meses de março e abril será armazenado na variável `totdias`:


```r
totd <- nd3 + nd4
totd
#> [1] 61
```

A atribuição de um mesmo valor para diferentes variáveis pode ser feita da seguinte forma:


```r
# número de dias em cada mês
jan <- mar <- mai <- jul <- ago <- out <- dez <- 31
abr <- jun <- set <- nov <- 30
fev <- 28
# verificação
jan; jul
#> [1] 31
#> [1] 31
jun; set
#> [1] 30
#> [1] 30
fev
#> [1] 28
```

Nós estamos definindo a variável, digitando o nome dela na linha de comando e teclando enter para ver o resultado. Há uma forma mais prática de fazer isso e mostrar o resultado cercando a atribuição por parênteses:


```r
# ao invés de 
# tar <- 20
# tar
# é mais prático
(tar <- 20) 
#> [1] 20
```

Se desejamos calcular e já visualizar o valor da pressão de vapor de saturação obtida com a [equação de Tetens](https://en.wikipedia.org/wiki/Tetens_equation), podemos fazer:


```r
(es <- 0.611 * exp((17.269 * tar)/(tar + 237.3)))
#> [1] 2.338865
```

Quando usamos a mesma variável numa sequência de atribuições o seu valor é sobrescrito. Portanto não é bom usar nomes que já foram usados antes, exceto se a intenção for realmente essa. Para saber os nomes das variáveis já usados use a função `ls()`[^9] para verificar as variáveis existentes:


```r
ls()
#>  [1] "abr"      "ago"      "dez"      "es"       "fev"      "jan"     
#>  [7] "jul"      "jun"      "mai"      "mar"      "nd3"      "nd4"     
#> [13] "nov"      "oper_nas" "out"      "p"        "pcks"     "p_pa"    
#> [19] "rblue"    "set"      "tar"      "totd"     "y1"       "y2"
```

[^9]: Essa lista de variáveis também é mostrada no painel *Environment* do RStudio (canto direito superior, aba *Environment*).



```r
totd <- jan*7; totd <- totd + fev; totd <- totd + 4*abr
totd
#> [1] 365
```

#### Atribuição com a função `assign()`


Outra forma de atribuição é através da função `assign()`:


```r
es
#> [1] 2.338865
assign(x = "es_hpa", value = es/10)
es_hpa
#> [1] 0.2338865
# usando função assign sem nome dos parâmetros
assign("u", 2.5)
u
#> [1] 2.5
```

Um exemplo mais elaborado de uso da função `assign()` para criar várias variáveis pode ser visto [aqui](https://gist.github.com/lhmet/d28856ed16690bb45d5be36ea4f5d458#file-assign-ex-rmd).

### Removendo variáveis

Para remover variáveis usa-se a função `rm()`.


```r
# lista de variáveis existentes
ls()
#>  [1] "abr"      "ago"      "dez"      "es"       "es_hpa"   "fev"     
#>  [7] "jan"      "jul"      "jun"      "mai"      "mar"      "nd3"     
#> [13] "nd4"      "nov"      "oper_nas" "out"      "p"        "pcks"    
#> [19] "p_pa"     "rblue"    "set"      "tar"      "totd"     "u"       
#> [25] "y1"       "y2"
```

Vamos remover a variável `u` criada previamente e ver a lista de objetos no espaço de trabalho.


```r
rm(u)
# lista de variáveis existentes, sem u
ls()
#>  [1] "abr"      "ago"      "dez"      "es"       "es_hpa"   "fev"     
#>  [7] "jan"      "jul"      "jun"      "mai"      "mar"      "nd3"     
#> [13] "nd4"      "nov"      "oper_nas" "out"      "p"        "pcks"    
#> [19] "p_pa"     "rblue"    "set"      "tar"      "totd"     "y1"      
#> [25] "y2"
```

Podemos remover mais de uma variável ao mesmo tempo.


```r
rm(es_hpa, es, tar, y1, y2)
# lista de variáveis existentes, sem es_hpa, es, tar, y1, y2
ls()
#>  [1] "abr"      "ago"      "dez"      "fev"      "jan"      "jul"     
#>  [7] "jun"      "mai"      "mar"      "nd3"      "nd4"      "nov"     
#> [13] "oper_nas" "out"      "p"        "pcks"     "p_pa"     "rblue"   
#> [19] "set"      "totd"
```

Para remover todas variáveis do espaço de trabalho (use com cautela):


```r
# apagando tudo
rm(list = ls())
ls()
#> character(0)
```



### Nomeando variáveis

É preciso ter cuidado ao nomear variáveis no R porque existem algumas regras:

* não iniciar com um número e não conter espaços


```r
1oAno <- 1990
raizDe10 <- srt(2)
variavel teste <- 67
```


```r
# nomes alternativos para as variaveis
ano1 <- 1990
variavel_teste <- 67
variavel.teste <- 68
```

* não conter símbolos especiais: 
    
        ^, !, $, @, +, -, /, ou *


```r
dia-1 <- 2
#> Error in dia - 1 <- 2: object 'dia' not found
# alternativa
dia_1 <- 2
```

* evitar o uso de nomes usados em objetos do sistema (funções internas do R ou constantes como o número $\pi$):

        c q  s  t  C  D  F  I  T  diff  exp  log  mean  pi  range  rank  var

        FALSE  Inf  NA  NaN  NULL TRUE 
     
        break  else  for  function  if  in  next  repeat  while


* variáveis com acento são permitidas mas não recomendadas.


```r
verão <- "DJF"
verão
#> [1] "DJF"
```

<div class="rmdtip">
<p>Há limitações de interpretação do R para caracteres latinos como cedilha e acentos. Por isso não recomenda-se o uso destes caracteres para nomear variáveis.</p>
</div>

Uma boa prática de programação é dar nomes informativos às variáveis para maior legibilidade do código. Uma boa referência para isso é a seção [**Sintaxe**](http://style.tidyverse.org/syntax.html) do [Guia de estilo tidyverse (ou universo arrumado)](http://style.tidyverse.org/).

Apesar do ganho de legibilidade do código com a aplicação das regras de formatação de código do *tidyverse* é difícil de lembrar de todas elas. 

Mas este não é mais um problema, pois o pacote [styler](http://styler.r-lib.org/) fornece funções para estilizar o seu código padrão *tidyverse*. 


```r
install.packages("styler")
library(styler)
```

As funções são acessíveis Através do menu *Addins* do RStudio e incluem as opções de: estilizar um arquivo e uma região destacada do código.

![](images/styler_0.1.gif)

## Exercícios

1. Execute as seguintes expressões no R mostrando os resultados obtidos.


```r
1 + 1
100:130
5 - +1
3 % 5
2 * 3
4 - 1
6 / (4 - 1)
```

- - - 

2. Utilize uma expressão para cada item. 
     a. Escolha um número e some 3 a ele.
     b. Multiplique o resultado por 2.
     c. Subtraia 10 da resposta.
     d. Divida o que foi obtido por 4.

- - - 

3. Calcule $\sqrt{16}$, ${16^{0.5}}^{3}$, ${(16^{0.5})}^{3}$ e $4^{\frac{3}{2}}$.

- - - 

4. Teste as expressões `log10(1000)`, `log(1000)`, `exp(log(1000))`. Depois teste a expressão `log2(64)`. Verifique se você entendeu as diferentes funções logarítmicas.

- - - 

5. Defina as variáveis abaixo tomando cuidados ao nomear as variáveis, conforme visto em sala de aula. Mostre os valores para as seguintes constantes:


    a. Velocidade da luz: $\nu = 2.998 \times 10^{8} \left[m \, s^{-1}\right]$ 

    b. Carga elementar ou eletrônica: $e = 1.602 \times 10^{-19} \left[C\right]$

    c. Permissividade do vácuo: $\epsilon_{0} = 8.85 \times 10^{-12} \left[C^{2} \, N^{-1} \, m^{2}\right]$
    
    d. Constante de Planck: $h=6.626 \times 10^{-34} \left[J \, s\right]$
    
    e. Constante de Stefan Boltzman: $\sigma = 5.67 \times 10^{-8} \left[W \, m^{-2} \, K^{-4}\right]$    
    f. Constante solar: $S_{0} = 1380 \left[W \, m^{-2}\right]$


    g. Constante de Avogadro: $N_{A} = 6.022 \times 10^{23} \left[mol^{-1}\right]$

    h. Constante dos gases para o ar seco: $R_{d} = 287.04 \left[J \, K^{-1} \, kg^{-1}\right]$
    
    i. Constante dos gases ideais para o vapor: $R_{w} = 461.5 \left[J \, K^{-1} \, kg^{-1}\right]$

    j. Densidade do ar seco para CNTP (à 0 ° C em 1000 mb): $\rho=1.2754 \left[kg \, m^{-3}\right]$

    k. Pressão média ao nível médio do mar para atmosfera padrão: $P_{0}=1013.25 \left[mb\right]$
    
    l. Temperatura ao nível médio do mar para atmosfera padrão: $T_{0}=288.15 \left[K\right]$
    
    m. Calor latente de vaporização ou condensação (à 0 °C): $\lambda_{v} =  2.501 \times 10^{6}\left[J \, kg^{-1}\right]$
    
    n. Calor latente de fusão (à 0 °C): $\lambda_{f} =  0.334 \times 10^{6}\left[J \, kg^{-1}\right]$
    
    o. Massa molecular da água: $M_w = 18.016 \left[g \, mol^{-1}\right]$
    
    p. Peso molecular do ar: $M_{ar} = 28.96 \left[g \, mol^{-1}\right]$

    q. Raio da terra: $r = 6.37 \times 10^{6} \left[m\right]$
    
    r. Velocidade angular da Terra: $\Omega=7.29 \times 10^{-5} \left[rad \, s^{-1}\right]$


- - - 

6. (a) Como você pode fazer para que a constante `pi` seja mostrada com 20 dígitos? (b) Como voltar a trabalhar a com 7 dígitos novamente? c. Mostre o número neperiano com 7 dígitos.

- - - 

7. Determine a temperatura de búlbo úmido ($T_{w}$) usando a expressão empírica ([Stull, 2011](http://journals.ametsoc.org/doi/abs/10.1175/JAMC-D-11-0143.1])) abaixo. Salve os resultados em variáveis diferentes. Para uma temperatura do ar ($T$) de 20°C e Umidade relativa ($UR$) de 70%, qual o valor de `Tw`? Defina variáveis para os valores $T$ e ($UR$) e use-as na equação de $T_{w}$.

$$
\begin{aligned} 
T_{w}=T\cdot atan\left [ 0.151977\cdot \left ( UR+8.313659 \right )^{1/2} \right ]+ \\
atan\left (T+UR \right )-\\
atan\left ( UR-1.676331 \right )+\\
0.00391838\left ( UR \right )^{3/2}\cdot atan\left ( 0.023101\cdot UR \right )-\\
4.686035
\end{aligned} 
$$

- - - 

8. Determine os valores de umidade do solo:

 - no potencial hídrico de 10kPa ($\theta_{10kPa}$)
 - na capacidade de campo ($\theta_{33kPa}$)
 - no ponto de murcha permanente ($\theta_{1500kPa}$)
 
    utilizando o conjunto de equações de pedotransferência abaixo ([Tomasela et al. 2003](https://dl.sciencesocieties.org/publications/sssaj/abstracts/67/4/1085)):

<img src="images/conj-eqs-tomasella2003.png" width="88%" style="display: block; margin: auto;" />

 - Considere $SI = 16.29$ (%), $CL =  49.25$ (%), $Db = 1.25$ ($g \, cm^{-3}$), $Me = 25$ (%), onde
$SI$ é a porcentagem de silte no solo, $CL$ é a porcentagem de argila, $Db$ é a densidade do solo e $Me$ é a umidade equivalente em %.


- - - 

9. Arredonde para 2 casas decimais os resultados da questão 8. Dica ver `?round`.

- - - 

10. Instale a **última versão do R** no (seu) computador usado para resolução desta lista. Crie um *script* chamado `solucao-q10-NomeDoAluno.R` contendo os códigos gerados para solução das questões 7 e 8. Faça as seguintes alterações no código do *script*:

 - no código da questão 8, utilize a temperatura do ar ($T$) de 30°C e Umidade relativa ($UR$) de 30% para calcular $Tw$.

 - no código da questão 9, considere $SI = 13$ (%), $CL =  37$ (%), $Db = 1.3$ ($g \, cm^{-3}$), $Me = 21$ (%) para recalcular  $\theta_{10kPa}$, $\theta_{33kPa}$ e $\theta_{1500kPa}$.

- após os códigos usados para resolver as questões 8 e 9, adicione uma nova linha com a expressão `sessionInfo()`.

 - Finalmente rode o *script* usando o R no modo não iterativo. Anexe o arquivo de saída `solucao-q10-NomeDoAluno.Rout` como resposta para este problema.

- - - 


<div class="rmdimportant">
<p><strong>Instruções para entrega da resolução da lista de exercícios.</strong></p>
<p>A resolução da lista deve conter um único arquivo compactado nomeado segundo o padrão <code>lista1-adar-NomedoAluno.zip</code>.</p>
<p>O arquivo compactado deve incluir pelo menos 3 arquivos:</p>
<ol style="list-style-type: decimal">
<li><p><code>solucao-q10-NomeDoAluno.R</code>: um <em>script</em> com os códigos usados para resolver a questão 10.</p></li>
<li><p><code>solucao-q10-NomeDoAluno.Rout</code> um arquivo texto de saída gerado (automaticamente) pelo R quando usado no modo não iterativo (<em>Batch</em>). Também faz parte da resolução da questão 10.</p></li>
<li><p><code>lista1-adar-NomedoAluno.Rmd</code>: arquivo <strong>Rmarkdown</strong> gerado no RStudio (<code>File &gt; New File &gt; R Notebook</code>) e editado de forma que contenha o texto e o código (<em>chuncks</em>) necessários para resolução das questões 1 a 9.</p></li>
</ol>
<p>Sempre procure criar variáveis par resolução das questões. Utilize nomes contextualizados e intuitivos. Siga as boas práticas recomendadas no material e em laboratório para nomear as variáveis.</p>
<ol start="4" style="list-style-type: decimal">
<li>(Opcional) <code>lista1-adar-NomedoAluno.html</code> arquivo html gerado pelo RStudio (botão knit na aba do painel do editor) a partir do arquivo <code>lista1-adar-NomedoAluno.Rmd</code>.</li>
</ol>
</div>


