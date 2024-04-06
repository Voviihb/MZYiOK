%include "../lib.asm"

section .data ; сегмент инициализированных переменных
enterMsg db "Enter a, x, b, y ",10
lenEnterMsg equ $-enterMsg

section .bss ; сегмент неинициализированных переменных
inBuf resb 10 ; буфер для вводимой строки
lenIn equ $-inBuf

outBuf resb 7
lenOut equ $-outBuf

a resw 1
x resw 1
b resw 1
y resw 1
n resw 1

section .text ; сегмент кода
global _start
_start:

; выводим сообщение о необходимости ввода
mov eax, 4 ; системная функция 4 (write)
mov ebx, 1 ; дескриптор файла stdout=1
mov ecx, enterMsg ; адрес выводимой строки
mov edx, lenEnterMsg ; длина выводимой строки
int 80h ; вызов системной функции



; вводим значение a
mov eax, 3 ; системная функция 3 (read)
mov ebx, 0 ; дескриптор файла stdin=0
mov ecx, inBuf ; адрес буфера ввода
mov edx, lenIn ; размер буфера
int 80h ; вызов системной функции

; передаем значние в функцию
mov esi,inBuf ; адрес введенной строки
call StrToInt
cmp EBX, 0 ; проверка кода ошибки
mov [a], ax ; запись числа в память


; вводим значение x
mov eax, 3 ; системная функция 3 (read)
mov ebx, 0 ; дескриптор файла stdin=0
mov ecx, inBuf ; адрес буфера ввода
mov edx, lenIn ; размер буфера
int 80h ; вызов системной функции

; передаем значние в функцию
mov esi,inBuf ; адрес введенной строки
call StrToInt
cmp EBX, 0 ; проверка кода ошибки
mov [x], ax ; запись числа в память


; вводим значение b
mov eax, 3 ; системная функция 3 (read)
mov ebx, 0 ; дескриптор файла stdin=0
mov ecx, inBuf ; адрес буфера ввода
mov edx, lenIn ; размер буфера
int 80h ; вызов системной функции

; передаем значние в функцию
mov esi,inBuf ; адрес введенной строки
call StrToInt
cmp EBX, 0 ; проверка кода ошибки
mov [b], ax ; запись числа в память


; вводим значение y
mov eax, 3 ; системная функция 3 (read)
mov ebx, 0 ; дескриптор файла stdin=0
mov ecx, inBuf ; адрес буфера ввода
mov edx, lenIn ; размер буфера
int 80h ; вызов системной функции

; передаем значние в функцию
mov esi,inBuf ; адрес введенной строки
call StrToInt
cmp EBX, 0 ; проверка кода ошибки
mov [y], ax ; запись числа в память


; начинаем вычисления
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

; вычисляем результат, он будет в AX
sub AX, DI
add AX, SI


; выводим число из AX в консоль
cwde ; развертование ax до eax
mov ESI, outBuf
call IntToStr
mov eax, 4 ; системная функция 4 (write)
mov ebx, 1 ; дескриптор файла stdout=1
mov ecx, outBuf ; адрес выводимой строки
mov edx, lenOut ; длина выводимой строки
int 80h ; вызов системной функции



; exit
mov eax, 1 ; системная функция 1 (exit)
xor ebx, ebx ; код возврата 0
int 80h ; вызов системной функции
