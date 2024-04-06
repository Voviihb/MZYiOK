%include "../lib.asm"

section .data ; сегмент инициализированных переменных
enterMsg db "Enter k, a, r ",10
lenEnterMsg equ $-enterMsg

section .bss ; сегмент неинициализированных переменных
inBuf resb 10 ; буфер для вводимой строки
lenIn equ $-inBuf

outBuf resb 7
lenOut equ $-outBuf

k resw 1
a resw 1
r resw 1
f resw 1

section .text ; сегмент кода
global _start
_start:

; выводим сообщение о необходимости ввода
mov eax, 4 ; системная функция 4 (write)
mov ebx, 1 ; дескриптор файла stdout=1
mov ecx, enterMsg ; адрес выводимой строки
mov edx, lenEnterMsg ; длина выводимой строки
int 80h ; вызов системной функции



; вводим значение k
mov eax, 3 ; системная функция 3 (read)
mov ebx, 0 ; дескриптор файла stdin=0
mov ecx, inBuf ; адрес буфера ввода
mov edx, lenIn ; размер буфера
int 80h ; вызов системной функции

; передаем значние в функцию
mov esi,inBuf ; адрес введенной строки
call StrToInt
cmp EBX, 0 ; проверка кода ошибки
mov [k], ax ; запись числа в память


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


; вводим значение r
mov eax, 3 ; системная функция 3 (read)
mov ebx, 0 ; дескриптор файла stdin=0
mov ecx, inBuf ; адрес буфера ввода
mov edx, lenIn ; размер буфера
int 80h ; вызов системной функции

; передаем значние в функцию
mov esi,inBuf ; адрес введенной строки
call StrToInt
cmp EBX, 0 ; проверка кода ошибки
mov [r], ax ; запись числа в память


; начинаем вычисления
mov AX, [k]
imul WORD[a] ;DX:AX = k * a
cmp AX, 5; сравниваем AX и 5
jle else ; if AX <= 5 переходим на ветку else
; k*a > 5:
mov AX, [k]
sub AX, 5 ; AX = k - 5
imul AX ; DX:AX = (k - 5)^2
idiv WORD[r] ; DX:AX = (k - 5)^2 / r
jmp res
else: ; k*a <= 5 
    mov AX, 8 ; AX = 8
    sub AX, WORD[a] ; AX = 8 - a
res: 
    mov [f], AX
    
    
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
