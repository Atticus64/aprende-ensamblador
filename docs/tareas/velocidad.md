# Calculadora de velocidad

Escribe un programa en Turbo Assembler (modo ideal) que calcule la
velocidad a partir de la distancia y el tiempo ingresados por el
usuario.

## Requisitos

1. Pedir al usuario la **distancia** (número entero sin signo)
2. Pedir al usuario el **tiempo** (número entero sin signo)
3. Calcular `velocidad = distancia / tiempo`
4. Mostrar un mensaje con el resultado: `"La velocidad es: X"`

## Especificaciones técnicas

- Usar **modo ideal** de TASM (`dosseg`, `model small`, `dataseg`/`codeseg`)
- Las variables `distancia` y `tiempo` deben ser de tipo **palabra** (`dw`)
- La división debe hacerse con la instrucción `div`
- Utilizar las utilidades de `lib/tasm/lib/` para entrada/salida:
  - `aputs` — imprimir cadenas
  - `agets` — leer entrada del usuario
  - `aatoi` — convertir ASCII a entero
  - `aitoa` — convertir entero a ASCII
  - `astrcat` — concatenar cadenas
- Terminar el programa con `int 21h, ah=04Ch`

## Pistas

- La división `div` opera sobre `DX:AX`, así que hay que limpiar `DX` con `xor dx, dx` antes de dividir
- Usar `push`/`pop` para preservar valores entre llamadas a las utilidades
- Los buffers deben ser suficientemente grandes para el texto esperado

## Código base

Partí de esta plantilla:

```asm
ideal
dosseg
model small
stack 256

dataseg
codsal db 0


codeseg
inicio:


salir:
mov ah, 04Ch
mov al, [codsal]
int 21h
end inicio
```

## Entrega

Publicá tu código completo en los comentarios abajo.
Incluí el código en un bloque con formato `asm`:

```asm
; tu código acá
```
