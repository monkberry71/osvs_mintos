[ORG 0x00]
[BITS 16]

SECTION .text

; mov ax, 0xB800
; mov ds, ax

; mov byte [0x00], 'M'
; mov byte [0x01], 0x4A

jmp 0x07C0:START

TOTAL_SECTOR_COUNT: dw 1024

START: 
    ;; set ds and es register
    mov ax, 0x07C0
    mov ds, ax
    mov ax, 0xB800
    mov es, ax

    ;; stack setting
    mov ax, 0x00
    mov ss, ax
    mov sp, 0xFFFE
    mov bp, 0xFFFE

;; we need to clear the screen.

mov si, 0
.SCREEN_CLEAR_LOOP: ;; clears the screen.
    mov byte [es : si], 0
    mov byte [es : si + 1], 0x0A

    add si, 2

    cmp si, 80 * 25* 2
    jl .SCREEN_CLEAR_LOOP

    mov si, 0
    mov di, 0

;; cleared

push MSG1
push 0
push 0
call PRINT_MSG
add sp, 6 ;; clean the stack

push IMG_LOADING_MSG
push 1
push 0
call PRINT_MSG
add sp, 6 ;; clean the stack

    jmp $


PRINT_MSG:
    push bp
    mov bp, sp ;; stack base pointer setting

    push es
    push si
    push di
    push ax
    push cx
    push dx ;; callee saved registers (all?)

    mov ax, 0xB800
    mov es, ax ;; now ES segment register is 0xB800

    mov ax, word [ bp + 6 ] ;; bp : past sp, bp + 2 : return address. bp + 4 : arg start, so (bp + 4) + arg * 2 
    mov si, 160 ;; screen width is 80, so we need to 2 * 80.
    mul si ;; ax *= si
    mov di, ax

    mov ax, word [ bp + 4 ]
    mov si, 2
    mul si
    add di, ax 

    mov si, word [bp + 8]

.MSG_LOOP:
    mov cl, byte[ si ]
    cmp cl, 0
    je .MSG_END

    mov byte [es:di], cl
    add si, 1
    add di, 2

    jmp .MSG_LOOP

.MSG_END:
    pop dx
    pop cx
    pop ax
    pop di
    pop si
    pop es
    
    mov sp, bp
    pop bp

    ret
    



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; constants? 
MSG1:
    db 'MINT64 OS WOW!!', 0

IMG_LOADING_MSG:
    db 'Let me load the OS...', 0

jmp $

times 510 - ($ - $$) db 0x00
db 0x55
db 0xAA