#include "shannon.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

double ep3CalculaEntropiaShannon(char *string, int base) {
    // Recebe uma string e um inteiro para servir como base
    // para o calculo da entropia de shannon da string,
    // que consiste em zero menos o somatorio da frequencia de 
    // cada caractere multiplicado pelo logaritmo desta frequencia
    // na base definida pelo parametro da funcao.

    // Calcula o tamanho da string para definir o denominador 
    // da fracao correspondente a frequencia:
    double tamanho = strlen(string);
    
    // Se a string for vazia, retorna zero:
    if (tamanho == 0) {
        return 0.0;
    }

    // Verifica a frequencia de cada caractere ASCII
    double quantidades[256] = {0};
    for (int i = 0; i < tamanho; i++) {
        quantidades[(unsigned char)string[i]]++;
    }

    // Calcula a entropia de Shannon multiplicando cada frequencia 
    // pelo log da frequencia na base dada como parametro da funcao
    // e subtrai a soma de zero
    double entropia = 0.0;
    for (int i = 0; i < 256; i++) {
        if (quantidades[i] > 0) {
            double p = (double)quantidades[i] / tamanho;
            entropia = entropia - (p * (log(p) / log(base)));
        }
    }

    return entropia;
}