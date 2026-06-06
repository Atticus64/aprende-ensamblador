# Introducción a Turbo Assembler — Modo Ideal

## ¿Qué es TASM?

Turbo Assembler (TASM) de Borland para x86 16-bit en DOS.
El modo **ideal** es su sintaxis más estructurada: usa `proc`/`endp`
para funciones, variables locales con `local`, y labels con `@@`.

## Registros: ¿cuándo se usa cada uno?

### Propósito general

| Registro | Partes | ¿Para qué sirve en la práctica? |
|----------|--------|---------------------------------|
| `AX` | `AH` / `AL` | **Resultado de operaciones**. Las utilidades devuelven valores acá. `aatoi` deja el número en `AX`; `aitoa` recibe el número por `AX`. `mul`/`div` siempre usan `AX`. |
| `BX` | `BH` / `BL` | **Base numérica**. En `aitoa` y `aatoi` se pasa por `BX` la base (2, 10, 16). También se usa como "acumulador extra" en Fibonacci (`fibo.asm` guarda `b` en `BX`). |
| `CX` | `CH` / `CL` | **Contador**. `astrlen` devuelve la longitud en `CX`. `loop` decrementa `CX` automáticamente. `aitoa` lo usa como contador de dígitos. |
| `DX` | `DH` / `DL` | **Dato auxiliar**. En `mul`/`div` guarda la parte alta del resultado. En `aatoi` guarda el signo. |

Prácticamente:
```asm
; AX = resultado de operaciones
mov si, offset numero
call aatoi       ; AX = 255
add ax, 1        ; AX = 256
mov di, offset cad
mov bx, 10
xor cx, cx
call aitoa       ; cad = "256"
```

### Índice

| Registro | ¿Para qué sirve en la práctica? |
|----------|---------------------------------|
| `SI` | **Fuente de datos**. Las utilidades reciben la cadena de entrada por `SI` (`aputs`, `aatoi`, `astrlen`, `astrcmp`). |
| `DI` | **Destino de datos**. Las utilidades reciben el buffer de salida por `DI` (`agets`, `aitoa`, `astrcat`). |
| `BP` | **Pila y variables locales**. Las funciones con `local` guardan `BP` y lo usan como referencia para acceder a parámetros y locales. |
| `SP` | **Tope de la pila**. `push` decrementa `SP`, `pop` lo incrementa. No se modifica manualmente. |

Prácticamente:
```asm
; SI = origen (lo que ya existe)
; DI = destino (donde se escribe)
mov si, offset mensaje
mov di, offset buffer
call astrcat     ; copia mensaje al final de buffer
```

### Segmentos

| Registro | ¿Para qué sirve en la práctica? |
|----------|---------------------------------|
| `CS` | El procesador busca las instrucciones en `CS:IP`. No se modifica en programas chicos. |
| `DS` | **Datos del programa**. Sin `DS` apuntando a `@data`, no podés leer variables. |
| `SS` | **Pila**. `SP` opera dentro de `SS`. En `model small` comparte segmento con `DS`. |
| `ES` | **Destino de cadenas**. Instrucciones como `stosb`, `scasb`, `movsb` usan `ES:DI`. Sin ES inicializado, `astrcat` y `agets` fallan. |

Prácticamente — esto es **obligatorio** al arrancar cualquier programa:
```asm
mov ax, @data
mov ds, ax
mov es, ax      ; ES también, porque las utilidades usan cadenas (scasb, stosb)
```

Sin estas dos líneas, `aputs` imprime basura y `agets` escribe en cualquier lado.

### FLAGS

| Flag | ¿Para qué sirve en la práctica? |
|------|---------------------------------|
| `CF` | **Detección de desbordamiento**. Después de `add`/`sub`, si el resultado no entra en 16 bits, `CF = 1`. |
| `ZF` | **Comparaciones y loops**. `cmp` activa `ZF` si son iguales; `test` lo activa si es cero. `jz` salta si `ZF = 1`. |
| `SF` | **Detección de negativos**. Después de operaciones con signo. |
| `DF` | **Dirección de cadenas**. `cld` lo pone en 0 (auto-incremento). Las utilidades hacen `cld` al inicio. Si está invertido, `astrcat` funciona al revés. |

Prácticamente:
```asm
test cx, cx      ; ¿CX es cero?
jz .fin          ; si ZF está activo, salta a .fin

cmp al, 0        ; ¿llegamos al final de la cadena?
je .fin          ; sí → terminamos

loop .ciclo      ; decrementa CX; si CX ≠ 0, salta
```

## Instrucciones clave: cómo y por qué se usan

### mov — Copiar datos

```asm
mov ax, @data    ; ax = dirección del segmento de datos
mov ds, ax       ; ds ahora apunta a los datos
```
Es la instrucción más común. Sin `mov` no se puede inicializar nada.

### xor — Poner en cero (más rápido que mov reg, 0)

```asm
xor ax, ax       ; ax = 0 (ocupa 2 bytes, mov ax, 0 ocupa 3)
```
Se usa para inicializar contadores y acumuladores. En Fibonacci: `xor ax, ax` pone `a = 0`.

### add / sub — Aritmética básica

```asm
add ax, bx       ; ax = ax + bx
sub cx, 1        ; cx = cx - 1
```
`dec cx` hace lo mismo que `sub cx, 1` pero ocupa menos bytes.

### imul / mul — Multiplicación con signo / sin signo

```asm
mov ax, [radio]
imul cx          ; ax = ax * cx (el resultado cabe en ax)
```
En `circle.asm`: `radio * radio * pi`. La multiplicación siempre usa `AX`.

### div / idiv — División

```asm
xor dx, dx       ; limpiar parte alta del dividendo
div bx           ; ax = ax / bx, dx = ax % bx
```
En `aitoa` se usa para extraer dígitos de derecha a izquierda.

### cmp — Comparar (solo afecta FLAGS, no modifica registros)

```asm
cmp al, 0        ; ¿al es 0?
je .fin          ; sí → terminamos

cmp cx, 5
jg .mayor        ; cx > 5

cmp al, 'a'
jb .no_minuscula ; al < 'a'
```

### test — AND bit a bit sin modificar operandos

```asm
test ax, ax      ; ¿ax es 0?
jz .es_cero

test al, 1       ; ¿al es impar?
jnz .impar
```
Más común que `cmp reg, 0` para chequear cero.

### jmp / jz / jnz / jg / jl — Saltos condicionales

```asm
jmp .loop        ; salta siempre (bucle infinito hasta que algo lo rompa)
jz .fin          ; salta si ZF = 1 (última operación dio cero)
jnz .ciclo       ; salta si ZF = 0 (última operación no dio cero)
jg .mayor        ; salta si es mayor (después de cmp)
jl .menor        ; salta si es menor
```
Los saltos son la única forma de hacer condiciones y loops en ASM.

### loop — Decrementar CX y saltar si no es cero

```asm
mov cx, 10
.ciclo:
    ; hacer algo 10 veces
loop .ciclo
```
Equivale a `dec cx; jnz .ciclo`. Se usa cada vez que se necesita repetir algo N veces.

### push / pop — Pila

```asm
push ax          ; guarda ax en la pila
push bx
; ... hacer algo con ax y bx ...
pop bx           ; restaura bx
pop ax           ; restaura ax
```
Se usa para **preservar registros** dentro de funciones. La pila es LIFO: el último en entrar es el primero en salir.

### cld / std — Dirección de cadenas

```asm
cld              ; auto-incremento (adelante) — el estándar
std              ; auto-decremento (atrás) — raro
```
Todas las utilidades hacen `cld` al empezar. Sin `cld`, `lodsb`/`stosb` podrían ir en dirección incorrecta.

### lodsb / lodsw — Cargar byte/word desde [SI] e incrementar SI

```asm
lodsb            ; al = [si]; si++
```
`aputs` la usa para leer cada caracter de la cadena a imprimir.

### stosb / stosw — Guardar byte/word en [DI] e incrementar DI

```asm
stosb            ; [di] = al; di++
```
`astrcat` y `agets` la usan para escribir caracteres en el buffer destino.

### scasb — Comparar [DI] con AL e incrementar DI

```asm
scasb            ; cmp al, [di]; di++
```
`astrlen` la usa para buscar el `0` terminador. `astrcat` la usa para encontrar el final del destino.

### int — Interrupción

```asm
mov ah, 04Ch     ; función "terminar programa"
xor al, al       ; código de salida 0
int 21h          ; llamar al DOS
```
`int` es la forma de pedirle servicios al sistema operativo o al BIOS.

## Cómo se usan las instrucciones en las utilidades

### astrlen — Buscar el terminador con scasb

```asm
proc astrlen
    push ax
    push di
    mov di, si      ; DI apunta al inicio
    xor al, al      ; AL = 0 (terminador)
    cld
@@whi: scasb        ; compara [DI] con AL, DI++
    jnz @@whi       ; si no es cero, sigue
    mov cx, di
    sub cx, si
    dec cx          ; CX = DI - SI - 1 (descontar el terminador)
    pop di
    pop ax
    ret
endp astrlen
```
**Uso real de**: `scasb`, `xor al, al`, `cld`, `push`/`pop`

### aputs — Recorrer e imprimir con lodsb e int 10h

```asm
proc aputs
    push ax
    push bx
    mov ah, 0Eh     ; función "escribir teletype"
    mov bh, 0
    cld
@@while: lodsb      ; AL = [SI], SI++
    cmp al, 0
    je @@endwhi
    int 10h         ; imprime AL en pantalla
    jmp @@while
@@endwhi:
    pop bx
    pop ax
    ret
endp aputs
```
**Uso real de**: `lodsb`, `cmp al, 0`, `je`, `jmp`, `int 10h`

### aitoa — Extraer dígitos con div

```asm
    xor cx, cx      ; contador de dígitos = 0
@@iter:
    cwd
    xor dx, dx      ; DX = 0 (dividendo alto)
    div bx          ; AX = AX / BX, DX = AX % BX (el dígito)
    call charV      ; convierte DX a carácter
    push dx         ; guarda el dígito en la pila
    inc cx          ; contador++
    cmp ax, 0
    je @@ciclo      ; ya no quedan dígitos
    jmp @@iter
@@ciclo:
    pop ax          ; recupera dígito (en orden inverso)
    stosb           ; lo escribe en el buffer
    loop @@ciclo
```
**Uso real de**: `div`, `push`/`pop`, `loop`, `stosb`

## Las utilidades en acción: ejemplo práctico

### Pedir número, duplicarlo y mostrarlo

```asm
dataseg
pedir  db 'Ingresa un numero: ', 0
buffer db 15 dup(?)
result db 14 dup(?)

codeseg
extrn aputs:proc, agets:proc, aitoa:proc, aatoi:proc

proc duplicar
    mov si, offset pedir
    call aputs

    mov di, offset buffer
    call agets

    mov si, offset buffer
    call aatoi       ; AX = número ingresado

    add ax, ax       ; AX = número * 2 (más rápido que mul)

    mov di, offset result
    mov bx, 10
    xor cx, cx
    call aitoa       ; result = "XX"

    mov si, offset result
    call aputs       ; imprime el resultado

    mov ah, 04Ch
    xor al, al
    int 21h
endp duplicar
```
Cada instrucción tiene un propósito concreto:
- `add ax, ax` duplica (más rápido que `imul ax, 2`)
- `xor cx, cx` pone el flag CR+LF en "sin salto"
- `mov bx, 10` configura base decimal

## Buenas prácticas

1. **Inicializar DS y ES** siempre al arranque con `@data`.
2. **Terminador nulo** (`0`) obligatorio en todas las cadenas.
3. **Buffers con tamaño suficiente** — las utilidades no verifican límites.
4. **`cld` antes de operaciones con cadenas** (dirección ascendente).
5. **`model small`** es el estándar: CS = 64 KB, DS = SS = 64 KB.
