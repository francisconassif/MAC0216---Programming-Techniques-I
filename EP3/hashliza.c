#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "hashliza.h"

char * ep1Passo1Preenche(char * entrada){

    // Recebe uma string e completa ela para que tenha um tamanho 
    // multiplo de 16 com o caractere de codigo ascii correspondente 
    // a quantidade de elementos necessaria para completar a string

    // Uso: char * nome_variavel = ep1Passo1Preenche(entrada);
    // Ao fim do uso, inserir: 
    // free(nome_variavel);
    // Para evitar problemas com reserva de memoria

    //Define o tamanho da string e o resto da divisao por 16:
    size_t tamanho = strlen(entrada);
    size_t resto = tamanho % 16;

    // Se o resto nao for zero, define a quantidade necessaria
    // para completar a string, coloca um caractere nulo no final
    // e devolve a string:
    if (resto != 0){
        size_t adicionar = 16 - resto;
        char *saida = (char*)malloc((tamanho+adicionar+1) * sizeof(char)); 
        strcpy(saida, entrada);
        for (size_t i = 0; i < adicionar; ++i){
            saida[tamanho + i]=(char)(adicionar);
        }
        saida[tamanho+adicionar]='\0';
        return saida;
    }

    // Se o resto for zero, devolve a string inalterada:
    return entrada;
}

char * ep1Passo2XOR(char * saidaPassoUm, unsigned int * vetorMagico){

    // Utiliza o vetor magico para gerar uma criptografia 
    // da entrada, que ja devera estar nos moldes da saida 
    // do passo um
    // Caso nao esteja, retorna NULL
    // Tambem retorna NULL se o vetorMagico nao for um vetor
    // com 256 elementos correspondente a uma permutacao
    // dos inteiros de 0 a 255

    // Uso: char * nome_variavel = ep1Passo2XOR(saidaPassoUm);
    // Recomendacao: antes de chamar a funcao ep1Passo2XOR, 
    // passar a string pela funcao ep1Passo1Preenche. Isso
    // evitara problemas e eventuais saidas NULL.
    // Ao fim do uso:
    // free(nome_variavel);
    // Para evitar problemas com alocacao de memoria

    //Verifica o tamanho da entrada ate o caractere nulo:
    unsigned int tamanho = strlen(saidaPassoUm);

    //Verifica se a entrada satisfaz a condicao
    if (tamanho % 16 != 0){
        return NULL;
    }

    //Verifica se o vetor magico eh realmente uma permutacao 
    //dos inteiros de 0 a 255:
    int verificados[256]={0};
    for (int i=0; i<256; ++i){
        if (vetorMagico[i] < 0 || vetorMagico[i] > 255 || verificados[vetorMagico[i]] == 1){
            return NULL;
        }
        verificados[vetorMagico[i]]=1;
    }

    //Reserva a memoria para o vetor novoBloco:

    unsigned char * novoBloco = (char*)malloc(16 * sizeof(char));

    //Preenche o vetor com zeros em todas as posições:
    for (int i=0; i<16; ++i){
        novoBloco[i]='\0';
    }

    //Cria a variavel novoValor e a variavel n:
    unsigned int novoValor=0;

    unsigned int n = tamanho >> 4;

    //Reserva a memoria para a saida do passo dois, com o tamanho
    //da saida do passoUm, mais o tamanho do novoBloco
    //e com espaco para o caractere nulo ao final
    char * saidaPassoDois = (char*)malloc((tamanho+17) * sizeof(char));

    //Copia a saida do passo um para a saida do passo dois:
    strcpy(saidaPassoDois, saidaPassoUm);

    //Preenche o novoBloco com os valores corretos:
    for (int i = 0; i < n; ++i) {
        //printf("%d\n", i);
        for (int j = 0; j < 16; ++j) {
            //printf("%d1\n",j);
            unsigned int posicao = (unsigned int)((saidaPassoUm[16*i + j]) ^ novoValor);
            //printf("%d2\n",j);
            //printf("posicao:%d\n", posicao);
            //printf("vetorMagico:%d\n", vetorMagico[posicao]);
            //printf("novoBloco[%d]: %d\n", j, novoBloco[j]);
            novoValor = (unsigned int)vetorMagico[posicao] ^ (unsigned int)novoBloco[j];
            //printf("%d3\n",j);
            novoBloco[j] = novoValor;
        }
    }
    //Copia cada elemento do novoBloco para a saidaPassoDois:
    for (int i = 0; i<16; ++i){
        saidaPassoDois[tamanho+i]=(char)novoBloco[i];
    }

    //Insere o caractere nulo para determinar o fim da string;
    saidaPassoDois[tamanho+16]='\0';

    //Libera a memória alocada para o novo bloco:
    free(novoBloco);

    return saidaPassoDois;
}

unsigned char * ep1Passo3Comprime(char* saidaPassoDois, unsigned int *vetorMagico, int tamanho){

    // Recebe uma string, um vetor magico e o tamanho dessa string
    // eh necessario inserir o tamanho pois o strlen usaria o primeiro NULL
    // como final, mas nosso programa pode gerar um NULL antes da hora 
    // mesmo quando executado corretamente
    
    // OBS: o tamanho devera ser calculado da seguinte forma:
    // strlen(saidaPassoUm) + 16
    // Dessa forma nao ha problema pois a string do passo um nao tera caractere
    // nulo

    // Uso: unsigned char * nome_variavel = ep1Passo3Comprime(saidaPassoDois, vetorMagico, tamanho);
    // saidaPassoDois deve ser uma string com numero de caracteres multiplo de 16
    // vetorMagico devera ser uma permutacao dos inteiros de 0 a 255
    // tamanho devera ser um int multiplo de 16 com o tamanho de saidaPassoDois
    // Apos o uso, inserir:
    // free(nome_variavel);
    // Para evitar problemas de alocacao de memoria 

    // Agora, partiremos para a verificacao de cada argumento da funcao:

    // String:
    if (saidaPassoDois == NULL){
        return NULL;
    }

    // Vetor Magico:
    unsigned int verificados[256]={0};
    for (int i=0; i<256; ++i){
        if (vetorMagico[i]<0 || vetorMagico[i] > 255 || verificados[vetorMagico[i]] == 1){
            return NULL;
        }
        verificados[vetorMagico[i]]=1;
    }

    // Tamanho:
    if (tamanho % 16 != 0 || tamanho <= 0 || sizeof(tamanho) != 4){
        return NULL;
    }

    // Reserva a area de memoria para o vetor, com uma posicao a mais 
    // para o caractere nulo:
    unsigned char * saidaPassoTres = (unsigned char*)malloc((49) * sizeof(unsigned char));

    // Preenche o vetor com zeros:
    for (int i=0; i<49; ++i){
        saidaPassoTres[i]='\0';
    }

    // Calcula a quantidade de vezes que o primeiro laco vai rodar:
    size_t blocos = tamanho/16;

    // Realiza o preenchimento do vetor saidaPassoTres:
    for (size_t i = 0; i<blocos; ++i){
        for (size_t j = 0; j<16; ++j){
            saidaPassoTres[j+16] = saidaPassoDois[16*i + j];
            saidaPassoTres[32 + j] = ((saidaPassoTres[16+j]) ^ (saidaPassoTres[j]));
        }
        unsigned int temp = 0;
        for (size_t j = 0; j<18; ++j){
            for (size_t k = 0; k<48; ++k){
                temp = ((saidaPassoTres[k]) ^ (vetorMagico[temp]));
                saidaPassoTres[k] = temp;
            }
            temp = temp + j;
            temp = temp%256;
        }
    }
    return saidaPassoTres;
}

unsigned char * ep1Passo4Hash(unsigned char * saidaPassoTres){
    
    // Recebe uma string saidaPassoTres, que deve ter 48 caracteres
    // Como esses caracteres podem assumir valor zero, nao eh 
    // possivel verificar a string usando strlen
    // Por isso, recomenda-se utilizar a funcao ep1Passo4Hash
    // apenas em strings geradas pela funcao ep1Passo3Comprime

    // A funcao remove os ultimos 32 caracteres dessa string, 
    // mantendo os 16 primeiros

    // Uso: unsigned char * nome_variavel = ep1Passo4Hash(saidaPassoTres);
    // Após o uso, inserir:
    // free(nome_variavel);
    // Para evitar problemas com alocacao de memoria


    // Verifica a string:
    if (saidaPassoTres == NULL){
        return NULL;
    }

    // Aloca a memoria para a saida:
    unsigned char * saidaPassoQuatro = (unsigned char*)malloc((17) * sizeof(char));

    // Percorre os primeiros 16 caracteres da entrada 
    // e registra na saida:
    for (size_t i = 0; i < 16; ++i){
        saidaPassoQuatro[i] = saidaPassoTres[i];
    }

    // Adiciona o caractere nulo ao final da string:
    saidaPassoQuatro[16]='\0';

    return saidaPassoQuatro;
}

unsigned char *ep1Passo4HashEmHexa(unsigned char *saidaPassoQuatroHash) {
    // Recebe uma string que deve ter 16 caracteres. Novamente, essa string
    // pode ter caracteres nulos antes do final, o que impossibilita a verificacao 
    // atraves do strlen

    // A funcao converte cada caractere da string em dois caracteres, correspondentes
    // ao valor ascii em hex daquele respectivo caractere

    // Uso: unsigned char * nome_variavel = ep1Passo4HashEmHexa(saidaPassoQuatro);
    // Assim como nas funcoes anteriores, recomenda-se que esta funcao seja 
    // utilizada apenas com entradas que tenham sido geradas pela funcao
    // ep1Passo4Hash
    // Apos o uso, liberar a memoria:
    // free(nome_variavel);

    // Verifica se a string passada nao eh nula:
    if (saidaPassoQuatroHash == NULL){
        return NULL;
    }

    // Aloca a memoria para a string final de 32 caracteres, com espaco
    // para o caractere nulo no final:
    unsigned char *hashFinal = (unsigned char *)malloc(33 * sizeof(unsigned char));

    // Cria a variavel j que sera responsavel por registrar o indice da string final
    // que esta sendo percorrido no momento:
    size_t j = 0;

    // A variavel j crescera 2 vezes a cada incremento em i, ja que cada caractere no hash
    // o valor hex tem dois caracteres

    // Laco que percorre cada um dos 16 caracteres:
    for (size_t i = 0; i < 16; ++i) {
        // Descobre cada caractere do valor em hex, fazendo o shift dos ultimos 4 bits
        // no caso do primeiro caractere 

        // Em ambos, eh feito o and com o valor "1111" para garantir que apenas os 
        // ultimos 4 bits serao considerados
        unsigned int dezena = (saidaPassoQuatroHash[i] >> 4) & 0x0F;
        unsigned int unidade = saidaPassoQuatroHash[i] & 0x0F;

        // Agora, precisamos converter o valor numerico para seu caractere ascii
        if (dezena < 10) {
            hashFinal[j] = dezena + '0';
        } else {
            hashFinal[j] = dezena - 10 + 'a';
        }
        ++j;

        if (unidade < 10) {
            hashFinal[j] = unidade + '0';
        } else {
            hashFinal[j] = unidade - 10 + 'a';
        }
        ++j;
    }

    // Adiciona o caractere nulo no final da string
    hashFinal[j] = '\0';

    return hashFinal;
}

unsigned int * ep3CriaVetorMagico(int semente){
    // Funcao que cria uma permutacao pseudo-aleatoria dos inteiros de 0 a 255 sem repeticao,
    // utilizando um inteiro como semente, de forma a garantir que sementes iguais
    // gerem vetores iguais

    // Uso: unsigned int * nome_vetor = ep3CriaVetorMagico(semente);
    // Apos o uso, liberar a memoria:
    // free(nome_vetor);

    // Inicializa a semente para garantir que sementes iguais gerem vetores iguais:
    srand(semente);

    // Aloca a memoria para a saida:
    unsigned int * VetorMagico = (unsigned int*)malloc((256) * sizeof(unsigned int));
    int tamanho = 256;

    // Preenche o vetor com valores ordenados de 0 a 255
    for (int i = 0; i < tamanho; ++i) {
        VetorMagico[i] = i;
    }

    // Embaralha o vetor:
    for (int i = tamanho - 1; i > 0; --i) {
        // A variavel j tera um indice aleatorio de 0 a i:
        int j = rand() % (i + 1);

        // Troca vetor[i] e vetor[j]
        int temp = VetorMagico[i];
        VetorMagico[i] = VetorMagico[j];
        VetorMagico[j] = temp;
    }
    return VetorMagico;
}


