Para localizar valores extremos em um vetor podemos usar as funções `which.max()` e `which.min()` que fornecem respectivamente, a posição do valor máximo e mínimo no vetor.
Elas são versões eficientes dos códigos `which(x == max(x))` e `which(x == min(x))`. Contudo, há uma diferença entre elas que pode ser verificada pela comparação dos resultados das instruções:

`which.min(prec)`

`which(prec == min(prec))`

A primeira seleciona o primeiro índice para o qual `prec` tem seu mínimo (5° elemento), enquanto a segunda retorna todos os índices correspondentes ao mínimo (5° e 6° elemento).
