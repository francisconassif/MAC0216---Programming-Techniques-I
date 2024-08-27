;MAC0216 - Tecnicas de programacao I

;Professor: Daniel Macedo Batista

;Instituto de Matematica e Estatistica da Universidade de Sao Paulo

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;Exercicio-Programa #01

;Autor: Francisco Nassif Membrive

;Descricao do programa: Recebe uma string de 1 a 100000 caracteres ASCII e imprime
;um hash hexadecimal de tamanho fixo (16 bytes).


;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


section .text

mul16:  ;multiplica r14 por 16
        xor r15, r15;
        mov r15, 4;
lacom:  
        add r14, r14;
        dec r15;
        jnz lacom;
        ret;




    global _start

    _start:

        ;o primeiro passo e ler a entrada atraves de uma syscall read

        mov rax, 0      ; codigo da syscall read
        mov rdi, 0      ; int fd - stdin
        mov rsi, string ; void *buf
        mov rdx, 100002 ; count
        syscall         ; chama a syscall read

        dec rax         ; tira o caractere vazio do tamanho
        mov qword [tamanho], rax
                        ; salva o numero de bytes lido na variavel tamanho


        ;agora precisamos dividir o numero de bytes lidos por 16 para encontrar n:

        mov dword ecx, 16
        xor rdx, rdx    ; zera rdx
        mov rdx, rax
        shr rdx, 32 
        div ecx

        mov [n], eax    ; move o quociente da divisao para a variavel n
        mov [resto], dl ; move o resto para a variavel resto


        mov byte [incremento], 16
        cmp edx, 0      ; compara o resto com zero 
                        ; para evitar que a string que ja tem 
                        ; um tamanho multiplo de 16 seja completada
        je noinc

        inc dword [n]   ; o tamanho de n vai ser completado para ser multiplo de 16
                        ; entao o quociente aumenta em 1
        sub [incremento], dl


        xor rsi, rsi
        mov rsi, string   ; seta rsi para a primeira posicao da string
        add rsi, [tamanho]; coloca rsi na ultima posicao

        xor rcx, rcx
        mov cl, byte [incremento]


laco1:                
        ;complementa a string para que o tamanho seja multiplo de 16
        mov dl, byte [incremento]
        mov byte [rsi], dl
        inc qword [tamanho]
        inc rsi
        dec cl
        jnz laco1


        ;nessa altura o PassoUm do programa esta concluido


noinc:  ;pula para o PassoDois
        ;caso a string ja tenha tamanho multiplo de 16


        mov byte [novoValor], 0;
        

        xor r8, r8      ; contador i

laco2:  
        xor r9, r9      ; contador j
laco3:
        ;primeiro precisamos do endereco
        ;16*i + j
        xor rax, rax
        xor rbx, rbx
        xor r14, r14
        mov r14, r8
        call mul16      ; exemplo de subrotina
                        ; r14 tem 16*i
                        ; r9 tem j
        add r14, r9     ; r14 tem 16*i+j
        add r14, string ; r14 tem o endereco de saidaPassoUm[16*i+j]
        xor rcx, rcx
        mov cl, [novoValor]
        xor cl, [r14]
        add rcx, vetorMagico

        add rax, r9     ; rcx tem o endereco de 
                        ; vetorMagico[novoValor ^ saidaPassoUm[16*i+j]]

        add rax, novoBloco
                        ; rax tem o endereco de novoBloco[j]
        mov bl, [rax]   ; bl tem novoBloco[j]

        xor bl, [rcx]   ;faz o xor externo do PassoDois
        
        mov [novoValor], bl
        mov [rax], bl

        ;fim do laco j:
        inc r9
        cmp r9b, 16
        jl laco3

        ;fim do laco externo:
        inc r8
        cmp r8d, [n]
        jl laco2

        ;ALGUNS NUMEROS ESTAO SAINDO POSITIVOS, OUTROS 
        ;COMO VALOR_CERTO - 256
        ;OU SEJA, O GDB ESTA INTERPRETANDO 
        ;COMO COMPLEMENTO DE DOIS
        ;ISSO PROVAVELMENTE NAO VAI DAR PROBLEMA
        ;SE ESTIVER TUDO CERTO ABAIXO

        xor rcx, rcx    ; contador para o laco4
                        ; que finaliza o PassoDois

laco4:  ;responsavel por concatenar saidaPassoUm
        ;e novoBloco
        ;o vetor string sera utilizado para guardar
        ;o que foi chamado no python de
        ;saidaPassoDois

        xor rax, rax
        mov rax, qword [tamanho]
        add rax, string
        add rax, rcx    ; rax tem as posicoes de string
                        ; apos o fim da entrada
        xor rbx, rbx
        mov rbx, novoBloco
        add rbx, rcx
                        ; rbx tem o endereco de
                        ; novoBloco[j]
        xor rdx, rdx    ; rdx sera uma variavel temporaria
                        ; para fazer os movs
        mov dl, byte [rbx]
        mov [rax], byte dl
        inc cl
        cmp cl, 16
        jl laco4
        ;laco4 funcionando plenamente para concatenar as 
        ;strings
        ;agora, saidaPassoDois = string

        xor rax, rax
        mov eax, [n]
        inc eax
        mov [tamanho2], eax

        ;quantidade de vezes que o contador i vai rodar


        xor r8,r8       ; sera o contador i

laco5:
        xor r9, r9      ; sera o contador j
laco6:  
        xor rax, rax
        add rax, saidaPassoTres
        add rax, 16
        add rax, r9     ; rax tem o endereco de saidaPassoTres[j+16]
        xor r14, r14
        mov r14, r8
        call mul16      ; r14 tem 16*i
        add r14, r9     ; r14 tem 16*i + j;
        add r14, string ; r14 tem o endereco de string[16*i+j]
        xor rbx, rbx
        mov bl, [r14]   ; bl tem saidaPassoDois[16*i + j]
        mov [rax], bl 
        ;saidaPassoTres[j+16] recebe saidaPassoDois[16*i + j]

        ;PROXIMA LINHA DO PYTHON NO LACO:
        xor rdx, rdx
        mov rdx, rax
        sub rdx, 16     ; agora rdx tem a posicao j e rax
                        ;tem a posicao j+16 de saidaPassoTres
        xor rbx, rbx
        mov bl, [rdx]
        xor bl, [rax]
        mov [rax+16], bl

        ;FIM DO PRIMEIRO LACO J:
        inc r9
        cmp r9b, 16
        jl laco6


        mov [temp], byte 0
        xor r9, r9      ; contador j


laco7:
        xor r10, r10    ; contador k
laco8:
        
        xor rax, rax
        mov rax, saidaPassoTres
        add rax, r10    ; rax tem o endereco de saidaPassoTres[k]

        xor rbx, rbx
        mov rbx, vetorMagico
        add rbx, [temp] ; rbx tem o endereco de vetorMagico[temp]

        xor rcx, rcx
        mov cl, [rbx]
        xor cl, [rax]
        mov [temp], cl
        mov [rax], cl

        ;FIM DO LOOP K
        inc r10
        cmp r10b, byte 48
        jl laco8


        xor rax, rax
        mov al, [temp]
        add ax, r9w
        cmp ax, word 256; como o valor em ax vai ser menor que 256*2
                        ; e possivel descobrir o resto sem dividir
        jl nada
        sub ax, word 256; subtrai 256 para encontrar o resto
nada:
        mov byte [temp], al
                        ; mantem inalterado se o valor for
                        ; menor que 256

        ;FIM DO LOOP  J      

        inc r9
        cmp r9b, byte 18
        jl laco7

        
        ;FIM DO LOOP I
        
        inc r8
        cmp r8d, [tamanho2]
        jl laco5



passo4:

        xor r8, r8      ; r8 sera o contador de bytes de saidaPassoTres
        xor r10, r10    ; sera o contador da posicao do hash
        mov r10, hash
        
traduz:
        xor rax, rax
        xor rbx, rbx
        xor r9, r9      ; r9 indicara a letra do alfabeto
        mov rbx, saidaPassoTres
        add rbx, r8
        mov al, byte [rbx]
        div byte [dezesseis]
        xor rdx, rdx    
        mov dl, al
        mov r9, alfabeto
        add r9, rdx
        mov dl, [r9]
        mov [r10], dl
        inc r10
        xor rdx, rdx
        mov dl, ah
        xor r9, r9
        mov r9, alfabeto
        add r9, rdx
        mov dl, byte [r9]
        mov [r10], dl
        inc r10
        inc r8
        cmp r8, 16
        jl traduz
        mov [r10], byte 10
        inc r10
        mov [r10], byte 0


        xor rdi, rdi
        xor rsi, rsi
        xor rax, rax
        xor rdx, rdx


print:  mov rax, 1
        mov rdi, 1
        mov rsi, hash
        mov rdx, 34
        syscall

exit:   mov rax, 60
        xor rdi, rdi
        syscall




section .data
        vetorMagico db 122, 77, 153, 59, 173, 107, 19, 104, 123, 183, 75, 10, 114, 236, 106, 83, 117, 16, 189, 211, 51, 231, 143, 118, 248, 148, 218, 245, 24, 61, 66, 73, 205, 185, 134, 215, 35, 213, 41, 0, 174, 240, 177, 195, 193, 39, 50, 138, 161, 151, 89, 38, 176, 45, 42, 27, 159, 225, 36, 64, 133, 168, 22, 247, 52, 216, 142, 100, 207, 234, 125, 229, 175, 79, 220, 156, 91, 110, 30, 147, 95, 191, 96, 78, 34, 251, 255, 181, 33, 221, 139, 119, 197, 63, 40, 121, 204, 4, 246, 109, 88, 146, 102, 235, 223, 214, 92, 224, 242, 170, 243, 154, 101, 239, 190, 15, 249, 203, 162, 164, 199, 113, 179, 8, 90, 141, 62, 171, 232, 163, 26, 67, 167, 222, 86, 87, 71, 11, 226, 165, 209, 144, 94, 20, 219, 53, 49, 21, 160, 115, 145, 17, 187, 244, 13, 29, 25, 57, 217, 194, 74, 200, 23, 182, 238, 128, 103, 140, 56, 252, 12, 135, 178, 152, 84, 111, 126, 47, 132, 99, 105, 237, 186, 37, 130, 72, 210, 157, 184, 3, 1, 44, 69, 172, 65, 7, 198, 206, 212, 166, 98, 192, 28, 5, 155, 136, 241, 208, 131, 124, 80, 116, 127, 202, 201, 58, 149, 108, 97, 60, 48, 14, 93, 81, 158, 137, 2, 227, 253, 68, 43, 120, 228, 169, 112, 54, 250, 129, 46, 188, 196, 85, 150, 6, 254, 180, 233, 230, 31, 76, 55, 18, 9, 32, 82, 70
        alfabeto db 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102
        dezesseis db 16



section .bss
        string resb 100017 ; reserva o tamanho maximo da string + novoBloco
        tamanho resq 1;
        n resd 1;
        resto resd 1;
        novoValor resb 1;
        incremento resb 1;
        novoBloco resb 16;
        saidaPassoTres resb 48;
        temp resb 1;
        hash resb 34;
        tamanho2 resd 1;
