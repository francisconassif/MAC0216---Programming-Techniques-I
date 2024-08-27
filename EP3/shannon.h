#ifndef _SHANNON_H_
#define _SHANNON_H_

/*!
 * \brief Função que calcula a entropia de Shannon de uma string de
 * acordo com o apresentado no video https://youtu.be/maJ0oG-JzGw
 * Basicamente, a função lê uma string, calcula a frequência de 
 * cada caractere e faz um somatório do produto da frequência de cada 
 * caractere com seu logaritimo na base dada como parâmetro da função.
 * Como as frequências são valores entre zero e um, o logaritmo será 
 * negativo. Portanto, depois de fazer a soma a função troca o sinal 
 * para devolver uma entropia sempre não-negativa.
 * \param stringEntrada: Uma string de qualquer tamanho
 * \param base: A base do logaritmo a ser usada no cálculo da entropia
 * \return O valor da entropia de Shannon
 */
double ep3CalculaEntropiaShannon(char * stringEntrada, int base);

#endif // _SHANNON_H_
