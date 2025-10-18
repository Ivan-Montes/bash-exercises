# bash-scripting

---

| Nº     | Nombre del Script | Descripción                                                                                                          |
| ------ | ----------------- | -------------------------------------------------------------------------------------------------------------------- |
| **01** | `script01.sh`     | Muestra el primer y último argumento. Maneja casos con 0 o 1 argumento.                                              |
| **02** | `script02.sh`     | Muestra la cantidad de argumentos pasados y los lista. Devuelve 0 si hay argumentos, 1 si no.                        |
| **03** | `script03.sh`     | Muestra la fecha y hora con el formato: "Son las hh horas, xx minutos del día dd de mmm de aaaa".                    |
| **04** | `script04.sh`     | Solicita un número, calcula su doble y pregunta si se desea continuar.                                               |
| **05** | `script05.sh`     | Muestra la tabla de multiplicar de un número del 0 al 10 pasado como argumento. Valida la entrada.                   |
| **06** | `script06.sh`     | Clasifica y cuenta archivos por tipo en un directorio (actual por defecto). Usa `file`.                              |
| **07** | `script07.sh`     | Copia un archivo a un directorio, valida permisos y tipo de archivo. Ajusta permisos de ejecución.                   |
| **08** | `script08.sh`     | Muestra saludo al usuario actual, la fecha/hora, usuarios conectados y procesos propios.                             |
| **09** | `script09.sh`     | Muestra información de un usuario. Permite opciones `-p`, `-u`, y `--help`. Verifica existencia del usuario.         |
| **10** | `script10.sh`     | Busca una cadena en archivos pasados como argumentos, sólo si son regulares y legibles.                              |
| **11** | `script11.sh`     | Compara archivos entre dos directorios. Opción `-i` para mostrar coincidencias. Soporta directorio por omisión.      |
| **12** | *(No definido)*   | ❗ Este número no aparece en el enunciado original. Puede reservarse para contenido futuro.                           |
| **13** | *(No definido)*   | ❗ Igual que el 12, no hay contenido asociado en el enunciado.                                                        |
| **14** | *(No definido)*   | ❗ No hay descripción ni enunciado para este número.                                                                  |
| **15** | `script15.sh`     | Script interactivo de agenda. Soporta añadir, borrar, listar y ordenar contactos. Fichero por defecto: `agenda.dat`. |

---
# Ejercicios de Shell Scripting

## 1. `script01`

Crear un script llamado `priult` que devuelva el primer y último argumento que se le han pasado.

Ejemplo de uso:

```bash
priult hola qué tal estás
```

Salida esperada:

```
El primer argumento es hola  
El último argumento es estás
```

**Mejoras**:
El script debe manejar los casos con 0 o 1 argumento e indicar adecuadamente que falta el argumento inicial y/o final.

---

## 2. `script02`

Crear un script llamado `num_arg` que devuelva el número de argumentos con los que ha sido llamado.

* Si se pasan argumentos, debe retornar código `0` (éxito) y listarlos.
* Si no se pasan argumentos, debe retornar código `1` (error) y notificarlo.

Ejemplo de salida:

```
Los argumentos pasados son:  
ARGUMENTO NÚMERO 1: X1  
...  
ARGUMENTO NÚMERO N: XN
```

O bien:

```
No se han pasado argumentos
```

---

## 3. `script03`

Crear un script llamado `fecha_hora` que devuelva la hora y la fecha con el formato:

```
Son las hh horas, xx minutos del día dd de mmm de aaaa
```

Donde `mmm` son las iniciales del mes en letras: `ENE`, `FEB`, `MAR`, ..., `DIC`.

---

## 4. `script04`

Crear un script llamado `doble` que pida un número por teclado y calcule su doble.
Debe:

* Verificar que el número sea válido.
* Preguntar si se desea calcular otro doble antes de finalizar.

Ejemplo:

```
Introduzca un número para calcular el doble: 89  
El doble de 89 es 178  
¿Desea calcular otro doble (S/N)?
```

---

## 5. `script05`

Crear un script llamado `tabla` que reciba como argumento un número del 0 al 10 y muestre su tabla de multiplicar.

Ejemplo:

```bash
tabla 5
```

Salida:

```
TABLA DE MULTIPLICAR DEL 5  
==========================  
5 * 1 = 5  
5 * 2 = 10  
...  
5 * 10 = 50
```

**Mejoras**:
Verificar que se pasa un único argumento y que es un número válido entre 0 y 10.

---

## 6. `script06`

Crear un script llamado `cuenta_tipos` que devuelva el número de ficheros de cada tipo en un directorio.

* Argumento opcional: el directorio a explorar (por defecto, el actual).
* Código de retorno: `0` (éxito), `1` (error).

Formato de salida:

```
La clasificación de ficheros del directorio XXXX es:  
Hay t ficheros de texto: X1, X2, ... Xt  
Hay dv directorios: X1, X2, ... Xdv  
Hay d ficheros ejecutables: X1, X2, ... Xd  
Hay e ficheros desconocidos: X1, X2, ... Xe
```

> **Pista**: usar la orden `file`.

---

## 7. `script07`

Crear un script llamado `instalar` que reciba dos argumentos: fichero y directorio.

Funcionalidad:

* Verificar que el fichero es válido y que hay permisos adecuados.
* Copiar el fichero al directorio.
* Cambiar permisos: ejecución permitida para el dueño y grupo, denegada para otros

Códigos de retorno:

* `0`: éxito
* `1`: error

---

## 8. `script08`

Crear un script llamado `infosis` que muestre:

1. Saludo con usuario y terminal:

   ```
   Hola usuario uuu, está usted conectado en el terminal ttt
   ```
2. Fecha y hora (formato `%fecha %hora`).
3. Lista de usuarios conectados.
4. Lista de procesos del usuario en ejecución.

---

## 9. `script09`

Script llamado `infouser` que recibe un login como único parámetro y muestra:

* Login
* Nombre completo
* Directorio home
* Shell que utiliza
* Si está conectado o no
* Lista de procesos (PID y línea de órdenes)

**Debe permitir estas opciones**:

* `-p`: mostrar solo información de procesos.
* `-u`: mostrar toda la información excepto procesos.
* `--help`: mostrar ayuda (uso, sintaxis, opciones).

**Códigos de retorno**:

* `0`: éxito
* `1`: error de sintaxis
* `2`: usuario no existe

> Parte de la información se puede obtener desde `/etc/passwd` o con `getent passwd`.
> Utilidades útiles: `ps`, `who`.

---

## 10. `script10`

Crear un script llamado `bustr` que reciba una cadena y una lista de ficheros.

Funcionalidad:

* Buscar la cadena en los ficheros.
* Solo operar con ficheros regulares y legibles.

Ejemplo:

```bash
bustr cadena fichero1 fichero2 fichero3
```

Salida:

```
La cadena "cadena" se ha encontrado en los siguientes ficheros:  
fichero2  
fichero3
```

**Búsqueda recursiva**:

```bash
bustr cadena $(find directorio -type f)
```

---

## 11. `script11`

Script llamado `diffd` con sintaxis:

```bash
diffd [-i] directorio1 [directorio2]
```

Funcionalidad:

* Comparar los ficheros (no directorios) entre dos directorios.
* Mostrar los ficheros que están en uno y no en el otro.

**Opciones**:

* `-i`: invertir la lógica. Muestra los ficheros que están en ambos.

**Notas**:

* Si `directorio2` se omite, se compara `directorio1` con el actual.

---

## 15. `script15`

Script llamado `agenda` con un argumento opcional: el nombre del fichero de datos (por defecto `agenda.dat`).

Formato de cada línea:

```
nombre:localidad:saldo:teléfono
```

### Menú interactivo:

```
AGENDA (Introduzca opción. ’h’ para ayuda) >>
```

### Opciones:

* `h`: mostrar ayuda.
* `q`: salir.
* `l`: listar en columnas.

Ejemplo de salida:

```
----------------- AGENDA -----------------------------
Nombre         Localidad     Saldo     Teléfono
Juan Ruiz      Cartagena     134       968507765
Jaime López    Málaga         95       952410455
Ana Martínez   Madrid        945       914678984
```

* `on`: ordenar por nombre (ascendente).
* `os`: ordenar por saldo (descendente, numéricamente).
* `a`: añadir nueva entrada (validar campos y duplicados).
* `b`: borrar por nombre (pedir confirmación).

---


