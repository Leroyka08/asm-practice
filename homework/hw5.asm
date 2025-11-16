
section .data
    N       dq 10                        
    MSG_IN  db "Vhidne chyslo (N): ", 0
    LEN_IN  equ $ - MSG_IN
    MSG_OUT db "Factorial (N!): ", 0
    LEN_OUT equ $ - MSG_OUT
    NEWLINE db 10

section .bss
    NUM_BUFFER  resb 32                  

section .text
    global _start

_start:

    mov     rax, 1          
    mov     rdi, 1          
    lea     rsi, [rel MSG_IN]
    mov     rdx, LEN_IN
    syscall


    mov     rax, [rel N]
    call    print_uint64
    call    print_newline

    mov     rax, [rel N]
    call    factorial_rec   

    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel MSG_OUT]
    mov     rdx, LEN_OUT
    syscall

    call    print_uint64
    call    print_newline

    ; --- exit ---
    mov     rax, 60
    xor     rdi, rdi
    syscall


factorial_rec:
    cmp     rax, 1
    jle     .base_case

    push    rax
    dec     rax
    call    factorial_rec
    pop     rcx
    mul     rcx
    ret

.base_case:
    mov     rax, 1
    ret

print_uint64:
    push    rax
    push    rcx
    push    rdx
    push    rsi

    mov     rcx, 10
    lea     rsi, [rel NUM_BUFFER + 31]   ; кінцевий байт буфера

    cmp     rax, 0
    jne     .convert_loop

    dec     rsi
    mov     byte [rsi], '0'
    jmp     .print

.convert_loop:
    xor     rdx, rdx
    div     rcx              ; rax = rax / 10, rdx = rax % 10
    add     dl, '0'
    dec     rsi
    mov     [rsi], dl
    test    rax, rax
    jnz     .convert_loop

.print:
    lea     rdx, [rel NUM_BUFFER + 31]
    sub     rdx, rsi        ; довжина рядка

    mov     rax, 1          ; sys_write
    mov     rdi, 1          ; stdout
    ; rsi уже містить адресу початку рядка
    syscall

    pop     rsi
    pop     rdx
    pop     rcx
    pop     rax
    ret

print_newline:
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel NEWLINE]
    mov     rdx, 1
    syscall
    ret
