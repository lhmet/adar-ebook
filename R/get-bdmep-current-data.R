library(tidyverse)

# como obter dados recentes do BDMEP
resp <- httr::GET("https://apitempo.inmet.gov.br/estacao/2020-07-17/2020-07-19/83936")

if (httr::http_error(resp)) {
  resp %>%
    httr::http_status() %>%
    tibble::as_tibble() %>%
    print()
}

emc_data_raw <- httr::content(resp, as = "text") %>%
  jsonlite::fromJSON(txt = ., flatten = TRUE) %>%
  tibble::as_tibble() 


truly_chars <- tolower(
  c("DC_NOME", "CD_ESTACAO", "UF", "DT_MEDICAO", "HR_MEDICAO")
)

emc_data_proc <- emc_data_raw %>%
  # nomes em minusculo
  setNames(., tolower(names(.))) %>%
  # converte vars numericas 
  mutate(across(.cols = -all_of(truly_chars), .fns = as.numeric)) %>%
  # reordena colunas
  select(all_of(truly_chars), 
         "lon" = vl_longitude, 
         "lat" = vl_latitude,
         everything()
         ) %>%
  # arruma horario
  mutate(hr_medicao = paste0(
    str_sub(hr_medicao, 1, 2),
    ":",
    str_sub(hr_medicao, 3, 5),
    ":00"
  )) %>%
  # coluna com data
  tidyr::unite(date,  c("dt_medicao", "hr_medicao"), sep = " ") %>%
  mutate(date = lubridate::as_datetime(date))
  
