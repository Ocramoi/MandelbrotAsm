; Mandelbrot set

; Vitor Caetano Brustolin - 11795589
; Marco Antonio Ribeiro de Toledo

jmp main

; Variaveis globais que sao uteis para as operacoes aritimeticas
im0: var #1
real0: var #1
offset: var #1
mOffset: var #1
n_iterations: var #1
mf: var #1
im_start: var #1
static im_start, #0
im_end: var #1
static im_end, #1
real_start: var #1
static real_start, #0
real_end: var #1
static real_end, #2

; Salvar como variaveis globais os valores de x de y para usar nas iteracoes
posx: var #1
posy: var #1

main:

    ; Setando o offset que sera usado para fazer as operacoes
    loadn r7, #256
    store offset, r7
    loadn r7, #2
    store mOffset, r7

    call mandelbrot_main
    halt

;   r1 = valor da variavel x, dado pelo valor do contador em cada iteracao da linha 
;   r2 = valor da variavel y, incrementado a cada iteracao da linha 
;   r3 = mandelbrot flag, indica se um "pixel" da tela sera pintado ou nao 
;   r4 = valor inicial do num real, usado nas iteracoes porem calculado nos loops de fora 
;   r5 = valor inicial do num imaginario, mesma coisa do num real 
mandelbrot_main:
    ; Setando a posicao inicial assim como os valores iniciais como 0
    loadn r0, #0
    loadn r1, #0
    loadn r2, #0
    loadn r4, #0
    loadn r5, #0
    store posx, r0
    store posy, r0
    

    ; Dois loops enlacados que ciclam por todos os "pixels" da tela
    y_loop:
        ;load r2, posy
        ;store posy, r2
        load r2, posy

    ;; halt

        ; im0 = y * offset
        ; a multiplicacao vem antes pra nao usar o valor de y++
        load r7, offset
        mov r6, r2
        mul r5, r6, r7

        loadn r7, #29
        cmp r2, r7
        jgr y_loop_end
        ;inc r2      ; Y++

        
    x_loop:
        ;store posx, r1
        load r1, posx

        ; real0 = x * offset
        ; a multiplicacao vem antes pra nao usar o valor de x++
        load r7, offset
        mov r6, r1
        mul r4, r6, r7

        loadn r7, #39
        cmp r1, r7
        jgr x_loop_end
        ;inc r1      ; X++

        ; mandelbrot_flag = 1
        loadn r3, #1
        store mf, r3

    ;   r0 = parte real das contas 
    ;   r1 = parte imaginaria das contas
    ;   r2 = valor da parte real do numero ao quadrado 
    ;   r3 = valor da parte imaginaria do numero ao quadrado
    ;   Os registradores r4 e r5 permanecem os mesmos
    ;   r6 = counter do loop de iteracoes
    setting_iteration_variables:
        ;; push r0
        ;; push r1
        ;; push r2
        ;; push r3
        loadn r0, #0
        loadn r1, #0
        loadn r2, #0
        loadn r3, #0
        loadn r6, #0
        
        ; Setando o maximo de iteracoes
        loadn r7, #250
        store n_iterations, r7

    ; Loop principal que faz as iteracoes
    iterations_loop:
        load r7, n_iterations
        cmp r6, r7
        jgr escape

        ;r2 = (r * r) / offset
        load r7, offset

        load r2, posx

        push r1

    mul r2, r2, r7

        loadn r1, #40
        div r2, r2, r1

        load r1, real_end
        mul r2, r2, r1

        pop r1

        ;im2 = (im * im) / offset
        load r7, offset

        load r3, posy

        push r1

        mul r3, r3, r7

        loadn r1, #30
        div r3, r3, r1

        load r1, im_end
        mul r3, r3, r1
    ;; breakp

        pop r1

        load r7, offset
        div r2, r2, r7
        div r3, r3, r7

    push r4
    loadn r4, #2
        pow r2, r2, r4
    pow r3, r3, r4
        pop r4

        ; Se r_squared + i_squared) > (4 * offset), mf = 0, jmp escape
        add r7, r2, r3
    breakp
        load r0, mOffset
        cmp r7, r0
        ;; halt
        jgr setting_mf

        ; im_part = (2 * real_part * im_part)/offset + im0
        ;; mul r7, r0, r1
        ;; loadn r6, #2
        ;; mul r7, r7, r6
        ;; load r6, offset
        ;; div r7, r7, r6
        ;; add r7, r7, r5
        ;; mov r1, r7

        ; real_part = r_squared - i_squared + real0
        ;; sub r7, r2, r3
        ;; add r7, r7, r4
        ;; mov r0, r7
        ;; pop r6      ; trazendo o contador de volta pro registrador e incrementando
        inc r6
        jmp iterations_loop
        
    escape:
            load r1, posx
            load r2, posy
            ;; breakp

            loadn r3, #40
            cmp r6, r3
            jle grad1

            loadn r3, #80
            cmp r6, r3
            jle grad2

            loadn r3, #120
            cmp r6, r3
            jle grad3

            loadn r3, #160
            cmp r6, r3
            jle grad4

            loadn r3, #200
            cmp r6, r3
            jle grad5

            jmp grad6

            grad1:
                loadn r3, #'a'
                jmp printa
            grad2:
                loadn r3, #'b'
                jmp printa
            grad3:
                loadn r3, #'c'
                jmp printa
            grad4:
                loadn r3, #'d'
                jmp printa
            grad5:
                loadn r3, #'e'
                jmp printa
            grad6:
                loadn r3, #'f'

            printa:
                loadn r4, #40
                mul r2, r2, r4
                add r2, r1, r2
                outchar r3, r2

        ; imprime o ponto usando posx e posy
        jmp ending_mandelbrot_iterations

    ; Mandelbrot flag == 0
    setting_mf:
        ;; pop r6
        ;; loadn r7, #0
        ;; store mf, r7
    breakp
        jmp escape
        
    ending_mandelbrot_iterations:
        ;; pop r3
        ;; pop r2
        ;; pop r1
        ;; pop r0
        
        ;inc r1          ; x++
        load r7, posx
        inc r7          ; x++
        store posx, r7
        loadn r6, #0    ; reinicia o contador k, setando ele para 0, para futuras iteracoes
        jmp x_loop

    x_loop_end:
        ; Seta o valor para 0, no caso de ser usado em outro loop ou nao
        loadn r7, #0
        store posx, r7
        load r7, posy
        inc r7          ; y++
        store posy, r7
        ;loadn r1, #0 
        ;; inc r2                  y++ ;
        jmp y_loop

    y_loop_end:

mandelbrot_sai:
    halt
