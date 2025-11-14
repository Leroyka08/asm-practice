section .data
    N           dq 10

    MSG_IN      db "Vhidne chyslo (N): ", 0
    MSG_OUT     db "Factorial (N!):   ", 0
    NEWLINE     db 10

section .bss
    NUM_BUFFER  resb 32

section .text
    global _start

_start:

    ; print "Vhidne chyslo (N): "
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, MSG_IN
    mov     rdx, 19
    syscall

    mov     rax, [N]
    call    print_uint64
    call    print_newline


    mov     rax, [N]
    call    factorial_rec

    push    rax

    ; print "Factorial (N!): "
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, MSG_OUT
    mov     rdx, 19
    syscall

    pop     rax
    call    print_uint64
    call    print_newline

    ; exit
    mov     rax, 60
    xor     rdi, rdi
    syscall


; ---------------------------------------------------------
; recursive factorial
; IN:  rax = n
; OUT: rax = n!
; ---------------------------------------------------------
factorial_rec:
    cmp     rax, 1
    jle     .base

    push    rax
    dec     rax
    call    factorial_rec

    pop     rbx
    mul     rbx
    ret

.base:
    mov     rax, 1
    ret


; ---------------------------------------------------------
; print_uint64 (rax)
; ---------------------------------------------------------
print_uint64:
    push    rax
    push    rbx
    push    rcx
    push    rdx
    push    rsi

    mov     rcx, 10
    mov     rsi, NUM_BUFFER + 31

    cmp     rax, 0
    jne     .loop

    dec     rsi
    mov     byte [rsi], '0'
    jmp     .print

.loop:
    xor     rdx, rdx
    div     rcx
    add     dl, '0'
    dec     rsi
    mov     [rsi], dl
    test    rax, rax
    jnz     .loop

.print:
    mov     rdx, NUM_BUFFER + 31
    sub     rdx, rsi

    mov     rax, 1
    mov     rdi, 1
    syscall

    pop     rsi
    pop     rdx
    pop     rcx
    pop     rbx
    pop     rax
    ret


print_newline:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, NEWLINE
    mov     rdx, 1
    syscall
    ret
