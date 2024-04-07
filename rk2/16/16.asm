%include "lib.asm"

section .data ; сегмент инициализированных переменных
matrix dd 1, 2, 3, 4, 5, 6, 7
       dd 2, 0, -7, 5, 9, 7, 1
       dd 7, 9, -4, -2, 0, -3, 5
       dd -9, -5, 11, 5, 44, 0, 1
       dd 0, 1, 2, 3, 4, 5, 6
       dd 0, 0, 0, 0, 0, 0, 0
       dd 7, 6, 5, 4, 3, 2, 1

section .bss ; сегмент неинициализированных переменных
inBuf resb 10 ; буфер для вводимой строки
lenIn equ $-inBuf

outBuf resb 7
lenOut equ $-outBuf

H resd 7

section .text ; сегмент кода
global _start
_start:

process:
    mov ECX, 7 ; count of operations needed
    mov EBX, 0 ; current H pos
    mov ESI, 0 ; pos1 for main diagonal
    mov EDI, 6 ; pos2 for addintional diagonal
cycle:
    mov EAX, [matrix+ESI*4]
    imul DWORD[matrix+EDI*4]
    mov [H+EBX*4], EAX
    add ESI, 8
    add EDI, 6
    inc EBX
    loop cycle
    
finalize:
  mov ECX, 7 ; total elements
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
    mov EAX, [H+EBX*4] ; to be converted to string
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