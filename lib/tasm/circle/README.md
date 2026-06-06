# Área del círculo — TASM

Calcula el área de un círculo (`radio² × π` con π = 3) usando
entrada/salida por consola y las rutinas de la biblioteca TASM.

## Código paso a paso

```asm
dataseg
radio dw ?          ; variable para el radio
pi    dw 3          ; aproximación de π
area  dw ?          ; resultado del área
msg1  db 'Ingresa el valor del radio: ', 0
msg2  db 'El area del circulo es ', 0
input db 15 dup(?)  ; buffer para entrada del usuario
cad   db 14 dup(?)  ; buffer para número convertido
cadf  db 50 dup(?)  ; buffer para cadena final
```

1. **Pedir y leer el radio** — `aputs` imprime `msg1`, `agets` lee el input
2. **Convertir a número** — `aatoi` convierte ASCII → entero en `AX`
3. **Calcular área** — `radio × radio × pi` usando `imul`
4. **Convertir resultado** — `aitoa` convierte entero → ASCII en `cad`
5. **Concatenar mensajes** — `astrcat` une `msg2` + `cad` en `cadf`
6. **Imprimir** — `aputs` muestra el resultado
7. **Salir** — `int 21h, ah=04Ch`

## Equivalente en C

```c
#include <stdio.h>

int main() {
    int radio, pi = 3, area;
    char cad[14], cadf[50];

    printf("Ingresa el valor del radio: ");
    scanf("%d", &radio);

    area = radio * radio * pi;

    sprintf(cad, "%d", area);
    sprintf(cadf, "El area del circulo es %s", cad);
    printf("%s\n", cadf);

    return 0;
}
```

## Compilación y ejecución

```bash
tasm /zi str.asm
tasm /zi str_io.asm
tasm /zi circle.asm
tlink /v circle str str_io
circle.exe
```

Ver `lib/tasm/DOSBox/readme.md` para setup del entorno.
