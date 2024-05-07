global _Z11deleteWordsPcPii
extern _Z8printDeli
section .text
_Z11deleteWordsPcPii:
    ; пролог
    push RBP
    mov RBP, RSP
    ; save params
    push RDX ; word count
    push RSI ; array of int
    ; сохранение содержимого регистров
    push RAX
    push RBX
    push RCX
    push R9
    push R10
    push R11
    push R13
    push R14
    push R15
.get_real_len:
    push RDI
    mov RCX, 255
    mov AL, '.'
    repne scasb ; search for '.'
    sub RCX, 255
    neg RCX ; real len of str
    mov RDI, RCX ; put len to func params
    mov RBX, RCX ; (printDel writes its own data to RCX)
    call _Z8printDeli ; print len
    mov RCX, RBX ; restore RCX
    pop RDI

.prepare:
    lea R10, [RDI] ; current start of word
    lea R11, [RDI] ; start position
    xor RDX, RDX
    mov R14, 0 ; offset for array elements
    mov R9, [RBP-16] ; address of first element of array
    mov EDX, [R9+R14] ; first element of array
    mov R13, 0 ; current word found
    movsxd R15, DWORD[RBP-8] ; words to be deleted left

.process:
    cmp RCX, 0
    jle .finalize
    cmp R15, 0
    jle .finalize

    mov AL, ' '
    repne scasb ; search for ' '
    inc R13 ; current word += 1

    mov RBX, RDI
    sub RBX, R10
    dec RBX ; word len
    cmp RDX, R13 ; if array[i] == cur_word
    jne .next

.delete:
    push RCX ; save counter
    inc RCX;
    mov RSI, RDI ; from
    push RDI
    lea RDI, [R10] ; to
    rep movsb ; copy left part of text
    pop RDI
    pop RCX
    add R14, 4 ; next element of array
    mov EDX, [R9+R14]
    dec R15 ; words_to_be_deleted -= 1
    mov RDI, R10
    jmp .process

.next:
    mov R10, RDI ; next word
    jmp .process

.finalize:
    add RDI, RCX
    dec RDI
    cmp BYTE[RDI], ' '
    jne .epilog
    mov AL, '.'
    stosb ; put . at the end
.epilog:
    ; эпилог
    pop R15
    pop R14
    pop R13
    pop R11
    pop R10
    pop R9
    pop RCX
    pop RBX
    pop RAX
    pop RSI
    pop RDX
    pop RBP
    ret
