[ORG 0x00]
[BITS 16]

SECTION .text

START:
    mov ax, 0x1000
    mov ds, ax
    mov es, ax

    cli ;; disable interrupt
    lgdt [ GDTR ]

    mov eax, 0x4000003B
    mov cr0, eax

    jmp dword 0x08:(PROTECTED_MODE - $$ + 0x10000)

[BITS 32]
PROTECTED_MODE:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ss, ax
    mov esp, 0xFFFE
    mov ebp, 0xFFFE

    push ( TRYING_MSG - $$ + 0x10000)
    push 2
    push 0
    call PRINT_MSG
    add esp, 12

    push ( SWITCH_SUCCESS_MSG - $$ + 0x10000)
    push 3
    push 0
    call PRINT_MSG
    add esp, 12

    jmp dword 0x08:0x10200

PRINT_MSG:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push eax
    push ecx
    push edx

    mov eax, dword [ ebp + 12 ]
    mov esi, 160
    mul esi
    mov edi, eax

    mov eax, dword [ ebp + 8 ]
    mov esi, 2
    mul esi
    add edi, eax

    mov esi, dword [ ebp + 16]

.MSG_LOOP:
    mov cl, byte [esi]
    cmp cl, 0
    je .MSG_END

    mov byte [ edi + 0xB8000 ], cl
    add esi, 1
    add edi, 2

    jmp .MSG_LOOP

.MSG_END:
    pop edx
    pop ecx
    pop eax
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret

;;;;;;;; data
align 8, db 0

dw 0x0000
GDTR:
    dw GDT_END - 1 - GDT ;; GDT_END is (last bit of GDT) + 1, so we need to subtract it by one
    dd (GDT - $$ + 0x10000)

GDT:
    NULL_D:
        dw 0x0000
        dw 0x0000
        db 0x00
        db 0x00
        db 0x00
        db 0x00

    CODE_D:
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 0x9A
        db 0xCF
        db 0x00
    
    DATA_D:
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 0x92
        db 0xCF
        db 0x00
GDT_END:
    
SWITCH_SUCCESS_MSG: db 'Protected mode success', 0
TRYING_MSG: db 'Trying to switch to protected mod', 0

times 512 - ( $ - $$ ) db 0x00



