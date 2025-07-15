[ORG 0x7C00]
[BITS 16]

SECTION .text

; mov ax, 0xB800
; mov ds, ax

; mov byte [0x00], 'M'
; mov byte [0x01], 0x4A

jmp START

TOTAL_SECTOR_COUNT: dw 2

START: 
    ;; set ds and es register
    ; mov ax, 0x07C0
    ; mov ds, ax
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

;;; RESET
RESET_DISK:
    mov ax, 0 ;; service number 0 == reset
    mov dl, 0 ;; drive number 0 == floppy
    int 0x13

    jc HANDLE_DISK_ERROR ;; if carry flag is set, it means the bios made it, because there was an error


    ;; ok no error now
    mov si, 0x1000
    mov es, si;
    mov bx, 0x0000

    mov di, word [ TOTAL_SECTOR_COUNT ]

.READ_DATA:
    cmp di, 0
    je READ_END
    sub di, 0x1

    mov ah, 0x02 ; BIOS Service number 2, read sector
    
    mov al, 0x01 ;; sector 1
    mov ch, byte [TRACK_NUMBER]
    mov cl, byte [SECTOR_NUMBER]
    mov dh, byte [HEAD_NUMBER]
    mov dl, 0x00; BIOS Drive number 0 == floppy

    int 0x13
    jc HANDLE_DISK_ERROR

    ;; Good, we read 1 sector

    add si, 0x0020
    mov es, si ; we read 0x200 byte, so increase that many.

    mov al, byte [SECTOR_NUMBER]
    add al, 0x01
    mov byte [ SECTOR_NUMBER ], al
    cmp al, 37
    jl .READ_DATA ; al - 19 < 0 -> goto READ_DATA

    ;; al == 19
    xor byte [ HEAD_NUMBER ], 0x01
    mov byte [ SECTOR_NUMBER ], 0x01

    cmp byte [ HEAD_NUMBER ], 0x00 ;; if toggled result is 0, it was 1, so we need to add track number by one.
    jne .READ_DATA ;; HEAD_NUMBER != 0 -> goto READ_DATA

    ;; HEAD_NUMBER ==0 
    add byte [ TRACK_NUMBER ], 0x01
    jmp .READ_DATA 

READ_END:
    push LOADING_COMPLETE_MSG
    push 1
    push 20
    call PRINT_MSG
    add sp, 6

    jmp 0x1000:0x0000

HANDLE_DISK_ERROR:
    push DISK_ERROR_MSG
    push 1
    push 20
    call PRINT_MSG
    add sp, 6

    jmp $




;;;;;;;; function area ahead

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




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; data
MSG1:
    db 'MINT64 OS WOW!!', 0

DISK_ERROR_MSG:
    db 'DISK erorr!', 0

IMG_LOADING_MSG:
    db 'Let me load the OS', 0

LOADING_COMPLETE_MSG:
    db 'Loading completed',0

SECTOR_NUMBER: db 0x02
HEAD_NUMBER: db 0x00
TRACK_NUMBER: db 0x00

times 510 - ($ - $$) db 0x00
db 0x55
db 0xAA