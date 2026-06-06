# Fibonacci — TASM

Calcula el n-ésimo número de Fibonacci de forma iterativa usando
solo registros, con entrada/salida por consola.

## Código paso a paso

### Entrada

```asm
mov si, offset msg1     ; "Ingresa el valor de n: "
call aputs
mov di, offset input
call agets              ; leer número como ASCII
mov si, offset input
call aatoi              ; convertir a entero
```

### Algoritmo iterativo

```asm
mov cx, ax              ; cx = n
xor ax, ax              ; a = 0
mov bx, 1               ; b = 1
```

Misma lógica que la versión NASM en `lib/examples/fibo_asm.asm`:
- `AX` = `a` (empieza en 0)
- `BX` = `b` (empieza en 1)
- Por cada iteración: `a += b`, luego intercambia `a ↔ b`

Casos borde:
- Si `n = 0` → salta directo a `.done` (retorna 0)
- Si `n = 1` → el `dec cx` lo deja en 0, salta a `.done_b` (retorna `bx = 1`)

### Salida

```asm
mov di, offset cad
mov bx, 10
xor cx, cx
call aitoa              ; entero → ASCII base 10
```

Luego concatena `msg2` + resultado y lo imprime.

## Equivalente en C

```c
#include <stdio.h>

int main() {
    int n;

    printf("Ingresa el valor de n: ");
    scanf("%d", &n);

    int a = 0, b = 1;

    if (n == 0) goto done;
    for (int i = 1; i < n; i++) {
        int fib = a + b;
        a = b;
        b = fib;
    }
    printf("Fibonacci(n) = %d\n", b);
    return 0;

done:
    printf("Fibonacci(n) = 0\n");
    return 0;
}
```

## Comparación con NASM x86-64

| Aspecto | NASM (lib/examples/) | TASM (este) |
|---------|----------------------|-------------|
| Convención | System V / MS x64 | DOS |
| Argumento | `edi` / `ecx` | `ax` (vía `aatoi`) |
| I/O | `printf` desde C | `aputs`/`agets` (int 10h) |
| Salida del programa | `ret` a C | `int 21h, ah=04Ch` |

## Compilación y ejecución

```bash
tasm /zi str.asm
tasm /zi str_io.asm
tasm /zi fibo.asm
tlink /v fibo str str_io
fibo.exe
```

Ver `lib/tasm/DOSBox/readme.md` para setup del entorno.
