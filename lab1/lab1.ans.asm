section .data ; сегмент инициализированных переменных
A db 10
B db 20
section .bss ; сегмент неинициализированных переменных
C resb 1
section .text ; сегмент кода
global _start
_start:

mov AL, [A]
add AL, [B]
mov [C], AL

; exit
mov eax, 1 ; системная функция 1 (exit)
xor ebx, ebx ; код возврата 0
int 80h ; вызов системной функции
