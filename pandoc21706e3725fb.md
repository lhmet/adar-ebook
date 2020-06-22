O reposicionamento dos elementos de um vetor pode ser feito pela especificação da ordem dos índices. Par ordenar os elementos na ordem dezembro, Janeiro e Fevereiro indexamos da seguinte maneira:

`prec[c(12, 1, 2)]`

A inversão da ordem dos elementos pode ser feita com a indexação:

`prec[length(prec):1]`

A função `rev()` economiza tempo de digitação de código para realizar esta mesma ação:

`rev(prec)`

