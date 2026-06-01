extern printf

section .data
msg: db "Hello, World!", 10, 0

section .text
global hello_asm

hello_asm:
    sub rsp, 40

%ifdef WIN64
    lea rcx, [rel msg]
%else
    lea rdi, [rel msg]
    xor eax, eax
%endif

    call printf
    add rsp, 40
    ret
