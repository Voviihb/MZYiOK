%include "lib.asm"

section .data ; сегмент инициализированных переменных
matrix dd 1, 2, 3, 4, 5
       dd 2, 0, -7, 5, 10
       dd 7, 9, -4, -2, -1
       dd -9, -5, 11, 5, 52
       dd -2, -5, -3, -7, -10

section .bss ; сегмент неинициализированных переменных
inBuf resb 10 ; буфер для вводимой строки
lenIn equ $-inBuf

outBuf resb 7
lenOut equ $-outBuf

tempMas resd 5

section .text ; сегмент кода
global _start
_start:

process:
    mov EBX, 0
    mov ECX, 5
cycle1:
    push ECX
    mov ECX, 5
    mov EAX, [matrix+EBX*4] ; first elem is temp max
cycle2:
    mov EDX, [matrix+EBX*4] ; current elem
    cmp EDX, EAX 
    jg change_max ; if EDX > EAX
continue:
    inc EBX
    loop cycle2
    
    pop ECX ; if cycle2 is finished
    mov EDX, 5
    sub EDX, ECX ; get current row
    mov [tempMas+EDX*4], EAX ; write row maximum
    loop cycle1
    
    mov ECX, 5 ; new counter
    mov EBX, 0 ; start position
    mov EDX, 0 ; row counter
    jmp change_matrix ; if cycle1 is finished
change_max:
    mov EAX, EDX ; update max
    jmp continue
 
change_matrix:
    mov EAX, [tempMas+EDX*4]
    mov [matrix+EBX*4], EAX
    add EBX, 6 ; change position
    inc EDX ; inc row counter
    loop change_matrix
    
finalize:
  mov ECX, 25 ; total elements
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
    mov EAX, [matrix+EBX*4] ; to be converted to string
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