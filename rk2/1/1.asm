%include "lib.asm"

section .data ; сегмент инициализированных переменных

section .bss ; сегмент неинициализированных переменных
outBuf resb 7
lenOut equ $-outBuf

inStr resb 21 ; память под вводимую строку
lenInStr equ $-inStr

outStr resb 21 ; длина результата 20 + байт под конец строки
lenOutStr equ $-outStr

section .text ; сегмент кода
global _start
_start:

input:
    mov eax, 3 ; системная функция 3 (read)
    mov ebx, 0 ; дескриптор файла stdin=0
    mov ecx, inStr ; адрес буфера ввода
    mov edx, lenInStr ; размер буфера
    int 80h ; вызов системной функции

get_real_len:
    mov ECX, 21 ; len of string
    lea EDI, [inStr] ; string to process
    mov AL, 10 
    repne scasb ; search for '\n'
    sub ECX, 21
    neg ECX ; real length of string 
process:
    lea EBP, [inStr] ; word with max len pos
    lea ESI, [inStr] ; prev pos string
    lea EDI, [inStr] ; string to process
    mov AL, " " 
    mov EDX, 0 ; max len
cycle:
    cmp ECX, 0
    jle generate_result
    
    repne scasb ; search for ' ' until it is not found
    mov EBX, EDI
    sub EBX, ESI ; get word len
    dec EBX
    cmp EBX, EDX
    jg new_max_len
com:
    mov ESI, EDI ; update prev position
    jmp cycle
new_max_len:
    mov EDX, EBX ; save max len
    mov EBP, ESI ; update max len word start pos
    jmp com

generate_result:
    mov ESI, EBP ; put source
    mov EDI, outStr ; put destination
    mov ECX, EDX ; put max length
    rep movsb ; copy word
    mov BYTE[EDI], 10 ; put end of string

output:
    inc EDX ; len of output + '\n'
    mov eax, 4 ; системная функция 4 (write)
    mov ebx, 1 ; дескриптор файла stdout=1
    mov ecx, outStr ; адрес выводимой строки
    int 80h ; вызов системной функции
  
    dec EDX
    mov EAX, EDX ; max len
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