%include "lib.asm"

section .data ; сегмент инициализированных переменных
matrix dd 1, 2, 3, 4, 5
       dd 2, 1, -7, 5, 9
       dd 7, 9, -4, -2, 1
       dd -9, -5, 11, 5, 44
       dd 1, 1, 2, 3, 4

divisor dd 5

section .bss ; сегмент неинициализированных переменных
inBuf resb 10 ; буфер для вводимой строки
lenIn equ $-inBuf

outBuf resb 7
lenOut equ $-outBuf

K resd 5
R resd 5

section .text ; сегмент кода
global _start
_start:

process1: ; for rows
    mov ECX, 5 
    mov ESI, 0 ; pos for matrix
    mov EDI, 0 ; pos for K
cycle1:
    mov EAX, 1 ; product
    push ECX
    mov ECX, 5
cycle2:
    push EAX ; save product
    mov EAX, [matrix+ESI*4]
    cdq ; EAX -> EDX:EAX
    idiv DWORD[divisor]
    pop EAX
    cmp EDX, 0
    je action1 ; if EAX % 5 == 0
continue1:
    inc ESI ; matrix pos += 1
    loop cycle2
    
    cmp EAX, 1 ; if no num % 5 == 0 were found
    jne numbers_found1 ; jmp if found
    mov EAX, 0 ; else product = 0
    jmp done1
numbers_found1:
    mov [K+EDI*4], EAX
done1:
    inc EDI ; K pos += 1
    pop ECX
    loop cycle1
    jmp process2
    
action1:
    imul DWORD[matrix+ESI*4]
    jmp continue1
 

process2:
    mov ECX, 5 ; columns count
    mov ESI, 0 ; current column pos
    mov EDI, 0 ; pos for R
cycle3:
    mov EAX, 1 ; product
    push ECX
    mov ECX, 5 ; elements in column count (rows)
    mov EBX, 0 ; current element in column
cycle4:
    push EAX ; save product
    mov EAX, [matrix+ESI*4+EBX]
    cdq ; EAX -> EDX:EAX
    idiv DWORD[divisor]
    pop EAX
    cmp EDX, 0
    je action2 ; if EAX % 5 == 0
continue2:
    add EBX, 20 ; nove to next row element
    loop cycle4
    
    cmp EAX, 1 ; if no num % 5 == 0 were found
    jne numbers_found2 ; jmp if found
    mov EAX, 0 ; else product = 0
    jmp done2
numbers_found2:
    mov [R+EDI*4], EAX
done2:
    inc EDI ; R pos += 1
    pop ECX
    inc ESI ; move to next column
    loop cycle3
    jmp finalize
   
action2:
    imul DWORD[matrix+ESI*4+EBX]
    jmp continue2     
    
finalize:
  mov ECX, 5 ; total elements
  mov EBX, 0 ; start pos
output:
    push ECX
    ; очищаем буфер после вывода
    mov ECX, 7 ; длина буфера вывода
    mov Al, 0
    cld ; сброс флага направления
    lea EDI, [outBuf] ; забиваем нулями
    rep stosb
    pop ECX

    mov ESI, outBuf ; output addr
    mov EAX, [R+EBX*4] ; to be converted to string
    push ECX ; save data
    push EBX
    call IntToStr
    mov eax, 4 ; системная функция 4 (write)
    mov ebx, 1 ; дескриптор файла stdout=1
    mov ecx, outBuf ; адрес выводимой строки
    mov edx, lenOut ; длина выводимой строки
    int 80h ; вызов системной функции
    
    pop EBX
    pop ECX
    inc EBX ; pos = pos + 1
    loop output
  
exit:
    mov eax, 1 ; системная функция 1 (exit)
    xor ebx, ebx ; код возврата 0
    int 80h ; вызов системной функции