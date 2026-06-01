default rel

extern printf

section .data
msg: db "Hello, World!", 10, 0

section .text
global hello_asm

hello_asm:
%ifdef WIN64
    sub rsp, 40
    lea rcx, [msg]
    call printf
    add rsp, 40
%else
    sub rsp, 8
    lea rdi, [msg]
    xor eax, eax
    call printf wrt ..plt
    add rsp, 8
%endif
    ret

section .note.GNU-stack noexec
