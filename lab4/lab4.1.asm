%include "../lib.asm"

section .data ; сегмент инициализированных переменных
enterMsg db "Enter Array by lines:",10
lenEnterMsg equ $-enterMsg
outMsg db "Your result:", 10
lenOutMsg equ $-outMsg

rows dd 4 ; строки
cols dd 6 ; столбцы

section .bss ; сегмент неинициализированных переменных
inBuf resb 10 ; буфер для вводимой строки
lenIn equ $-inBuf

outBuf resb 7
lenOut equ $-outBuf


matrix resd 24
new_matrix resd 24 ; Резервируем место под новую матрицу, 
                   ; максимум того же размера
new_cols resd 1 ; память под новое количество столбцов


section .text ; сегмент кода
global _start
_start:
    ; выводим сообщение о необходимости ввода
    mov eax, 4 ; системная функция 4 (write)
    mov ebx, 1 ; дескриптор файла stdout=1
    mov ecx, enterMsg ; адрес выводимой строки
    mov edx, lenEnterMsg ; длина выводимой строки
    int 80h ; вызов системной функции
    
    mov ECX, 0 ; счетчик для ввода чисел
input:
    push ECX ; сохраняем значение счетчика цикла в стек
    mov eax, 3 ; системная функция 3 (read)
    mov ebx, 0 ; дескриптор файла stdin=0
    mov ecx, inBuf ; адрес буфера ввода
    mov edx, lenIn ; размер буфера
    int 80h ; вызов системной функции
    
    ; передаем значние в функцию
    mov esi,inBuf ; адрес введенной строки
    call StrToInt
    cmp EBX, 0 ; проверка кода ошибки
    
    pop ECX ; возвращаем значение счетчика цикла из стека
    mov [matrix + ECX*4], eax ; запись числа в память   
    inc ECX ; увеличиваем счетчик
    cmp ECX, 24 ; ввели меньше 24 чисел? тогда продолжаем
    jne input
    
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
    
prepare:
    ; выводим сообщение о выводе результата
    mov eax, 4 ; системная функция 4 (write)
    mov ebx, 1 ; дескриптор файла stdout=1
    mov ecx, outMsg ; адрес выводимой строки
    mov edx, lenOutMsg ; длина выводимой строки
    int 80h ; вызов системной функции
    
    mov ECX, 4 ; количество строк
    mov EBP, 0 ; смещение по строкам

check:
    cmp DWORD[new_cols], 0 ; если в таблице нет столбцов, то выходим
    jz exit
output1:
    mov EDI, 0 ; смещение эл. в строке
    push ECX ; сохранили количество строк в стеке
    mov ECX, [new_cols]
output2:
    mov EAX, [new_matrix + EBP + EDI*4] ; выводимый элемент
    mov ESI, outBuf ; адрес выходной строки
    call IntToStr
    push ECX ; сохранили счетчик эл. внутри строки
    mov eax, 4 ; системная функция 4 (write)
    mov ebx, 1 ; дескриптор файла stdout=1
    mov ecx, outBuf ; адрес выводимой строки
    mov edx, lenOut ; длина выводимой строки
    int 80h ; вызов системной функции
    
    ; очищаем буфер после вывода
    push EDI
    mov ECX, 7 ; длина буфера вывода
    mov Al, 0
    cld ; сброс флага направления
    lea EDI, [outBuf] ; забиваем нулями
    rep stosb
    pop EDI
    
    
    pop ECX ; восстановили счетчик эл. внутри строки
    inc EDI ; увеличили смещение эл. в строке
    loop output2
    pop ECX ; достали счетчик строк
    add EBP, 24 ; перенесли смещение по строкам на следующую
    loop output1
    
exit:
    mov eax, 1 ; системная функция 1 (exit)
    xor ebx, ebx ; код возврата 0
    int 80h ; вызов системной функции
