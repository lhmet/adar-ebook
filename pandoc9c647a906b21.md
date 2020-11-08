Você pode acessar uma função de um pacote instalado com a forma especial `pacote::funcao`. O trecho de código anterior poderia ser reduzido a: 

`remotes::install_github("lhmet/ADARdata")`

Essa forma deixa explícito que estamos usando a função `install_github()` do pacote **remotes**.

As vezes você pode estar com diversos pacotes carregados e eles podem ter funções de mesmo nome. Portanto, essa é a alternativa mais segura de avaliar funções afim de evitar conflitos. 
