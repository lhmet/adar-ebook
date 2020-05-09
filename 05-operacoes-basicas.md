# (PART) Fundamentos do R {-}

<!--
# Boas refrências
http://swcarpentry.github.io/r-novice-gapminder/
https://datacarpentry.org/R-ecology-lesson/
https://swcarpentry.github.io/r-novice-inflammation/06-best-practices-R/index.html
https://github.com/swcarpentry/2013-10-09-canberra
-->



<!--
NAO QUERO SER CHATO

If there’s one piece of advice I wish I could communicate to my past self, it’s “You have permission not to be boring.” Something being boring doesn’t make it necessary: often material is boring because it’s not solving a problem the students have. Something being boring doesn’t make it reliable, either. If students forget what you taught them, they can’t be relied upon to use it well.

In time, students will learn the “boring” material when they need to, during the thousands of hours it takes to become a proficient programmer. An introductory course has a different and important responsibility: to convince people that R is worth learning. And tidyverse packages are a powerful tool towards that goal.
-->


# Operações básicas {#operbasic}






Nesta seção veremos:

- operações aritméticas básicas com <img src="images/logo_r.png" width="20">
- a atribuição de valores a uma variável
- o uso de funções matemáticas internas do <img src="images/logo_r.png" width="20">
- valores numéricos especiais do <img src="images/logo_r.png" width="20">
- os cuidados ao nomear variáveis




## Convenção

<!-- 
tenho que trocar isso de lugar 
-->

A partir deste capítulo, os códigos a serem avaliadas no <img src="images/logo_r.png" width="20"> terão o *prompt* do <img src="images/logo_r.png" width="20"> (`>`) omitidos. Essa convenção é para tornar mais fácil a ação de copiar e colar os códigos na linha de comando do <img src="images/logo_r.png" width="20">. O resultado da avaliação das expressões será mostrado precedido do símbolo (`#>`). Esses valores são os resultados que esperam-se sejam reproduzidos pelo leitor na sessão do <img src="images/logo_r.png" width="20"> em seu computador. Por exemplo:


```r
1:5
#> [1] 1 2 3 4 5
```

No trecho de código acima,  a primeira linha contém o código a ser copiado pelo leitor para execução em seu computador. A segunda linha é a saída do código avaliado pelo R.


## Calculadora

O <img src="images/logo_r.png" width="20"> é uma calculadora turbinada com diversas funções matemáticas disponíveis. Para quem não conhece o <img src="images/logo_r.png" width="20">, essa uma forma de familiarizar-se com a linha de comandos.

### Aritmética básica

Todas operações feitas em uma calculadora podem ser realizadas no painel com console do <img src="images/logo_r.png" width="20"> no RStudio. Podemos calcular diversas operações em uma expressão:


```r
10 + 8^2 / 4 - pi
#> [1] 22.85841
```

Além de números e operadores artiméticos a expressão acima inclui a constante pré-definida ($\pi$): `pi` (=3.1415927).


<div class="rmdwarning">
<p>Note que no R, o separador decimal é o ponto ".", ao invés da vírgula "," usada na notação brasileira. As vírgulas tem a finalidade de separar os argumentos nas chamadas de funções, tal como <code>log(10, 10)</code>, que veremos na seção @ref(matfuns) .</p>
</div>

As operações no <img src="images/logo_r.png" width="20"> seguem a mesma ordem de precedência que aprendemos em matemática na escola: 

- parênteses: `(` `)`

- expoentes: `^`ou `**`

- multiplicação: `*`

- divisão: `/`

Então os parênteses podem ser usados para forçar a ordem das operações acima conforme nossa intenção:


```r
10 + ((8^2) / 4) - pi # parênteses opcionais se você lembrar a regra
#> [1] 22.85841
(10 + 8^2) / 4 - pi
#> [1] 15.35841
(10 + 8)^2 / 4 - pi
#> [1] 77.85841
(10 + 8^2 / 4) - pi
#> [1] 22.85841
10 + (8^2) / (4 - pi)
#> [1] 84.55668
10 + 8^(2 / 4) - pi
#> [1] 9.686834
10 + 8^(2 / 4 - pi)
#> [1] 10.00412
```

<!-- 
-1^2 = ?
-->

Se você quer saber se um número é divisor exato de outro número (resto da divisão igual a zero), o operador `%%` determina o resto de uma divisão:


```r
10 %% 2
#> [1] 0
11 %% 2
#> [1] 1
```

O operador `%/%` fornece a parte inteira do quociente da divisão entre 2 números.


```r
11 / 2
#> [1] 5.5
11 %/% 2
#> [1] 5
```


Operações que resultam em números muito pequenos ou muito grandes são representados em notação científica.



```r
5/10000
#> [1] 5e-04
```

Este mesmo valor pode ser escrito nas seguintes formas equivalentes:


```r
5e-4
#> [1] 5e-04
5E-4
#> [1] 5e-04
5*10^-4
#> [1] 5e-04
```


<!--
Os resultados dos cálculos no <img src="images/logo_r.png" width="20"> são mostrados com 7 dígitos significativos, o que pode ser verificado pela `getOptions()`. É possível mudar para `n` dígitos usando a função `options()`, conforme exemplo abaixo.


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
-->

O valor absoluto e o sinal de um número podem ser obtidos pelas seguintes expressões:


```r
abs(-6)
#> [1] 6
sign(-6)
#> [1] -1
```


### Cálculos problemáticos {#nans}

Quando um cálculo não tem sentido matemático ou não pode ser propriamente realizado (Tabela \@ref(tab:tab-num-esp)) surgirão alguns valores numéricos especiais na sua frente, como:  `Inf`(Infinito) e `NaN` (abreviação do termo em inglês *Not a Number* - valor indefinido).


Table: (\#tab:tab-num-esp)Exemplos de operações que resultam em NaN ou $\pm\infty$ .

           operação               resultado 
-------------------------------  -----------
              2/0                    Inf    
             -12/0                  -Inf    
            log(0)                  -Inf    
        (c(-3, 3))^Inf            NaN, Inf  
             0*Inf                   NaN    
           log(-0.5)                 NaN    
           sqrt(-1)                  NaN    
              0/0                    NaN    
            Inf-Inf                  NaN    
 mean(c(NA, NA), na.rm = TRUE)       NaN    

A demonstração das diferentes formas de se obter essas constantes especiais é importante para entender a origem delas ao rodar um script longo.

Por outro lado, há operações válidas com estes valores especiais.


```r
exp(-Inf)
#> [1] 0
(0:1)^Inf
#> [1] 0 1
0 / Inf
#> [1] 0
(-1 * Inf)^0
#> [1] 1
0^0
#> [1] 1
```

### Dados faltantes

<!-- 
https://medium.com/coinmonks/dealing-with-missing-data-using-r-3ae428da2d17 
https://towardsdatascience.com/how-to-handle-missing-data-8646b18db0d4
-->
Antes do que você imagina, na sua jornada pelo mundo real dos dados ambientais, você irá se deparar com os \"NAs\". `NA` é a abreviação do termo em inglês  *Not Available*, uma constante especial do <img src="images/logo_r.png" width="20"> que representa **dado faltante**. Geralmente dados faltantes são representados por um código [^codNA] como \"-999.99\" ou qualquer outro valor fora do intervalo de variação possível da variável. 

A coisa mais importante a saber sobre `NA` é que qualquer operação envolvendo `NA` resultará em `NA` (Tabela \@ref(tab:tab-nas)). 

[^codNA]: Valores não numéricos também podem ser encontrados por aí, como por exemplo \"---\", \"na\", \"N/A\", \"None\", \" \".



Table: (\#tab:tab-nas)Operações com NA.

 operação    resultado 
----------  -----------
  NA + 5        NA     
 sqrt(NA)       NA     
   NA^2         NA     
  NA/NaN        NA     




### Funções matemáticas {#matfuns}

O <img src="images/logo_r.png" width="20"> tem diversas funções internas. A sintaxe para chamar uma função é simplesmente:

<p style="color:DodgerBlue; font-size:1.3em; font-weight: bold;text-align:center;"> `funcão(argumento)` </p>

Por exemplo:


```r
# cosseno de 60°
cos(60 * pi / 180)
#> [1] 0.5
# raiz quadrada de 100
sqrt(100)
#> [1] 10
# exponencial de 1
exp(1)
#> [1] 2.718282
# fatorial de 4 (4*3*2*1)
factorial(4)
#> [1] 24
```

Por padrão a função logaritmo (`log()`) determina o logaritmo natural (logaritmo na base $e$). 


```r
# logaritmo natural de 10
log(x = 10)
#> [1] 2.302585
```

Para obter o logaritmo de 10 na base 10, o segundo argumento da função `log()` deve ser especificado, ou pode-se usar a função `log10()`.


```r
log(x = 10, base = 10) # logaritmo de 10 na base 10
#> [1] 1
log10(10) # forma equivalente
#> [1] 1
```

No <img src="images/logo_r.png" width="20"> você verá que parênteses são frequentemente utilizados. Em geral, uma palavra antecedendo um parênteses em uma expressão: é uma função.


Você não precisa lembrar do nome de cada função do <img src="images/logo_r.png" width="20">. Você pode ou buscar pelo termo em um site de busca, ou usar o auto-preenchimento de código (<tab> no RStudio)  após a parte inicial do nome da função.  

Digitando `?` antes do nome de uma função ou operador abrirá a página de ajuda daquela função. 


```r
?atan2
```


## Variáveis {#variaveis}

Até agora nós usamos expressões para fazer uma operação e obter um resultado. O termo \"expressão\" significa uma sentença de código que pode ser executada. Se a avaliação de uma expressão é salva usando o operador `<-`, esta combinação é chamada de operador **atribuição**. A expressão geral para definir uma variável é:

<p style="color:DodgerBlue; font-size:1.3em; font-weight: bold;text-align:center;"> `variavel <- valor` </p>

Uma atribuição armazena o valor (no lado direita da atribuição) em uma **variável**[^var-def] (no lado esquerdo da atribuição). Então uma variável é um nome usado para guardar os dados. Os valores dos dados podem ser de diferentes tipos, como veremos na seção \@ref(tipos-dados). 

[^var-def]: Uma variável é um nome que podemos usar para nos referirmos a um local específico na memória do computador, onde nós armazenamos dados enquanto nosso programa está rodando.


Quando uma variável recebe um valor, o <img src="images/logo_r.png" width="20"> não imprime nada no console.


```r
m_kg <- 100
```


Para visualizar o valor de uma variável, digite o nome da variável na linha de comando, ou imprima seu valor com a função `print()`.


```r
m_kg
#> [1] 100
print(m_kg)
#> [1] 100
```


O <img src="images/logo_r.png" width="20"> diferencia letras maiúsculas de minúsculas. 


```r
m_kg
#> [1] 100
M_KG
#> Error in eval(expr, envir, enclos): objeto 'M_KG' não encontrado
```

Como criamos apenas a variável `m_kg`, `M_kg` não foi encontrada. 

A variável `m_kg` pode ser utilizado para criar outras variáveis.


```r
peso_kg <- m_kg * 9.8
peso_kg
#> [1] 980
```

Os espaços em torno do operador de atribuição (` <- `) não são obrigatórios mas eles ajudam na legibilidade do código. Veja as diferentes interpretações que as expressões abaixo podem ter dependendo de como os espaços são posicionados em torno da variável `g`.


```r
g <- 9.8  # g é igual a 9.8
g < -9.8  # g é menor que -9.8 ?
g<-9.8    # g é igual a 9.8 ou é menor que -9.8 ?
```


Nós estamos definindo a variável, digitando o nome dela na linha de comando e teclando enter para ver o resultado. Há uma forma mais prática de fazer isso. Para criar e já mostrar o resultado da variável, podemos colocar parênteses em torno da atribuição:


```r
g <- 9.8 # cria
g        # imprime
#> [1] 9.8
(g <- 9.8) # cria e imprime
#> [1] 9.8
```

Podemos criar uma variável baseado em variáveis criadas previamente. Por exemplo, vamos definir a variável peso, como $p_{kg} = m_{kg}.g$:


```r
(peso_kg <- m_kg * g)
#> [1] 980
```

Se alterarmos o valor de uma das variáveis isso não mudará o valor da outra:


```r
(m_kg <- 10)
#> [1] 10
peso_kg
#> [1] 980
```

O antigo valor de `m_kg` será sobrescrito. Mas, embora `p_kg` tenha sido definida a partir de `m_kg`, seu valor permanecerá o mesmo. Esse comportamento que nos permite compreender o que acontece quando temos várias expressões em sequência num *script*. 


Para saber as variáveis já criadas numa sessão  <img src="images/logo_r.png" width="20">, use a função `ls()`[^11] para verificar as variáveis existentes:




```r
ls()
#> [1] "cran_news_windows"  "format_hotkey"      "g"                 
#> [4] "m_kg"               "peso_kg"            "r_cran_version_win"
```

[^11]: A saída da `ls()` é a lista de variáveis ou objetos criadas na sessão do R atual. Ela também é mostrada no painel *Environment* do RStudio.


<!--

```r
totd <- jan*7; totd <- totd + fev; totd <- totd + 4*abr
totd
```

#### Atribuição com a função `assign()`


Outra forma de atribuição é através da função `assign()`:


```r
es <- 3
assign(x = "es_hpa", value = es/10)
es_hpa
# usando função assign sem nome dos parâmetros
assign("u", 2.5)
u
```

Um exemplo mais elaborado de uso da função `assign()` para criar várias variáveis pode ser visto [aqui](https://gist.github.com/lhmet/d28856ed16690bb45d5be36ea4f5d458#file-assign-ex-rmd).


<div class="rmdwarning">
<p>Este método de atribuição é menos comum, por deixar o código menos legível que o método <code>variavel &lt;- valor</code>. Mas em alguns casos de programação avançada envolvendo ambientes (especificado como 3° argumento da <code>assign()</code>) ele pode ser útil.</p>
</div>
-->





### Removendo variáveis

Para remover variáveis usa-se a função `rm()`. Vamos remover a variável `m` criada previamente e ver a lista de objetos no espaço de trabalho.


```r
rm(m_kg)
ls()
#> [1] "cran_news_windows"  "format_hotkey"      "g"                 
#> [4] "peso_kg"            "r_cran_version_win"
```

Podemos remover mais de uma variável ao mesmo tempo.


```r
rm(g, peso_kg)
ls()
#> [1] "cran_news_windows"  "format_hotkey"      "r_cran_version_win"
```

Para remover todas variáveis do espaço de trabalho (use com cautela):


```r
# apagando tudo
rm(list = ls())
ls()
```



## Erros comuns

As expressões abaixo ilustram o que acontece quando cometemos alguns erros bem comuns ao trabalhar com <img src="images/logo_r.png" width="20">:


```r
srt(2)
#> Error in srt(2): não foi possível encontrar a função "srt"
m * g
#> Error in eval(expr, envir, enclos): objeto 'm' não encontrado
setwd("algum/caminho/no/alem")
#> Error in setwd("algum/caminho/no/alem"): não é possível mudar o diretório de trabalho
save(file = "algum/outro/caminho/no/alem")
#> Warning in save(file = "algum/outro/caminho/no/alem"): nothing specified to be
#> save()d
#> Warning in gzfile(file, "wb"): não foi possível abrir o arquivo comprimido
#> 'algum/outro/caminho/no/alem', motivo provável 'No such file or directory'
#> Error in gzfile(file, "wb"): não é possível abrir a conexão
```



Reconhecemos um erro pela presença da palavra **`Error`** na mensagem e por estar destacada em vermelha ou laranja, dependendo de como o RStudio está configurado. O que tem depois do \":\" na mensagem é uma tentativa do <img src="images/logo_r.png" width="20"> nos dizer o que deu errado. 


<div class="rmdtip">
<p><strong>As mensagens de erro são suas amigas. Sempre leia as mensagens de erro</strong>. Elas serão incompreensíveis no início, mas acabarão fazendo mais sentido e tornando-se útil (eu espero). Essa maneira de aprender só funciona se lermos as mensagens de erro em primeiro lugar.</p>
</div>

No trecho de código acima, na avaliação da expressão com a função `save()` surge primeiro um **Warning** (aviso). Avisos surgem quando algo inesperado ocorreu, mas que as coisas ainda podem dar certo. Outro exemplo de mensagem de aviso é:


```r
sqrt(-1)
#> Warning in sqrt(-1): NaNs produzidos
#> [1] NaN
```

Na expressão acima foi possível obter um resultado, mas o R avisa que foi produzido `NaN`. Como visto na seção \@ref(nans), qualquer operação derivada deste resultado produzirá `NaN`. 


Algumas vezes, as mensagens de erro e aviso podem não fazer sentido nem mesmo para usuários experientes, então fica a dica de consulta para referência (Figura \@ref(fig:google-it)).

<div class="figure" style="text-align: center">
<img src="images/practicalDev_googleErrorMessage.jpg" alt="Aprenda como descobrir qual o significado das mensagens de erro." width="50%" />
<p class="caption">(\#fig:google-it)Aprenda como descobrir qual o significado das mensagens de erro.</p>
</div>

<!--
https://br.pinterest.com/marcusoh/funny/
-->



## Boas práticas para códigos de boa qualidade

<!-- 
# consultar para acrescentar o que for útil/complementar
https://swcarpentry.github.io/r-novice-inflammation/06-best-practices-R/index.html

https://style.tidyverse.org/syntax.html#object-names

https://medium.com/experience-valley/ser%C3%A1-que-seus-coment%C3%A1rios-est%C3%A3o-deixando-seu-c%C3%B3digo-pior-5a961d5f4140

https://towardsdatascience.com/data-scientists-your-variable-names-are-awful-heres-how-to-fix-them-89053d2855be
-->

> Uma codificação em bom estilo é como usar a pontuação corretamente. Você pode até escrever sem usá-la, mas ela certamente deixa as coisas mais fáceis de ler.
>
>— Hadley Wickham




<!--
> O bom código não deve focar apenas na performance de execução, mas também em sua simplicidade, legibilidade e facilidade de manutenção por outros contribuidores.
>
>— [Silvio Henrique Ferreira](https://medium.com/experience-valley/ser%C3%A1-que-seus-coment%C3%A1rios-est%C3%A3o-deixando-seu-c%C3%B3digo-pior-5a961d5f4140)
-->

A medida que a complexidade dos códigos aumenta, você perceberá que a organização é imprescindível para rápida compreensão dele por você mesmo no futuro, pelos usuários e colaboradores. Um bom código não deve focar somente no desempenho de execução, mas também em sua simplicidade, legibilidade, o que inerentemente facilita sua manutenção por outros contribuidores.

Para deixar seu código compreensível uma boa referência é o [Guia de estilo de codificação **`tidyverse`**](https://style.tidyverse.org/). Um guia bastante utilizado pela comunidade <img src="images/logo_r.png" width="20"> e adotado pela [Google](https://google.github.io/styleguide/Rguide.html). 

A aplicação de todas as regras de formatação de código do **`tidyverse`** podem ser difíceis de ser lembradas. Mas este problema pode ser amenizado com o pacote [styler](http://styler.r-lib.org/) que fornece funções para estilizar o seu código no padrão **`tidyverse`**. Para utilizá-lo, instale o pacote **`styler`**.


```r
install.packages("styler")
```

As funções são acessíveis Através do menu  *`Addins`* do RStudio e incluem as opções de: estilizar um arquivo e uma região destacada do código (Figura \@ref(fig:styler-addin)).


<div class="figure" style="text-align: center">
<img src="images/styler_0.1.gif" alt="Exemplo de aplicação do Estilo de codificação tidyverse."  />
<p class="caption">(\#fig:styler-addin)Exemplo de aplicação do Estilo de codificação tidyverse.</p>
</div>


A convenção de estilo dos seus códigos é uma escolha sua.  Eu indico o estilo tidyverse, mas você pode optar por outro. O mais importante é ser consistente.

### Nomes de variáveis

<!-- 
Sobre boas práticas:
- falta inserir limite de largura de códigos num lugar mais adequado 
- falta falar sobre comentário de forma eficaz
-->

>“Há somente duas coisas difíceis em Ciência da Computação: invalidação de cache e escolher nomes para as coisas.”
>
>— Phil Karlton


Na seção (\@ref(variaveis)), vimos como criar variáveis. Este procedimento, implica em definir um nome para variável. Dar nomes claros, objetivos e coerentes para variáveis, funções, e argumentos é difícil. 

<div class="figure" style="text-align: center">
<img src="images/5-meaningfull-var-names.jpg" alt="Nomes de variáveis com significado." width="70%" />
<p class="caption">(\#fig:meanningfull-vnames)Nomes de variáveis com significado.</p>
</div>


A falta de clareza as vezes é compensada por excesso de comentários no código. Porém, hoje em dia, a prática de comentar o máximo possível está obsoleta e danosa. 

> O bom código é sua própria melhor documentação. Quando você for a adicionar um comentário, se pergunte, “Como eu posso melhorar o código para que o este comentário não seja necessário?” Melhore o código e então o documente para torná-lo ainda mais claro.
>
>— Steve McConnell



De forma geral, podemos listar os seguintes cuidados ao nomear variáveis no <img src="images/logo_r.png" width="20">: 

- usar nomes claros, objetivos e coerentes

- não iniciar com um número, ponto (`.`) ou sublinhado (`_`) e não conter espaços

- não usar acentos e caracteres especiais

        ^, !, $, @, +, -, /, ou *

- evitar o uso de nomes reservados do <img src="images/logo_r.png" width="20"> (funções internas, constantes e etc):

        c q  s  t  C  D  F  I  T  diff  exp  log  mean  pi  range  rank  var

        FALSE  Inf  NA  NaN  NULL TRUE 
     
        break  else  for  function  if  in  next  repeat  while


- usar ` <- ` para atribuição (colocar um espaço antes e depois) e deixe o ` = ` para argumentos de funções.

- não colocar ` ; ` no final de uma linha e evite vários comandos na mesma linha.

- usar somente letras minúsculas, números (após a primeira letra do nome). Use o `_` ou sublinhado para separar palavras dentro de um nome de variável longo([caso cobra](https://pt.qwe.wiki/wiki/Snake_case)).

<!---
; do operador igual ` = ` na chamada de função com argumentos.

- usar identação de código

   - Código sem identação:


```r
mydf <- cbind.data.frame(do.call(rbind, lapply(strsplit(myfile[!seq(length(myfile)) %% 2], ", "),function(x)gsub(".*\\=", "", x))), lca = gsub(".*\\:\\s+", "", myfile[seq(length(myfile)) %% 2]))
```

   - Código com identação:


```r
mydf <-
  cbind.data.frame(
    do.call(
      rbind,
      lapply(
        strsplit(
          x = myfile[!seq(length(myfile)) %% 2],
          split = ", "
        ),
        function(x) {
          gsub(".*\\=", "", x)
        }
      )
    ),
    lca = gsub(
      pattern = ".*\\:\\s+",
      replacement = "",
      x = myfile[seq(length(myfile)) %% 2]
    )
  )
```
-->


## Exercícios

<!-- 
equação de báskara para dados valores 
-->


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

7. Determine a temperatura de bulbo úmido ($T_{w}$) usando a expressão empírica ([Stull, 2011](http://journals.ametsoc.org/doi/abs/10.1175/JAMC-D-11-0143.1])) abaixo. Salve os resultados em variáveis diferentes. Para uma temperatura do ar ($T$) de 20°C e Umidade relativa ($UR$) de 70%, qual o valor de `Tw`? Defina variáveis para os valores $T$ e ($UR$) e use-as na equação de $T_{w}$.

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
<li><p><code>lista1-adar-NomedoAluno.Rmd</code>: arquivo <strong>Rmarkdown</strong> gerado no RStudio (<em><code>File ▶ New File ▶ R Notebook</code></em>) e editado de forma que contenha o texto e o código (<em>chuncks</em>) necessários para resolução das questões 1 a 9.</p></li>
</ol>
<p>Sempre procure criar variáveis para cada etapa da resolução das questões. Utilize nomes contextualizados e intuitivos. Siga as boas práticas recomendadas no material para nomear as variáveis.</p>
<ol start="4" style="list-style-type: decimal">
<li>(Opcional) <code>lista1-adar-NomedoAluno.html</code> arquivo html gerado pelo RStudio (botão knit na aba do painel do editor) a partir do arquivo <code>lista1-adar-NomedoAluno.Rmd</code>.</li>
</ol>
</div>



