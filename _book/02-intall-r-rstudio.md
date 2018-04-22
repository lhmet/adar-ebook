# Instalação do R e RStudio {#install}



A interação do usuário com o <img src="images/logo_r.png" width="20"> é por meio da linha de comando. Essa interação pode ser facilitada com o uso do software RStudio *Desktop*.

A seguir descreve-se como:

- instalar o <img src="images/logo_r.png" width="20"> no Windows e no Linux Ubuntu

- manter o <img src="images/logo_r.png" width="20"> sempre atualizado no Linux Ubuntu 

- configurar um diretório para armazenar os pacotes do R instalados

- instalar o Rstudio *Desktop*

Neste livro, o maior foco na instalação do <img src="images/logo_r.png" width="20"> é dada para o SO Linux [Ubuntu](https://pt.wikipedia.org/wiki/Ubuntu), pelo fato de assim como o R, ser um software livre e de código aberto. Como o Linux Ubuntu é baseado no [Debian](https://pt.wikipedia.org/wiki/Debian) o procedimento de instalação também se estende a essa distribuição Linux e as [versões derivadas do Ubuntu](https://pt.wikipedia.org/wiki/Ubuntu#Projetos_derivados) que são oficialmente reconhecidas. 

A instalação no SO Windows é igual a instalação de qualquer outro *software* e pode ser facilmente encontrada na internet. Por esta razão, somente indicou-se o caminho de instalação, sem as instruções detalhadas de instalação para este SO.


<div class="rmdtip">
<p>Ao instalar R e RStudio recomenda-se optar por instalar na língua inglesa. Assim quando surgir uma mensagem de erro durante o uso do software, basta buscar na internet por esta mensagem que a chance de encontrar uma solução para o problema será muito maior.</p>
</div>

## Instalando o <img src="images/logo_r.png" width="20">

O <img src="images/logo_r.png" width="20"> pode ser instalado a partir dos [binários pré-compilados](https://cran.r-project.org/bin/) ou do [código fonte](https://cran.r-project.org/sources.html). Aqui, descreve-se a instalação do <img src="images/logo_r.png" width="20"> a partir dos arquivos binários.



### Windows 

A forma de instalar o <img src="images/logo_r.png" width="20"> no Windows é baixar o binário executável da **Rede Abrangente de Arquivos do <img src="images/logo_r.png" width="20">** ([CRAN](https://cran.r-project.org/)).
Depois clicar em *Download <img src="images/logo_r.png" width="20"> for Windows* e  *install <img src="images/logo_r.png" width="20"> for the first time*. Quando este tutorial foi escrito a última versão foi a [R 3.4.4](https://cran.r-project.org/bin/windows/base/R-3.4.4-win.exe).

A instalação do <img src="images/logo_r.png" width="20"> para o Windows, a partir do executável acima, incluirá na instalação uma Interface Gráfica do Usuário (GUI) acessível pelo executável `RGui.exe` (Figura \@ref(fig:r-gui)). Um atalho para esse executável é gerado por *default* após a intalação do <img src="images/logo_r.png" width="20">, na área de trabalho com o símbolo do <img src="images/logo_r.png" width="20">.

<div class="figure">
<img src="images/rgui-windows.png" alt="Interface gráfica do usuário no R para Windows." width="100%" />
<p class="caption">(\#fig:r-gui)Interface gráfica do usuário no R para Windows.</p>
</div>


### Linux 

#### Ubuntu

Há várias formas de instalar o <img src="images/logo_r.png" width="20"> no Ubuntu, mas geralmente a versão compilada no repositório *default* do Ubuntu não é a última. Se isso não for problema para você então basta executar:


```r
sudo apt-get install r-base
```

Entretanto, os pacotes do <img src="images/logo_r.png" width="20"> recém lançados são compilados para última versão do <img src="images/logo_r.png" width="20">. Então você pode ter restrições ao uso de pacotes novos, os quais geralmente incluem o estado da arte de análise de dados. Por esta razão, abaixo mostra-se como manter o R sempre atualizado no SO Linux, nas distribuições Ubuntu.

#### R sempre atualizado

Se você quer trabalhar sempre com a última versão estável do <img src="images/logo_r.png" width="20">, é possível configurar o Linux Ubuntu para atualizar automaticamente o <img src="images/logo_r.png" width="20">. O procedimento de instalação requer senha de superusuário do sistema ou de privilégios [sudo](https://en.wikipedia.org/wiki/Sudo). Caso não tenha, consulte o administrador do sistema.

Ao utilizar distribuições Linux Ubuntu é importante optar por versões estáveis[^1]. As versões de Suporte de longo prazo (LTS) mais recentes são:

- 14.04 (abril de 2014, *codename* `trusty`) 
- 16.04 (abril de 2016, *codename* `xenial`)

[^1]: Clique [aqui](http://releases.ubuntu.com) para saber mais sobre as versões do Ubuntu.

 
O [R](http://www.r-project.org/) é distribuído  na CRAN. Geralmente há duas atualizações ao ano. A versão mais atual é a R version 3.4.4 (2018-03-15). Para que ele seja atualizado automaticamente no Ubuntu precisamos adicionar o [repósitório do R](http://cran.r-project.org/mirrors.html) mais próximo da nossa região à lista de repositórios do Linux. No nosso caso, o repositório mais próximo é o da UFPR (<http://cran-r.c3sl.ufpr.br/>).

##### Incluindo repositório do <img src="images/logo_r.png" width="20"> na Lista de repositórios do Ubuntu

A lista de repositórios do sistema é armazenada no arquivo `/etc/apt/sources.list`. Mas primeiro, você precisa descobrir ou verificar o nome da versão do sistema operacional. Para isso, você pode utilizar o seguinte comando[^2] :



```
$ lsb_release --codename | cut -f2
```
```
trusty
```


[^2]: Se o comando `lsb_release` não funcionar você precisa instalar o pacote `lsb-release` no sistema. Para isso, digite no terminal Linux `sudo apt-get install lsb-release`.

Precisamos incluir no arquivo `sources.list` o espelho do repositório do R mais próximo. Veja a lista de espelhos de repositórios do <img src="images/logo_r.png" width="20"> [aqui](https://cran.r-project.org/mirrors.html). Assim o gerenciador de pacotes 
[apt](http://pt.wikipedia.org/wiki/Advanced_Packaging_Tool)[^3] fará a atualização do <img src="images/logo_r.png" width="20"> quando uma nova versão estiver disponível. Ou seja, você estará utilizando sempre versão mais atual do <img src="images/logo_r.png" width="20">.

[^3]: o gerenciador de pacotes [apt](http://pt.wikipedia.org/wiki/Advanced_Packaging_Tool) é usado para instalação, atualização e remoção de pacotes em distribuições Debian GNU/Linux.

O endereço do repositório da UFPR será inserido na última linha do arquivo `sources.list` usando alguns comandos linux. Essa tarefa requer privilégios de [superusuário](https://pt.wikipedia.org/wiki/Superusu%C3%A1rio). Vamos trocar do seu usuário para o superusuário.


    $ sudo su


Vamos definir no terminal uma variável com o endereço do repositório (da UFPR nesse caso) e o nome de versão do Ubuntu.

    # repos="deb http://cran-r.c3sl.ufpr.br/bin/linux/ubuntu `lsb_release --codename | cut -f2`/"
 
Note que a variável `repos` é uma sequência de caracteres com as seguintes informações:

    deb `linkRepositorioSelecionado`/bin/linux/ubuntu `versaoUbuntu`/

O valor da variável `repos` é mostrado pelo comando: `echo $repos`. Certifique-se de que a última palavra corresponde ao nome da sua versão Ubuntu. 

Para acrescentar essa informação no final do arquivo `sources.list` digite no terminal linux:

    # echo $repos >> /etc/apt/sources.list

Feito isso, você pode retornar a sessão de usuário comum, usando o comando abaixo:

    # exit

##### [APT protegido](https://cran.r-project.org/bin/linux/ubuntu/README.html#secure-apt) 

Os arquivos binários do <img src="images/logo_r.png" width="20"> para Ubuntu na [CRAN](http://cran.r-project.org) são assinados com uma chave pública [^4] Para adicionar essa chave ao seu sistema digite os seguintes comandos:

    $ gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9

[^4]: Chave pública de autenticação é um meio alternativo de se logar em um servidor ao invés de digitar uma senha. É uma forma mais segura e flexível, mas mais difícil de ser configurada. Esse meio alternativo de fazer login é importante se o computador está visível na internet. Para saber mais veja [aqui](http://the.earth.li/~sgtatham/putty/0.55/htmldoc/Chapter8.html).
        
e então use essa informação como entrada no `apt-key` com

    $ gpg -a --export E084DAB9 | sudo apt-key add -
      
Se aparecer a mensagem de que a chave pública foi importada, então não há necessidade de executar os comandos abaixo. Mas caso seja impresso alguma mensagem de erro, outra alternativa pode ser usada para obter a chave, via os comandos:

    $ gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
    $ gpg -a --export E084DAB9 | sudo apt-key add -


##### Atualização da lista de repositórios do Ubuntu e instalação do <img src="images/logo_r.png" width="20">

Após fazer as configurações da lista de repositórios e adicionar a chave é necessário fazer a atualização dessa lista (requer poderes de super usuário):

    $ sudo apt-get update
    
Agora, pode instalar o binário do R:

    $ sudo apt-get install r-base

##### Testando o <img src="images/logo_r.png" width="20">

Para iniciar o <img src="images/logo_r.png" width="20"> no Ubuntu, digite `R` no cursor do terminal:

    $ R

A partir desse momento já começamos uma sessão no <img src="images/logo_r.png" width="20">. Vamos gerar uma sequência numérica de 1 a 10 e plotá-la.


```r
> 1:10
 [1]  1  2  3  4  5  6  7  8  9 10
> plot(1:10)
```

<div class="figure" style="text-align: center">
<img src="images/Chunck4-1.png" alt="Gráfico da sequência de 10 números."  />
<p class="caption">(\#fig:Chunck4)Gráfico da sequência de 10 números.</p>
</div>

Você pode sair do <img src="images/logo_r.png" width="20">, sem salvar os dados da seção, com o código a seguir:


```r
> q(save = "no")
```


## Diretório para instalação de pacotes

Uma boa prática é definir um diretório para armazenamento dos pacotes utilizados. Isso lhe dá mais controle sobre os pacotes do <img src="images/logo_r.png" width="20"> instalados no sistema. Um local sugerido é o `/home/usuario/.R/libs`. O seu `home` ou `pasta pessoal` pode ser obtido com o comando `echo $HOME`. Para criar o diretório você pode digitar o comando abaixo:

    $ mkdir -p `echo $HOME`/.R/libs/
    
Para informar ao <img src="images/logo_r.png" width="20"> onde procurar os pacotes instalados, você precisa criar um arquivo chamado `.Renviron`, no diretório `$HOME`, contendo a expressão `R_LIBS=/home/usuario/.R/libs/`. Você pode fazer isso em um terminal com os comandos:

    $ R_LIBS=`echo $HOME/.R/libs/`
    $ echo $R_LIBS >> `echo $HOME/.Renviron`

Esse caminho fica então visível ao <img src="images/logo_r.png" width="20">, o que pode ser verificado executando a função `.libPaths()` na linha de comando do <img src="images/logo_r.png" width="20">. 

Abra o <img src="images/logo_r.png" width="20">:

    $ R

e ao digitar:


```r
> .libPaths()
[1] "/home/hidrometeorologista/.R/libs" "/usr/local/lib/R/site-library"    
[3] "/usr/lib/R/site-library"           "/usr/lib/R/library"               
```
    
o seu diretório `/home/usuario/.R/libs` [^5] deve aparecer em primeiro lugar. Indicando que este local tem prioridade para instalação dos pacotes. Caso o diretório deixe de existir os seguintes diretórios serão usados.

[^5]: Diretórios precedidos por "." no Linux são diretórios ocultos. O diretório `/home/usuario/.R` é um diretório oculto, para visualizá-lo no Ubuntu, na interface gráfica do sistema, acesse *View > Show Hidden Files* (ou *Visualizar > Mostrar arquivos ocultos*). No terminal utilize `ls -a` para listar os arquivos ocultos.

## RStudio no Ubuntu {#install-rstudio}

<img src="images/logo_rstudio.png" width="80"> é uma empresa que desenvolve ferramentas gratuitas para o <img src="images/logo_r.png" width="20"> e [produtos pagos](https://www.rstudio.com/products/) para empresas.

Uma de suas ferramentas gratuitas é o software RStudio *Desktop* que consiste em um ambiente integrado de desenvolvimento ([IDE](http://en.wikipedia.org/wiki/Integrated_development_environment)) construído especificamente para o <img src="images/logo_r.png" width="20">, consequentemente, também é multiplataforma.

Para instalação da versão do RStudio para *[Desktop](https://pt.wikipedia.org/wiki/Ambiente_de_desktop)*, você precisa saber se seu SO é 64 ou 32-bit e a versão do Linux Ubuntu. Essas informações podem ser obtidas, respectivamente, pelos comandos:

    $ arch

```
x86_64
```
Se retornar **x86_64** sua máquina é 64-bit.

    $ lsb_release --release | cut -f2

```
14.04
```

Com essas informações, siga os seguintes passos:

  1. acesse [RStudio](https://www.rstudio.com/products/rstudio/download/)
  2. clique em *Download* (Figura \@ref(fig:rstudio-choose))


<div class="figure" style="text-align: center">
<img src="images/rstudio-choose.png" alt="Opção para baixar o RStudio *Desktop*." width="100%" />
<p class="caption">(\#fig:rstudio-choose)Opção para baixar o RStudio *Desktop*.</p>
</div>

  3. Clique na sua plataforma escolhida de acordo com seu SO, arquitetura e versão da distribuição (Figura \@ref(fig:rstudio-plat)), no exemplo deste livro *RStudio 1.1.447 - Ubuntu 12.04-15.10/Debian 8 (64-bit)*
  
<div class="figure" style="text-align: center">
<img src="images/rstudio-plataform-options.png" alt="Escolha da plataforma em que será o usada o RStudio *Desktop*." width="100%" />
<p class="caption">(\#fig:rstudio-plat)Escolha da plataforma em que será o usada o RStudio *Desktop*.</p>
</div>
  

  4. Dependendo da sua versão Ubuntu, ao clicar sobre o sobre o arquivo baixado com o botão direito, há a opção de abrir com *Ubuntu Software Center* e então clicar em `instalar`. Se na versão de seu *Desktop* não há esta opção ao clicar com botão direito sobre o arquivo, instale via **terminal**[^6] com os seguintes comandos:


[^6]: digite 'Ctrl+Alt+t' para abrir um terminal no Linux Ubuntu

```
$ cd /local/do/arquivo/baixado
$ sudo dpkg -i arquivoBaixado.deb
$ sudo apt-get install -f
```


Abra o RStudio digitando no terminal:

    $ rstudio &
    
Agora você está pronto para começar a programar em <img src="images/logo_r.png" width="20"> aproveitando as facilidades que o [RStudio](http://www.rstudio.com/) oferece. 

