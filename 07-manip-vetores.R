## ----setup, include = FALSE------------------------------------------
rm(list = ls())
pcks <- c("knitr", "pander", "htmlTable")
easypackages::libraries(pcks)
opts_chunk$set(
  prompt = FALSE,
  cache = FALSE,
  fig.path = "images/",
  comment = "#>",
  collapse = TRUE
)
source("R/utils.R")


## ----nv1, message=FALSE----------------------------------------------
# vetor de chuva mensal para um dado ano
prec <- c(
  jan = 300, 
  fev = 150,
  mar = 210,
  abr = 12, 
  mai = 0, 
  jun = 0, 
  jul = 12, 
  ago = 22, 
  set = 100, 
  out = 120, 
  nov = 10,  
  dez = 280
  )


## ----nv2-------------------------------------------------------------
prec <- c(300, 200, 210, 12, 0, 0, 12, 22, 100, 120, 10, 280)
meses <- c("jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out", "nov", "dez")
names(prec) <- meses
prec


## ----nv3-------------------------------------------------------------
prec <- setNames(
  object = c(300, 200, 210, 12, 0, 0, 12, 22, 100, 120, 10, 280),
  nm = c("jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out", "nov", "dez")
)
prec


## ----chunk75---------------------------------------------------------
(meses <- c(jan = 1, fev = 2, 3:12))
names(meses)


## --------------------------------------------------------------------
names(1:12)


## ----chunk76, message=FALSE------------------------------------------
prec_clim <- c(230, 205, 160, 100, 60, 30, 40, 60, 110, 165, 200, 220)
names(prec_clim) <- names(prec)
prec_clim
unname(prec_clim)
names(prec_clim) <- NULL
prec_clim


## --------------------------------------------------------------------
temp <- c(27, 23, 21, 18, 19, 28)
attributes(temp)


## --------------------------------------------------------------------
attr(temp, "metadados") <- "dados obtidos em www.inmet.gov.br, acesso em 10/10/2010"
temp


## --------------------------------------------------------------------
(temp_inc <- temp + 1)
(temp_inc <- c(temp_inc, 18))


## ----chunk78, message=FALSE------------------------------------------
# desvios da prec em relação a média climatológica
prec - prec_clim
# anomalia em % relativa
prec/prec_clim * 100
# transformação boxcox da prec com alpha = 0.335
((prec^0.335 - 1)/0.335)
# cte^intervalo
mean(prec)^(1/2:5)


## ----chunk711, message=FALSE-----------------------------------------
# velocidades em m s-1
(vel_ms <- c(1.5, 0.3, 1.4, 2.0))
# fator de conversão para km h-1
fator_conv <- 3.6
vel_ms * fator_conv
# equivalência
fator_conv <- c(3.6, 3.6, 3.6, 3.6)
vel_ms * fator_conv


## --------------------------------------------------------------------
1:10 * 1:2
1:10 * 1:3


## --------------------------------------------------------------------
FALSE - TRUE
prec_clim >= 100
(prec_clim >= 100) * 1:12


## ----oper-logic, echo = FALSE, warning=FALSE-------------------------
# <a name="tab-oper-logic"></a>
oper <- c("<", "<=", ">", ">=", "==", "!=", "!x", "x | y", "x & y", "isTRUE(x)", "%in%")
desc <- c("menor que", " menor ou igual a", "maior que", "maior ou igual", "idêntico", "diferente", "não é x (negação)", "x ou y", "x e y", "teste se x é verdadeiro", "está contido em")
oper_logic <- data.frame(
  Operador = oper,
  Descrição = desc,
  stringsAsFactors = FALSE
)
kable(oper_logic, caption = "Operadores Lógicos", align = "c")


## --------------------------------------------------------------------
prec
prec_clim
prec - prec_clim < 0


## --------------------------------------------------------------------
# operador está contido em
c(200, 150, 100) %in% prec
# 2:4 são elementos de x?
is.element(c(200, 150, 100), prec)


## --------------------------------------------------------------------
# prec entre 0 e 100 mm
prec > 0 & prec <= 100
# prec abaixo de 50 e acima de 150 mm
prec < 50 | prec >= 150


## ----chunk7290, message=FALSE----------------------------------------
a <- c(1, 1, 0, 1)
b <- c(2, 1, 0, 1)
# forma normal verifica cada elemento de a e cada elemento de b
a == 1 & b == 1
# forma dupla verifica somente o primeiro elemento de a e o primeiro elemento de b
# retornando somente um resultado
a == 1 && b == 1


## ----chunk72901, message=FALSE  , echo=FALSE, out.width=200----------
oper <- c("a", "b", "a==1", "b==1", "a == 1 & b == 1", "a == 1 && b == 1")
desc <- data.frame(
  a,
  b,
  a == 1,
  b == 1,
  a == 1 & b == 1,
  a == 1 && b == 1
)
names(desc) <- oper
desc[2:nrow(desc), 6] <- ""
pander(desc, caption = "Demonstração da diferença entre & e &&.")


## --------------------------------------------------------------------
0.6 - 0.3
0.9 - 0.6
0.3 == 0.3


## --------------------------------------------------------------------
(0.6 - 0.3) == (0.9 - 0.6)


## --------------------------------------------------------------------
all.equal(
  target = 0.6 - 0.3,
  current = 0.9 - 0.6
)


## ----chunk715, message=FALSE-----------------------------------------
vetor <- c(0, 1, -1, -2, 3, 5, -5)
all(vetor < 0) # todas as posições são maiores que 0 ?
any(vetor > 0) # alguma posição é maior que 0?


## ----chunk716, message=FALSE-----------------------------------------
(ddm <- 1:31)
typeof(ddm)
# sequencia de inteiros decrescente
(si_dec <- 10:-10)
typeof(si_dec)


## ----seq1------------------------------------------------------------
seq(from = 1, to = 10, by = 3)
seq(from = 10, to = 1, by = -3)


## ----seqs-by, eval = TRUE, echo = FALSE------------------------------
tbl_seqs_by <- tibble::tibble(
  `'from'` = 1,
  `'to'` = c(10, 10, 11, 11),
  `'to' é par?` = `'to'` %% 2 == 0,
  `'by'` = rep(c(2, 3), times = 2),
  `'by' é par?` = `'by'` %% 2 == 0,
  `sequência` = mapply(base::seq,
    from = `'from'`,
    to = `'to'`,
    by = rep(c(2, 3), times = 2)
  ),
  `resultado inclui 'to'` = lapply(
    base::seq_along(`'to'`),
    function(i) {
      `'to'`[i] %in% `sequência`[[i]]
    }
  )
)
knitr::kable(tbl_seqs_by,
  caption = "Sequências com argumentos ímpares e pares.",
  align = "c"
)



## ----chunk718, message=FALSE-----------------------------------------
seq(from = 1, to = 10, length.out = 20)


## --------------------------------------------------------------------
rep(x = 1:2, times = 4)


## --------------------------------------------------------------------
rep(x = 1:2, each = 3)


## --------------------------------------------------------------------
rep(x = 1:2, times = 4, each = 3)


## --------------------------------------------------------------------
rep(x = 1:2, times = 4:3)


## ----chunk721, message=FALSE-----------------------------------------
# vetor com as posições dos meses de janeiro e dezembro
c(1, length(prec))
# acesso aos valores localizados nas posições 1 e 12 
prec[c(1, length(prec))]


## ----chunk723, message=FALSE-----------------------------------------
inds_jja <- 6:8
# vetor de chuva JJA
prec[inds_jja]


## O reposicionamento dos elementos de um vetor pode ser feito pela especificação da ordem dos índices. Par ordenar os elementos na ordem dezembro, Janeiro e Fevereiro indexamos da seguinte maneira:

## 
## `prec[c(12, 1, 2)]`

## 
## A inversão da ordem dos elementos pode ser feita com a indexação:

## 
## `prec[length(prec):1]`

## 
## A função `rev()` economiza tempo de digitação de código para realizar esta mesma ação:

## 
## `rev(prec)`

## 

## ----chunk724, message=FALSE-----------------------------------------
prec[-(2:11)]


## --------------------------------------------------------------------
 prec[-c(1:5, 9:12)]


## --------------------------------------------------------------------
prec[c("jan", "dez")]


## --------------------------------------------------------------------
prec[c("jun", "jul", "ago")]


## ----chunk725, message=FALSE-----------------------------------------
inds_log <- c(
  TRUE, FALSE, FALSE, FALSE,
  FALSE, FALSE, FALSE, FALSE,
  FALSE, FALSE, FALSE, TRUE
)
prec[inds_log]


## ----chunk727, message=FALSE-----------------------------------------
inds_log <- c(TRUE, FALSE)
prec[inds_log]


## ----chunk728, message=FALSE-----------------------------------------
inds_prec_alta <- prec > 80
prec[inds_prec_alta]


## --------------------------------------------------------------------
which(inds_prec_alta)


## --------------------------------------------------------------------
which(inds_prec_alta)[4]
names(which(inds_prec_alta)[4])
# ou
names(prec)[which(inds_prec_alta)[4]]


## A resultado da `which()` é um vetor numérico e portanto equivale a indexação numérica. Então a seleções abaixo são equivalentes:

## 
## 
## `prec[which(inds_prec_alta)]`

## 
## `prec[inds_prec_alta]`

## 
## 
## Quando é melhor usar uma ou outra opção?

## Note que o resultado de `which(inds_prec_alta)` armazena somente os índices que satisfazem a condição, enquanto que o resultado de `inds_prec_alta` é um vetor lógico de mesmo tamanho que `prec`. Então, se estiver trabalhando com **big data** (p.ex.: um vetor com milhões de elementos) em termos de eficiência de uso da memória a `which()` é melhor opção.


## Para localizar valores extremos em um vetor podemos usar as funções `which.max()` e `which.min()` que fornecem respectivamente, a posição do valor máximo e mínimo no vetor.

## Elas são versões eficientes dos códigos `which(x == max(x))` e `which(x == min(x))`. Contudo, há uma diferença entre elas que pode ser verificada pela comparação dos resultados das instruções:

## 
## `which.min(prec)`

## 
## `which(prec == min(prec))`

## 
## A primeira seleciona o primeiro índice para o qual `prec` tem seu mínimo (5° elemento), enquanto a segunda retorna todos os índices correspondentes ao mínimo (5° e 6° elemento).


## --------------------------------------------------------------------
(prec_alt <- prec)


## ----chunk732, message=FALSE-----------------------------------------
inds_jja
prec_alt[inds_jja] <- c(NA, 21, 42)
prec
prec_alt


## ----chunk733, message=FALSE-----------------------------------------
prec_jd_corr <- c(250, 208)
prec_alt[c("jan", "dez")] <- prec_jd_corr
prec
prec_alt


## --------------------------------------------------------------------
# limiar em % da normal climatológica
limiar <- 10 
desvios <- prec - prec_clim
# anomalias relativas em %
(anom_perc <-  abs(desvios)/prec_clim * 100)


## --------------------------------------------------------------------
# meses com prec em torno de +-10% da média climatol.
prec[anom_perc <= 10]
# substituição pela prec mensal climatol. 
prec[anom_perc <= 10] <- prec_clim[anom_perc <= 10]
prec


## ---- eval = FALSE---------------------------------------------------
## prec <- ifelse(ano_perc <= 10, prec_clim, prec)

## --------------------------------------------------------------------
prec


## --------------------------------------------------------------------
prec_alt_comp <- ifelse(
  test = is.na(prec_alt), # condição: é faltante?
  yes = prec_clim,        # se verdadeira: preenche com prec_clim 
  no = prec_alt           # se falsa: mantém prec_alt
)
prec_alt_comp


## --------------------------------------------------------------------
prec_alt[c(3, 4, 11)] <- NA
prec_alt


## --------------------------------------------------------------------
is.na(prec_alt)


## --------------------------------------------------------------------
which(is.na(prec_alt))


## --------------------------------------------------------------------
prec_alt == NA


## --------------------------------------------------------------------
anyNA(prec_alt)
sum(is.na(prec_alt))


## --------------------------------------------------------------------
prec_alt[!is.na(prec_alt)]
# outra forma equivalente
#prec_alt[-which(is.na(prec_alt))]


## --------------------------------------------------------------------
prec_alt_sem_falt <- na.omit(prec_alt)
attributes(prec_alt_sem_falt)


## --------------------------------------------------------------------
attr(
  x = prec_alt_sem_falt,
  which = "na.action"
)


## --------------------------------------------------------------------
prec_alt_val_long <- na.contiguous(prec_alt)
prec_alt_val_long


## --------------------------------------------------------------------
prec_alt > 220


## --------------------------------------------------------------------
prec_clim[prec_alt > 220]


## --------------------------------------------------------------------
prec_clim[!is.na(prec_alt) & prec_alt > 220]


## --------------------------------------------------------------------
subset(
  x = prec_clim,
  subset = prec_alt > 220
)


## --------------------------------------------------------------------
range(prec_alt)


## --------------------------------------------------------------------
range(prec_alt, na.rm = TRUE)


## --------------------------------------------------------------------
# prec máx. mensal
max(prec_alt, na.rm = TRUE)
# pŕec min mensal
min(prec_alt, na.rm = TRUE)
# prec total anual
sum(prec_alt, na.rm = TRUE)
# prec média
mean(prec_alt, na.rm = TRUE)
# mediana da prec 
median(prec_alt, na.rm = TRUE)
# desvio padrão
sd(prec_alt, na.rm = TRUE)
# variância
var(prec_alt, na.rm = TRUE)


## --------------------------------------------------------------------
summary(prec_alt)


## --------------------------------------------------------------------
vetor_nulo1 <- NULL
vetor_nulo1
length(vetor_nulo1)


## --------------------------------------------------------------------
vetor_nulo2 <- c()
vetor_nulo2


## --------------------------------------------------------------------
exists(x = "vetor_nulo1")


## --------------------------------------------------------------------
(vetor_elem_nulo <- c(1, 2, NULL, 4))
length(vetor_elem_nulo)
vetor_elem_nulo + NULL


## --------------------------------------------------------------------
prec
names(prec) <- NULL
prec
prec <- NULL
prec


## --------------------------------------------------------------------
datas <- seq(
  from = as.Date("2017-01-10"),
  to = as.Date("2017-01-10") + 10,
  by = "day"
)
datas <- c(
  datas[1:6], NA, 
  datas[7:length(datas)], 
  datas[length(datas)], 
  datas[5:6]
)
datas


## --------------------------------------------------------------------
duplicated(datas)


## --------------------------------------------------------------------
# datas únicas: sem valores duplicados
datas[!duplicated(datas)]


## --------------------------------------------------------------------
unique(datas)


## --------------------------------------------------------------------
sort(prec_alt)
sort(prec_alt, decreasing = TRUE)


## --------------------------------------------------------------------
sort(names(prec_alt))


## --------------------------------------------------------------------
prec_alt
order(prec_alt)


## --------------------------------------------------------------------
order(prec_alt, na.last = NA)


## ---- eval=TRUE,echo=FALSE,comment=""--------------------------------
(tar0 <- c(-20, seq(0, 40, by = 10)))


## ---- eval=TRUE,echo=FALSE,comment=""--------------------------------
(seq(-1, 1, by = 1 / 4))


## ---- eval=TRUE,echo=FALSE,comment=""--------------------------------
(seq(-pi, pi, length.out = 12))


## ---- eval=TRUE,echo=FALSE,comment=""--------------------------------
rep(1:5, times = 5:1)


## ---- eval=TRUE,echo=FALSE,comment=""--------------------------------
rep(c(1:5, 4:1), times = c(5:1, 2:5))


## ---- eval=TRUE,echo=FALSE,comment=""--------------------------------
v3 <- c(10, 0.5, 8, 4)


## ---- eval=TRUE,echo=FALSE,comment=""--------------------------------
1:length(v3)


## ----Chunk7b, eval=TRUE,echo=FALSE,comment=""------------------------
v2 <- c(10, 0.5)


## ----Chunk7b_sol, eval=TRUE,echo=FALSE,comment=""--------------------
1:length(v2)


## ----Chunk7c, eval=TRUE,echo=FALSE,comment=""------------------------
v1 <- c(10)


## ----Chunk7c_sol, eval=TRUE,echo=FALSE,comment=""--------------------
1:length(v1)


## ----Chunk7d, eval=TRUE,echo=FALSE,comment=""------------------------
v0 <- c()


## ----Chunk7d_sol, eval=TRUE,echo=FALSE,comment=""--------------------
# 1:length(v0)
seq_along(v0)


## ---- echo = FALSE---------------------------------------------------
hora <- (12:24) - 3
prec_h <- c(0, 0, 0, 0, 0, 0, 0, 21.4, 41.2, 2.6, 1, 0.4, 0)
evento <- data.frame(hora, prec = prec_h)
knitr::kable(evento, align = "c", longtable = TRUE)


## ---- include = FALSE------------------------------------------------
(prec_acum <- cumsum(prec_h))


## ---- include = FALSE------------------------------------------------
hora[which.max(prec_h)]


## ---- include = FALSE------------------------------------------------
(inicio <- hora[prec_h > 0][1])
(fim <- hora[max(which(prec_h > 0))])
fim - inicio + 1
sum(prec_h > 0)


## ---- include = FALSE------------------------------------------------
tot_evento <- sum(prec_h)
perc_rel <- prec_h / tot_evento * 100
perc_rel
perc_rel_cum <- cumsum(perc_rel)
perc_rel_cum[hora == 17]
round(perc_rel_cum[hora == 17])


## --------------------------------------------------------------------
x <- c(
  11, 10, 15, 2, 6, -15, -10, -22, -8, 5,
  7, 2, 12, 8, 4, 1, 3, -3, -1, 30, 14
)
# x1 <- ifelse(x > 0, 1, 0)
# cópia de x
x01 <- x
# substituo x positivo por 1 e x negativo por 0
x01[x > 0] <- 1
x01[!x > 0] <- 0
res <- x[which(diff(x01) == 1) + 1]
res


## ----Chunk10, echo=FALSE, eval=FALSE---------------------------------
## # como gerar vetor de precipitações
## vprec <- c(
##   0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
##   1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0,
##   0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0,
##   1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0,
##   0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0,
##   0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0,
##   0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0,
##   1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1,
##   1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0,
##   0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
##   0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0,
##   0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
##   0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1,
##   1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1,
##   1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1,
##   1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0,
##   1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0
## )
## prec <- vprec
## prec[vprec > 0] <- runif(sum(vprec > 0)) * sample(c(0.1, 1, 5, 10, 20), size = sum(vprec > 0), replace = TRUE, prob = c(0.1, 0.30, 0.3, 0.2, 0.1))
## prec
## dput(round(prec, 2))


## ----Chunk10a, message=FALSE, echo=TRUE, eval=TRUE-------------------
prec <- c(
  0, 0, 0, 0.8, 0, 0.01, 0.75, 0,
  0, 0, 0, 0.35, 0.08, 0, 0, 0, 0, 0.31, 0, 3.57, 12.17, 0, 0,
  0, 0.04, 3.16, 0, 0.95, 0.79, 0, 0, 0, 0, 0, 3.51, 0, 0, 0.16,
  0, 0, 8.16, 0.54, 4.39, 1.24, 0, 0, 0, 0, 0, 2.43, 0, 0, 0, 0,
  0, 7.18, 0, 0, 0.26, 0, 0, 0.28, 0, 0, 0.09, 0.38, 0, 0, 0, 0,
  0, 0, 0.51, 0, 0, 0, 0, 0, 0, 0.67, 0, 0, 0, 0, 0.15, 0, 0.82,
  0, 0, 0, 0, 0, 0, 0, 0, 0.37, 0, 0.58, 4.95, 0, 0, 0, 0, 0, 7.68,
  0, 0, 0.37, 0, 1.56, 0, 0, 0, 0.34, 0.48, 0, 4.21, 2.28, 4.3,
  0, 3.38, 0, 0, 0, 0, 7.28, 0, 4.89, 3.91, 0, 0, 0, 0, 0, 0, 2.93,
  0, 2.49, 0.77, 0, 2.9, 3.53, 0.83, 0, 0, 0, 0.94, 0.59, 0, 0,
  0, 0, 0.04, 0, 0.65, 0, 0, 0, 6.23, 0.09, 0, 0.66, 0, 0, 0, 4.42,
  0, 0, 0, 0.84, 0, 0, 0, 0, 0, 0.09, 0, 0, 0.08, 0, 0.66, 0, 0,
  0, 0.06, 0, 0, 0, 3.28, 0, 0.8, 5.69, 0.8, 0
)


## ----Chunk10a1, echo=FALSE, eval=TRUE, results = FALSE---------------
n_ev <- sum(prec > 0 & prec < 0.25)
n_ev
vals_ev <- prec[prec > 0 & prec < 0.25]
vals_ev


## ----Chunk10b, echo=FALSE, eval=TRUE, results = FALSE----------------
prec[prec > 0 & prec < 0.25] <- 0
prec


## ----Chunk10c, echo=FALSE, eval=TRUE, results = FALSE----------------
limiar <- 0.25
prec01 <- as.integer(prec > limiar)
# prec01
prec_estado <- prec01
prec_estado[prec_estado == 1] <- "chuvoso"
# prec_estado
prec_estado[prec_estado == "0"] <- "seco"
prec_estado


## ----Chunk10d, echo=FALSE, eval=TRUE, results = FALSE----------------
prob <- sum(prec01) / length(prec01)
prob <- mean(prec01)
# %
prob_perc <- mean(prec01) * 100
prob
prob_perc


## ----Chunk10e, message=FALSE, echo=FALSE, eval=TRUE, results=FALSE----
choveu <- data.frame(
  hoje = prec01[-length(prec01)],
  amanha = prec01[-1]
)
choveu
# p11: núm de eventos com chuva em dois dias consecutivos /núm. de combinações de 2 dias
prob11 <- with(
  choveu,
  sum(hoje == 1 & amanha == 1) / length(amanha) * 100
)
prob11
# p01
prob01 <- with(
  choveu,
  sum(hoje == 0 & amanha == 1) / length(amanha) * 100
)
prob01
# p10
prob10 <- with(
  choveu,
  sum(hoje == 1 & amanha == 0) / length(amanha) * 100
)
prob10
prob10 == prob01
# sum(sapply(1:(length(prec01)-1), function(i) if(prec01[i] == 1 & prec01[i+1] == 1) 1 else 0))/length()
# numero de vezes que choveu ou hoje ou amanhã: p(1|1)
prob12 <- with(
  choveu,
  sum(hoje != amanha) / length(amanha) * 100
)
prob12
# p00
prob00 <- with(
  choveu,
  sum(hoje == 0 & amanha == 0) / length(amanha) * 100
)
prob00
# somas das probalidades deve ser igual a 1
prob12 + prob11 + prob00


## ----Chunk10e1, echo=FALSE, eval=TRUE, results='hide'----------------
## PARA MELHOR VISUALIZAÇÃO
# data frame para visualização de casos de prec com 2 consecutivos
conds_df <- with(
  choveu,
  data.frame(hoje,
    amanha,
    cond00 = hoje == 0 & amanha == 0,
    cond11 = hoje == 1 & amanha == 1,
    cond01 = (hoje == 0 & amanha == 1),
    cond10 = (hoje == 1 & amanha == 0),
    cond12 = (hoje != amanha)
  )
)
# dia que não permite comparação para as transições de estado
# conds_df <- conds_df[complete.cases(conds_df), ]
(probs <- colSums(conds_df) / nrow(conds_df))
# verificação das probabilidades
(probs_sum <- sum(probs[-c(1:2, 7)]))


## ----Chunk10f, echo=FALSE, eval=TRUE, results='hide'-----------------
# posições iniciais do evento
posi <- which(diff(c(0, prec01)) == 1)
# posições finais do evento
posf <- c(which(diff(c(prec01, 0)) == -1))
# duracao de cada evento
duracao <- posf - posi + 1
# duracao
names(duracao) <- paste("evento", 1:length(duracao), sep = "")


## ----Chunk10f1, eval=TRUE, results = 'hide'--------------------------
duracao <- c(evento1 = 1, evento2 = 1, evento3 = 1, evento4 = 1, evento5 = 2, 
evento6 = 1, evento7 = 2, evento8 = 1, evento9 = 4, evento10 = 1, 
evento11 = 1, evento12 = 1, evento13 = 1, evento14 = 1, evento15 = 1, 
evento16 = 1, evento17 = 1, evento18 = 1, evento19 = 2, evento20 = 1, 
evento21 = 1, evento22 = 1, evento23 = 2, evento24 = 3, evento25 = 1, 
evento26 = 1, evento27 = 2, evento28 = 1, evento29 = 2, evento30 = 3, 
evento31 = 2, evento32 = 1, evento33 = 1, evento34 = 1, evento35 = 1, 
evento36 = 1, evento37 = 1, evento38 = 1, evento39 = 3)


## --------------------------------------------------------------------
duracao


## ----Chunk111, echo=FALSE, eval=TRUE---------------------------------
temp <- sample(0:30, 30)
temp[2:4] <- NA
temp[10:15] <- NA
temp[23:29] <- NA
# dput(temp)
temp <- c(
  NA, NA, 27L, 7L, 4L, 0L, 26L, 15L, 25L, NA, NA, NA, NA, 6L,
  29L, 18L, 17L, 23L, 20L, 1L, 30L, 13L, NA, NA, NA, NA, NA, NA,
  NA, 19L
)

## ----Chunk112--------------------------------------------------------
temp <- c(
  NA, NA, 27L, 7L, 4L, 0L, 26L, 15L, 25L, NA, NA, NA, NA, 6L,
  29L, 18L, 17L, 23L, 20L, 1L, 30L, 13L, NA, NA, NA, NA, NA, NA,
  NA, 19L
)


## ----Chunk11a--------------------------------------------------------
# vetor lógico de falhas
eh_falha <- is.na(temp)
# soma cumulativa de falhas
acum_falhas <- cumsum(eh_falha)
# calculando soma a partir do início da falha
seq_falhas <- acum_falhas - cummax((!eh_falha) * acum_falhas)
seq_falhas


## ----Chunk11c--------------------------------------------------------
(ordem_falhas <- cumsum(seq_falhas == 1) * as.integer(eh_falha > 0))


## --------------------------------------------------------------------
pos_fim_falha <- which(c(NA, diff(ordem_falhas)) < 0) - 1
(tamanho_falhas <- seq_falhas[pos_fim_falha])
# names(tamanho_falhas) <- paste0("falha", unique(ordem_falhas[ordem_falhas > 0]))
names(tamanho_falhas) <- paste0("falha", seq_along(tamanho_falhas))
tamanho_falhas


## --------------------------------------------------------------------
(max_falha <- max(tamanho_falhas))


## ----Chunk12, include=FALSE------------------------------------------
ws <- c(10, 10, 10, 10, 14.142, 14.142, 14.142, 14.142, 0)
wd <- c(270, 180, 360, 90, 225, 315, 135, 45, 0)


## ---- eval = TRUE, echo = FALSE--------------------------------------
uv_df <- structure(list(u = c(10, 0, 0, -10, 10, 10, -10, -10, 0), v = c(0, 
10, -10, 0, 10, -10, 10, -10, 0), ws = c(10, 10, 10, 10, 14.142, 
14.142, 14.142, 14.142, 0), wd = c(270, 180, 360, 90, 225, 315, 
135, 45, 0), wd_uv = c(270, 180, 360, 90, 225, 315, 135, 45, 
0), dir = structure(c(6L, 9L, 5L, 2L, 8L, 4L, 7L, 3L, 1L), .Label = c("Calmo", 
"Leste", "Nordeste", "Noroeste", "Norte", "Oeste", "Sudeste", 
"Sudoeste", "Sul"), class = "factor")), class = "data.frame", row.names = c(NA, 
-9L))
knitr::kable(uv_df)


## ---- include=TRUE---------------------------------------------------
prec_obs <- c(
  0, 0, 0, 0.5, 1, 6, 9, 0.2, 1, 0, 0, 0.25,
  10, 15, 8, 3, 0, 0, 0, 0, 0, 0, 0.25, 0,
  0, 0, 1, 5, 0, 20, 0, 0, 0, 0, 1, 1,
  0, 2, 12, 1, 0, 0, 0, 0, 0, 0, 5, 5
)
prec_sim <- c(
  0, 0.2, 0.1, 0, 0, 3, 1, 1, 1, 1, 0, 3,
  0, 10, 4, 1, 0.3, 0.5, 0.5, 0.5, 0.5, 0, 0.25, 0.25,
  0.25, 0, 0.5, 3, 0, 5, 0, 0, 0, 0, 0.5, 0,
  0.25, 0.2, 0, 0.2, 0, 0, 0, 0, 1, 2, 1, 0
)


## ---- include=TRUE---------------------------------------------------
obs <- c(
  -0.49, 0.27, -0.48, 0.8, -1, 0.1, -1.16,
  0.58, -1.6, -0.31, 0.45, -0.98, 0.19, 0.73,
  -0.49, -0.04, -0.11, 0.46, 2.02, -1.05
)
prev <- c(
  NA, -0.49, 0.27, -0.48, 0.8, -1, 0.1, -1.16,
  0.58, -1.6, -0.31, 0.45, -0.98, 0.19, 0.73,
  -0.49, -0.04, -0.11, 0.46, 2.02
)

