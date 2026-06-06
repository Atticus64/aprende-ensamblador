# Hola Mundo — TASM

Ejemplo mínimo que imprime "Hello, World!" en pantalla usando la
rutina `aputs` de la biblioteca TASM.

## Código paso a paso

```asm
dataseg
msg db 'Hello, World!', 13, 10, 0
```

`13, 10` = CR+LF (retorno de carro y nueva línea). `0` = terminador.

```asm
codeseg
extrn aputs:proc
```

`aputs` está en `lib/str_io.asm`. Se resuelve en el enlazado.

```asm
mov ax, @data
mov ds, ax
```

Inicializa `DS` apuntando al segmento de datos (requerido en .exe).

```asm
mov si, offset msg
call aputs
```

`SI` apunta a la cadena, `aputs` la recorre byte a byte imprimiendo
cada carácter con `int 10h ah=0Eh` (modo texto).

```asm
mov ah, 04Ch
xor al, al
int 21h
```

Retorna al DOS con código de salida 0.

## Equivalente en C

```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

## Compilación y ejecución

```bash
tasm /zi str_io.asm
tasm /zi hello.asm
tlink /v hello str_io
hello.exe
```

Ver `lib/tasm/DOSBox/readme.md` para setup del entorno.
