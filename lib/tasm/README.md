# Turbo Assembler (TASM)

Ejemplos educativos en **Turbo Assembler 16-bit para DOS**
como complemento a los ejemplos NASM x86-64 del proyecto principal.

## Estructura

```
lib/tasm/
├── lib/              ← Biblioteca de rutinas comunes
│   ├── str.asm       ← astrlen, astrupr, aatoi, aitoa, astrcat, astrcmp
│   └── str_io.asm    ← aputs, agets, aputsc, insert, delete
├── hello/            ← Hola Mundo con aputs
├── fibo/             ← Fibonacci iterativo
├── circle/           ← Área del círculo (radio² × π)
├── DOSBox/           ← Setup y comandos de compilación
└── README.md         ← Este archivo
```

## Ejemplos

| Ejemplo | Archivo | Conceptos |
|---------|---------|-----------|
| Hola Mundo | `hello/hello.asm` | Llamada a `aputs`, segmentos, int 21h |
| Fibonacci | `fibo/fibo.asm` | Algoritmo iterativo, `aatoi`/`aitoa` |
| Área del círculo | `circle/circle.asm` | `imul`, `astrcat`, entrada/salida completa |

## Dependencias

Todos los ejemplos usan `lib/str.asm` y `lib/str_io.asm`. Ver
`DOSBox/readme.md` para instrucciones de compilación y ejecución.

## Comparativa con NASM x86-64

| Concepto | NASM (x86-64) | TASM |
|----------|---------------|-------------------|
| Formato | `elf64` / `win64` | 16-bit .exe (MZ) |
| Segmentos | planos (flat) | segmentos reales (CS, DS, SS, ES) |
| I/O | `printf` desde C | `int 10h` / `int 21h` |
| Salida | `ret` a C | `int 21h, ah=04Ch` |
| Directivas | `%ifdef WIN64` | `extrn`/`public` |
| Sintaxis | NASM (Intel) | TASM (ideal / simplificado) |
