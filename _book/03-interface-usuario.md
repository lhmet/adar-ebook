# (PART) Interação {-}

# Interface do Usuário {#iu}





Na maior parte do tempo você provavelmente usará o <img src="images/logo_r.png" width="20"> no **modo interativo**: rodando comandos e vendo os resultados.
 
Eventualmente esse processo pode ser inconveniente. Por exemplo, no caso de uma análise com um código bem extenso e que precisa ser  repetida com dados atualizados semanalmente. Nessa situação, recomenda-se a criação de um script, ou seja, um arquivo texto, com a extensão `.R`, contendo o código de sua análise.

Esse *script* pode ser executado pelo R no **modo de processamento em lote** (do termo em inglês *Batch Processing*) através de um terminal do SO Linux, ou via o *Prompt* de comando (`cmd.exe`) do SO Windows.

Nesta seção apresenta-se ao leitor estes dois modos de execução do <img src="images/logo_r.png" width="20">.


## R no modo interativo

No Linux o <img src="images/logo_r.png" width="20"> pode ser aberto simplesmente digitando em um terminal a letra `R`. 


```bash
$ R
```

```
R version 4.0.3 (2020-10-10) -- "Bunny-Wunnies Freak Out"
Copyright (C) 2020 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64 (64-bit)

R é um software livre e vem sem GARANTIA ALGUMA.
Você pode redistribuí-lo sob certas circunstâncias.
Digite 'license()' ou 'licence()' para
detalhes de distribuição.

R é um projeto colaborativo com muitos
contribuidores.
Digite 'contributors()' para obter mais informações e
'citation()' para saber como citar o R
ou pacotes do R em publicações.

Digite 'demo()' para demonstrações, 'help()' para o sistema on-line de ajuda,
ou 'help.start()' para abrir o sistema
de ajuda em HTML no seu navegador.
Digite 'q()' para sair do R.

>
```

A janela com a linha de comando do <img src="images/logo_r.png" width="20"> apresenta o *prompt* do <img src="images/logo_r.png" width="20"> (` > `). Após este símbolo digitamos os comandos, pressionamos a tecla `<enter>`, o <img src="images/logo_r.png" width="20"> interpreta o comando e retorna o resultado. 

Os comandos digitados na linha de comando são chamados de expressões. Esse é o modo iterativo do <img src="images/logo_r.png" width="20">. Portanto, a linha de comando é a mais importante ferramenta do <img src="images/logo_r.png" width="20">, pois todas expressões são avaliadas através dela. 


```r
> 62 + 38
[1] 100
```

A expressão é avaliada pelo <img src="images/logo_r.png" width="20">, o resultado é mostrado, mas o seu valor é perdido.

O número entre colchetes que aparece como resultado da operação ("[1]" no caso acima) indica o conteúdo resultante da operação iniciando na posição 1 desse objeto. O significado dessa informação torna-se mais óbvio quando trabalhamos com objetos maiores, como por exemplo com vetores. Observe os valores nos colchetes para uma sequência de 100 até 1.


```r
> 100:1
  [1] 100  99  98  97  96  95  94  93  92  91  90  89  88  87  86  85  84  83
 [19]  82  81  80  79  78  77  76  75  74  73  72  71  70  69  68  67  66  65
 [37]  64  63  62  61  60  59  58  57  56  55  54  53  52  51  50  49  48  47
 [55]  46  45  44  43  42  41  40  39  38  37  36  35  34  33  32  31  30  29
 [73]  28  27  26  25  24  23  22  21  20  19  18  17  16  15  14  13  12  11
 [91]  10   9   8   7   6   5   4   3   2   1
```

O elemento `[18]` da sequência de 100 até 1 é o número `83`.


Pode ocorrer da expressão digitada na linha ser muito extensa e ir além de uma linha. Se a expressão estiver incompleta o <img src="images/logo_r.png" width="20"> mostra um sinal de `+`.


```r
> 1 * 2 * 3 * 4 * 5 *
+ 6 * 7 * 8 * 9 * 10
[1] 3628800
```

Execute a expressão abaixo até o sinal de menos e tecle `<enter>`. Enquanto a instrução não estiver completa o sinal de `+` se repetirá. Você pode cancelar a execução digitando `Ctrl + c` ou `Esc`. No código abaixo isso acontecerá até que você digite o número que deseja subtrair de 4, no caso de o número 3.


```r
> 4 -
+   
+   3
[1] 1
```



### Expressões em sequência {#expressInSeq}

Podemos executar todas expressões anteriores em apenas uma linha, usando o ponto e vírgula  `;` para separar as expressões:


```r
> 62 + 38; 100:1; 1 * 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 10; 4 - 3
[1] 100
  [1] 100  99  98  97  96  95  94  93  92  91  90  89  88  87  86  85  84  83
 [19]  82  81  80  79  78  77  76  75  74  73  72  71  70  69  68  67  66  65
 [37]  64  63  62  61  60  59  58  57  56  55  54  53  52  51  50  49  48  47
 [55]  46  45  44  43  42  41  40  39  38  37  36  35  34  33  32  31  30  29
 [73]  28  27  26  25  24  23  22  21  20  19  18  17  16  15  14  13  12  11
 [91]  10   9   8   7   6   5   4   3   2   1
[1] 3628800
[1] 1
```

### Navegação entre as expressões já avaliadas


Você pode usar as teclas ↑ e ↓ para navegar entre as expressões já avaliadas pelo <img src="images/logo_r.png" width="20">. O que é útil quando precisamos repetir um comando anterior com alguma mudança ou para corrigir um erro de digitação ou a omissão de um parênteses.

Quando a linha de comando é usada por muito tempo a sua tela pode ficar poluída com a saída das expressões anteriores. Para limpar a tela, tecle  <kbd>Ctrl</kbd>+<kbd>l</kbd>. Assim o console aparece na parte superior do terminal.



```r
> 15 + 4
[1] 19
> 100:1
  [1] 100  99  98  97  96  95  94  93  92  91  90  89  88  87  86  85  84  83
 [19]  82  81  80  79  78  77  76  75  74  73  72  71  70  69  68  67  66  65
 [37]  64  63  62  61  60  59  58  57  56  55  54  53  52  51  50  49  48  47
 [55]  46  45  44  43  42  41  40  39  38  37  36  35  34  33  32  31  30  29
 [73]  28  27  26  25  24  23  22  21  20  19  18  17  16  15  14  13  12  11
 [91]  10   9   8   7   6   5   4   3   2   1
```

Para parar ou cancelar a execução de uma expressão utilize <kbd>Ctrl</kbd>+<kbd>c</kbd>.

### Comentários {#comentarios}

No <img src="images/logo_r.png" width="20">, a cerquilha `#` (hashtag) é um caractere especial. Qualquer coisa após esse caractere será ignorada pelo <img src="images/logo_r.png" width="20">. Somente as expressões antes da `#` são avaliadas. Com esse símbolo podemos fazer anotações e comentários no código sem atrapalhar a interpretação das expressões pelo <img src="images/logo_r.png" width="20">.


```r
> # Comentários de novatos
> # o operador + adiociona o num. da esquerda ao da direita 
```

```r
> 17 + 3 # como somar números
[1] 20
```


Nos seus códigos use comentários para registrar descobertas importantes e decisões de análise. Procure comentar o porquê, ao invés de o que. Se você precisar de comentários para explicar o que seu código está fazendo, considere reescrever seu código para ficar mais claro. Se você descobrir que tem mais comentários do que código, considere mudar para R Markdown.

<!-- 
> Comentários que não desejo ver você fazendo após este curso:


Enfatizar como e quando usar efetivamente comentários.

https://medium.com/javascript-in-plain-english/part-2-the-most-hilarious-code-comments-ever-9586592e3bec 



```r
# Não sei por que isso funciona, mas resolve o problema.

# rm(list = ls()) # Se esta linha for descomentada o programa explodirá

# Este código é péssimo, você sabe e eu sei, mas são 3 horas da manhã e preciso que isso funcione.

# Se, futuramente, ler isso, voltarei no tempo e me matarei.

# Isto é magia negra de algum link do stackoverflow. Não brinque com magia, ela pode te arrancar pedaço.

# Este código funcionou antes, mas meu gato decidiu fazer uma viagem pelo meu teclado ...

# Se você está lendo isso, significa que você foi encarregado 
# do meu projeto anterior. Eu sinto muito por você. Boa Sorte 
# Vá com Deus.

# Quando eu escrevi isso, somente Deus e eu entendemos o que estava fazendo. Agora, somente Deus sabe.

# Haleluya eu posso ir para casa!

# Traduzido e adaptado de
# https://medium.com/javascript-in-plain-english/part-2-the-most-hilarious-code-comments-ever-9586592e3bec 
```
-->



### Auto preenchimento de funções

O <img src="images/logo_r.png" width="20"> inclui o preenchimento automático de nomes de funções e arquivos por meio da tecla `<tab>`. Uma lista de possíveis funções que começam com as letras inicialmente digitadas aparecerão.


```r
> read#<tab> pressione <tab> para ver as opções de comandos que iniciam com o termo read
```


<div class="figure" style="text-align: center">
<img src="images/screenscast-autocomplete-r.gif" alt="Auto preenchimento de código na linha de comandos do R." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-4)Auto preenchimento de código na linha de comandos do R.</p>
</div>

### Primeiro *script* {#primeiro-script}

O trecho de código abaixo apresenta nas primeiras linhas algumas expressões do <img src="images/logo_r.png" width="20"> executadas anteriormente. Mas há também, na segunda parte, códigos para salvar um gráfico de pontos num arquivo *pdf*. Na última parte do trecho, define-se uma variável `x` que contém aquela mesma sequência numérica usada no gráfico.



```r
# Primeiro script no R
#----------------------------------------------------------------
# cálculos básicos
15 + 4
1:100
1 * 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 10
4 - 3
#----------------------------------------------------------------
# salvando um gráfico em um arquivo pdf
arquivo_pdf <- "plot-script1.pdf"
pdf(arquivo_pdf)        # cria e abre um arquivo pdf
x <- seq(-2*pi, 2*pi, by = 0.1)
plot(x = x, y = exp(-x/5)*sin(x)^2, type = "o")
dev.off()               # fecha o arquivo pdf
#----------------------------------------------------------------
```

Este conjunto de linhas de código, quando inseridos em um arquivo texto[^newtextfile] formam um primeiro *script* <img src="images/logo_r.png" width="20">. Este *script* pode ser executado pelo <img src="images/logo_r.png" width="20"> através da função `source()`, usando como argumento o caminho para o local do *script*. 

[^newtextfile]: Para fazer isso, você pode usar um editor de texto qualquer (p.ex.: [gedit](https://help.gnome.org/users/gedit/stable/index.html.pt_BR) no SO Linux, ou [Notepad](https://pt.wikipedia.org/wiki/Bloco_de_Notas) no SO Windows).


```r
> source("/home/usuario/adar/script1.R")
```


Este *script* produzirá como saída o arquivo `/home/usuario/adar/plot-script1.pdf`. Você pode visualizar o arquivo para conferir o gráficos de pontos gerado.


## R no modo de processamento em lote

### Linux

Para rodar um *script* no modo de processamento em lote do <img src="images/logo_r.png" width="20"> através do seguinte comando no terminal Linux:

```
$ R CMD BATCH opcoes arqentrada arqsaida
```

Onde: `arqentrada`é o nome do script (arquivo com a extensão `.R`) a ser executado; `arqsaida` é o arquivo (com a extensão `.Rout`) com as saídas dos comandos executados no R; `opcoes` é a lista de opções que controlam a execução.

Vamos rodar como exemplo, o `script1.R` da seção \@ref(primeiro-script). 

```
$ R CMD BATCH /home/usuario/adar/script1.R
```

O comando acima, produzirá dois arquivos de saída: 
 
1. `script1.Rout`[^Rout] criado por *default* quando o `arqsaida` não é especificado, e;

[^Rout]: Você pode notar que este arquivo tem o mesmo nome do `arqentrada`, exceto que a sua extensão foi alterada para `.Rout`.

2. arquivo \"plot-script1.pdf\".


Você pode especificar o nome do `arqsaida` como desejar. No exemplo abaixo, mostra-se como salvar o arquivo de saída incluindo a data em que ele foi gerado, `script1-saida-adatadehoje.log`.

```
$ R CMD BATCH script1.R script1-saida-`date "+%Y%m%d"`.log
```
Após a execução do último comando, os mesmos arquivos resultantes do comando anterior serão gerados, exceto pelo primeiro (`.Rout`), que será nomeado ` script1-saida-20210129.Rout `.

Para mais opções do comando `R CMD BATCH` digite no terminal do Linux `R --help`.

### Windows

A execução no modo de processamento em lote no Windows é feita da mesma forma, porém substituindo `R` pelo caminho completo ao executável do <img src="images/logo_r.png" width="20">. Esse caminho pode ser obtido com os códigos:


```r
> r_exe <- file.path((R.home("bin")), "R.exe")
> r_exe
> library(fs)
> fs::path_real(r_exe)
```

```
[1] "C:/PROGRA~1/R/R-4.0.3/bin/x64/R.exe"
C:/Program Files/R/R-4.0.3/bin/x64/R.exe
```

O terminal do Windows é acessível digitando `cmd` na barra de pesquisa ao lado no meu iniciar e digitando *enter*. O *Prompt* de comando (cmd.exe) do SO Windows abrirá e você poderá rodar o `script1.R`, digitando o comando abaixo com a adequação dos caminhos para os arquivos:

```
"C:\Program Files\R\R-4.0.2\bin\R.exe" CMD BATCH "C:\Users\usuario\adar\script1.R"
```



