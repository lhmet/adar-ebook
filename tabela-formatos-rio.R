tab_rio <- readLines("https://raw.githubusercontent.com/leeper/rio/master/README.md")
tab_rio <- grep("^\\|", tab_rio, value = TRUE) %>%
  grep("^\\| -", ., value = TRUE, invert = TRUE) %>%
  gsub('\\"', "", .)

tab_rio <- read.delim(text = tab_rio, sep = "|") #%>%
#setNames()
cols_exclud <- apply(tab_rio, 2, function(coluna) all(is.na(coluna)))
tab_rio <- tab_rio[, !cols_exclud]

#x <- readr::read_delim(x, delim = "|") %>%
#  select(-X1, -X7)

knitr::kable(tab_rio,
             longtable = TRUE,
             booktabs = TRUE,
             caption = "Versão resumida da tabela com os formatos suportados pelo pacote **rio**.",
             align = "c"
)

