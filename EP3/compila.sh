#!/bin/bash

CAMINHO=$(pwd)
export LD_LIBRARY_PATH="$CAMINHO"

# Compilar a biblioteca estática hashliza
gcc -c -o hashliza.o hashliza.c && ar rcs libhashliza.a hashliza.o

if [ $? -ne 0 ]; then
    echo "Erro ao compilar hashliza"
    exit 1
fi

# Compilar a biblioteca dinamica e o teste
gcc -c -fPIC -o shannon.o shannon.c -L. -lm
if [ $? -ne 0 ]; then
    echo "Erro ao compilar shannon"
    exit 1
fi
gcc -o libshannon.so -shared shannon.o 
if [ $? -ne 0 ]; then
    echo "Erro ao criar libshannon"
    exit 1
fi
gcc -o testa testa.c -L. -lshannon -lhashliza -lm
if [ $? -ne 0 ]; then
    echo "Erro ao compilar o teste"
    exit 1
fi

#Cria o doxyfile
doxygen -g 
if [ $? -ne 0 ]; then
    echo "Erro ao gerar doxyfile"
    exit 1
fi

# Caminho do arquivo
config="Doxyfile"

# Configura o doxyfile
sed -i 's/^GENERATE_LATEX.*/GENERATE_LATEX = NO/' "$config"
sed -i 's/^PROJECT_NAME[[:space:]]\{3,\}.*/PROJECT_NAME              = "EP3 - Bibliotecas em C - Francisco Membrive"/' "$config"
sed -i 's/^OUTPUT_LANGUAGE.*/OUTPUT_LANGUAGE = Brazilian/' "$config"
sed -i 's/^OPTIMIZE_OUTPUT_FOR_C.*/OPTIMIZE_OUTPUT_FOR_C = YES/' "$config"
sed -i 's/^GENERATE_TREEVIEW.*/GENERATE_TREEVIEW = YES/' "$config"
sed -i 's/^INPUT[[:space:]]\{3,\}.*/INPUT              = shannon.h hashliza.h/' "$config"
sed -i 's/^EXTRACT_ALL.*/EXTRACT_ALL                 =  YES/' "$config"

#Gera a documentacao:
doxygen $config

if [ $? -ne 0 ]; then
    echo "Erro ao gerar documentação com Doxygen"
    exit 1
fi

#Roda o teste
./testa
if [ $? -ne 0 ]; then
    echo "Erro na execucao de teste.c"
    exit 1
fi


exit 0
