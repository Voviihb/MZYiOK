%include "lib.asm"

section .data ; сегмент инициализированных переменных


section .bss ; сегмент неинициализированных переменных
inBuf resb 10 ; буфер для вводимой строки
lenIn equ $-inBuf

outBuf resb 7
lenOut equ $-outBuf

matrix resd 24

section .text ; сегмент кода
global _start
_start:
  
  
    
exit:
    mov eax, 1 ; системная функция 1 (exit)
    xor ebx, ebx ; код возврата 0
    int 80h ; вызов системной функции