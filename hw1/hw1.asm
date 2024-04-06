%include "../lib.asm"

section .data ; сегмент инициализированных переменных
enterMsg db "Enter string, len=20:",10
lenEnterMsg equ $-enterMsg
outMsg db "Your result:", 10
lenOutMsg equ $-outMsg

section .bss ; сегмент неинициализированных переменных
inBuf resb 10 ; буфер для вводимой строки
lenIn equ $-inBuf

inStr resb 21 ; память под вводимую строку
lenInStr equ $-inStr

outBuf resb 7 ; буфер для вывода количества повторений
lenOut equ $-outBuf

outStr resb 21 ; длина результата 20 + байт под конец строки
lenOutStr equ $-outStr

count resb 1 ; количество повторений OP

section .text ; сегмент кода
global _start
_start:
    ; выводим сообщение о необходимости ввода
    mov eax, 4 ; системная функция 4 (write)
    mov ebx, 1 ; дескриптор файла stdout=1
    mov ecx, enterMsg ; адрес выводимой строки
    mov edx, lenEnterMsg ; длина выводимой строки
    int 80h ; вызов системной функции

input:
    mov eax, 3 ; системная функция 3 (read)
    mov ebx, 0 ; дескриптор файла stdin=0
    mov ecx, inStr ; адрес буфера ввода
    mov edx, lenInStr ; размер буфера
    int 80h ; вызов системной функции

copyStr:
    cld ; сброс флага направления
    lea ESI, [inStr] ; загрузка адреса источника
    lea EDI, [outStr] ; загрузка адреса приемника
    mov ECX, 21 ; установка счетчика на длину строки
    rep movsb ; копируем строчку

process:
    lea EAX, [outStr] ; адрес начала строки
    mov EBX, 21 ; длина строки
    mov ESI, EAX ; адрес строки
    push EAX ; сохранили адрес в стек

check:
    mov EDX, [ESP] ; достали адрес начала строки из стека
    sub EDX, ESI ; нашли разницу адресов, она отрицательная
    neg EDX ; взяли модуль от разницы адресов
    mov ECX, EBX 
    sub ECX, EDX ; ECX = сколько символов еще не проверили
    cmp ECX, 2 ; сравнение
    jl output ; если осталось меньше двух симв, то идем на вывод

L1: 
    mov AX, WORD[ESI] ; ввели два символа
    cmp AX, 'OP' ; сравнили введенные символы и OP
    je L2 ; если равно, то начинаем обработку
    inc ESI ; сдвинули указатель на один символ
    jmp check

L2:
    mov BYTE[ESI], '!' ; заменили первый символ на !
    lea EDI, [ESI+1] ; установили указатель на P
    add ESI, 2 ; перекинули ESI на символ после P
    mov EDX, [ESP] ; достали адрес начала строки из стека
    sub EDX, ESI ; нашли разницу адресов, она отрицательная
    neg EDX ; взяли модуль от разницы адресов
    mov ECX, EBX 
    sub ECX, EDX ; ECX = длина строки - текущее положение симв. P
    push ESI ; сохранили ESI в стек
    rep movsb ; выполнили удаление сдвигом
    pop ESI ; достали ESi из стека
    dec ESI ; поставили указатель на место, где раньше был симв. P
    inc BYTE[count] ; увеличили счетчик
    jmp check
    

output:
    push EBX ; сохранили значение в стек
    ; выводим сообщение о выводе результата
    mov eax, 4 ; системная функция 4 (write)
    mov ebx, 1 ; дескриптор файла stdout=1
    mov ecx, outMsg ; адрес выводимой строки
    mov edx, lenOutMsg ; длина выводимой строки
    int 80h ; вызов системной функции
    pop EBX ; выстащили значение из стека
    
    
    sub BL, BYTE[count] ; вычислили новую длину строки
    mov edx, EBX ; длина выводимой строки
    mov eax, 4 ; системная функция 4 (write)
    mov ebx, 1 ; дескриптор файла stdout=1
    mov ecx, outStr ; адрес выводимой строки
    int 80h ; вызов системной функции
    
    xor EAX, EAX ; очистка EAX
    mov AL, BYTE[count] ; выводим количество повторений OP
    mov ESI, outBuf ; адрес выходной строки
    call IntToStr
    mov eax, 4 ; системная функция 4 (write)
    mov ebx, 1 ; дескриптор файла stdout=1
    mov ecx, outBuf ; адрес выводимой строки
    mov edx, lenOut ; длина выводимой строки
    int 80h ; вызов системной функции
    
            
exit:
    mov eax, 1 ; системная функция 1 (exit)
    xor ebx, ebx ; код возврата 0
    int 80h ; вызов системной функции