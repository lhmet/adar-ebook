# Instalação do R e RStudio {#install}



A interação do usuário com o R é por meio da linha de comando. Essa interação pode ser facilitada com o uso do [RStudio](http://www.rstudio.com/).

A seguir descreve-se como instalar o *R* no Windows e no Linux Ubuntu. A forma de instalação do R no Linux tenta ser mais didática do que prática. Alguns comandos linux básicos serão utilizados, mas mesmo quem não é usuário linux será capaz de entendê-los.

## Instalando o R

O *R* pode ser instalado a partir dos [binários pré-compilados](https://cran.r-project.org/bin/) ou do [código fonte](https://cran.r-project.org/sources.html). Aqui, descreve-se a instalação do *R* a partir dos binários

### Windows 

A forma de instalar o R no Windows é baixar o binário executável da **Rede Abrangente de Arquivos do R** ([CRAN](https://cran.r-project.org/)).
Depois clicar em *Download R for Windows* e  *install R for the first time*. Quando este tutorial foi escrito a última versão foi a [R 3.4.4](https://cran.r-project.org/bin/windows/base/R-3.4.4-win.exe).

A instalação do R para Windows a partir do executável acima incluirá na instalação uma GUI chamada `RGui.exe`, mostrada abaixo.

<div class="figure">
<img src="images/rgui-windows.png" alt="Interface gráfica do usuário no R para Windows." width="1042" />
<p class="caption">(\#fig:unnamed-chunk-1)Interface gráfica do usuário no R para Windows.</p>
</div>


### Linux 

#### Ubuntu

Há várias formas de instalar o R no Ubuntu, mas geralmente a versão compilada no repositório *default* do Ubuntu não é a última. Se isso for problema para você então basta executar:


```r
sudo apt-get install r-base
```


#### R sempre atualizado

Se você prefere trabalhar com a última versão estável do R, precisamos configurar o Linux Ubuntu para atualizar automaticamente o *R*. Também uma boa prática definir um diretório para armazenamento dos pacotes utilizados. 

O procedimento de instalação requer senha de superusuário do sistema ou de privilégios [sudo](https://en.wikipedia.org/wiki/Sudo). Caso não tenha, consulte o administrador do sistema.

Ao utilizar distribuições Linux Ubuntu é importante optar por versões estáveis[^1]. As versões de Suporte de longo prazo (LTS) mais recentes são:

- 14.04 (abril de 2014, *codename* `trusty`) 
- 16.04 (abril de 2016, *codename* `xenial`)

[^1]: Clique [aqui](http://releases.ubuntu.com) para saber mais sobre as versões do Ubuntu.

 
O [R](http://www.r-project.org/) é distribuído  na CRAN. Geralmente há duas atualizações ao ano. A versão mais atual é a R version 3.4.4 (2018-03-15). Para que ele seja atualizado automaticamente no Ubuntu precisamos adicionar o [repósitório do R](http://cran.r-project.org/mirrors.html) mais próximo da nossa região à lista de repositórios do Linux. No nosso caso, o repositório mais próximo é o da UFPR (<http://cran-r.c3sl.ufpr.br/>).

##### Incluindo repositório do *R* na Lista de repositórios do Ubuntu

A lista de repositórios do sistema é armazenada no arquivo `/etc/apt/sources.list`. Mas primeiro, você precisa descobrir ou verificar o nome da versão do sistema operacional. Para isso, você pode utilizar o seguinte comando[^2] :

    $ lsb_release --codename | cut -f2
   

```
trusty
```

[^2]: Se o comando `lsb_release` não funcionar você precisa instalar o pacote `lsb-release` no sistema. Para isso, digite no terminal Linux `sudo apt-get install lsb-release`.

Precisamos incluir no arquivo `sources.list` o espelho do repositório do R mais próximo. Veja a lista de espelhos de repositórios do R [aqui](https://cran.r-project.org/mirrors.html). Assim o gerenciador de pacotes 
[apt](http://pt.wikipedia.org/wiki/Advanced_Packaging_Tool)[^3] fará a atualização do *R* quando uma nova versão estiver disponível. Ou seja, você estará utilizando sempre versão mais atual do *R*.

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

Os arquivos binários do *R* para Ubuntu na [CRAN](http://cran.r-project.org) são assinados com uma chave pública [^4] Para adicionar essa chave ao seu sistema digite os seguintes comandos:

    $ gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9

[^4]: Chave pública de autenticação é um meio alternativo de se logar em um servidor ao invés de digitar uma senha. É uma forma mais segura e flexível, mas mais difícil de ser configurada. Esse meio alternativo de fazer login é importante se o computador está visível na internet. Para saber mais veja [aqui](http://the.earth.li/~sgtatham/putty/0.55/htmldoc/Chapter8.html).
        
e então use essa informação como entrada no `apt-key` com

    $ gpg -a --export E084DAB9 | sudo apt-key add -
      
Se aparecer a mensagem de que a chave pública foi importada, então não há necessidade de executar os comandos abaixo. Mas caso seja impresso alguma mensagem de erro, outra alternativa pode ser usada para obter a chave, via os comandos:

    $ gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
    $ gpg -a --export E084DAB9 | sudo apt-key add -


##### Atualização da lista de repositórios do Ubuntu e instalação do *R*

Após fazer as configurações da lista de repositórios e adicionar a chave é necessário fazer a atualização dessa lista (requer poderes de super usuário):

    $ sudo apt-get update
    
Agora, pode instalar o binário do R:

    $ sudo apt-get install r-base

##### Testando o *R*

Para iniciar o *R* no Ubuntu, digite `R` no cursor do terminal:

    $ R

A partir desse momento já começamos uma sessão no R. Vamos gerar uma sequência numérica de 1 a 10 e plotá-la.


```r
> 1:10
 [1]  1  2  3  4  5  6  7  8  9 10
> plot(1:10)
```

<div class="figure" style="text-align: center">
<img src="images/Chunck4-1.png" alt="Gráfico da sequência de 10 números."  />
<p class="caption">(\#fig:Chunck4)Gráfico da sequência de 10 números.</p>
</div>

Você pode sair do *R*, sem salvar os dados da seção, com o código a seguir:


```r
> q(save = "no")
```


## Diretório para instalação de pacotes

Para termos melhor controle sobre os pacotes do *R* instalados no sistema é recomendado criar um diretório (`/home/usuario/.R/libs`) no seu `home`. O diretório do `home` pode ser obtido com o comando `echo $HOME`.

    $ mkdir -p `echo $HOME`/.R/libs/
    
Para informar ao **R** onde procurar os pacotes que instalamos criamos um arquivo chamado `.Renviron` no diretório `$HOME` contendo a linha `R_LIBS=/home/usuario/.R/libs/`, o que pode ser feito com o  comando:

    $ R_LIBS=`echo $HOME/.R/libs/`
    $ echo $R_LIBS >> `echo $HOME/.Renviron`

Esse caminho fica então visível ao *R*, o que pode ser verificado executando a função `.libPaths()` no console do *R*.

    $ R

No console do R:


```r
> .libPaths()
[1] "/home/hidrometeorologista/.R/libs" "/usr/local/lib/R/site-library"    
[3] "/usr/lib/R/site-library"           "/usr/lib/R/library"               
```
    



## Rstudio no Ubuntu

O RStudio é um ambiente integrado de desenvolvimento ([IDE](http://en.wikipedia.org/wiki/Integrated_development_environment)) construído especificamente para o *R*. Assim como o *R*, o RStudio pode ser baixado gratuitamente e é multiplataforma. 

Para instalação da versão do RStudio para *[Desktop](https://pt.wikipedia.org/wiki/Ambiente_de_desktop)*, você precisa saber se seu sistema operacional é 64 ou 32-bit e a versão do Linux Ubuntu. Essas informações podem ser obtidas, respectivamente, pelos comandos:

    $ arch


```
x86_64
```

    $ lsb_release --release | cut -f2


```
14.04
```

Se retornar **x86_64** sua máquina é 64-bit.

Com essa informação e versão do sistema operacional, siga os seguintes passos:

  1. acesse [RStudio](http://www.rstudio.com/)
  2. clique em *Download RStudio*
  3. Procure a opção *RStudio Desktop* (FREE) e clique *download*

<img src="images/rstudio-choose.png" width="996" style="display: block; margin: auto;" />

  5. Selecione sua plataforma
  
<img src="images/rstudio-plataform-options.png" width="1002" style="display: block; margin: auto;" />
  
clique sobre o link da sua plataforma, p.ex.: *RStudio x.xx.xxx - Ubuntu 12.04-15.10/Debian 8 (64-bit)*

  6. Dependendo da sua versão Ubuntu, ao clicar sobre o sobre o arquivo baixado com o botão direito, há a opção de abrir com *Ubuntu Software Center* e então clicar em `instalar`. Se na versão de seu Desktop não há esta opção ao clicar com botão direito sobre o arquivo, instale via **terminal**[^5] com os seguintes comandos:

[^5]: digite 'Ctrl+Alt+t' para abrir um terminal no Linux Ubuntu

```
$ cd /local/do/arquivo/baixado
$ sudo dpkg -i arquivoBaixado.deb
$ sudo apt-get install -f
```


Abra o RStudio digitando no terminal:

    $ rstudio &
    
Agora você está pronto para começar a programar em *R* aproveitando as facilidades que o [RStudio](http://www.rstudio.com/) oferece. 

