%include "../lib.asm"

section .data ; сегмент инициализированных переменных
enterMsg db "Enter Array by lines:",10
lenEnterMsg equ $-enterMsg

matrix  dd  1, 2, 3, 4, 5, 6,     
        dd  7, 8, 9, 10,11,12,
        dd  2,14,16,16,17,18,
        dd  19,20,21,22,23,24
rows dd 4 ; строки
cols dd 6 ; столбцы

section .bss ; сегмент неинициализированных переменных
inBuf resb 10 ; буфер для вводимой строки
lenIn equ $-inBuf

outBuf resb 7
lenOut equ $-outBuf

new_matrix resd 24 ; Резервируем место под новую матрицу, 
                   ; максимум того же размера
new_cols resd 1 ; память под новое количество столбцов


section .text ; сегмент кода
global _start
_start:
    ; TODO ввод массива 
    
process:
    mov EDI, 0 ; индекс в строке для новой матрицы
    mov EAX, 0 ; обнуляем сумму
    mov EBX, 0 ; смещение эл. в строке
    mov ECX, 6 ; количество столбцов
cycle1:
    push ECX ; сохраняем счетчик
    mov ECX, 3 ; количество элементов в столбце - 1
    mov EAX, [EBX+matrix] ; первый элемент столбца
    mov ESI, 24 ; смещение второго элемента столбца
cycle2:
    add EAX, [EBX+ESI+matrix] ; добавляем к сумме новый эл.
    add ESI, 24 ; переход к следующему эл. в столбце
    loop cycle2 ; цикл по эл-там столбца
    
    test EAX, 1 ; проверка суммы на четность
    jz next_cycle ; если четная, то обрабатываем дальше
    ; подготовка к копированию столбца
    xor ESI, ESI ; сброс смещения в столбце
    mov ECX, 4 ; установка счетчика кол-во эл. в столбце
copy_loop:
    mov EAX, [EBX+ESI+matrix] ; сохраняем элемент
    mov [EDI+ESI+new_matrix], EAX ; копируем в новую матрицу
    add ESI, 24 ; переход к следующему в столбце
    loop copy_loop
    add EDI, 4 ; переход к след. столбцу в новой матрице
    inc DWORD[new_cols] ; увеличиваем зн. столбцов в новой матрице
    

next_cycle:
    pop ECX ; восстановили счетчик cycle1
    add EBX, 4 ; переход к след. столбцу
    loop cycle1 ; цикл по самим столбцам
    
exit:
    mov eax, 1 ; системная функция 1 (exit)
    xor ebx, ebx ; код возврата 0
    int 80h ; вызов системной функции
