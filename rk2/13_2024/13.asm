section .data
section .bss
inStr resb 21
lenInStr equ $-inStr
outStr resb 21
lenOutStr equ $-outStr

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
    mov AL, 10
    repne scasb ; search for \n
    sub ECX, 21
    neg ECX ; real len of str
    
prepare:
    lea EBP, [inStr] ; for search
    lea ESI, [inStr] ; for output
    lea EDI, [inStr] ; for ' ' split

process:
    cmp ECX, 0
    jle exit
    
    mov AL, " "
    repne scasb ; search for ' '
    mov EBX, EDI
    sub EBX, ESI ; get word len
    dec EBX
    
    push ECX
    mov ECX, EBX ; counter for word
    
cycle_search:
    cmp BYTE[EBP], "#"
    je next_word
    cmp BYTE[EBP], "?"
    je next_word
    cmp BYTE[EBP], "@"
    je next_word

    inc EBP ; next symbol
    loop cycle_search
    
 
print_word:
    push EDI
    push EDX
    mov EDI, outStr
    mov ECX, EBX ; word len
    rep movsb ; copy word
    mov BYTE[EDI], 10 ; len + \n
    
    mov EDX, EBX ; move len
    inc EDX ; len + 1
    mov EAX, 4
    mov EBX, 1
    mov ECX, outStr
    int 80h
    
    pop EDX
    pop EDI
   
next_word:
    mov ESI, EDI
    mov EBP, EDI
    pop ECX ; counter for left part of string
    jmp process

exit:
    mov EAX, 1
    xor EBX, EBX
    int 80h