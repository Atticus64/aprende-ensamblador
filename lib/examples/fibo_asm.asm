section .text
global fibo_asm

fibo_asm:
%ifdef WIN64
    mov edi, ecx
%endif

    xor eax, eax
    mov ecx, 1

    test edi, edi
    jz .done

.loop:
    dec edi
    jz .done_b

    add eax, ecx
    xchg eax, ecx
    jmp .loop

.done_b:
    mov eax, ecx

.done:
    ret
