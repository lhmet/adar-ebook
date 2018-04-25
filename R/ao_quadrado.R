# ----------------------------------------------------------------------------
# primeira função no R
# eleva um número ao quadrado
# Código da função
ao_quadrado <- function(x) {
  mensagem <- paste("entrou:", x)
  print(mensagem)
  res <- x^2
  return(res)
}
# chamada da funcão
ao_quadrado(2)
ao_quadrado(3)
ao_quadrado(4)
