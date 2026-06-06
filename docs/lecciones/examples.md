# Ejemplos

## Hola Mundo en ensamblador

`hello_asm` imprime "Hello, World!" llamando a `printf` desde
ensamblador, demostrando la integración C + ASM y la convención
de llamada según la plataforma.

```nasm
hello_asm:
    sub rsp, 40         ; shadow space (Win64) / alignment

%ifdef WIN64
    lea rcx, [rel msg]  ; 1er arg en rcx (Win64)
%else
    lea rdi, [rel msg]  ; 1er arg en rdi (System V)
    xor eax, eax        ; variadic: 0 registros XMM
%endif

    call printf
    add rsp, 40
    ret
```

Llamada desde C:

```c
#include "lib/examples/hello.h"

hello_asm();  // imprime "Hello, World!"
```

## Fibonacci

`fibo_asm(n)` calcula el n-ésimo número de Fibonacci de forma
iterativa usando solo registros. Sigue la misma lógica sin
importar la plataforma; solo cambia cómo se obtiene el argumento.

| Parámetro | Linux (System V) | Windows (MS x64) |
|-----------|-----------------|-------------------|
| `n` (1er arg) | `edi` | `ecx` → `edi` |
| `a` | `eax` | `eax` |
| `b` | `ecx` | `ecx` |
| retorno | `eax` | `eax` |

```nasm
fibo_asm:
%ifdef WIN64
    mov edi, ecx        ; Windows: arg en ecx → edi
%endif
    xor eax, eax        ; a = 0
    mov ecx, 1          ; b = 1
    test edi, edi
    jz .done
.loop:
    dec edi
    jz .done_b
    add eax, ecx        ; fib = a + b
    xchg eax, ecx       ; a = b, b = fib
    jmp .loop
.done_b:
    mov eax, ecx
.done:
    ret
```

Llamada desde C:

```c
#include "lib/examples/fibo.h"

int r = fibo_asm(10);  // r = 55
```
