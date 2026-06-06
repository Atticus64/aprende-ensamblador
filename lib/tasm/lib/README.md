# Librería TASM

Rutinas comunes de entrada/salida y manipulación de strings para
los ejemplos en Turbo Assembler para DOS.

## Archivos

| Archivo | Funciones | Descripción |
|---------|-----------|-------------|
| `str.asm` | `astrlen`, `astrupr`, `aatoi`, `aitoa`, `astrcat`, `astrcmp` | Manipulación de cadenas y conversión numérica |
| `str_io.asm` | `aputs`, `agets`, `aputsc`, `insert`, `delete` | Entrada/salida por pantalla y teclado |

## Funciones

### str.asm

| Función | Entrada | Salida | Descripción |
|---------|---------|--------|-------------|
| `astrlen` | `SI` = cadena | `CX` = longitud | Longitud de cadena |
| `astrcat` | `SI` = origen, `DI` = destino | `DI` apunta al final | Concatena cadenas |
| `astrupr` | `SI` = cadena | `SI` = cadena en mayúsculas | Convierte a mayúsculas |
| `aatoi` | `SI` = cadena numérica | `AX` = número | ASCII a entero (base 2, 8, 10, 16) |
| `aitoa` | `DI` = buffer, `BX` = base, `AX` = número, `CX` = 0 | `DI` = cadena | Entero a ASCII |
| `astrcmp` | `SI` = cad1, `DI` = cad2 | `AX` = diferencia | Compara cadenas |

### str_io.asm

| Función | Entrada | Salida | Descripción |
|---------|---------|--------|-------------|
| `aputs` | `SI` = cadena | — | Imprime cadena (int 10h ah=0Eh) |
| `aputsc` | `SI` = cadena | — | Imprime con atributos (int 10h ah=09h) |
| `agets` | `DI` = buffer | `DI` = cadena ingresada | Lee cadena con edición (insert/delete/ flechas) |
