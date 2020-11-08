No exemplo anterior nós introduzimos a função `dplyr::nth()`. Ela é equivalente ao operador colchetes `[` da base do R. Se `a <- 5:1` então as instruções abaixo produzem resultados equivalentes:

`a[2]; nth(a, 2)`

`#> [1] 4`
`#> [1] 4`

