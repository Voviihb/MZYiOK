section .data ; сегмент инициализированных переменных
A dw -30
B dw 21

section .bss ; сегмент неинициализированных переменных
X resd 1

section .text ; сегмент кода

global _start
_start:
mov EAX, [A] ; загрузить число A в регистр EAX
add EAX, 5 ; сложить EAX и 5, результат в EAX
sub EAX, [B] ; вычесть число B, результат в EAX
mov [X], EAX ; сохранить результат в памяти

; write


; read


; exit
mov eax, 1 ; системная функция 1 (exit)
xor ebx, ebx ; код возврата 0
int 80h ; вызов системной функции
