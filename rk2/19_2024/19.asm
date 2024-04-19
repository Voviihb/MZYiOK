section .data
section .bss
inStr resb 21
lenInStr equ $-inStr
outStr resb 21
lenOutStr equ $-outStr
counter resd 1 ; to check if word counter % 2 == 0
max_len resd 1 ; to store max len of word

section .text
global _start
_start:

input:
    mov EAX, 3
    mov EBX, 0
    mov ECX, inStr
    mov EDX, lenInStr
    int 80h
    
get_real_len:
    mov ECX, 21
    lea EDI, [inStr]
    mov AL, "."
    repne scasb ; search for '.'
    sub ECX, 21
    neg ECX ; real len of str
    
prepare:
    lea EBP, [inStr] ; to store start of word
    lea ESI, [inStr] ; for output
    lea EDI, [inStr] ; for ',' split
    mov DWORD[counter], 0 ; word counter = 0
    mov DWORD[max_len], -1 ; max_len = -1

process:
    cmp ECX, 0
    jle print_word
    
    mov AL, ","
    repne scasb ; search for ','
    mov EBX, EDI
    sub EBX, EBP ; get word len
    dec EBX
    inc DWORD[counter] ; word counter += 1

    test DWORD[counter], 1 ; check if word_counter % 2 == 1
    jnz next_word ; <- if word_counter % 2 == 0
    cmp EBX, [max_len] ; <- else check if current len > max_len
    jle next_word ; <- if EBX <= max_len
    mov ESI, EBP ; <- else change position of word with max len
    mov [max_len], EBX ; update max len
    jmp next_word
    
next_word:
    mov EBP, EDI ; update pointer to next word
    jmp process   

 
print_word:
    mov EDI, outStr
    mov ECX, [max_len] ; word len
    rep movsb ; copy word from ESI
    mov BYTE[EDI], 10 ; word + \n
    
    mov EDX, [max_len] ; move len
    inc EDX ; len + 1
    mov EAX, 4
    mov EBX, 1
    mov ECX, outStr
    int 80h
    

exit:
    mov EAX, 1
    xor EBX, EBX
    int 80h