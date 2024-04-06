section .data ; сегмент инициализированных переменных
f1 dw 65535
f2 dd 65535

section .bss ; сегмент неинициализированных переменных

section .text ; сегмент кода

global _start
_start:
mov cx, [f1]
mov edx, [f2]
add cx, 1
add edx, 1
; write

; read

; exit
mov eax, 1 ; системная функция 1 (exit)
xor ebx, ebx ; код возврата 0
int 80h ; вызов системной функции
