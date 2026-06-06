ideal
dosseg
model small
tamVarsLoc equ 2

codeseg

public astrlen, astrupr, aatoi, aitoa, astrcat, astrcmp

proc astrlen
 push ax
 push di
 mov di, si
 xor al, al
 cld
@@whi: scasb
 jnz @@whi
 mov cx, di
 sub cx, si
 dec cx
 pop di
 pop ax
 ret
endp astrlen

proc astrcat
    push ax
    push si
    push di

    xor al, al
    cld

@@whi:
    scasb
    jnz @@whi

    dec di

@@do:
    lodsb
    stosb
    cmp al, 0
    jne @@do

@@fin:
    pop di
    pop si
    pop ax
    ret
endp astrcat

proc astrupr
 push ax
 push cx
 push si
 push di
 call astrlen
 jcxz @@fin
 mov di, si
 cld
@@do:
 lodsb
 cmp al, 'a'
 jb @@sig
 cmp al, 'z'
 ja @@sig
 sub al, 'a'-'A'
@@sig: stosb
 loop @@do
@@fin: pop di
 pop si
 pop cx
 pop ax
 ret
endp astrupr

proc aatoi
 push bx
 push cx
 push dx
 push si

 call astrupr
 call astrlen
 call obtenSigno
 call obtenBase
 call atou
 cmp dx, 0
 je @@sig
 neg ax

@@sig: pop si
 pop dx
 pop cx
 pop bx
 ret
endp aatoi

proc obtenSigno
 xor dx, dx
 cmp [byte si], '+'
 je @@pos
 cmp [byte si], '-'
 je @@neg
 jmp @@fin
@@neg: mov dx, 1
@@pos: inc si
 dec cx
@@fin: ret
endp obtenSigno

proc obtenBase
 push si
 add si, cx
 dec si

 mov bx, 10
 cmp [byte si], 'B'
 je @@bin
 cmp [byte si], 'H'
 je @@hex
 cmp [byte si], 'D'
 je @@dec
 cmp [byte si], 'O'
 je @@oct
 jmp @@fin

@@bin: mov bx, 2
 jmp @@dec
@@hex: mov bx, 16
 jmp @@dec
@@oct: mov bx, 8
@@dec: dec cx

@@fin:
 pop si
 ret
endp obtenBase

proc atou
 push dx
 push di
 xor ax, ax
 jcxz @@fin
 xor di, di
@@do:
 mov ax, di
 mul bx
 mov dl, [byte si]
 xor dh, dh
 call valC
 add ax, dx
 mov di, ax
 inc si
 loop @@do

 mov ax, di
@@fin: pop di
 pop dx
 ret
endp atou

proc valC
 cmp dx, '9'
 ja @@hex
 sub dx, '0'
 ret
@@hex: sub dx, 55
 ret
endp valC

proc aitoa
local carr: word = tamVarsLoc
push bp
mov  bp, sp
sub sp, tamVarsLoc
mov [carr], cx
push cx
push dx
push ax
push bx
push di

xor cx, cx
xor dx, dx

push ax
cmp bx, 10
je @@dec
jmp @@cont

@@dec:
jmp @@cont

@@cont:
pop ax

@@iter:
    cwd
    xor dx, dx
    div bx
    call charV
    push dx
    inc cx

    cmp ax, 0
    je @@ciclo
jmp @@iter

@@ciclo:
    pop ax
    stosb
loop @@ciclo

@@end:
cmp [carr], 0
je @@exit
mov al, 13
stosb
mov al, 10
stosb

@@exit:
mov [byte di], 0
pop di
pop bx
pop ax
pop dx
pop cx
mov sp, bp
pop bp

endp aitoa

proc charB
mov dl, 'D'
cmp bx, 16
je @@hex
cmp bx, 2
je @@bin
cmp bx, 8
je @@oct
ret

@@hex:
mov dl, 'H'
ret
@@bin:
mov dl, 'B'
ret
@@oct:
mov dl, 'O'
ret
endp charB

proc charV
    cmp dx, 9
    ja @@hex
    add dx, '0'
    ret
    @@hex: add dx, 55
    ret
endp charV

proc astrcmp
    cld

@@whi:
    cmp [byte si], 0
    je @@fin
    cmpsb
    jne @@endwhi
    jmp @@whi

@@endwhi:
    dec si
    dec di

@@fin:
    mov al, [byte si]
    sub al, [byte di]
    cbw
    ret
endp astrcmp

end
