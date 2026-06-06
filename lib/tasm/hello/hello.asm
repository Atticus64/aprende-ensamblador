dosseg
model small
stack 256

dataseg
msg db 'Hello, World!', 13, 10, 0

codeseg
extrn aputs:proc

inicio:
mov ax, @data
mov ds, ax

mov si, offset msg
call aputs

mov ah, 04Ch
xor al, al
int 21h

end inicio
