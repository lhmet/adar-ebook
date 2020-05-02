# -------------------------------------------------
# Testar se um objeto é da classe Date
is.date <- function(x) {
  return(class(x) == "Date")
}

# Teste da is.Date
is.date("abs")
is.date(123)
is.date("2009-01-01")
is.date(as.Date("2009-01-01"))
