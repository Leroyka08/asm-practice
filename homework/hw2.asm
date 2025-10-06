section .data
    buffer db 32 dup(0)
    newline db 0Ah, 0

section .text
    global _start

int2str:
    push rax
    push rbx
    push rcx
    push rdx
    push rdi

    mov rcx, 0
    mov rbx, 10

.convert_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .convert_loop

.write_digits:
    cmp rcx, 0
    jz .done
    pop rdx
    mov [rsi], dl
    inc rsi
    dec rcx
    jmp .write_digits

.done:
    mov byte [rsi], 0

    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret


_start:
    mov rax, 1234567
    lea rsi, [buffer]
    call int2str

    ; write(1, buffer, 32)
    mov rax, 1          ; syscall write
    mov rdi, 1
    lea rsi, [buffer]
    mov rdx, 32
    syscall

    ; write newline
    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 2
    syscall

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall
