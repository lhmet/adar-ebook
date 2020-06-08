## ----setup, include = FALSE----------------------------------------
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


## ----fig-estrut-dados, echo = FALSE, out.width="100%", fig.cap="Principais estruturas de dados no R."----
knitr::include_graphics("images/dataStructuresR.png")


## ----Chunk410, message=FALSE   , echo=TRUE, eval=TRUE--------------
# lista de dados heterogêneos
lst <- list(1:4, c(1.1, 2.3, 5.9), c(TRUE, FALSE), "R", list(0, 1))
lst
# estrutura da lista
str(lst)
# tamanho da lista (num. de componentes ou elementos)
length(lst)
# atribuindo nomes a lista
names(lst)
names(lst) <- c("vetor_int", "vetor_dbl", "logico", "char", "lista")


## Veremos que no R, listas são frequentemente usadas para armazenar a saída de funções com diversos resultados. Como por exemplo a saída das funções `rle()`.


## ------------------------------------------------------------------
is.recursive(lst)


## ----Chunk412, message=FALSE  , echo=TRUE, eval=TRUE---------------
# matriz de dados meteorológicos da estação de Santa Maria
dados_sm <- cbind(
  tar = c(31, 35, 21, 23, 33, 17),
  prec = c(300, 200, 150, 120, 210, 110)
)
dados_sm
# lista com informações da estação de santa maria
sm_l <- list(
  c(-45, -23),
  "Santa Maria",
  dados_sm
)
sm_l
# adicionar nomes aos elementos
names(sm_l) <- c("coords", "cidade", "dados")
sm_l
# matriz de dados meteorológicos da estação de Júlio de Castilhos
dados_jc <- cbind(
  tar = c(22.5, 20, 18.75, 18, 20.25, 17.75),
  prec = c(360, 310, 285, 270, 315, 265)
)
# criando lista de JC, mas nomeando de forma diferente
jc_l <- list(
  coords = c(-45.1, -23.2),
  cidade = "Júlio de Castilhos",
  dados = dados_jc
)
# adicionar nomes as componentes
names(jc_l) <- names(sm_l)
jc_l


## ----Chunk413, message=FALSE  , echo=TRUE, eval=TRUE---------------
# combinando listas mantendo os elementos separadamente
dados_l <- list(sm_l, jc_l)
dados_l
names(dados_l)
names(dados_l) <- c("sm", "jc")
dados_l
# como a lista é um tipo vetor, a função length()
# fornece o número de elementos da lista
length(dados_l)


## ----Chunk414, message=FALSE   , echo=TRUE, eval=TRUE--------------
str(dados_l)


## ----Chunk415, message=FALSE   , echo=TRUE, eval=TRUE--------------
dados_l2 <- c(sm_l, jc_l)
dados_l2
str(dados_l2)


## ----chunck 420, message=FALSE   , echo=TRUE, eval=TRUE------------
sm_l[1:2]
sm_l[c("coords", "alt")]


## ----chunck 421, message=FALSE   , echo=TRUE, eval=TRUE, error=TRUE----
# seleção do 1º elemento da lst
lst[1]
# o resultado da seleção é uma lista
mode(lst[1])
# a função sum() espera como entrada um vetor
sum(lst[1])
# acessando elemento inexistente
lst[6]


## ----Chunk4220, message=FALSE   , echo=TRUE, eval=TRUE-------------
# 1º elemento de sm_l
sm_l[[1]]
sm_l[["coords"]]
# modo de sm_l
mode(sm_l)
# ultimo elemento de sm_l
sm_l[[length(sm_l)]]
sm_l[["dados"]]
# subelementos
dados_l[["sm"]][["cidade"]]


## ----Chunk4221, message=FALSE   , echo=TRUE, eval=TRUE-------------
# seleção de dados por nomes usando o símbolo $
dados_l$s
dados_l$j
dados_l$sm$dados
dados_l$sm$dados[3:5, 1:2]
dados_l$sm$dados[, "tar"]
dados_l$sm$dados[, "tar", drop = FALSE]


## ---- echo = FALSE-------------------------------------------------
df <- data.frame(
  descrição = c(
    "frasco de pimenta",
    "frasco de pimenta com apenas 1 pacote de pimenta",
    "1 pacote de pimenta",
    "conteúdo de um pacote de pimenta"
  ),
  código = c("frasco", "frasco[1]", "frasco[[1]]", "frasco[[1]][[1]]"),
  resultado = c(
    pandoc.image.return("images/pepper.jpg"),
    pandoc.image.return("images/pepper-1.jpg"),
    pandoc.image.return("images/pepper-2.jpg"),
    pandoc.image.return("images/pepper-3.jpg")
  ),
  stringsAsFactors = FALSE
)
pander::pander(df)


## ----Chunk45, message=FALSE   , echo=TRUE, eval=TRUE---------------
vet <- 1:10
vet
vet.list <- as.list(vet)
vet.list
# desmanchando a lista
unlist(vet.list)
# deletando um elemento de uma lista
length(vet.list)
vet.list[8] <- NULL
vet.list
length(vet.list)


## ----Chunk46, message=FALSE   , echo=TRUE, eval=TRUE---------------
sm_l
# ao invés da componente coords, criamos uma lon e lat
sm_l$lon <- sm_l$coords[1]
sm_l$lat <- sm_l$coords[2]
sm_l$coords <- NULL
sm_l
# converter para dataframe
sm_df <- data.frame(sm_l)
sm_df


## ----Chunk510, message=FALSE   , echo=TRUE, eval=TRUE--------------
# criando um dataframe
dados <- data.frame(
  datas = c(
    "2013-01-01", "2013-01-02", "2013-01-03", "2013-01-04", "2013-01-05",
    "2013-01-06", "2013-01-07", "2013-01-08", "2013-01-09", "2013-01-10",
    "2013-01-11", "2013-01-12", "2013-01-13", "2013-01-14", "2013-01-15"
  ),
  cidade = rep("Santa Maria", 15),
  tar = c(31, 35, 21, 23, 33, 17, 18, 16, 34, 27, 15, 28, 22, 29, 32)
)
dados
class(dados)
is.data.frame(dados)


## ----Chunk511, message=FALSE   , echo=TRUE, eval=TRUE--------------
# descrição geral do conjunto de dados
str(dados)


## ----Chunk512, message=FALSE   , echo=TRUE, eval=TRUE--------------
# criando um dataframe
dados <- data.frame(
  datas = c(
    "2013-01-01", "2013-01-02", "2013-01-03", "2013-01-04", "2013-01-05",
    "2013-01-06", "2013-01-07", "2013-01-08", "2013-01-09", "2013-01-10",
    "2013-01-11", "2013-01-12", "2013-01-13", "2013-01-14", "2013-01-15"
  ),
  cidade = rep("Santa Maria", 15),
  tar = c(31, 35, 21, 23, 33, 17, 18, 16, 34, 27, 15, 28, 22, 29, 32),
  stringsAsFactors = FALSE
)
str(dados)


## ----Chunk513, message=FALSE   , echo=TRUE, eval=TRUE--------------
# resumo estatístico dos dados
summary(dados)


## ----Chunk520, message=FALSE   , echo=TRUE, eval=TRUE--------------
# atributos
attributes(dados)
# atributos armazenados em uma lista
str(attributes(dados))
# número de colunas
ncol(dados)
# número de linhas
nrow(dados)
# dimensões
dim(dados)
# nomes podem ser atribuídos as linhas e as colunas
rownames(dados)
# novos nomes para as linhas de dados
rownames(dados) <- paste0("linha", rownames(dados))
dados
# removendo nomes das linhas
rownames(dados) <- NULL
dados
# mesmo que names(dados)
colnames(dados)
# ou simplesmente
names(dados)


## ----Chunk530, message=FALSE   , echo=TRUE, eval=TRUE, error =TRUE----
# variáveis do dataframe
names(dados)
# acessando os dados de temperatura
dados[, 3]
# ou
dados[, "tar"]
# ou
dados$tar
is.vector(dados$tar)
# note a diferença no resultado da extração
dados["tar"]
class(dados["tar"])
dados[["tar"]]
class(dados[["tar"]])
dados[, "tar"]
class(dados[, "tar"])


## ----Chunk5310, message=FALSE  , echo=TRUE, eval=TRUE--------------
# acesso a variáveis de um dataframe
with(data = dados, expr = tar)
tarK <- with(data = dados, expr = tar + 273.15)
tarK
# gráfico de uma variável usando with()
with(data = dados, 
     # parâmetro expr geralmente não é mostrado
       plot(tar + 273.15, type = "o")
     )


## ------------------------------------------------------------------
with(dados, 
     {
       dates <- as.Date(datas)
       plot(dates, tar)
     }
)


## ----Chunk540, message=FALSE   , echo=TRUE, eval=TRUE--------------
# exclui a primeiro e a última observação para todas variáveis
dados[-c(1, nrow(dados)), ]
# temperatura dos primeiros 5 dias
dados[1:5, 3]
# temperatura no dia 2013-01-09
dados[dados$datas == "2013-01-09", "tar"]
# acrescentar uma nova variavel
dados$prec <- c(rep(0, 5), 10, 18, 4, 0, 0, 5, 0, 0, 2, 0)
dados


## ----Chunk541, message=FALSE , echo=TRUE, eval=TRUE----------------
# subconjunto baseado em condição lógica
ss1 <- subset(dados, datas == "2013-01-09", select = "tar")
ss1
# subconjunto baseado em condição lógica
ss2 <- subset(dados, tar > 26 & prec > 0)
ss2
# subconjunto baseado em condição lógica
ss3 <- subset(dados, tar > 26 | prec > 0)
ss3
# subconjunto baseado em condição lógica
ss4 <- subset(dados,
  datas %in% c("2013-01-09", "2013-01-13", "2013-01-15"),
  select = -cidade
)
ss4
# subconjunto baseado em condição lógica
ss4 <- subset(dados,
  !datas %in% c("2013-01-09", "2013-01-13", "2013-01-15"),
  select = -cidade
)
ss4


## ----Chunk542, message=FALSE  , echo=TRUE, eval=TRUE---------------
# mudança do dataframe, alteração de várias variáveis
dados <- transform(dados,
  cidade = ifelse(1:nrow(dados) > 8, "Sao Sepe", cidade),
  datas = c(datas[1:8], datas[1:7]),
  anomalias = ifelse(cidade == "Santa Maria",
    tar - mean(tar[cidade == "Santa Maria"]),
    tar - mean(tar[cidade == "Sao Sepe"])
  )
)
dados
# alterar só uma variavel, anomalia normalizada
dados$anomalias.norm <- ifelse(dados$cidade == "Santa Maria",
  dados$anomalias / sd(dados$anomalias[dados$cidade == "Santa Maria"]),
  dados$anomalias / sd(dados$anomalias[dados$cidade == "Sao Sepe"])
)
dados


## ----Chunk550, message=FALSE  , echo=TRUE, eval=TRUE---------------
coords_df <- data.frame(
  lon = c(rep(-45, 8), rep(-45.1, 7)), # longitudes
  lat = c(rep(-23, 8), rep(-23.1, 7))
) # latitudes
d <- cbind(dados, coords_df)
d
# usando a própria função data.frame()
d2 <- data.frame(dados, coords_df, stringsAsFactors = FALSE)
d2
# verificando se os dois dataframes são idênticos
identical(d, d2)
# dados de Caçapava
cacapava <- data.frame(
  datas = "2013-01-01",
  cidade = "Cacapava",
  tar = 19,
  prec = 0,
  anomalias = NA,
  anomalias.norm = NA,
  lon = -45.1,
  lat = -23.2
)
d <- rbind(d, cacapava)
d


## ----Chunk551, message=FALSE  , echo=TRUE, eval=TRUE---------------
# temperatura do ar média mensal do ano de 1990
temp90 <- c(
  25.00, 23.20, 22.50, 21.00, 19.00, 17.60,
  18.00, 19.70, 21.30, 22.00, 24.00, 26.80
)
# convertendo lista para dataframe
sm_l
sm_l_df <- as.data.frame(sm_l)
sm_l_df
# convertendo array para dataframe
v <- c(3, 100, NA, NA, 6)
v_df <- as.data.frame(v)
# convertendo vetor para dataframe
temp90_df <- as.data.frame(temp90)


## ------------------------------------------------------------------
vetor <- c(0, 1, -1, -2, 3, 5, -5)
mat <- matrix(vetor, ncol = 4, byrow = TRUE)
mat
# convertendo matrix para dataframe
mat
mat_df <- as.data.frame(mat)
names(mat_df)
mat_df
# testes
is.data.frame(mat_df)
class(v_df)


## ---- include = FALSE----------------------------------------------
x <- seq(3, 6, by = 0.1)
exp(x) * cos(x)
# (exp(1)^x)*cos(x)


## ---- include = FALSE----------------------------------------------
0.1 ^ (seq(3, 36, by = 3)) * (0.2 ^ (seq(1, 34, by = 3)))


## ---- include = FALSE----------------------------------------------
2^(1:25)/(1:25)
#paste(2^(1:25), 1:25, sep = "/")


## ---- message=FALSE, eval=TRUE, echo = FALSE, comment=""-----------
dds <- 1:7
names(dds) <- c(
  "Domingo", "Segunda-feira", "Terca-feira", 
  "Quarta-feira", "Quinta-feira", "Sexta-feira", 
  "Sabado"
)
dds


## ---- include = FALSE----------------------------------------------
set.seed(2)
# (a)
(eh_par <- nums %% 2 == 0)
(n_pares <- sum(eh_par))
# (b)
(eh_biss <- anos %% 4 == 0)
(n_biss <- sum(!eh_biss))


## ---- eval=TRUE,echo=FALSE,comment=""------------------------------
(tar0 <- c(-20, seq(0,40, by = 10)))


## ---- eval=TRUE,echo=FALSE,comment=""------------------------------
(seq(-1, 1, by = 1/4))


## ---- eval=TRUE,echo=FALSE,comment=""------------------------------
(seq(-pi, pi, length.out = 12))


## ---- eval=TRUE,echo=FALSE,comment=""------------------------------
rep(1:5, times = 5:1)


## ---- eval=TRUE,echo=FALSE,comment=""------------------------------
rep(c(1:5, 4:1), times = c(5:1, 2:5))


## ---- eval=TRUE,echo=FALSE,comment=""------------------------------
vetor_f <- c(
  rep(rep(1:2, each = 2), times = 2),
  rep(rep(3:4, each = 2), times = 2)
)
(m <- matrix(vetor_f, byrow = TRUE, ncol = 4))


## ---- eval=TRUE,echo=FALSE,comment=""------------------------------
(mat_g <- t(m))


## ---- eval=TRUE,echo=FALSE,comment=""------------------------------
c(t(mat_g))


## ---- eval=TRUE,echo=FALSE,comment=""------------------------------
v3 <- c(10, 0.5, 8, 4)


## ---- eval=TRUE,echo=FALSE,comment=""------------------------------
1:length(v3)


## ----Chunk7b, eval=TRUE,echo=FALSE,comment=""----------------------
v2 <- c(10, 0.5)


## ----Chunk7b_sol, eval=TRUE,echo=FALSE,comment=""------------------
1:length(v2)


## ----Chunk7c, eval=TRUE,echo=FALSE,comment=""----------------------
v1 <- c(10)


## ----Chunk7c_sol, eval=TRUE,echo=FALSE,comment=""------------------
1:length(v1)


## ----Chunk7d, eval=TRUE,echo=FALSE,comment=""----------------------
v0 <- c()


## ----Chunk7d_sol, eval=TRUE,echo=FALSE,comment=""------------------
#1:length(v0)
seq_along(v0)


## ---- echo = FALSE, results='hide'---------------------------------
cumsum(2:6)
cumsum(rev(2:6))


## ---- echo = FALSE-------------------------------------------------
hora <- (12:24) - 3
prec_h <- c(0, 0, 0, 0, 0, 0, 0, 21.4, 41.2, 2.6, 1, 0.4, 0)
evento <- data.frame(hora, prec = prec_h)
knitr::kable(evento, align = "c", longtable = TRUE)


## ---- include = FALSE----------------------------------------------
(prec_acum <- cumsum(prec_h))


## ---- include = FALSE----------------------------------------------
hora[which.max(prec_h)]


## ---- include = FALSE----------------------------------------------
(inicio <- hora[prec_h > 0][1])
(fim <- hora[max(which(prec_h > 0))])
fim - inicio + 1
sum(prec_h > 0)


## ---- include = FALSE----------------------------------------------
tot_evento <- sum(prec_h)
perc_rel <- prec_h / tot_evento * 100
perc_rel
perc_rel_cum <- cumsum(perc_rel)
perc_rel_cum[hora == 17]
round(perc_rel_cum[hora == 17])


## ------------------------------------------------------------------
x <- c(
  11, 10, 15, 2, 6, -15, -10, -22, -8,  5,
   7,  2, 12, 8, 4,   1,   3,  -3, -1, 30, 14
)
# x1 <- ifelse(x > 0, 1, 0)
# cópia de x
x01 <- x
# substituo x positivo por 1 e x negativo por 0
x01[x > 0] <- 1
x01[!x > 0] <- 0
res <- x[which(diff(x01) == 1) + 1]
res


## ----Chunk10, echo=FALSE, eval=FALSE-------------------------------
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


## ----Chunk10a, message=FALSE, echo=TRUE, eval=TRUE-----------------
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


## ----Chunk10a1, echo=FALSE, eval=TRUE, results = FALSE-------------
n_ev <- sum(prec > 0 & prec < 0.25)
n_ev
vals_ev <- prec[prec > 0 & prec < 0.25]
vals_ev


## ----Chunk10b, echo=FALSE, eval=TRUE, results = FALSE--------------
prec[prec > 0 & prec < 0.25] <- 0
prec


## ----Chunk10c, echo=FALSE, eval=TRUE, results = FALSE--------------
limiar <- 0.25
prec01 <- as.integer(prec > limiar)
# prec01
prec_estado <- prec01
prec_estado[prec_estado == 1] <- "chuvoso"
# prec_estado
prec_estado[prec_estado == "0"] <- "seco"
prec_estado


## ----Chunk10d, echo=FALSE, eval=TRUE, results = FALSE--------------
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


## ----Chunk10e1, echo=FALSE, eval=TRUE, results='hide'--------------
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


## ----Chunk10f, echo=FALSE, eval=TRUE, results='hide'---------------
# posições iniciais do evento
posi <- which(diff(c(0, prec01)) == 1)
# posições finais do evento
posf <- c(which(diff(c(prec01, 0)) == -1))
# duracao de cada evento
duracao <- posf - posi + 1
# duracao
names(duracao) <- paste("evento", 1:length(duracao), sep = "")


## ----Chunk10f1-----------------------------------------------------
duracao


## ----Chunk111, echo=FALSE, eval=TRUE-------------------------------
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

## ----Chunk112------------------------------------------------------
temp <- c(
  NA, NA, 27L, 7L, 4L, 0L, 26L, 15L, 25L, NA, NA, NA, NA, 6L,
  29L, 18L, 17L, 23L, 20L, 1L, 30L, 13L, NA, NA, NA, NA, NA, NA,
  NA, 19L
)


## ----Chunk11a------------------------------------------------------
# vetor lógico de falhas
eh_falha <- is.na(temp)
# soma cumulativa de falhas
acum_falhas <- cumsum(eh_falha)
# calculando soma a partir do início da falha
seq_falhas <- acum_falhas - cummax((!eh_falha) * acum_falhas)
seq_falhas


## ----Chunk11c------------------------------------------------------
(ordem_falhas <- cumsum(seq_falhas == 1) * as.integer(eh_falha > 0))


## ------------------------------------------------------------------
pos_fim_falha <- which(c(NA, diff(ordem_falhas)) < 0) - 1
(tamanho_falhas <- seq_falhas[pos_fim_falha])
# names(tamanho_falhas) <- paste0("falha", unique(ordem_falhas[ordem_falhas > 0]))
names(tamanho_falhas) <- paste0("falha", seq_along(tamanho_falhas))
tamanho_falhas


## ------------------------------------------------------------------
(max_falha <- max(tamanho_falhas))


## ----Chunk12, include=FALSE----------------------------------------
ws <- c(10, 10, 10, 10, 14.142, 14.142, 14.142, 14.142, 0)
wd <- c(270, 180, 360, 90, 225, 315, 135, 45, 0)


## ----Chunk12_a, echo=FALSE, eval=TRUE, results = FALSE-------------
u <- round(-ws * sin(wd * pi / 180), 3)
u
v <- round(-ws * cos(wd * pi / 180), 3)
v


## ----Chunk12_b, echo=FALSE, eval=TRUE, results = FALSE-------------
# velocidade horizontal do vento a partir de u e v
(ws_uv <- round(sqrt(u^2 + v^2), 3))
# direção do vento
(wd_uv <- atan2(-u, -v) * 180/pi)
# ajuste para dir <= 0 do angulo matemático para meteorológico
wd_uv[wd_uv <= 0] <- wd_uv[wd_uv <= 0] + 360
wd_uv[u == 0 & v == 0] <- 0
wd_uv
wd
identical(wd, wd_uv)
all.equal(wd, wd_uv)


## ---- echo=FALSE---------------------------------------------------
knitr::kable(data.frame(u, v, ws, 
           wd, wd_uv, 
           dir = c("Oeste", "Sul", "Norte", 
                   "Leste", "Sudoeste", "Noroeste",
                   "Sudeste", "Nordeste", "Calmo")
           ))


## ---- include=TRUE-------------------------------------------------
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


## ---- include=FALSE------------------------------------------------
wc <- sum((prec_obs > 0.25) & (prec_sim > 0.25))
dc <- sum((prec_obs <= 0.25) & (prec_sim <= 0.25))
n <- length(prec_obs)
wi <- sum((prec_obs <= 0.25) & (prec_sim > 0.25))
di <- sum((prec_obs > 0.25) & (prec_sim <= 0.25))
PC <- (wc + dc) / n
PC
CSI <- wc / (wc + wi + di)
CSI


## ---- include=TRUE-------------------------------------------------
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


## ---- include = FALSE----------------------------------------------
ok <- !(is.na(obs) | is.na(prev))
obs <- obs[ok]
prev <- prev[ok]
n <- length(prev)
# cálculo da correlação
(r <- sum((obs - mean(obs)) * (prev - mean(prev))) /
  sqrt(sum((obs - mean(obs)) ^ 2) * sum((prev - mean(prev)) ^ 2)))
cor(obs, prev)


## ---- include=FALSE------------------------------------------------
k2c <- function(tk) tk - 273.15
k2c(300)
k2c(273)
rad2graus <- function(rad) rad / pi * 180
rad2graus(pi)
rad2graus(pi / 2)

