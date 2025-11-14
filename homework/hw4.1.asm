; factorial.asm - NASM x86_64 Linux
; iterative factorial, prints input and result (64-bit part)

section .data
    N           dq 10                    ; вхідне число (qword)
    MSG_IN      db 'Vhidne chyslo (N): '
    LEN_IN      equ $ - MSG_IN
    MSG_OUT     db 'Factorial (N!): '
    LEN_OUT     equ $ - MSG_OUT
    NEWLINE     db 0x0A

section .bss
    NUM_BUFFER  resb 21                  ; буфер для ASCII цифр

section .text
    global _start

_start:
    ; - print prompt
    mov     rax, 1                       ; sys_write
    mov     rdi, 1                       ; stdout
    lea     rsi, [rel MSG_IN]
    mov     rdx, LEN_IN
    syscall

    ; - load N and print it
    mov     rax, [rel N]                 ; rax = N
    call    print_uint64
    call    print_newline

    ; - compute factorial (iterative)
    mov     rax, [rel N]                 ; rax = N
    call    factorial_iter               ; returns result in rax (low 64-bit)

    ; - print label
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel MSG_OUT]
    mov     rdx, LEN_OUT
    syscall

    ; - print result (contents of rax)
    call    print_uint64
    call    print_newline

    ; exit(0)
    mov     rax, 60
    xor     rdi, rdi
    syscall

; -------------------------
; factorial_iter:
; input: rax = N
; output: rax = factorial (low 64-bit)
; Note: this routine ignores overflow beyond 64 bits
; -------------------------
factorial_iter:
    push    rbx
    push    rcx

    mov     rcx, rax      ; rcx = N
    mov     rax, 1
    xor     rdx, rdx

    cmp     rcx, 1
    jle     .fi_done

    mov     rbx, 2

.fi_loop:
    mul     rbx           ; rdx:rax = rax * rbx
    inc     rbx
    cmp     rbx, rcx
    jle     .fi_loop

.fi_done:
    pop     rcx
    pop     rbx
    ret

; -------------------------
; print_uint64:
; prints unsigned integer in RAX (decimal)
; uses NUM_BUFFER (21 bytes)
; preserves registers RAX, RCX, RDX, RSI
; -------------------------
print_uint64:
    push    rax
    push    rcx
    push    rdx
    push    rsi

    mov     rcx, 10
    lea     rsi, [rel NUM_BUFFER + 20]   ; rsi points to last byte in buffer

    cmp     rax, 0
    jne     .conv_loop

    ; if zero, put '0'
    dec     rsi
    mov     byte [rsi], '0'
    jmp     .pprint

.conv_loop:
    xor     rdx, rdx
    div     rcx               ; rax = rax / 10, rdx = rax % 10
    add     dl, '0'
    dec     rsi
    mov     [rsi], dl
    test    rax, rax
    jnz     .conv_loop

.pprint:
    ; compute length = (NUM_BUFFER+20) - rsi
    lea     rdx, [rel NUM_BUFFER + 20]
    sub     rdx, rsi

    ; write(rsi, rdx)
    mov     rax, 1
    mov     rdi, 1
    ; rsi already points to buffer start
    syscall

    pop     rsi
    pop     rdx
    pop     rcx
    pop     rax
    ret

; -------------------------
; print_newline: prints '\n'
; -------------------------
print_newline:
    push    rax
    push    rdi
    push    rsi
    push    rdx

    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel NEWLINE]
    mov     rdx, 1
    syscall

    pop     rdx
    pop     rsi
    pop     rdi
    pop     rax
    ret
