dosseg
model small
stack 256

dataseg
msg1 db 'Ingresa el valor de n: ', 0
msg2 db 'Fibonacci(n) = ', 0
input db 15 dup(?)
cad   db 14 dup(?)
cadf  db 50 dup(?)

codeseg
extrn aputs:proc, agets:proc, aitoa:proc
extrn aatoi:proc, astrcat:proc

inicio:
mov ax, @data
mov ds, ax
mov es, ax

mov si, offset msg1
call aputs

mov di, offset input
call agets

mov si, offset input
call aatoi

mov cx, ax
xor ax, ax
mov bx, 1

test cx, cx
jz .done

.loop:
    dec cx
    jz .done_b

    add ax, bx
    xchg ax, bx
    jmp .loop

.done_b:
    mov ax, bx

.done:
    mov di, offset cad
    mov bx, 10
    xor cx, cx
    call aitoa

    mov si, offset msg2
    mov di, offset cadf
    call astrcat

    mov si, offset cad
    mov di, offset cadf
    call astrcat

    mov si, offset cadf
    call aputs

    mov ah, 04Ch
    xor al, al
    int 21h

end inicio
