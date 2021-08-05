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

; Salvar como variaveis globais os valores de x de y para usar nas iteracoes
posx: var #1
posy: var #1

main:

    ; Setando o offset que sera usado para fazer as operacoes
    loadn r7, #256
    store offset, r7
    loadn r7, #1024
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
    loadn r1, #0
    loadn r2, #0
    loadn r4, #0
    loadn r5, #0

    ; Dois loops enlacados que ciclam por todos os "pixels" da tela
    y_loop:
    ;;     push r1
    ;;     push r2
    ;;     push r3

    ;;     loadn r1, #80
    ;; mov r2, r5
    ;; loadn r3, #'0'
    ;; add r2, r2, r3
    ;; outchar r2, r1

    ;;     pop r3
    ;;     pop r2
    ;;     pop r1

        ;load r2, posy
        store posy, r2

    ;; halt

        ; im0 = y * offset
        ; a multiplicacao vem antes pra nao usar o valor de y++
        load r7, offset
        mov r6, r2
        mul r5, r6, r7

        loadn r7, #39
        cmp r2, r7
        jgr y_loop_end
        inc r2      ; Y++

        
    x_loop:
        store posx, r1

        ; real0 = x * offset
        ; a multiplicacao vem antes pra nao usar o valor de x++
        load r7, offset
        mov r6, r1
        mul r4, r6, r7

        loadn r7, #29
        cmp r1, r7
        jgr x_loop_end
        inc r1      ; X++

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
        push r0
        push r1
        push r2
        push r3
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
        mul r2, r0, r0
        load r7, offset
        div r2, r2, r7

        ;im2 = (im * im) / offset
        mul r3, r1, r1
        load r7, offset
        div r3, r3, r7

        ; Se r_squared + i_squared) > (4 * offset), mf = 0, jmp escape
        push r6         ; para usar o registrador r6 sem perder a referencia ao contador
        add r7, r2, r3
        load r6, mOffset
        cmp r7, r6
        jgr setting_mf

        ; im_part = (2 * real_part * im_part)/offset + im0
        mul r7, r0, r1
        loadn r6, #2
        mul r7, r7, r6
        load r6, offset
        div r7, r7, r6
        add r7, r7, r5
        mov r1, r7

        ; real_part = r_squared - i_squared + real0
        sub r7, r2, r3
        add r7, r7, r4
        mov r0, r7
        pop r6      ; trazendo o contador de volta pro registrador e incrementando
        inc r6
        jmp iterations_loop
        
    escape:
    ;;     push r1
    ;;     push r2
    ;;     push r3
    ;;     push r4

    ;;     load r1, posx
    ;;     load r2, posy
    ;;     loadn r3, #120
    ;;     loadn r4, #40
    ;;     halt
    ;;     mul r2, r2, r4
    ;;     add r2, r1, r2
    ;;     outchar r3, r2

        ;; pop r4
        ;; pop r3
        ;; pop r2
        ;; pop r1

        ; TODO: colocar aqui o plot dos dos pontos de acordo com o charmap
        ; usar o posx e posy

        loadn r0, mf
        jnz is_mandelbrot 
        ;nao imprime o ponto
        jmp ending_mandelbrot_iterations
        is_mandelbrot:
        ; imprime o ponto usando posx e posy
        jmp ending_mandelbrot_iterations

    ; Mandelbrot flag == 0
    setting_mf:
        loadn r7, #0
        store mf, r7
        jmp escape
        
    ending_mandelbrot_iterations:
        pop r3
        pop r2
        pop r1
        pop r0
        
        ;inc r1          ; x++
        loadn r6, #0    ; reinicia o contador k, setando ele para 0, para futuras iteracoes
        jmp x_loop

    x_loop_end:
        ; Seta o valor para 0, no caso de ser usado em outro loop ou nao
        loadn r1, #0 
        ;inc r2          ; y++
        jmp y_loop

    y_loop_end:
        ;; push r1
        ;; push r2
        ;; push r3
        ;; push r4

    ;;     loadn r1, #80
    ;; load r2, posy
    ;; loadn r3, #'0'
    ;; add r2, r2, r3
        ;; outchar r2, r1

        ;; pop r4
        ;; pop r3
        ;; pop r2
        ;; pop r1
    
mandelbrot_sai:
    halt
