# bash-scripting

---

| Nº     | Script Name     | Description                                                                                                      |
| ------ | --------------- | ---------------------------------------------------------------------------------------------------------------- |
| **01** | `script01.sh`   | Displays the first and last argument. Handles cases with 0 or 1 argument.                                        |
| **02** | `script02.sh`   | Displays the number of arguments passed and lists them. Returns 0 if arguments are provided, 1 if not.           |
| **03** | `script03.sh`   | Displays the date and time in the format: "It is hh hours, xx minutes on day dd of mmm of yyyy".                 |
| **04** | `script04.sh`   | Prompts for a number, calculates its double, and asks if you want to continue.                                   |
| **05** | `script05.sh`   | Displays the multiplication table of a number from 0 to 10 passed as an argument. Validates the input.           |
| **06** | `script06.sh`   | Classifies and counts files by type in a directory (current by default). Uses `file`.                            |
| **07** | `script07.sh`   | Copies a file to a directory, validates permissions and file type. Adjusts execution permissions.                |
| **08** | `script08.sh`   | Displays a greeting to the current user, date/time, logged-in users, and own processes.                          |
| **09** | `script09.sh`   | Displays information about a user. Allows options `-p`, `-u`, and `--help`. Verifies user existence.             |
| **10** | `script10.sh`   | Searches for a string in files passed as arguments, only if they are regular and readable.                       |
| **11** | `script11.sh`   | Compares files between two directories. Option `-i` to show matches. Supports directory by default.              |
| **12** | *(Not defined)* | ❗ This number does not appear in the original statement. May be reserved for future content.                     |
| **13** | *(Not defined)* | ❗ Same as 12, no content associated in the statement.                                                            |
| **14** | *(Not defined)* | ❗ No description or statement for this number.                                                                   |
| **15** | `script15.sh`   | Interactive agenda script. Supports adding, deleting, listing, and sorting contacts. Default file: `agenda.dat`. |

---

# Shell Scripting Exercises

## 1. `script01`

Create a script named `priult` that returns the first and last argument passed to it.

Usage example:

```bash
priult hello how are you
```

Expected output:

```
The first argument is hello  
The last argument is you
```

**Improvements**:
The script should handle cases with 0 or 1 argument and appropriately indicate that the initial and/or final argument is missing.

---

## 2. `script02`

Create a script named `num_arg` that returns the number of arguments it was called with.

* If arguments are passed, it should return code `0` (success) and list them.
* If no arguments are passed, it should return code `1` (error) and notify it.

Sample output:

```
The passed arguments are:  
ARGUMENT NUMBER 1: X1  
...  
ARGUMENT NUMBER N: XN
```

Or:

```
No arguments were passed
```

---

## 3. `script03`

Create a script named `fecha_hora` that returns the time and date in the format:

```
It is hh hours, xx minutes on day dd of mmm of yyyy
```

Where `mmm` are the initials of the month in letters: `JAN`, `FEB`, `MAR`, ..., `DEC`.

---

## 4. `script04`

Create a script named `doble` that asks for a number and calculates its double. It should:

* Verify that the number is valid.
* Ask if you want to calculate another double before finishing.

Example:

```
Enter a number to calculate its double: 89  
The double of 89 is 178  
Do you want to calculate another double (Y/N)?
```

---

## 5. `script05`

Create a script named `tabla` that receives as an argument a number from 0 to 10 and displays its multiplication table.

Example:

```bash
tabla 5
```

Output:

```
MULTIPLICATION TABLE OF 5  
==========================  
5 * 1 = 5  
5 * 2 = 10  
...  
5 * 10 = 50
```

**Improvements**:
Verify that a single argument is passed and that it is a valid number between 0 and 10.

---

## 6. `script06`

Create a script named `cuenta_tipos` that returns the number of files of each type in a directory.

* Optional argument: the directory to explore (default is the current one).
* Return code: `0` (success), `1` (error).

Output format:

```
The file classification of directory XXXX is:  
There are t text files: X1, X2, ... Xt  
There are dv device files: X1, X2, ... Xdv  
There are d directories: X1, X2, ... Xd  
There are e executable files: X1, X2, ... Xe
```

> **Hint**: use the `file` command.

---

## 7. `script07`

Create a script named `instalar` that receives two arguments: file and directory.

Functionality:

* Copy the file to the directory.
* Change permissions: execution allowed for owner and group, denied for others.
* Verify that the file is valid and that there are appropriate permissions.

Return codes:

* `0`: success
* `1`: error

---

## 8. `script08`

Create a script named `infosis` that displays:

1. Greeting with user and terminal:

   ```
   Hello user uuu, you are connected in terminal ttt
   ```
2. Date and time (use `fecha_hora`).
3. List of logged-in users.
4. List of running processes of the user.

---

## 9. `script09`

Script named `infouser` that receives a login as the only parameter and displays:

* Login
* Full name
* Home directory
* Shell used
* Whether they are connected or not
* List of processes (PID and command line)

**Should allow these options**:

* `-p`: show only process information.
* `-u`: show all information except processes.
* `--help`: show help (usage, syntax, options).

**Return codes**:

* `0`: success
* `1`: syntax error
* `2`: user does not exist

> Part of the information can be obtained from `/etc/passwd` or with `ypcat passwd`.
> Useful utilities: `getopts`, `finger`.

---

## 10. `script10`

Create a script named `bustr` that takes a string and a list of files.

**Functionality:**

* Search for the string in the files.
* Only operate on regular and readable files.

**Example:**

```bash
bustr string file1 file2 file3
```

**Output:**

```
The string "string" was found in the following files:  
file2  
file3
```

**Recursive search:**

```bash
bustr string $(find directory -type f)
```

---

## 11. `script11`

Script named `diffd` with the following syntax:

```bash
diffd [-i] directory1 [directory2]
```

**Functionality:**

* Compare the files (not directories) between two directories.
* Show the files that are present in one and not the other.

**Options:**

* `-i`: invert the logic. Show the files that exist in both directories.

**Notes:**

* If `directory2` is omitted, `directory1` is compared with the current directory.

---

## 15. `script15`

Script named `agenda` with an optional argument: the name of the data file (default is `agenda.dat`).

**Line format:**

```
name:location:balance:phone
```

### Interactive menu:

```
AGENDA (Enter option. 'h' for help) >>
```

### Options:

* `h`: show help.
* `q`: quit.
* `l`: list in columns.

**Example output:**

```
----------------- AGENDA -----------------------------
Name            Location      Balance   Phone
Juan Ruiz       Cartagena     134       968507765
Jaime López     Málaga         95       952410455
Ana Martínez    Madrid        945       914678984
```

* `on`: sort by name (ascending).
* `os`: sort by balance (descending, numerically).
* `a`: add a new entry (validate fields and check for duplicates).
* `b`: delete by name (ask for confirmation).

---

