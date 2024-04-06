section .data ; сегмент инициализированных переменных
val1 db 255
chart dw 256
lue3 dw -128
v5 db 10h
   db 100101B
beta db 23,23h,0ch
sdk db "Hello",10
min dw -32767
ar dd 12345678h
valar times 5 db 8


section .bss ; сегмент неинициализированных переменных
alu resw 10
f1 resb 5

section .text ; сегмент кода

global _start
_start:
mov ecx, [val1]

; write


; read


; exit
mov eax, 1 ; системная функция 1 (exit)
xor ebx, ebx ; код возврата 0
int 80h ; вызов системной функции
