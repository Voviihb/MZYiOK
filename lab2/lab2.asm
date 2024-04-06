section .data ; сегмент инициализированных переменных
a dw 10
x dw 32
b dw 50
y dw -2

section .bss ; сегмент неинициализированных переменных
n resw 1

section .text ; сегмент кода
global _start
_start:
mov CX, [y]
add CX, [a] ;CX = y + a
mov AX, [x]
cwd ;AX -> DX:AX (расширение для деления)
idiv CX ; AX := (DX:AX) / CX или x / (y + a)
mov SI, AX ; сохранили результат вычисления в SI

mov AX, [b]
imul WORD[y] ; DX:AX = b * y
idiv WORD[a] ; AX := (DX:AX) / [a] или (b * y) / a
mov DI, AX ; сохранили результат вычисления в DI

mov AX, [x]
imul WORD[x] ; DX:AX = x * x
imul WORD[a] ; DX:AX = a * x * x

; вычисляем результат, он будет в [n]
sub AX, DI
add AX, SI
mov [n], AX







; write

; read

; exit
mov eax, 1 ; системная функция 1 (exit)
xor ebx, ebx ; код возврата 0
int 80h ; вызов системной функции
