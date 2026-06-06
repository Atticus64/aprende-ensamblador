# DOSBox — Setup y compilación TASM

Guía para compilar y ejecutar los ejemplos TASM en **DOSBox**.

## Requisitos

1. **DOSBox** — [descargar](https://www.dosbox.com/)
2. **Turbo Assembler (TASM)** — `tasm.exe`, `tlink.exe`

### Obtener TASM

Incluido en **Borland Turbo Assembler** (freeware, versión 5.0).
Alternativa: **JWASM** (compatible, open source).

## Estructura en DOSBox

Se recomienda montar la carpeta raíz del proyecto como unidad C:

```
mount c: e:\prog\projects\univ\talleres\c-asm
c:
cd lib\tasm
```

## Compilación

Todos los ejemplos dependen de las bibliotecas `str.asm` y `str_io.asm`.

### Biblioteca (compilar una vez)

```bash
tasm /zi lib\str.asm
tasm /zi lib\str_io.asm
```

El flag `/zi` incluye información de debugging (opcional).

### Ejemplo: Hola Mundo

```bash
tasm /zi hello\hello.asm
tlink /v hello\hello lib\str_io
hello.exe
```

### Ejemplo: Fibonacci

```bash
tasm /zi fibo\fibo.asm
tlink /v fibo\fibo lib\str lib\str_io
fibo.exe
```

### Ejemplo: Círculo

```bash
tasm /zi circle\circle.asm
tlink /v circle\circle lib\str lib\str_io
circle.exe
```

### Script todo-en-uno (opcional)

```bash
tasm /zi lib\str.asm
tasm /zi lib\str_io.asm
tasm /zi hello\hello.asm
tasm /zi fibo\fibo.asm
tasm /zi circle\circle.asm
tlink /v hello\hello lib\str_io
tlink /v fibo\fibo lib\str lib\str_io
tlink /v circle\circle lib\str lib\str_io
```

## Notas

- Los `.obj` se generan junto al `.asm` (misma carpeta).
- `tlink /v` permite debugging con Turbo Debugger.
- Si usás JWASM: `jwasm` y `jwlink` con sintaxis similar.
