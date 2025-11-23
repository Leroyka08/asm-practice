section .data
    BORDER  equ '#'  
    DOT     equ '#'   
    SPACE   equ ' '  
    CR      equ 13     
    LF      equ 10      

section .bss
    line_buffer:    resb 255 + 2   
    height:         resb 1         
    width:          resb 1      

section .text
    global _start

_start:
    mov ah, 36
    mov al, 18

    mov [width], ah    
    mov [height], al   

    call drawEnvelope

    ; выход из программы
    mov eax, 1         
    xor ebx, ebx        
    int 0x80

drawEnvelope:
    push ebp           
    mov ebp, esp

    call prepareLineBuffer  

    call printBorderLine
    call printCenterLines   
    call printBorderLine   

    pop ebp           
    ret

; инициализация буфера новой строкой
prepareLineBuffer:
    push eax
    movzx eax, byte [width]   
    mov ecx, eax
    mov edi, line_buffer
    xor eax, eax
fill_space:
    mov byte [edi], SPACE
    inc edi
    loop fill_space

    ; добавить CR LF
    mov byte [edi], CR
    inc edi
    mov byte [edi], LF

    pop eax
    ret

printBorderLine:
    push ecx
    push eax

    movzx ecx, byte [width]   
    xor eax, eax      
fill_loop:
    mov [line_buffer + eax], byte BORDER
    inc eax
    dec ecx
    jnz fill_loop

    call printLine    

    pop eax
    pop ecx
    ret

; печать центра конверта с точками
printCenterLines:
    push ebp            
    mov ebp, esp
    sub esp, 8          

    mov dword [ebp-4], 0  ; счетчик смещения для DOT

    xor eax, eax
    
    movzx eax, byte [width]
    movzx ecx, byte [height]
    sub ecx, 2
    mov [ebp-8], ecx    ; количество центральных линий

dot_loop:
    cmp dword [ebp-8], 0
    je end_dot_loop

    mov eax, [ebp-4]
    inc dword [ebp-4]

    ; левая точка
    mov edx, [ebp-4]
    mov [line_buffer + edx], byte DOT

    ; правая точка
    movzx ebx, byte [width]
    dec ebx
    sub ebx, edx
    mov [line_buffer + ebx], byte DOT

    call printLine

    mov [line_buffer + edx], byte SPACE
    mov [line_buffer + ebx], byte SPACE

    dec dword [ebp-8]
    jmp dot_loop

end_dot_loop:
    mov esp, ebp      
    pop ebp
    ret

printLine:
    pusha              

    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, line_buffer
    movzx edx, byte [width]
    add edx, 2          ; +CR LF
    int 0x80

    popa                
    ret
