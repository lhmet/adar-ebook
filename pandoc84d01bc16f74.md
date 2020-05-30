O exemplo acima é mais uma operação com caracteres onde foi usada  a função `stringr::str_detect()` para detectar os elementos da variável do tipo caractere que contenham o termo \"Sul\". O pacote **stringr** [@Wickham-stringr] fornece funções para casar padrões de caracteres de texto e os nomes das funções são fáceis de lembrar. Todos começam com `str_` (de string) seguido do verbo, p.ex.:

`str_replace_all(`

   `  string = c("abc", "lca"),`

   `  pattern = "a",`

   `  replacement =  "A"`

`)`

`#> [1] "Abc" "lcA"`
