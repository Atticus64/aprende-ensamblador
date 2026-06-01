# c-asm-learn

Proyecto plantilla para aprender ensamblador moderno (NASM x86-64)
junto con C, usando CMake como sistema de compilación.

## Requisitos

- **CMake** ≥ 3.12
- **NASM** (Netwide Assembler)
- **Compilador C** (MSVC, GCC, o Clang)

## Build y ejecución

```bash
./run.sh                    # debug (Linux / WSL / Git Bash)
cmake -B build && cmake --build build
./build/Debug/c-asm-learn   # Windows (MSVC)
./build/c-asm-learn         # Linux
```

## Ejemplos

| Ejemplo | Archivo ASM | Descripción |
|---------|-------------|-------------|
| Hola Mundo | `lib/examples/hello_asm.asm` | Llamada a `printf` desde ASM |
| Fibonacci | `lib/examples/fibo_asm.asm` | Fibonacci iterativo vía registros |

## Estructura

```
├── .github/workflows/   CI (GitHub Actions)
├── docs/                Documentación
├── lib/examples/        Código ensamblador + headers
├── src/                 main.c
├── CMakeLists.txt       Build system
└── run.sh               Script build + run
```

## Convenciones de llamada

Soporte multiplataforma mediante compilación condicional NASM:

| Plataforma | ABI | 1er arg |
|------------|-----|---------|
| Windows | Microsoft x64 | `rcx` |
| Linux | System V AMD64 | `rdi` |
