#ifndef _HASHLIZA_H_
#define _HASHLIZA_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/*!
 * \brief Função que recebe uma string, verifica seu tamanho e,
 * caso não seja múltiplo de 16, completa com a quantidade de 
 * caracteres necessária. O caractere usado para completar será
 * o de código ASCII correspondente a 16 - strlen(stringEntrada)%16.
 * \param stringEntrada: Uma string de qualquer tamanho, formada
 * apenas por caracteres ASCII.
 * \return Devolve a mesma string, agora
 * completa com tamanho múltiplo de 16.
 */
char * ep1Passo1Preenche(char * stringEntrada);

/*!
 * \brief Função que recebe uma string que deve ter tamanho múltiplo de 16.
 * Recebe um vetorMagico a ser utilizado para criptografar a string.
 * \param saidaPassoUm: Uma string tamanho múltiplo de 16, formada
 * apenas por caracteres ASCII.
 * \param vetorMagico: Um vetor formado pela permutação dos inteiros de 
 * 0 a 255, sem repetição.
 * \return Retorna NULL se o vetorMagico ou a saidaPassoUm não estiverem
 * no formato correto. Se estiver tudo certo, retorna uma string de tamanho
 * strlen(saidaPassoUm) + 16, formada pela string original e por um novoBloco
 * de 16 caracteres gerado através dos caracteres da string original e 
 * do vetorMagico.
 */
char * ep1Passo2XOR(char * saidaPassoUm, unsigned int * vetorMagico);

/*!
 * \brief Função que recebe uma string que deve ter tamanho múltiplo de 16.
 * Recebe um vetorMagico a ser utilizado para criptografar a string e gera
 * um hash de 48 caracteres ASCII.
 * \param saidaPassoDois: Uma string com tamanho múltiplo de 16, formada
 * apenas por caracteres ASCII.
 * \param vetorMagico: Um vetor formado pela permutação dos inteiros de 
 * 0 a 255, sem repetição.
 * \param tamanho: Parâmetro correspondente ao tamanho da string saidaPassoDois,
 * que não pode ser calculado em C utilizando strlen() pois a string pode conter 
 * caracteres nulos antes do seu fim. É recomendado que seja calculado
 * a partir de strlen(saidaPassoUm) + 16, pois a saidaPassoUm nao conterá 
 * caracteres nulos antes do final da string. Deve ser múltiplo de 16.
 * \return Retorna NULL se o vetorMagico ou o tamanho não estiverem
 * no formato correto. Se estiver tudo certo, retorna uma string de tamanho
 * 48, formada por um hash gerado a partir da saidaPassoDois e do vetorMagico.
 */
unsigned char * ep1Passo3Comprime(char* saidaPassoDois, unsigned int *vetorMagico, int tamanho);

/*!
 * \brief Função que recebe uma string de 48 caracteres ASCII e remove os últimos
 * 32 caracteres. 
 * \param saidaPassoTres: Uma string com tamanho 48, formada
 * apenas por caracteres ASCII.
 * \return Retorna NULL se saidaPassoTres for NULL. Caso contrário, retorna uma string de
 * tamanho 16, formada pelos primeiros 16 caracteres de saidaPassoTres.
 */
unsigned char * ep1Passo4Hash(unsigned char * saidaPassoTres);

/*!
 * \brief Função que recebe uma string de 16 caracteres ASCII e converte
 * cada caractere em dois, correspondentes ao valor dos caracteres 
 * originais em hexadecimal. Por exemplo, o caractere 'a' tem valor 48
 * em ASCII. Esse valor em hex seria 30, ou seja o caractere 'a' é convertido
 * por está função nos caracteres '3' e '0'.
 * \param saidaPassoQuatroHash: Uma string com tamanho 16, formada
 * apenas por caracteres ASCII.
 * \return Retorna NULL se saidaPassoQuatroHash for NULL. Caso contrário, retorna uma string de
 * tamanho 32, formada pelos caracteres de saidaPassoQuatroHash convertidos
 * em seus valores hexadecimais.
 */
unsigned char *ep1Passo4HashEmHexa(unsigned char *saidaPassoQuatroHash);

/*!
 * \brief Função que recebe um inteiro e utiliza ele como semente para 
 * gerar um vetor pseudo-aleatório formado por uma permutação dos inteiros de 
 * 0 a 255 sem repetição.
 * \param semente: Um inteiro. Sementes iguais garantem vetores mágicos iguais.
 * \return Retorna um vetorMagico de tamanho 256 que contém todos os inteiros de 0 a 255.
 */
unsigned int * ep3CriaVetorMagico(int semente);

#endif // _HASHLIZA_H_
