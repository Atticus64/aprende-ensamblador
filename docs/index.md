# c-asm-learn

Proyecto plantilla para aprender ensamblador NASM x86-64 junto con C,
con soporte multiplataforma (Windows y Linux).

## Estructura del proyecto

```
├── .github/workflows/     CI (GitHub Actions)
├── docs/                  Documentación
│   ├── index.md           Este archivo
│   ├── examples.md        Documentación de ejemplos
│   └── asm.md             Guía de sintaxis NASM
├── lib/examples/          Código ensamblador + headers C
│   ├── hello.h            Header Hola Mundo
│   ├── hello_asm.asm      Implementación Hola Mundo (printf)
│   ├── fibo.h             Header Fibonacci
│   └── fibo_asm.asm       Implementación Fibonacci iterativa
├── src/
│   └── main.c             Punto de entrada
├── CMakeLists.txt         Build system
└── run.sh                 Script build + run
```

## Módulos

| Módulo | Archivo ASM | Descripción | Documentación |
|--------|-------------|-------------|---------------|
| Hola Mundo | `lib/examples/hello_asm.asm` | Llamada a `printf` desde ASM | [examples.md](examples.md) |
| Fibonacci | `lib/examples/fibo_asm.asm` | Fibonacci iterativo | [examples.md](examples.md) |

## Build System

| Comando | Descripción | Flags C |
|---------|-------------|---------|
| `./run.sh` | Debug | `-g -O0 -Wall -Wextra` |
| `./run.sh release` | Release | `-O2 -march=native -Wall -Wextra` |

### Build manual

```bash
cmake -B build -DRELEASE=OFF
cmake --build build
./build/c-asm-learn        # Linux
./build/Debug/c-asm-learn  # Windows (MSVC)
```

## Quick Start

```bash
./run.sh                   # Linux / WSL / Git Bash
```

## Convenciones de llamada

El proyecto es **multiplataforma**: los archivos `.asm` usan
compilación condicional (`%ifdef WIN64`) para adaptarse a la
ABI de cada sistema:

| Plataforma | ABI | 1er argumento |
|------------|-----|---------------|
| Windows | Microsoft x64 | `rcx` |
| Linux | System V AMD64 | `rdi` |
