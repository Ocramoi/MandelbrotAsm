; Da uma conferida geral pra ver se ta parecido, tem algumas partes que eu nao entendi


jmp main

; Variaveis globais

; Variaveis que representam os elementos da operacao, possuem o dobro de bits de uma variavel normal
; para maior precisao
multiplicand: var #2
static multiplicand + #0, #0
static multiplicand + #1, #0

multiplier: var #2
static multiplier + #0, #0
static multiplier + #1, #0

sum: var #2
static sum + #0, #0
static sum + #1, #0

; Para as variaveis abaixo: 0 = positivo, 1 = negativo
multiplicand_sign: var #1
static multiplicand_sign + #0, #0

multiplier_sign: var #1
static multiplier_sign + #0, #0

product_sign: var #1
static product_sign + #0, #0

; Variavel auxiliar para carregar o maior de uma variavel de 16 bits
aux: var #2
static aux + #0, #0
static aux + #1, #0

offset: var #1
main:

    ; Atribuindo o valor maximo de uma variavel de 16 bits para aux
    loadn r7, #65536
    store aux, r7
    
    ; Offset da operacao
    loadn r7, #64
    store offset, r7

    loadn r7, #5
    store multiplicand, r7

    loadn r7, #3
    store multiplier, r7

    call multiply
    halt

multiply:
    loadn r7, #multiplicand
    loadn r0, #0
    cmp r7, r0
    jeg skip_multiplicand_comp

    setc ; talvez tenha que setar o carry duas vezes
    ; Nao sei se eh assim para aderecar uma variavel desse tipo
    loadn r7, #aux + #1
    loadn r6, #multiplicand + #1
    subc r5, r7, r6 
    store multiplicand + #1, r5

    loadn r7, #aux + #0
    loadn r6, #multiplicand + #0
    subc r5, r7, r6 
    store multiplicand + #0, r5

    loadn r7, #1
    store multiplicand_sign, r7

skip_multiplicand_comp:
    loadn r7, #multiplier 
    loadn r6, #0
    cmp r7, r6
    jeg loop

    setc
    ; Low byte
    loadn r7, #aux + #1
    loadn r6, #multiplier + #1
    subc r5, r7, r6 
    store multiplier + #1, r5

    ; High byte
    loadn r7, #aux + #0
    loadn r6, #multiplier + #0
    subc r5, r7, r6 
    store multiplier + #0, r5

    loadn r7, #1
    store multiplier_sign, r7

loop:
    loadn r7, #sum + #1    
    ; Nao entendi a diferenca entre os shifts 0 e 1
    ; eu imagino que o n seja o numero de bits a ser shiftados
    shiftl0 r7, 1
    store sum + #1, r7

    loadn r7, #sum + #0    
    rotl r7, 1
    store sum + #0, r7

    loadn r7, #multiplier + #1    
    rotl r7, 1
    store multiplier + #1, r7

    loadn r7, #multiplier + #0
    rotl r7, 1
    store multiplier + #0, r7

    jnc skip_add
    
    clearc
    loadn r7, #sum + #1
    loadn r6, #multiplicand + #1
    add r5, r7, r6
    store sum + #1, r5
    loadn r7, #sum + #0
    loadn r6, #multiplicand + #0
    add r5, r7, r6
    store sum + #0, r5

skip_add:
    ; a linha original faz isso
    ; dex
    ; bne loop
    ; n entendi muito bem

    ; Dividir pelo offset
    loadn r7, #sum + #0    
    shiftl0 r7, 1
    store sum + #0, r7

    loadn r7, #sum + #1 
    rotl r7, 1
    store sum + #1, r7

    loadn r7, #sum + #0    
    shiftl0 r7, 1
    store sum + #0, r7

    loadn r7, #sum + #1 
    rotl r7, 1
    store sum + #1, r7

    loadn r7, #sum + #0    
    shiftl0 r7, 1
    store sum + #0, r7

    loadn r7, #sum + #1 
    rotl r7, 1
    store sum + #1, r7

    loadn r7, #sum + #0    
    shiftl0 r7, 1
    store sum + #0, r7

    loadn r7, #sum + #1 
    rotl r7, 1
    store sum + #1, r7

    loadn r7, #sum + #0    
    shiftl0 r7, 1
    store sum + #0, r7

    loadn r7, #sum + #1 
    rotl r7, 1
    store sum + #1, r7

    loadn r7, #sum + #0    
    shiftl0 r7, 1
    store sum + #0, r7

    loadn r7, #sum + #1 
    rotl r7, 1
    store sum + #1, r7

    loadn r7, #multiplicand_sign
    loadn r6, #multiplier_sign
    xor r5, r7, r6
    loadn r4, #1
    cmp r5, r4
    jne skip_product_complement

    setc ; talvez tenha que setar o carry duas vezes
    loadn r7, #aux + #1
    loadn r6, #sum + #1
    subc r5, r7, r6 
    store sum + #1, r5

    loadn r7, #aux + #0
    loadn r6, #sum + #0
    subc r5, r7, r6 
    store sum + #0, r5

skip_product_complement:
    rts



