"""
MAC0216 - Tecnicas de programacao I

Professor: Daniel Macedo Batista

Instituto de Matematica e Estatistica da Universidade de Sao Paulo

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Exercicio-Programa #01

Autor: Francisco Nassif Membrive

Descricao do programa: Recebe uma string de 1 a 100000 caracteres ASCII e imprime
um hash hexadecimal de tamanho fixo (16 bytes).


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

"""


def passoum(entrada):
    """
    recebe uma string como entrada e transforma ela em um vetor de codigos ascii de seus caracteres
    alem disso, completa o vetor com a quantidade minima necessaria para que o vetor resultante
    possua um tamanho multiplo de 16
    """
    caracteres = list(entrada)
    for i in range(len(caracteres)):
        caracteres[i] = ord(caracteres[i])
    incremento = 16 - len(caracteres)%16
    if incremento != 16:
        for i in range(incremento):
            caracteres.append(incremento)
    return caracteres

# print(passoum("Ola mundo!")) #depuracao


def passodois(entrada):
    """
    Recebe uma string como entrada, utiliza a funcao do passo 1 para transforma-la no vetor com o codigo ascii dos caracteres
    e depois usa o vetor magico para criptografar o vetor gerado no passo 1
    """
    saidaPassoUm = passoum(entrada)
    #para o passo dois, é necessário um vetormagico:
    vetorMagico = [122, 77, 153, 59, 173, 107, 19, 104, 123, 183, 75, 10, 114, 236, 106, 83, 117, 16, 189, 211, 51, 231, 143, 118, 248, 148, 218, 245, 24, 61, 66, 73, 205, 185, 134, 215, 35, 213, 41, 0, 174, 240, 177, 195, 193, 39, 50, 138, 161, 151, 89, 38, 176, 45, 42, 27, 159, 225, 36, 64, 133, 168, 22, 247, 52, 216, 142, 100, 207, 234, 125, 229, 175, 79, 220, 156, 91, 110, 30, 147, 95, 191, 96, 78, 34, 251, 255, 181, 33, 221, 139, 119, 197, 63, 40, 121, 204, 4, 246, 109, 88, 146, 102, 235, 223, 214, 92, 224, 242, 170, 243, 154, 101, 239, 190, 15, 249, 203, 162, 164, 199, 113, 179, 8, 90, 141, 62, 171, 232, 163, 26, 67, 167, 222, 86, 87, 71, 11, 226, 165, 209, 144, 94, 20, 219, 53, 49, 21, 160, 115, 145, 17, 187, 244, 13, 29, 25, 57, 217, 194, 74, 200, 23, 182, 238, 128, 103, 140, 56, 252, 12, 135, 178, 152, 84, 111, 126, 47, 132, 99, 105, 237, 186, 37, 130, 72, 210, 157, 184, 3, 1, 44, 69, 172, 65, 7, 198, 206, 212, 166, 98, 192, 28, 5, 155, 136, 241, 208, 131, 124, 80, 116, 127, 202, 201, 58, 149, 108, 97, 60, 48, 14, 93, 81, 158, 137, 2, 227, 253, 68, 43, 120, 228, 169, 112, 54, 250, 129, 46, 188, 196, 85, 150, 6, 254, 180, 233, 230, 31, 76, 55, 18, 9, 32, 82, 70]
    novoBloco = []
    for i in range(16):
        novoBloco.append(0)
    novoValor = 0
    n = len(saidaPassoUm)//16
    for i in range(n):
        for j in range(16):
            novoValor = vetorMagico[saidaPassoUm[16*i+j]^novoValor]^novoBloco[j]
            novoBloco[j] = novoValor
    saidaPassoDois = saidaPassoUm + novoBloco
    return saidaPassoDois

# depuracao
# print(passodois("Ola mundo!"))

def passotres(entrada):
    """
    utiliza o vetor resultante do passodois e novamente o vetor magico para produzir um vetor
    de tamanho unico = 48 que corresponde a uma criptografia da string de entrada
    """
    vetorMagico = [122, 77, 153, 59, 173, 107, 19, 104, 123, 183, 75, 10, 114, 236, 106, 83, 117, 16, 189, 211, 51, 231, 143, 118, 248, 148, 218, 245, 24, 61, 66, 73, 205, 185, 134, 215, 35, 213, 41, 0, 174, 240, 177, 195, 193, 39, 50, 138, 161, 151, 89, 38, 176, 45, 42, 27, 159, 225, 36, 64, 133, 168, 22, 247, 52, 216, 142, 100, 207, 234, 125, 229, 175, 79, 220, 156, 91, 110, 30, 147, 95, 191, 96, 78, 34, 251, 255, 181, 33, 221, 139, 119, 197, 63, 40, 121, 204, 4, 246, 109, 88, 146, 102, 235, 223, 214, 92, 224, 242, 170, 243, 154, 101, 239, 190, 15, 249, 203, 162, 164, 199, 113, 179, 8, 90, 141, 62, 171, 232, 163, 26, 67, 167, 222, 86, 87, 71, 11, 226, 165, 209, 144, 94, 20, 219, 53, 49, 21, 160, 115, 145, 17, 187, 244, 13, 29, 25, 57, 217, 194, 74, 200, 23, 182, 238, 128, 103, 140, 56, 252, 12, 135, 178, 152, 84, 111, 126, 47, 132, 99, 105, 237, 186, 37, 130, 72, 210, 157, 184, 3, 1, 44, 69, 172, 65, 7, 198, 206, 212, 166, 98, 192, 28, 5, 155, 136, 241, 208, 131, 124, 80, 116, 127, 202, 201, 58, 149, 108, 97, 60, 48, 14, 93, 81, 158, 137, 2, 227, 253, 68, 43, 120, 228, 169, 112, 54, 250, 129, 46, 188, 196, 85, 150, 6, 254, 180, 233, 230, 31, 76, 55, 18, 9, 32, 82, 70]
    saidaPassoDois = passodois(entrada)
    saidaPassoTres = [0]*48
    tamanho_2 = len(saidaPassoDois)//16
    n = tamanho_2 - 1
    for i in range(tamanho_2):
        for j in range(16):
            saidaPassoTres[j+16] = saidaPassoDois[16*i + j]
            saidaPassoTres[32 + j] = ((saidaPassoTres[16+j]) ^ (saidaPassoTres[j]))
        temp = 0
        for j in range(18):
            for k in range(48):
                temp = ((saidaPassoTres[k]) ^ (vetorMagico[temp]))
                saidaPassoTres[k] = temp
            temp = (temp+j)%256
    return saidaPassoTres

def main():
    """
    recebe na entrada padrao uma string, que passa pelo processo do passo 3
    do vetor obtido, as primeiras 16 posicoes sao convertidas em seus valores em hex
    e concatenadas para obter o hash final, que e impresso na saida padrao
    """
    entrada = input()
    saidaPassoTres = passotres(entrada)
    hash = ""
    for i in range(16):
        byte = str(hex(saidaPassoTres[i]))
        if len(byte[2:])<2:
          hash += '0'
        hash += byte[2:]
    print(hash)

main()
