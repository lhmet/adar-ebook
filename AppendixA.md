---
output:
  html_document: default
---

# (APPENDIX) Appendix {-} 



# Operações adicionais com matrizes {#oper-mat}

Há outras formas de se construir uma matriz além daquela usando a função `matrix()`. Há também diveras operações matriciais que podem ser realizadas no <img src="images/logo_r.png" width="20">. Aqui apresentam-se esse conteúdo complementar sobre matrizes.

## Função `dim()`

Podemos converter um vetor atômico em uma arranjo de `n` dimensões através do atributo da dimensão de um objeto. Este atributo pode ser alterado pela função `dim()`. Para fazer isso, definimos o atributo `dim` (de dimensão) com um vetor numérico com os tamanhos para cada dimensão. 
O R reorganizará os elementos do vetor de acordo com as dimensões.


```r
v <- vetor <- 1:12
length(v)
#> [1] 12
attributes(v)
#> NULL
typeof(v)
#> [1] "integer"
# conversão de vetor para matriz
dim(v) <- c(3, 4) # 1a dimensão: linhas , 2a dimensão: colunas
# v é vector?
is.vector(v)
#> [1] FALSE
# v é matrix?
is.matrix(v)
#> [1] TRUE
# classe de vetor
class(v)
#> [1] "matrix"
attributes(v)
#> $dim
#> [1] 3 4
v
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    4    7   10
#> [2,]    2    5    8   11
#> [3,]    3    6    9   12
# invertendo as dimensões
dim(v) <- c(4, 3)
v
#>      [,1] [,2] [,3]
#> [1,]    1    5    9
#> [2,]    2    6   10
#> [3,]    3    7   11
#> [4,]    4    8   12
```

O R usa o primeiro elemento de `dim()` para o número de linhas e o segundo para o número de colunas. De forma geral, em operações que usam linhas e colunas, as linhas vem sempre em primeiro lugar.

Note como os valores de `v` foram distribuídos na matriz com 3 linhas e 4 colunas. O R sempre preenche a matriz ao longo das colunas.

Para mais controle na forma como R reorganiza os dados em linhas e colunas, podemos utilizar a função `matrix()` ou `array()`. Elas fazem a mesma coisa que a `dim()` porém com argumentos mais versáteis para estruturar uma `matrix`.


## Atribuição por indexação

Uma matriz `mat` poderia ser criada especificando os valores de cada elemento :


```r
# criando a matriz gerada com dim
mat <- matrix(nrow = 3, ncol = 4)
mat
#>      [,1] [,2] [,3] [,4]
#> [1,]   NA   NA   NA   NA
#> [2,]   NA   NA   NA   NA
#> [3,]   NA   NA   NA   NA
mat[1, 1] <- 1
mat[2, 1] <- 2
mat[3, 1] <- 3
mat[1, 2] <- 4
mat[2, 2] <- 5
mat[3, 2] <- 6
mat[1, 3] <- 7
mat[2, 3] <- 8
mat[3, 3] <- 9
mat[1, 4] <- 10
mat[2, 4] <- 11
mat[3, 4] <- 12
mat
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    4    7   10
#> [2,]    2    5    8   11
#> [3,]    3    6    9   12
```

No exemplo a seguir os dados do vetor aparecem distribuídos ao longo das linhas e não das colunas como no caso acima. Nós definimos isso com o argumento **`byrow = TRUE`** da função `matrix()`:


```r
vetor <- 1:12
mat <- matrix(vetor, ncol = 4, byrow = TRUE)
mat
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    2    3    4
#> [2,]    5    6    7    8
#> [3,]    9   10   11   12
```

## Operações matriciais 

### Multiplicação matricial

Operações algébricas, incluindo a multiplicação `*`, atuam elemento a elemento sobre matrizes. Mas se a intenção é fazer uma multiplicação matricial (Figura \@ref(fig:fig-multiplicacao-mat)) usamos o operador (`%*%`).

<div class="figure" style="text-align: center">
<img src="images/multilicacaoMatricial.png" alt="Multiplicação matricial." width="50%" />
<p class="caption">(\#fig:fig-multiplicacao-mat)Multiplicação matricial.</p>
</div>


```r
# multiplicação de duas matrizes
A <- matrix(c(2, 1, 4, 3, 0, 5), ncol = 2)
A
#>      [,1] [,2]
#> [1,]    2    3
#> [2,]    1    0
#> [3,]    4    5
B <- matrix(c(3, 2, 1, 4), ncol = 2)
B
#>      [,1] [,2]
#> [1,]    3    1
#> [2,]    2    4
A * B # erro pela diferença nas dims entre as matrizes
#> Error in A * B: non-conformable arrays
prod_mat <- A %*% B
prod_mat
#>      [,1] [,2]
#> [1,]   12   14
#> [2,]    3    1
#> [3,]   22   24
# multiplicação de uma matriz por um escalar
m <- matrix(1:16, nrow = 4, byrow = TRUE)
m
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    2    3    4
#> [2,]    5    6    7    8
#> [3,]    9   10   11   12
#> [4,]   13   14   15   16
m * 2
#>      [,1] [,2] [,3] [,4]
#> [1,]    2    4    6    8
#> [2,]   10   12   14   16
#> [3,]   18   20   22   24
#> [4,]   26   28   30   32
```

### Adição matricial


```r
m
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    2    3    4
#> [2,]    5    6    7    8
#> [3,]    9   10   11   12
#> [4,]   13   14   15   16
m + m
#>      [,1] [,2] [,3] [,4]
#> [1,]    2    4    6    8
#> [2,]   10   12   14   16
#> [3,]   18   20   22   24
#> [4,]   26   28   30   32
```

### Produto escalar


```r
u <- 1:3
v <- c(5, 12, 13)
u * v
#> [1]  5 24 39
# produto escalar = u.v = 1*5 + 2*12 + 3*13
crossprod(u, v)
#>      [,1]
#> [1,]   68
```

### Determinante


```r
# matriz exemplo
mat_ex <- matrix(c(1, -7, 3, 5, -9, 2, 6, 6, 1), ncol = 3)
det(mat_ex)
#> [1] 182
```

### Solução de sistemas lineares

$$
\left\{\begin{matrix}
x_1 + x_2 = 2
\\ 
-x_1 + x_2 = 4
\end{matrix}\right.
$$

Qual os valores de $x_1$ e $x_2$?


```r
# matrizes do sistema linear
coefs <- matrix(c(1, -1, 1, 1), ncol = 2)
y <- c(2, 4)
x <- solve(coefs, y)
x
#> [1] -1  3
```

