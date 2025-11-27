global _start

section .data
arr     dq 5,3,8,1,4        
sorted  dq 0,0,0,0,0        
len     equ 5                
outbuf  times 64 db 0        
newline db 10

section .text
_start:
    
    lea rsi, [rel arr]       
    lea rdi, [rel sorted]    
    mov rcx, len
    mov rbx, 8               
    call copy_array

    
    lea rsi, [rel sorted]
    mov rcx, len
    mov rbx, 8
    call sort_array

    
    lea rsi, [rel sorted]
    mov rcx, len
print_loop:
    test rcx, rcx
    jz done
    mov rax, [rsi]           
    call print_number
    add rsi, rbx
    dec rcx
    jmp print_loop

done:
    mov rax, 60              
    xor rdi, rdi
    syscall


copy_array:
    push rcx
    push rsi
    push rdi
    mov rcx, rcx
.copy_loop:
    test rcx, rcx
    jz .copy_done
    mov rax, [rsi]           
    mov [rdi], rax
    add rsi, rbx
    add rdi, rbx
    dec rcx
    jmp .copy_loop
.copy_done:
    pop rdi
    pop rsi
    pop rcx
    ret

sort_array:
    push rsi
    push rcx
    push rbx
.outer_loop:
    mov rdx, rcx
    dec rdx
    jz .done_sort
    lea r10, [rsi]           
.inner_loop:
    mov rax, [r10]
    mov r11, [r10+rbx]
    cmp rax, r11
    jbe .no_swap
    mov [r10], r11
    mov [r10+rbx], rax
.no_swap:
    add r10, rbx
    dec rdx
    jnz .inner_loop
    dec rcx
    jnz .outer_loop
.done_sort:
    pop rbx
    pop rcx
    pop rsi
    ret


print_number:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi

    mov rsi, outbuf
    mov rcx, 0

    cmp rax, 0
    jne .convert
    mov byte [rsi], '0'
    mov rcx, 1
    jmp .write

.convert:
.convert_loop:
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .convert_loop

.write_loop:
    pop rax
    mov [rsi], al
    inc rsi
    dec rcx
    jnz .write_loop

.write:
    mov byte [rsi], 32        
    inc rsi
    mov rdx, rsi
    sub rdx, outbuf
    mov rax, 1                
    mov rdi, 1                
    lea rsi, [rel outbuf]
    syscall

    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret
