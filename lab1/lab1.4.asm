section .data ; сегмент инициализированных переменных
a dw 25h
b dw 37

section .bss ; сегмент неинициализированных переменных

section .text ; сегмент кода

global _start
_start:
mov ax, [a]
mov ch, [a]

mov dx, [b]
mov bh, [b]
; write

; read

; exit
mov eax, 1 ; системная функция 1 (exit)
xor ebx, ebx ; код возврата 0
int 80h ; вызов системной функции
