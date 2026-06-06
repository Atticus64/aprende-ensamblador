# Guía de Turbo Assembler (TASM)

## Modos de sintaxis

| Aspecto | Ideal | Simplificado |
|---------|-------|--------------|
| Funciones | `proc` / `endp` | `label:` y `ret` |
| Labels locales | `@@while`, `@@fin` | `while:`, `fin:` |
| Variables locales | `local x: word = N` | No tiene |
| Se usa en | `lib/str.asm`, `lib/str_io.asm` | ejemplos `hello/`, `fibo/`, `circle/` |

Ambos modos se linkean sin problema.

## Segmentos: cómo se usan en la práctica

| Registro | ¿Qué contiene? | ¿Cuándo se usa? |
|----------|---------------|-----------------|
| `CS` | Dirección del código | Lo setea DOS al cargar el programa. No se toca. |
| `DS` | Dirección de las variables | **Siempre al inicio**: `mov ax, @data` / `mov ds, ax`. Sin esto, leer variables da basura. |
| `SS` | Dirección de la pila | Lo setea DOS. `SP` arranca apuntando al tope del stack. |
| `ES` | Segmento extra para cadenas | **Idem DS**: `mov es, ax`. `stosb`/`scasb` usan `ES:DI`. Las utilidades fallan si no está. |

En `model small`, DS y SS apuntan al mismo segmento (64 KB para datos + pila).

## Instrucciones de cadenas: cómo funcionan en las utilidades

Todas operan con `SI` (fuente) y `DI` (destino), auto-incrementan si `DF = 0` (`cld`).

| Instrucción | Qué hace | Dónde se usa en el proyecto |
|-------------|----------|------------------------------|
| `lodsb` | `AL = [SI]; SI++` | `aputs`: leer cada caracter a imprimir |
| `stosb` | `[DI] = AL; DI++` | `aitoa`, `astrcat`: escribir en el buffer destino |
| `scasb` | `cmp AL, [DI]; DI++` | `astrlen`: buscar el `0` final; `astrcat`: encontrar fin del destino |
| `movsb` | `[DI] = [SI]; SI++; DI++` | Copia bloques de memoria (no se usa directamente en las utilidades, pero `astrcat` emula su comportamiento) |

```asm
; Ejemplo vivo: cómo astrlen cuenta caracteres
@@whi: scasb        ; compara AL(0) con [DI], DI++
    jnz @@whi       ; si no encontró el 0, sigue
; al finalizar, DI - SI - 1 = longitud
```

## Interrupciones: para qué sirve cada una

| Int | AH | ¿Qué problema resuelve? | ¿Dónde se usa? |
|-----|----|------------------------|-----------------|
| `int 10h` | `0Eh` | **Imprimir un carácter** en pantalla (modo teletype). Avanza el cursor solo. | `aputs`: imprime carácter por carácter |
| `int 10h` | `03h` | **Saber dónde está el cursor** (devuelve fila/columna en DX). | `agets`: para mover el cursor con flechas |
| `int 10h` | `02h` | **Mover el cursor** a una posición (DH=fila, DL=columna). | `agets`: posicionar cursor al editar |
| `int 10h` | `09h` | **Imprimir con atributo** (color). CX = cantidad de repeticiones. | `aputsc`: imprime caracteres con estilo |
| `int 16h` | `10h` | **Leer una tecla** (espera hasta que el usuario presione). Devuelve scan code en AH, ASCII en AL. | `agets`: capturar teclas, incluyendo flechas (scan codes 75/77) |
| `int 21h` | `4Ch` | **Terminar el programa** y volver a DOS. AL = código de salida. | Todos los programas al finalizar |

### Ejemplo con int 16h (lectura de teclado)

```asm
; agets espera una tecla
mov ah, 10h
int 16h            ; AH = scan code, AL = carácter

cmp ah, 75         ; ¿flecha izquierda?
je @@izq
cmp ah, 77         ; ¿flecha derecha?
je @@der
cmp al, 8          ; ¿backspace?
je @@del
cmp al, 13         ; ¿Enter?
je @@fin
; si no, es un carácter normal → lo escribe
```

## Instrucciones aritméticas en contexto real

### mul / imul — Multiplicar

En `circle.asm`:
```asm
mov ax, [radio]    ; AX = radio
mov cx, [radio]
imul cx            ; AX = radio * radio (con signo)
mov cx, [pi]       ; CX = 3
imul cx            ; AX = (radio * radio) * 3 = área
```
`imul` es "integer multiply" con signo. Como radio nunca es negativo, da igual usar `mul` o `imul`.

### div / idiv — Dividir

En `aitoa`:
```asm
xor dx, dx          ; limpia parte alta (requerido por div)
div bx              ; AX = AX / BX (cociente), DX = AX % BX (resto = dígito)
```
`div` siempre divide `DX:AX` entre el operando. Por eso hay que limpiar `DX` antes.

### add / sub — Sumar y restar

```asm
add ax, bx          ; más rápido que mul para multiplicar por 2
add ax, ax          ; AX = AX * 2 (sin usar mul)

sub cx, 1           ; o más común: dec cx
```

### xchg — Intercambiar registros

En `fibo.asm`:
```asm
add ax, bx          ; fib = a + b
xchg ax, bx         ; a = b, b = fib (intercambio en 1 instrucción)
```
`xchg` hace el swap sin necesidad de un registro temporal.

## Cómo se combinan instrucciones en un programa real

### Flujo del programa de ejemplo (`fibo.asm`)

```asm
; 1. Inicializar segmentos
mov ax, @data
mov ds, ax
mov es, ax          ; sin ES, scasb falla

; 2. Pedir número
mov si, offset msg1
call aputs          ; lodsb + int 10h

; 3. Leer entrada
mov di, offset input
call agets          ; int 16h + stosb + manejo de flechas

; 4. Convertir a entero
mov si, offset input
call aatoi          ; scasb + mul + lógica de conversión

; 5. Calcular Fibonacci
mov cx, ax          ; contador = n
xor ax, ax          ; a = 0
mov bx, 1           ; b = 1
test cx, cx
jz .done
.loop:
    dec cx          ; n--
    jz .done_b
    add ax, bx      ; fib = a + b
    xchg ax, bx     ; a = b, b = fib
    jmp .loop

; 6. Convertir resultado a texto
mov di, offset cad
mov bx, 10
xor cx, cx
call aitoa          ; div + charV + stosb

; 7. Concatenar mensajes
mov si, offset msg2
mov di, offset cadf
call astrcat        ; scasb + lodsb + stosb
mov si, offset cad
mov di, offset cadf
call astrcat

; 8. Mostrar y salir
mov si, offset cadf
call aputs
mov ah, 04Ch
xor al, al
int 21h
```

## Convención de llamada de las utilidades

| Registro | Se usa para pasar… |
|----------|--------------------|
| `SI` | Cadena de entrada (fuente) |
| `DI` | Buffer de salida (destino) |
| `AX` | Número (entrada en `aitoa`, salida en `aatoi`) |
| `BX` | Base numérica (2, 10, 16) |
| `CX` | Flag CR+LF en `aitoa`; salida de longitud en `astrlen` |
| `AX` (retorno) | Resultado numérico |

## Comparativa TASM vs NASM x86-64

| Concepto | TASM | NASM (x86-64) |
|----------|------|---------------|
| Tamaño de palabra | 16 bits | 64 bits |
| Registros | `ax`, `bx`, `cx`, `dx`, `si`, `di`, `bp`, `sp` | `rax`–`rsp` + `r8`–`r15` |
| I/O | `int 10h` / `int 21h` (BIOS/DOS) | `printf` / syscalls |
| Paso de args | `SI`, `DI`, `AX`, `BX`, `CX` | `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9` |
| Función | `proc` / `endp` | `global` / `extern` |
| Condicional | `ifdef` / `endif` | `%ifdef` / `%endif` |
