# Guía de sintaxis NASM x86-64

## Convenciones de llamada

### System V AMD64 ABI (Linux, macOS)

| Argumento | Registro |
|-----------|----------|
| 1ro | `rdi` |
| 2do | `rsi` |
| 3ro | `rdx` |
| 4to | `rcx` |
| 5to | `r8` |
| 6to | `r9` |
| retorno | `rax` |

Callee-saved: `rbx`, `rbp`, `r12`–`r15`

### Microsoft x64 ABI (Windows)

| Argumento | Registro |
|-----------|----------|
| 1ro | `rcx` |
| 2do | `rdx` |
| 3ro | `r8` |
| 4to | `r9` |
| retorno | `rax` |

Callee-saved: `rbx`, `rbp`, `rdi`, `rsi`, `r12`–`r15`

El caller debe reservar **shadow space** (32 bytes) en la pila
antes de llamar a una función.

## Sintaxis NASM (Intel)

### Secciones

```nasm
section .text    ; código ejecutable
section .data    ; datos inicializados
section .bss     ; datos sin inicializar
```

### Definir datos

```nasm
msg:  db "Hello", 0    ; bytes (string)
num:  dq 42             ; quad word (8 bytes)
arr:  times 10 dd 0     ; array de 10 dwords
```

### Saltos condicionales

| Instrucción | Salta si |
|-------------|----------|
| `jz` / `je` | zero / igual |
| `jnz` / `jne` | not zero / no igual |
| `jl` / `jb` | menor / below |
| `jg` / `ja` | mayor / above |
| `jle` | menor o igual |
| `jge` | mayor o igual |

### Directivas útiles

```nasm
global mi_func      ; exportar símbolo
extern printf       ; importar símbolo externo
```

### Llamar funciones C desde ASM

```nasm
; Linux (System V)
mov edi, fmt        ; 1er arg
mov esi, 42         ; 2do arg
xor eax, eax        ; variadic: 0 registros XMM
call printf

; Windows (MS x64)
sub rsp, 32         ; shadow space
mov rcx, fmt        ; 1er arg
mov edx, 42         ; 2do arg
call printf
add rsp, 32
```

### Syscalls Linux x86-64

| syscall | Número (`rax`) | arg1 | arg2 | arg3 |
|---------|----------------|------|------|------|
| `read` | 0 | `rdi` (fd) | `rsi` (buf) | `rdx` (count) |
| `write` | 1 | `rdi` (fd) | `rsi` (buf) | `rdx` (count) |
| `exit` | 60 | `rdi` (code) | - | - |

### Compilación condicional con NASM

```nasm
%ifdef WIN64
    ; código para Windows x64
%else
    ; código para Linux x86-64
%endif
```

La macro `WIN64` se define automáticamente por CMakeLists.txt
cuando se compila en Windows.
