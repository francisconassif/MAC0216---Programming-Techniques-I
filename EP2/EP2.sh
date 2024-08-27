#!/bin/bash

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# AUTOR:
# FRANCISCO NASSIF MEMBRIVE
#
# DESCRICAO:
# Este exercicio-programa, o segundo da disciplina de MAC0216,
# Tecnicas de Programacao I, corresponde a um sistema de chat 
# programado em um script bash, que funciona em duas instancias,
# cliente e servidor. Deve ser executado primeiro o servidor e 
# a seguir quantos clientes for necessario para atender a quantidade 
# de usuarios desejada. 
# O servidor suporta 4 comandos: time, list, reset e quit, enquanto
# o cliente suporta create, passwd, login, logout, list, msg e quit.
# time - diz quanto tempo em segundos se passou desde que o servidor foi iniciado
# list - imprime na tela a lista de usuarios logados no momento
# reset - remove todos os usuarios criados e logados
# quit - fecha o servidor ou o cliente
# create user senha - cria o usuario e define sua senha para que possa ser feito login
# passwd user senha nova_senha - modifica a senha de user de senha para nova_senha
# login - permite que o usuario receba mensagens, entrando nele naquele shell
# logout - sai do usuario, interrompendo a possibilidade de receber mensagens
# msg usuario mensagem - imprime a mensagem do user logado na tela do usuario passado como parametro
# 
#
# COMO EXECUTAR:
# Efetive a permissao de execucao do arquivo com
# chmod +x ep2.sh
# Execute o arquivo das seguintes maneiras:
# Servidor: ./ep2.sh servidor
# Cliente:  ./ep2.sh cliente
#
# TESTES:
# Os testes foram feitos logando ate 5 usuarios e testando todos os comandos possiveis
# enumerados na secao Descricao acima
#
# DEPENDˆENCIAS:
# O programa foi rodado em uma Virtual Machine usando o software da Oracle
# sistema Ubuntu 22.4 com 6 nucleos utilizados do processador Ryzen 5 3600
# reservados para a maquina virtual e 16GB de memoria RAM.
# Foi escrito atraves do Visual Studio Code e executado no terminal
# padrao do Ubuntu com todas as permissoes necessarias.

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Parte um, cria os caminhos dos arquivos temporarios a serem utilizados tanto 
# por servidor como por cliente.
# Serao 4 arquivos, com funcao descrita a seguir

USERS="/tmp/ep2/users.txt"          # Armazena os usuarios criados
SENHAS="/tmp/ep2/senhas.txt"        # Armazena as senhas dos usuarios criados
LOGADOS="/tmp/ep2/logados.txt"      # Armazena os usuarios logados
TERMINAIS="/tmp/ep2/terminais.txt"  # Armazena o shell em que os usuarios logados estao 

# Eh importante observar que os arquivos tem uma correspondencia dois a dois, sendo que o 
# USERS e o SENHAS tem a mesma quantidade de informacao, por tratarem dos usuarios criados.
# E o LOGADOS e TERMINAIS tem a mesma quantidade de informacoes, por tratarem dos usuarios
# logados.

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Parte dois, funcoes a serem utilizadas ao longo do programa:


# Funcao verifica_logado_criado

# Essa funcao recebe como parametros, nesta ordem, um usuario e um arquivo.
# E entao ela verifica se aquele usuario existe naquele arquivo, podendo 
# servir tanto para verificar se esta em USERS, como em LOGADOS.
# A funcao retorna o numero da linha que o usuario ocupa caso exista naquele 
# arquivo, e a string "-2", caso nao exista
# Alem disso, a funcao registra em "$?" o valor 0 caso nao tenha encontrado o 
# usuario e o valor 1 caso tenha encontrado.

verifica_logado_criado() {
    local usr=$1
    local arquivo=$2
    num_users=$(wc -l "$arquivo" | cut -d " " -f 1)
    if [ $num_users -eq 0 ]; then
        echo "-2"
        return 0
    else
        for ((i=1; i<=${num_users}; i++)); do
            usuario=$(head -n "${i}" "$arquivo" | tail -n 1)
            if [ "$usuario" == "$usr" ]; then
                echo $i
                return 1
            fi
        done
        return 0
        echo "-2"
    fi
}



# Funcao create

# Essa funcao recebe como parametros, nesta ordem, um usuario e uma senha,
# digitados no shell do cliente. Entao ela verifica se o usuario ja existe
# e imprime a string erro se for o caso. Caso contrario, registra nos arquivos
# USERS e SENHAS as respectivas informacoes, tornando possivel o login para 
# aquele usuario.

create() {
    local usr=$1
    local senha=$2
    verifica_logado_criado "$usr" "$USERS" > "/dev/null"
    existe=$?
    if [ $existe -eq 0 ]; then
        echo "$usr" >> "$USERS"
        echo "$senha" >> "$SENHAS"
    else
        echo "ERRO"
    fi
}



# Funcao list

# Essa funcao nao tem parametros e pode ser invocada tanto pelo servidor, 
# como pelo cliente. Ela le linha por linha o arquivo que contem os 
# usuarios logados e imprime um em cada linha.
list() {
    num_users=$(wc -l "$LOGADOS" | cut -d " " -f 1)
    if [ ${num_users} -ge 1 ]; then
        for ((i=1; i<=${num_users}; i++)); do
            usuario=$(head -n "${i}" "$LOGADOS" | tail -n 1)
            echo "$usuario"
        done
    fi
}



# Funcao reset

# Essa funcao nao tem parametros e pode ser utilizada apenas pelo 
# servidor. Ela apaga todo o conteudo nos 4 arquivos criados no 
# inicio da execucao do servidor.

reset() {
    echo -n "" > "$USERS"
    echo -n "" > "$SENHAS"
    echo -n "" > "$LOGADOS"
    echo -n "" > "$TERMINAIS"
}



# Funcao quit_server

# Essa curta funcao e utilizada quando o servidor invoca o comando
# quit. Ela remove tudo que foi criado no computador para execucao
# do programa

quit_server() {
    rm -r /tmp/ep2
}



# Funcao passwd

# A funcao passwd recebe tres argumentos, nesta ordem: um usuario,
# uma senha antiga e uma senha nova. Primeiramente ela verifica se
# ha algum usuario criado e se p usuario solicitado existe. Caso
# nao, a string "ERRO" eh impressa. Depois de verificar a existencia
# do usuario, ela verifica a corretude da senha e imprime "ERRO" caso 
# esteja errada. Por fim, estando tudo certo, a funcao acessa
# o arquivo das senhas e modifica a senha do usuario solicitado
# para a senha nova.

passwd() {
    local usr=$1
    local antiga=$2
    local nova=$3
    local i=1
    local indice_linha="-2"
    num_users=$(wc -l "$USERS" | cut -d " " -f 1)
    if [ $num_users -eq 0 ]; then
        echo "ERRO"
    else
        for LINHA in $(cat $USERS); do
            if [ "$LINHA" == "$usr" ]; then
                indice_linha=$i
            else
                ((i++))
            fi
        done
        if [ "$indice_linha" == "-2" ]; then
            echo "ERRO"
        else 
            senha=$(sed -n "${indice_linha}p" "$SENHAS")
            if [ "$senha" == "$antiga" ]; then
                sed -i "${indice_linha}s/.*/${nova}/" "$SENHAS"
            fi
        fi
    fi
}



# Funcao logout

# A funcao logout recebe o parametro usuario, embora no momento em que
# este comando seja invocado no cliente ele nao precise de argumentos.
# A funcao remove o usuario do arquivo de LOGADOS e envia ao Telegram
# o aviso de que aquele usuario se deslogou.

logout() {
    local usr=$1
    indice_logado=$(verifica_logado_criado "$usr" "$LOGADOS")
    if [ $indice_logado -ge 0 ]; then
        sed -i "${indice_logado}d" "$LOGADOS"
        sed -i "${indice_logado}d" "$TERMINAIS"
        curl -s --data "text=Usuario ${usr} deslogou as $(date '+%H:%M:%S') do dia $(date '+%d-%m-%Y')" insert-bot-link 1>/dev/null &
    else
        echo "ERRO"
    fi
}



# Funcao msg

# A funcao msg, executada pelo cliente logado, recebe tres parametros, embora
# quando invocado o comando sejam apenas dois. O primeiro parametro eh o usuario
# destinatario, o segundo eh a mensagem e o terceiro eh o remetente
# A funcao inicialmente descobre se o destinatario esta logado e determina
# em que linha ele esta nos arquivos. Com essa informacao, determina
# o endereco do terminal em que esta logado com o comando tty e 
# envia a mensagem sinalizando qual eh o remetente.

msg() {
    local usr=$1                                               #contem o nome do usuario que devera receber a mensagem
    local mensagem=$2                                          #contem a string da mensagem
    local remet=$3                                             #contem o nome do usuario que enviou a mensagem
    indice_destino=$(verifica_logado_criado "$usr" "$LOGADOS") #funcao recebe como parametro um user e um arquivo de users e retorna a linha que este user ocupa no arquivo
                                                               #retorna -2 se o user nao existir neste arquivo
    if [ "$indice_destino" != "-2" ]; then
        local terminal_destino=$(sed -n "${indice_destino}p" "${TERMINAIS}") 
        echo "" > "$terminal_destino"
        echo -n "[Mensagem do ${remet}]:" > "$terminal_destino"
        echo "${mensagem}" > "$terminal_destino"
        echo -n "cliente>" > "$terminal_destino"
    else
        echo "ERRO"
    fi
}



# Funcao login

# A funcao login recebe dois parametros, o usuario e a senha, respectivamente.
# Primeiro, verifica se o usuario ja foi criado e se a senha esta correta. Depois, 
# inicia um loop que sera encerrado apenas quando o cliente invocar o logout. Esse 
# loop permite que sejam executados os comandos list, msg, logout e quit. Alem disso,
# a funcao avisa ao Telegram se o usuario se logou com sucesso ou se errou a senha.

login() {
    local usr=$1
    local senha=$2
    local erro="false"
    local log="false"
    local num_users=$(wc -l "$USERS" | cut -d " " -f 1)
    local i=1
    local terminal=$(tty)
    if [ $num_users -eq 0 ]; then
        echo "ERRO"
        return 0
    else
        for LINHA in $(cat $USERS); do
            if [ "$LINHA" == "$usr" ]; then
                local indice_linha=$i
            else
                ((i++))
            fi
        done
        if [ "$indice_linha" == "-2" ]; then
            echo "ERRO"
            return 0
        else 
            senha_certa=$(sed -n "${indice_linha}p" "$SENHAS")
            if [ "$senha_certa" != "$senha" ]; then
                echo "ERRO"
                curl -s --data "text=Usuario ${usr} errou a senha as $(date '+%H:%M:%S') do dia $(date '+%d-%m-%Y')"  insert-bot-link?chat_id=1 1>/dev/null &
                return 0
            else
                for LINE in $(cat $LOGADOS); do
                    if [ "$LINE" == "$usr" ]; then
                        echo "ERRO"
                        erro="true"
                        return 0
                    fi
                done
                if [ "$erro" != "true" ]; then
                    echo "$usr" >> "$LOGADOS"
                    echo "$terminal" >> "$TERMINAIS"
                    log="true"
                    curl -s --data "text=Usuario ${usr} logou com sucesso as $(date '+%H:%M:%S') do dia $(date '+%d-%m-%Y')" insert-bot-link?chat_id=1 1>/dev/null &
                fi
            fi
        fi
    fi
    while [ "$log" == "true" ]; do
        entrada_logado=""
        echo -n "cliente>"
        read entrada_logado
        vetor=($entrada_logado)
        comando=${vetor[0]}
        if [ "$comando" == "list" ]; then list
        elif [ "$comando" == "logout" ]; then
            log="false"
            logout "$usr"
            return 0
        elif [ "$comando" == "msg" ]; then
            info_msg=($entrada_logado)
            destino=${info_msg[1]}
            mensagem=$(echo "$entrada_logado" | cut -d " " -f 3-)
            msg "$destino" "$mensagem" "$usr"
        elif [ "$comando" == "quit" ]; then
            log="false"
            logout "$usr"
            return 1
        fi
    done
}



# Funcao list_telegram

# A funcao list_telegram nao recebe argumentos, apenas utiliza a funcao
# list para enviar, a cada sessenta segundos, a lista de usuario logados
# ao Telegram. Ela faz isso enquanto o servidor estiver em execucao. 

list_telegram() {
    local enter='
'
    while [ -d "/tmp/ep2" ]; do
        list > /tmp/ep2/lista.txt
        curl -s --data "text=Lista de usuarios as $(date '+%H:%M:%S') do dia $(date '+%d-%m-%Y') ${enter}$(cat /tmp/ep2/lista.txt)" insert-bot-link?chat_id=1 1>/dev/null 
        sleep 60
    done
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Parte tres, os proprios servidor e cliente


# SERVIDOR:

# Inicia registrando o tempo de abertura para o caso do comando time ser
# executado. Depois, verifica se ja existe algum servidor em execucao.
# Se existir, encerra o programa e imprime "ERRO". Se nao, inicia a execucao do 
# list_telegram, cria o diretorio temporario e os arquivos necessarios para
# o programa funcionar.

# Em seguida, inicia o loop de leitura de comandos que sera encerrado
# apenas quando o servidor receber um comando quit. Apos o comando quit
# todas as acoes acima sao revertidas, os arquivos sao excluidos e 
# list_telegram eh encerrada.

# Eh valido observar que tanto para o cliente, como para o servidor, 
# comandos que estejam fora do script nao vao realizar nada nem provocar
# algum erro.

servidor() {
    inicio=$(date +%s)
    quit="false"
    if [ -d "/tmp/ep2" ]; then
        echo "ERRO"
        quit="true"
    else
        mkdir "/tmp/ep2"
        list_telegram &
        > "$USERS"
        > "$SENHAS"
        > "$LOGADOS"
        > "$TERMINAIS"
    fi
    while [ "$quit" == "false" ]; do
        entrada_servidor=""
        echo -n "servidor>"
        read entrada_servidor
        if [ "$entrada_servidor" == "time" ]; then
            tempo=$(date +%s)
            intervalo=$((tempo - inicio))
            echo "$intervalo"
        elif [ "$entrada_servidor" == "list" ]; then list
        elif [ "$entrada_servidor" == "reset" ]; then reset
        elif [ "$entrada_servidor" == "quit" ]; then 
            quit_server
            quit="true"
        fi
    done
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# CLIENTE

# Inicia verificando se ja existe um servidor em execucao,
# caso contrario encerra o programa e imprime "ERRO".

# Entao, inicia um loop que le os comandos ate que o comando quit
# seja executado. Caso o usuario esteja logado, o quit automaticamente executa o 
# logout.

cliente() {
    #verifica se ha um servidor funcionando
    if [ -d "/tmp/ep2" ]; then
        quitc="false"
    else
        echo "ERRO"
        quitc="true"
    fi
    while [ "$quitc" == "false" ]; do
        entrada_cliente=""
        echo -n "cliente>"
        read entrada_cliente
        vetor=($entrada_cliente)
        comando=${vetor[0]}
        if [ "$comando" == "create" ]; then
            info_usuario=($entrada_cliente)
            novo_usuario=${info_usuario[1]}
            nova_senha=${info_usuario[2]}
            create "$novo_usuario" "$nova_senha"
        elif [ "$comando" == "passwd" ]; then
            info_senha=($entrada_cliente)
            usr=${info_senha[1]}
            antiga=${info_senha[2]}
            nova=${info_senha[3]}
            passwd "$usr" "$antiga" "$nova"
        elif [ "$comando" == "login" ]; then
            info_usuario=($entrada_cliente)
            usuario=${info_usuario[1]}
            senha=${info_usuario[2]}
            login "$usuario" "$senha"
            sair=$?
            if [ $sair -eq 1 ]; then
                quitc="true"
            fi
        elif [ "$comando" == "quit" ]; then
            quitc="true"
        fi 
    done
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# "Parte quatro" - main

# Verifica qual das instancias do programa
# foi invocada e direciona para a respectiva 
# funcao, imprimindo "ERRO" caso o programa
# tenha sido rodado no shell sem argumentos.

if [ "$1" == "servidor" ]; then
    servidor
elif [ "$1" == "cliente" ]; then
    cliente
else
    echo "ERRO"
fi

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# FIM
