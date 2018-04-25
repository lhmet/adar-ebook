# ------------------------------------------------------------------------------
# Calcular a idade a partir de uma data de nascimento.
# Argumento tem valor default.
calc_idade <- function(data_nasc = "1996-07-28") {
  data_nasc <- as.Date(data_nasc)
  hoje <- Sys.Date()
  # hoje
  # cálculo em anos
  idade <- as.numeric((hoje - data_nasc) / 365.25)
  # aredondamento da idade
  idade_arred <- floor(idade)
  print(paste("Idade:", idade_arred, "anos", sep = " "))
  return(idade_arred)
}

# ------------------------------------------------------------------------------
# testes função idade
calc_idade()
#calc_idade(20 / 07 / 1980) # erro, fora do formato de entrada esperado
calc_idade("1981-01-01")
calc_idade("1991-01-01")
calc_idade("1950-01-01")

# idade para mais de uma data?
nascimentos <- c("1996-07-28", "2000-07-31", "2006-09-20", "1890-01-01")
calc_idade(data_nasc = nascimentos)
