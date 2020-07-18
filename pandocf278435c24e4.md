A resultado da `which()` é um vetor numérico e portanto equivale a indexação numérica. Então a seleções abaixo são equivalentes:


`prec[which(inds_prec_alta)]`

`prec[inds_prec_alta]`


Quando é melhor usar uma ou outra opção?
Note que o resultado de `which(inds_prec_alta)` armazena somente os índices que satisfazem a condição, enquanto que o resultado de `inds_prec_alta` é um vetor lógico de mesmo tamanho que `prec`. Então, se estiver trabalhando com **big data** (p.ex.: um vetor com milhões de elementos) em termos de eficiência de uso da memória a `which()` é melhor opção.
