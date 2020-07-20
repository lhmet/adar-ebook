
easypackages::libraries(c("tidyverse", "rio", "openair", "lubridate", "magrittr"))

# dados de SM
# início 31/12/1911


# dados passados --------------------------------------------------------------
arq_inmet_bdmep <- "https://www.dropbox.com/s/xr0a78mbfh12usf/dados_83967_H_1910-01-01_2020-07-18.csv?dl=1"

# importar dados
dados_hist <- rio::import(arq_inmet_bdmep,
                     format = "csv",
                     skip = 10, 
                     na.strings = "null",
                     dec = ","
                     ) 
dados_hist_orig <- dados_hist

# limpar nomes
dados_hist <- as_tibble(dados_hist) %>%
  setNames(
    .,
    names(.) %>%
      stringi::stri_trans_general(., "latin-ascii")
    ) %>%
      janitor::clean_names()

# arrumar nomes
(nms_orig <- names(dados_hist))

lut_nms <- c("dia", "hora", 
             "nuvens_altas", "nuvens_baixas", "nuvens_medias", "neb_dec",
             "prec", "patm", "patm_0", 
             "tar_bs", "tar_bu", "td", 
             "ur", "wd", "ws", "visib",
             "dummy")
names(lut_nms) <- nms_orig
 
dados_hist <- setNames(dados_hist, nm = lut_nms[names(dados_hist)])



# remover variavéis sem nenhum dado
dados_hist <- dados_hist %>% 
  select(!where(~ all(is.na(.x))))

#dados_hist %>% select(hora) %>% distinct()

# date
dados_hist <- dados_hist %>% 
  mutate(hora = recode(hora, 
                       "1200" = "12",
                       "1800" = "18", 
                       "0" = "00"
                       #.default = "NA"
                       ),
         hora = paste0(hora, ":00:00"),
         date = lubridate::as_datetime(paste0(dia, " ", hora)),
         dia = NULL,
         hora = NULL
         ) %>%
  select(date, tar_bs, prec, everything())


# verificando vars numericas
sample_n(dados_hist, 20)
#dados_hist <- mutate(across(-date, as.numeric))


# janitor::tabyl(dados_hist, nuvens_altas) %>%
#   janitor::adorn_pct_formatting(digits = 0, affix_sign = TRUE) %>%
#   janitor::adorn_totals(where = c("row", "col"))

psych::describe(dados_hist)

# filter de obs that have values at least for one variable
#is.POSIXct(dados_hist$date)
any_obs_valid <- function(x) rowSums(!is.na(x)) > 0

dados_hist <-
  filter(dados_hist, any_obs_valid(
    across(
      .cols = where(~ !is.POSIXct(.x))
      #.fns = ~ .x > 0
    )
  ))

# dados_hist %>% select(where(~ !is.POSIXct(.x)))
# some_obs <- apply(dados_hist[, -1], 1, function(x) any(!is.na(x)))
# sum(some_obs)
# dados_hist <- filter(dados_hist, some_obs)
     


dados_hist %>% 
  #filter() %>%
  timePlot(., c("tar_bs", "prec"))

dd_hist <- dados_hist %>%
  arrange(date) %>%
  rename("tar" = tar_bs) %>%
  # get_dupes()
  mutate(
    date = date - 3 * 3600,
    # remoção de dados errôneos de prec
    prec = ifelse(!(year(date) <= 1986 | year(date) >= 2000), NA, prec)
  ) %>%
  group_by(date = ceiling_date(date, unit = "day")) %>%
  summarise(
    across(
      .cols = tar,
      .fns = list(med = mean, valid = ~ sum(!is.na(.x))),
      na.rm = TRUE
    ),
    across(
      .cols = prec,
      .fns = list(tot = sum, valid = ~ sum(!is.na(.x))),
      na.rm = TRUE
    ),
    n = n(),
    .groups = 'drop'
  ) %T>%
  timePlot(., c("tar_med", "prec_tot"))

# estatiscas por dia do ano
passado <- dd_hist %>%
  select(date, tar = tar_med, prec = prec_tot) %>%
  mutate(dda = lubridate::yday(date)) %>%
  # tira o ano atual
  filter(year(date) != year(today())) %>%
  group_by(dda) %>%
  arrange(dda) %>%
  mutate(
    across(
      .cols = all_of(c("tar", "prec")),
      .fns = list(
        max = ~ max(.x, na.rm = TRUE),
        min = ~ min(.x, na.rm = TRUE),
        med = ~ mean(.x, na.rm = TRUE),
        valid = ~ sum(!is.na(.x)),
        se = ~ sd(.x, na.rm = TRUE)
      ),
      na.rm = TRUE
    ),
    n = n()
  ) %>%
  mutate(
    tar_med_max = tar_med + (2.101 * tar_se/sqrt(tar_valid)),
    tar_95 = quantile(tar, probs = 0.975, na.rm = TRUE),
    tar_med_min = tar_med - (2.101 * tar_se/sqrt(tar_valid)),
    tar_05 = quantile(tar, probs = 0.025, na.rm = TRUE)
    #prec_med_sup = prec_med + (2.101*prec_se/sqrt(prec_valid)),
    #prec_med_inf = prec_med - (2.101*prec_se/sqrt(prec_valid))
    ) %>%
  ungroup()
passado

  timePlot(filter(passado, year(date) == 2018), 
           c("tar", "tar_med","tar_max", "tar_med_max",
             "tar_min", "tar_med_min"),
           group = TRUE)

  
# dados atuais: ultimo ano
atual <- dd_hist %>%
  select(date, tar = tar_med, prec = prec_tot) %>%
  mutate(dda = lubridate::yday(date)) %>%
  # tira o ano atual
  filter(year(date) == year(today()))

# recordes históricos de max e min
recordes <- passado %>%
  select(dda, tar_min, tar_max) %>%
  distinct()

  
recordes_atual <- left_join(recordes, atual) %>%
  mutate(record_max = ifelse(tar > tar_max, "S", "N"),
         record_min = ifelse(tar < tar_min, "S", "N")
         ) %>%
  filter(record_max == "S" | record_min == "S")
  
# ---------------------------------------------------------------
#dados_pres <- 

clima <- passado
tempo <- atual
recordes_atual

dados_sm <- list(clima = clima, tempo = tempo, recordes_atual = recordes_atual)

save(dados_sm,
     file = "D:/Dropbox/ufsm/ensino/1-semestre-2020/ADAR/notas-de-aula/bdmep-sm/dados-cap11-adar.RData")

print(load("D:/Dropbox/ufsm/ensino/1-semestre-2020/ADAR/notas-de-aula/bdmep-sm/dados-cap11-adar.RData"))




# link dos dados
url_data <- "https://www.dropbox.com/s/wqw42gp9vw54k87/dados-cap11-adar.RData?dl=1"
# arquivo temporário
#rio::import(url_data, format = "Rdata")
arq_temp <- tempfile(fileext = ".RData")
download.file(
  url = url_data,
  destfile = arq_temp,
  mode = "wb"
)
# nome dos dados carregados para os exercícios
print(load(arq_temp))

str(dados_sm)







 
