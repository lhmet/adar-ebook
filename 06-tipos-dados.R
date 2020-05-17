

## ----va-1--------------------------------------------------------------
(vetor_dbl <- c(-1.51, 0.33, 1.46, 2.04))


## A função `c()` aceita um **número variado de argumentos**, o que é representado por três pontos ou reticências (`...`) na sua documentação de ajuda (`?c`).


## ----va-2--------------------------------------------------------------
class(vetor_dbl)


## Medidas são compostas de um número e uma escala. Você pode estar trabalhando com valores de população na escala de milhões de habitantes, mas o valor pode ser apenas 1.7. Para garantir consistência nos seus cálculos, em termos de unidades, é recomendado nomear sua variável com alguma referência à sua unidade de medida. Erros de unidades podem ter consequências catastróficas como o exemplo do [Caso do Orbitador Climático de Marte](https://pt.wikipedia.org/wiki/Mars_Climate_Orbiter#Resultados).


## ----nums-1------------------------------------------------------------
(vetor_num <- c(-1, 0, 1, 2, NA_real_))
class(vetor_num)


## ----nums-2------------------------------------------------------------
typeof(vetor_num)


## ----nums-3------------------------------------------------------------
(vetor_int <- c(1L, 6L, 10L, NA_integer_))
typeof(vetor_int)


## ----------------------------------------------------------------------
vetor_num_fi <- as.integer(vetor_num)
typeof(vetor_num_fi)


## Há outros tipos de dados numéricos no R, como: complexos e hexadecimais.


## ----------------------------------------------------------------------
(vetor_char <- c('ae', NA_character_, "ou"))
class(vetor_char)


## ----------------------------------------------------------------------
nchar(vetor_char)


## ----------------------------------------------------------------------
# alfabeto inglês em letras minúsculas
letters
# alfabeto inglês em letras maiúsculas
LETTERS
# nomes dos meses em inglês
month.name
# abreviatura dos nomes dos meses em inglês
month.abb


## ----char-1------------------------------------------------------------
citacao <- 'Me diga o que é pior: "Desistir do que quer ou se contentar com o que nunca quiz?" - Reverb Poesia.'
citacao

sentenca_apos <- "Marca d'água"
sentenca_apos


## ----char-2------------------------------------------------------------
(sentenca_2aspas <- "Ele disse: \"Me sinto como um peixe fora d'água\"")


## ----------------------------------------------------------------------
print(sentenca_2aspas)


## ----------------------------------------------------------------------
cat(sentenca_2aspas, "\n")


## Há diversos caracteres especiais com interpretação especial dentro de caracteres (strings). Eles são precedidos por uma barra invertida (*escape*). Os mais comuns são:

##
## - `\\'` aspas simples

##
## - `\\"` aspas duplas

##
## - `\\n` quebra de lina ou nova linha

##
## - `\\\\` a própria barra invertida

##

## ----chunk9------------------------------------------------------------
# variável lógica
vetor_log <- c(FALSE, NA, FALSE, TRUE)
vetor_log
class(vetor_log)


## ----chunk12-----------------------------------------------------------
TRUE
T
class(T)
T <- 10
class(T)
c(T, F)


## ----------------------------------------------------------------------
is.character(vetor_num)


## ----------------------------------------------------------------------
is.integer(vetor_num)
is.numeric(vetor_num)
is.double(vetor_num)
is.logical(vetor_num)


## ----------------------------------------------------------------------
vetor_num
as.integer(vetor_num)
# verificação do resultado
typeof(as.integer(vetor_num))


## ----------------------------------------------------------------------
as.logical(vetor_num)
# verificação do resultado
typeof(as.logical(vetor_num))


## ----------------------------------------------------------------------
vetor_log
as.numeric(vetor_log)
# verificação do resultado
typeof(as.numeric(vetor_log))


## ----------------------------------------------------------------------
vetor_char
as.integer(vetor_char)
# verificação do resultado
typeof(as.numeric(vetor_char))


## ----------------------------------------------------------------------
(vmix_num_char <- c(vetor_num, vetor_char))
typeof(vmix_num_char)


## ----------------------------------------------------------------------
(vmix_log_num <- c(vetor_log, vetor_num))
typeof(vmix_log_num)


## ----------------------------------------------------------------------
(vmix_dbl_int <- c(vetor_dbl, vetor_int))
typeof(vmix_dbl_int)


## ----------------------------------------------------------------------
(vmix_log_char <- c(vetor_log, vetor_char))
typeof(vmix_log_char)


## ----------------------------------------------------------------------
# vetor lógico
vetor_num > 0
sum(vetor_num > 0, na.rm = TRUE)


# Continuação a partir do final do capítulo 6 (Aula 5) -----------

## ----------------------------------------------------------------------
intensidade <- factor(
  x = c("baixa", "moderada", "alta")
  )
intensidade


## ----------------------------------------------------------------------
levels(intensidade)


## ----------------------------------------------------------------------
str(intensidade)
as.numeric(intensidade)


## ----------------------------------------------------------------------
intensidade_o <- factor(
  x = c("baixa", "moderada", "alta"),
  levels = c("baixa", "moderada", "alta"),
  ordered = TRUE
  )
intensidade_o


## ----------------------------------------------------------------------
n_casos <- c(90, 30, 5)


## ----------------------------------------------------------------------
library(ggplot2)
qplot(x = intensidade, y = n_casos, geom = "col")
qplot(x = intensidade_o, y = n_casos, geom = "col")


## ----------------------------------------------------------------------
Sys.Date()
Sys.time()


## ----------------------------------------------------------------------
amd <- as.Date("2012-06-28")
amd
class(amd)
# num. de dias de 1971
as.numeric(amd)


## ----------------------------------------------------------------------
amd_hms <- as.POSIXct("2012-06-28 17:42")
amd_hms
class(amd_hms)
as.numeric(amd_hms)


## ----format-dates, echo = FALSE, warning=FALSE-------------------------
#<a name="tab-oper-logic"></a>
cod <- c(
  "%Y",
  "%m",
  "%d",
  "%H",
  "%M",
  "%S"
)
sig <- c(
  "ano (incluindo século)",
  "mês",
  "dia",
  "hora",
  "minuto",
  "segundo"
)

interv <- c(
  "1 - 9999",
  "01 - 12",
  "01 - 31",
  "00 - 23",
  "00 - 59",
  "00 - 59"
)

dates_format <- data.frame(
  código = cod,
  Significado = sig,
  Intervalo = interv,
  stringsAsFactors = FALSE
)
kable(dates_format,
      caption = "Códigos de formato de datas e horas.",
      align = "c")


## ----------------------------------------------------------------------
format(x = Sys.Date(), format = "%Y")


## ----------------------------------------------------------------------
as.POSIXct(
  x = "prec010120001942.grib",
  tz = "UTC",
  format = "prec%d%m%Y%H%M.grib"
  )

