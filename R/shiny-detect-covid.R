# aplicação do styler
detecta_suspeito_covid <- function(info_paciente, limiar_covid = 4) {
  # info_paciente = paciente

  # Sindrome respiratoria aguda
  ptos1 <- ifelse(
    test = info_paciente$srag,
    yes = 4,
    no = 0
  )

  # febre
  ptos2 <- ifelse(
    test = info_paciente$febre > 37.8,
    yes = 2,
    no = 0
  )

  # tosse
  ptos3 <- ifelse(
    test = info_paciente$tosse == "com catarro",
    yes = 2,
    no = 0
  )

  # roquidao
  ptos4 <- ifelse(test = info_paciente$roquidao,
    yes = 1,
    no = 0
  )

  # dor de garganta
  ptos5 <- ifelse(
    test = info_paciente$dor_garganta,
    yes = 1,
    no = 0
  )

  # nariz entupido
  ptos6 <- ifelse(test = info_paciente$nariz_ent,
    yes = 1,
    no = 0
  )

  ptos_tot <- ptos1 + ptos2 + ptos3 + ptos4 + ptos5 + ptos6
  ptos_tot

  message("total de pontos:", ptos_tot)
  eh_suspeito <- ifelse(
    test = ptos_tot >= limiar_covid,
    yes = TRUE,
    no = FALSE
  )
  eh_suspeito
}

# critérios para casos suspeito de covid-19
dados_paciente <- data.frame(
  srag = TRUE,
  febre = 36,
  tosse = "sem catarro",
  roquidao = FALSE,
  dor_garganta = TRUE,
  nariz_ent = TRUE
)

# aplicando a função
detecta_suspeito_covid(info_paciente = dados_paciente)
