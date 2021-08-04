; Mandelbrot set

; Vitor Caetano Brustolin - 11795589
; Marco Antonio Ribeiro de Toledo

; da uma checada ai no codigo to morrendo de sono deve ter coisa errada principalmente
; na parte de mexer com os registradores, qualquer coisa me pergunta
jmp main

im0: var #1
real0: var #1
offset: var #1
4xoffset: var #1
n_iterations: var #1
mf: var #1


main:

    ; Setando o offset que sera usado para fazer as operacoes
    loadn r7, #64
    store offset, r7
    loadn r7, #256
    store 4xoffset, r7

    call mandelbrot_main
    halt

;   r0 = screen counter, contador do loop que passa por todos os pontos da tela     <<<<<==== ignora
;   r1 = valor da variavel x, dado pelo valor do contador em cada iteracao da linha 
;   r2 = valor da variavel y, incrementado a cada iteracao da linha 
;   r3 = mandelbrot flag, indica se um "pixel" da tela sera pintado ou nao 
;   r4 = valor inicial do num real, usado nas iteracoes porem calculado nos loops de fora 
;   r5 = valor inicial do num imaginario, mesma coisa do num real 
mandelbrot_main:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    
    ; Setando a posicao inicial assim como os valores iniciais como 0
    loadn r0, #0
    loadn r1, #0
    loadn r2, #0

    y_loop:
        loadn r7, #30
        cmp r5, r7
        jeq y_loop_end
        loadn r7, offset
        loadi r6, r2
        mult r5, r6, r7 
    x_loop:
        loadn r7, #40
        cmp r4, r7
        jeq x_loop_end
        loadn r7, offset
        loadi r6, r1
        mult r5, r6, r7 
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

    iterations_loop:
        ;r2 = (r * r) / offset
        mult r2, r0, r0
        loadn r7, #offset
        div r2, r2, r7

        ;im2 = (im * im) / offset
        mult r3, r1, r1
        loadn r7, #offset
        div r3, r3, r7

        ; Se r_squared + i_squared) > (4 * offset), mf = 0, jmp escape
        push r6     ; para usar o registrador r6 sem perder a referencia ao contador
        add r7, r2, r3
        loadn r6, #4xoffset
        cmp r7, r6
        jgr escape

        ; im_part = (2 * real_part * im_part)/offset + im0
        mult r7, r0, r1
        loadn r6, #2
        mult r7, r7, r6 
        loadn r6, #offset
        div r7, r7, r6
        add r7, r7, r5
        loadi r1, r7

        ; real_part = r_squared - i_squared + real0
        sub r7, r2, r3
        add r7, r7, r4
        loadi r0, r7
        pop r6      ; trazendo o contador de volta pro registrador e incrementando
        inc r6
        jmp iterations_loop
        
    escape:
        ; TODO: colocar aqui o plot dos dos pontos de acordo com o charmap
        
    ending_mandelbrot_iterations:
        pop r3
        pop r2
        pop r1
        pop r0
        
        inc r1      ; x++
        jmp x_loop

    x_loop_end:
        ; Seta o valor para 0, no caso de ser usado em outro loop ou nao
        loadn r1, #0 
        inc r2      ; y++
        jmp y_loop

    y_loop_end:
    
mandelbrot__sai:
        pop r5
        pop r4
        pop r3
        pop r2
        pop r1
        pop r0
        rts
