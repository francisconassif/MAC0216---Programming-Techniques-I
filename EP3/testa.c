#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "hashliza.h"
#include <sys/time.h>
#include "shannon.h"

// Esse programa teste.c realiza um teste das funcoes das bibliotecas
// shannon.h e hashliza.h, com 10 strings de tamanho 100. Imprime na
// saida padrao o tempo gasto para execucao de cada funcao com cada
// string. Alem disso, imprime o hash gerado por aquela string, junto
// com a semente utilizada em vetorMagico. Tambem imprime a entropia
// de Shannon da string, calculada com uma base tambem impressa. Ao final
// da execucao com as 10 strings, imprime o tempo minimo, maximo e medio
// gasto na execucao de cada funcao.
//
//
//
//


long double t_microsegundos() {
    struct timeval tempo;
    gettimeofday(&tempo, NULL);
    long double t_microsegundos = (long double)tempo.tv_sec * 1000000.0L + (long double)tempo.tv_usec;
    return t_microsegundos;
}

int main() {
    int imprimir_resultados = 0;
    long double soma_0=0.0L;
    long double soma_1=0.0L;
    long double soma_2=0.0L;
    long double soma_3=0.0L;
    long double soma_4=0.0L;
    long double soma_5=0.0L;
    long double soma_6=0.0L;
    long double max_0=0.0L;
    long double max_1=0.0L;
    long double max_2=0.0L;
    long double max_3=0.0L;
    long double max_4=0.0L;
    long double max_5=0.0L;
    long double max_6=0.0L;
    long double min_0=999999999.0L;
    long double min_1=999999999.0L;
    long double min_2=999999999.0L;
    long double min_3=999999999.0L;
    long double min_4=999999999.0L;
    long double min_5=999999999.0L;
    long double min_6=999999999.0L;


    // Strings de entrada
    char teste0[]="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    char teste1[]="Il n'y a qu'un probleme philosophique vraiment serieux: c'est le suicide. Juger que la vie vaut ou ";
    char teste2[]="Tired of lying in the sunshine, staying home to watch the rain, and you are young, and life is long";
    char teste3[]="Nunca conheci quem tivesse levado porrada. Todos os meus conhecidos tem sido campeoes em tudo. E eu";
    char teste4[]="O VERDADEIRO NOME de Geraldo Viramundo, embora ele afirmasse ser Jose Geraldo Peres da Nobrega e Si";
    char teste5[]="Mau tempo para votar, queixou-se o presidente da mesa da assembleia eleitoral numero 14 depois de f";
    char teste6[]="Jemand muBte Josef K. verleumdet haben, denn ohne daB er etwas Boses getan hatte, wurde er eines Mo";
    char teste7[]="Ave Maria, Gratia Plena. Dominus Tecum. Et Benedicta tu in mulieribus. Et Benedictus frutus ventris";
    char teste8[]="It was a bright cold day in April, and the clocks were striking thirteen. Winston Smith, his chin n";
    char teste9[]="Muchos anos despues, frente al peloton de fusilamiento, el coronel Aureliano Buendia habia de recor";

    char entrada[100];

    for (int i = 0; i < 10; ++i){
        // Vetor mágico
        long double t = t_microsegundos();
        unsigned int * vetorMagico = ep3CriaVetorMagico(i);
        long double t_0 = t_microsegundos();
        long double delta = t_0 - t;
        if (delta < min_0) min_0 = delta;
            if (delta > max_0) max_0 = delta;
            soma_0 = soma_0 + delta;

        

        if (i == 0) strcpy(entrada,teste0);
        if (i == 1) strcpy(entrada,teste1);
        if (i == 2) strcpy(entrada,teste2);
        if (i == 3) strcpy(entrada,teste3);
        if (i == 4) strcpy(entrada,teste4);
        if (i == 5) strcpy(entrada,teste5);
        if (i == 6) strcpy(entrada,teste6);
        if (i == 7) strcpy(entrada,teste7);
        if (i == 8) strcpy(entrada,teste8);
        if (i == 9) strcpy(entrada,teste9);
        // Chama a função passoUm
        
        t_0 = t_microsegundos();

        unsigned char* resultadoPassoUm = ep1Passo1Preenche(entrada);

        long double t_1 = t_microsegundos();

        delta = t_1 - t_0;
        if (delta < min_1) min_1 = delta;
        if (delta > max_1) max_1 = delta;
        soma_1 = soma_1 + delta;

        unsigned int tamanho_1 = strlen(resultadoPassoUm);
        unsigned int tamanho_2 = tamanho_1 + 16;

        if (resultadoPassoUm == NULL) {
            fprintf(stderr, "Erro ao executar passoUm.\n");
            return EXIT_FAILURE;
        }

        // Imprime o resultado do passoUm
        if (imprimir_resultados == 1){
            printf("Resultado de ep1Passo1Preenche: ");
            for (size_t i = 0; i < strlen(resultadoPassoUm); ++i) {
                printf("%d ", resultadoPassoUm[i]);
            }
            printf("\n");
        }
        

        printf("Tempo gasto na execucao do passo 1 em microssegundos: %Lf\n", delta);


        t_0 = t_microsegundos();

        // Chama a função passoDois
        unsigned char* resultadoPassoDois = ep1Passo2XOR(resultadoPassoUm, vetorMagico);

        long double t_2 = t_microsegundos();

        delta = t_2 - t_0;
        if (delta < min_2) min_2 = delta;
        if (delta > max_2) max_2 = delta;
        soma_2 = soma_2 + delta;


        if (resultadoPassoDois == NULL) {
            fprintf(stderr, "Erro ao executar passoDois.\n");
            free(resultadoPassoUm);
            return EXIT_FAILURE;
        }

        printf("Tempo gasto na execucao do passo 2 em microssegundos: %Lf\n", delta);

        // Imprime o resultado do passoDois
        if (imprimir_resultados == 1){
            printf("Resultado do passoDois: ");
            for (size_t i = 0; i < strlen(resultadoPassoUm)+16; ++i) {
                printf("%d ", resultadoPassoDois[i]);
            }
            printf("\n");
        }

        t_0 = t_microsegundos();

        unsigned char* saidaTres = ep1Passo3Comprime(resultadoPassoDois, vetorMagico, tamanho_2);

        long double t_3 = t_microsegundos();

        delta = t_3 - t_0;

        if (delta < min_3) min_3 = delta;
        if (delta > max_3) max_3 = delta;
        soma_3 = soma_3 + delta;

        printf("Tempo gasto na execucao do passo 3 em microssegundos: %Lf\n", delta);

        if (saidaTres == NULL){
            fprintf(stderr, "Erro ao executar o passoTres.\n");
            free(resultadoPassoDois);
            free(saidaTres);
            return EXIT_FAILURE;
        }


        // Imprime o resultado do passoTres:
        if (imprimir_resultados == 1){
            printf("Resultado do passoTres: ");
            for (size_t i = 0; i<48; ++i){
                printf("%d ", saidaTres[i]);
            }
            printf("\n");
        }
        
        t_0 = t_microsegundos();
        unsigned char* saidaQuatro = ep1Passo4Hash(saidaTres);
        long double t_4 = t_microsegundos();

        delta = t_4 - t_0;
        if (delta < min_4) min_4 = delta;
        if (delta > max_4) max_4 = delta;
        soma_4 = soma_4 + delta;

        printf("Tempo gasto na execucao de ep1Passo4Hash em microssegundos: %Lf\n", delta);


        if (imprimir_resultados == 1){
            printf("Resultado do passoQuatro: ");
            for (size_t i = 0; i<16; ++i){
                printf("%d ", saidaQuatro[i]);
            }
            printf("\n");
        }

        t_0 = t_microsegundos();
        
        unsigned char* hashFinal = ep1Passo4HashEmHexa(saidaQuatro);

        long double t_5 = t_microsegundos();

        delta = t_5 - t_0;
        if (delta < min_5) min_5 = delta;
        if (delta > max_5) max_5 = delta;
        soma_5 = soma_5 + delta;


        printf("Tempo gasto na execucao de ep1Passo4Hash em microssegundos: %Lf\n", delta);

        printf("Hash final da string %d, usando como semente para vetorMagico o inteiro %d: ", i, i);
        printf("%s",hashFinal);
        printf("\n");

        t_0 = t_microsegundos();
        double x = ep3CalculaEntropiaShannon(entrada,i+2);
        long double t_6 = t_microsegundos();
        printf("A entropia de Shannon da string %d, usando como base do logaritmo %d: %f\n", i, i+2, x);

        delta = t_6 - t_0;
        if (delta < min_6) min_6 = delta;
        if (delta > max_6) max_6 = delta;
        soma_6 = soma_6 + delta;


        // Libera a memória alocada
        free(resultadoPassoUm);
        free(resultadoPassoDois);
        free(saidaTres);
        free(saidaQuatro);
        free(vetorMagico);
    }

    long double media_0 = soma_0/10.0;
    long double media_1 = soma_1/10.0;
    long double media_2 = soma_2/10.0;
    long double media_3 = soma_3/10.0;
    long double media_4 = soma_4/10.0;
    long double media_5 = soma_5/10.0;
    long double media_6 = soma_6/10.0;



    printf("\n");
    printf("Informacoes sobre ep1Passo1Preenche:\n");
    printf("    Tempo maximo: %Lf microssegundos\n", max_1);
    printf("    Tempo minimo: %Lf microssegundos\n", min_1);
    printf("    Tempo medio: %Lf microssegundos\n", media_1);

    printf("\n");
    printf("Informacoes sobre ep1Passo2XOR:\n");
    printf("    Tempo maximo: %Lf microssegundos\n", max_2);
    printf("    Tempo minimo: %Lf microssegundos\n", min_2);
    printf("    Tempo medio: %Lf microssegundos\n", media_2);

    printf("\n");
    printf("Informacoes sobre ep1Passo3Comprime:\n");
    printf("    Tempo maximo: %Lf microssegundos\n", max_3);
    printf("    Tempo minimo: %Lf microssegundos\n", min_3);
    printf("    Tempo medio: %Lf microssegundos\n", media_3);

    printf("\n");
    printf("Informacoes sobre ep1Passo4Hash:\n");
    printf("    Tempo maximo: %Lf microssegundos\n", max_4);
    printf("    Tempo minimo: %Lf microssegundos\n", min_4);
    printf("    Tempo medio: %Lf microssegundos\n", media_4);

    printf("\n");
    printf("Informacoes sobre ep1Passo4HashEmHexa:\n");
    printf("    Tempo maximo: %Lf microssegundos\n", max_5);
    printf("    Tempo minimo: %Lf microssegundos\n", min_5);
    printf("    Tempo medio: %Lf microssegundos\n", media_5);

    printf("\n");
    printf("Informacoes sobre ep3CriaVetorMagico:\n");
    printf("    Tempo maximo: %Lf microssegundos\n", max_0);
    printf("    Tempo minimo: %Lf microssegundos\n", min_0);
    printf("    Tempo medio: %Lf microssegundos\n", media_0);

    printf("\n");
    printf("Informacoes sobre ep3CalculaEntropiaShannon:\n");
    printf("    Tempo maximo: %Lf microssegundos\n", max_6);
    printf("    Tempo minimo: %Lf microssegundos\n", min_6);
    printf("    Tempo medio: %Lf microssegundos\n", media_6);
    
    

    return 0;
}