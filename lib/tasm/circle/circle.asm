dosseg
model small
stack 256

dataseg
codsal db 0
radio dw ?
pi    dw 3
area  dw ?
msg1  db 'Ingresa el valor del radio: ', 0
msg2  db 'El area del circulo es ', 0
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
mov [radio], ax

mov ax, [radio]
mov cx, [radio]
imul cx
mov cx, [pi]
imul cx
mov [area], ax

mov di, offset cad
mov bx, 10
mov cx, 0
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
mov al,[codsal]
int 21h

end inicio
