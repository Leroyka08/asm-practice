section .data
    msg_num     db "Number: ", 0
    msg_prime   db " -> is prime", 10, 0
    msg_notprime db " -> not prime", 10, 0

section .bss
    buffer resb 20

section .text
    global _start

_start:
    mov rax, 17        
    mov rbx, rax       

    mov rsi, msg_num
    call print_string

    mov rax, rbx
    call print_number

   
    mov rax, rbx
    call is_prime

    mov rax, 60        
    xor rdi, rdi
    syscall


print_string:
    mov rdx, 0
.find_len:
    cmp byte [rsi+rdx], 0
    je .len_found
    inc rdx
    jmp .find_len
.len_found:
    mov rax, 1
    mov rdi, 1
    syscall
    ret


print_number:
    mov rbx, 10
    mov rcx, buffer+19
    mov byte [rcx], 0

.convert_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rcx
    mov [rcx], dl
    test rax, rax
    jnz .convert_loop

    mov rsi, rcx
    call print_string
    ret


is_prime:
    cmp rax, 2
    jl .not_prime
    je .prime

    mov rcx, 2

.next_div:
    mov rdx, 0
    mov rbx, rcx
    mov rax, rbx
    mov rax, rbx
    mov rdi, rax
    mov rax, rbx
    mov rdx, 0
    mov rax, rbx
    mov rdx, 0
    mov rax, rbx
    mov rdx, 0
    mov rax, rbx
    mov rdx, 0
    mov rax, rbx
    mov rdx, 0
    mov rax, rbx
    mov rdx, 0
    mov rax, rbx
    
    mov rax, rbx
    mov rdx, 0
    div rcx
    cmp rdx, 0
    je .not_prime
    inc rcx
    mov rax, rbx
    cmp rcx, rbx
    jl .next_div

.prime:
    mov rsi, msg_prime
    call print_string
    ret

.not_prime:
    mov rsi, msg_notprime
    call print_string
    ret
