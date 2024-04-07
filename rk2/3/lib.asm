StrToInt:
push edi
mov bh,'9'
mov bl,'0'
push esi ; сохраняем адрес исходной строки
cmp byte[esi], '-'
jne .prod
inc esi ; пропускаем знак минус
.prod cld
xor di,di ; обнуляем будущее число
.cycle: lodsb ; загружаем символ (цифру)
cmp al,10 ; если 10, то на конец
je .Return
cmp al,bl ; сравниваем с кодом нуля
jb .Error ; "ниже" – Ошибка
cmp al,bh ; сравниваем с кодом девяти
ja .Error ; "выше" – Ошибка
sub al,30h ; получаем цифру из символа
cbw ; расширяем до слова
push ax ; сохраняем в стеке
mov ax,10 ; заносим 10 в AX
mul di ; умножаем, результат в DX:AX
pop di ; в DI – очередная цифра
add ax,di
mov di,ax ; в DI – накопленное число
jmp .cycle
.Return: pop esi
mov ebx,0
cmp byte[esi],'-'
jne .J
neg di
.J mov ax,di
cwde
jmp .R
.Error: pop esi
mov eax,0
mov ebx,1
.R pop EDI
ret



IntToStr:
push edi
push ebx
push edx
push ecx
push esi
mov byte[esi],0 ; на место знака
cmp eax,0
jge .l1
neg eax
mov byte[esi],'-'
.l1 mov byte[esi+6],10
mov edi,5
mov bx,10
.again: cwd ; расширили слово до двойного
div bx ; делим результат на 10
add dl,30h ; получаем из остатка код цифры
mov [esi+edi],DL ; пишем символ в строку
dec edi ; переводим указатель на
; предыдущую позицию
cmp ax, 0 ; преобразовали все число?
jne .again
mov eax, 6
sub ecx, edi ; длина результата+знак
mov eax,ecx
inc eax ; длина результата+знак+0А
inc esi ; пропускаем знак
push esi
lea esi,[esi+edi] ; начало символов результата
pop edi
;rep movsb
pop esi
pop ecx
pop edx
pop ebx
pop edi
ret
