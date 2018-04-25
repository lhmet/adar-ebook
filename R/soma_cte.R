# ----------------------------------------------------------------------------
# ex. função adiciona 1
mais1 <- function(z) {
  z + 1
}
# teste
mais1(4)

# ----------------------------------------------------------------------------
# upgrade de mais1
soma_cte <- function(z, k = 1) {
  z + k
}
# testes
soma_cte(z = 1, k = 2)
soma_cte(z = 10, k = pi)
soma_cte(z = 10, k = 10)
