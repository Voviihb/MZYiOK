section .data ; сегмент инициализированных переменных
a dw 25
b dd -35
name dw "Vladimir Владимир",10



section .bss ; сегмент неинициализированных переменных


section .text ; сегмент кода

global _start
_start:
mov ecx, [a]

; write


; read


; exit
mov eax, 1 ; системная функция 1 (exit)
xor ebx, ebx ; код возврата 0
int 80h ; вызов системной функции
