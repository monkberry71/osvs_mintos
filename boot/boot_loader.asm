[ORG 0x00]
[BITS 16]

SECTION .text

; mov ax, 0xB800
; mov ds, ax

; mov byte [0x00], 'M'
; mov byte [0x01], 0x4A

jmp 0x07C0:START

START:
    mov ax, 0x07C0
    mov ds, ax
    mov ax, 0xB800
    mov es, ax

; mov byte [ es: 0x00 ], 'F'
; mov byte [ es: 0x01 ], 0x4A

mov si, 0

.SCREEN_CLEAR_LOOP:
    mov byte [es : si], 0
    mov byte [es : si + 1], 0x0A

    add si, 2

    cmp si, 80 * 25* 2
    jl .SCREEN_CLEAR_LOOP

    mov si, 0
    mov di, 0

.MSG_LOOP:
    mov cl, byte[ si + MSG1 ]
    cmp cl, 0
    je .MSG_END

    mov byte [es:di], cl
    add si, 1
    add di, 2

    jmp .MSG_LOOP

.MSG_END:
    jmp $

MSG1:
    db 'MINT64 OS WOW!!', 0;

jmp $

times 510 - ($ - $$) db 0x00
db 0x55
db 0xAA