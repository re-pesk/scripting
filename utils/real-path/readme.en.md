[\[&nbsp;&uarr;&nbsp;\]](../readme.en.md "Go toward the start page")

*[Lithuanian](readme.lt.md).*

*Installation guide: [English](install.en.md), [Lithuanian](install.lt.md).*

# real-path

A pure POSIX `sh` library for reliable and fast resolution of physical file and directory paths. The library automatically follows symbolic link chains, searches for files through `$PATH` and `$APPS_LIB`, and dynamically adapts to available system tools (`realpath`, `readlink`, or `ls -ld`).

## Features

* **100% POSIX `sh` Compliant.** Works in `dash`, `ash`, `bash`, `zsh`, and other standard shells.
* **Safety and Isolation.** All functions execute inside a sub-shell `( ... )`, preventing global variable pollution and keeping the caller's working directory intact.
* **Localized Messages.** Error and usage messages are automatically displayed in Lithuanian (`lt_LT`) or English based on the `$LANG` environment variable.
* **Modular Loading.** Load only the base single-file functions or the full suite including batch processing utilities.

## Project Structure

```text
real-path/
├── lib/
│   ├── real-path.sh        # Main entry point (get_real_path, get_real_dir)
│   └── real-path-list.sh   # Batch processing functions (map and list)
├── test/
│   └── real-path-tests.sh  # Automated test suite
├── install.sh              # Automated installation/uninstallation script
├── install.lt.md           # Manual installation guide in Lithuanian
├── install.lt.md           # Manual installation guide in English
├── README.md               # Main description page
├── README.lt.md            # Description in Lithuanian
└── README.en.md            # Description in English
```

## Installation

Ensure that the `$APPS_LIB` environment variable is set and points to an existing library directory on your system.

*For the installation guide, see [install.en.md](install.en.md).*

## Loading into Scripts

This library is designed strictly to be sourced into other scripts using the `.` command.

### 1. Base Mode (Single-file functions only)

Loads only `get_real_path` and `get_real_dir`:

```sh
  . "\${APPS_LIB}/real-path.sh"
```

### 2. Full Mode (All functions)

Additionally loads batch processing functions from `real-path-list.sh`:

```sh
  REAL_PATH_MODE="full" . "\${APPS_LIB}/real-path.sh"
```

## Exit Codes

All library functions adhere to a strict exit code convention:

* **`0`** – All specified paths were successfully resolved.
* **`1`** – Missing required arguments (prints usage instructions to `stderr`).
* **`2`** – At least one file was not found, a key is missing from the map, or a symbolic link is broken (prints an error message to `stderr`).

---

## Function Reference and Examples

### Single-File Functions (`real-path.sh`)

#### `get_real_path <file>`

Resolves and outputs the real physical path to a single specified file.

```sh
  real_file="$(get_real_path "./my_symlink.sh")"
  echo "${real_file}"
  # Output: '/home/user/project/script.sh'
```

#### `get_real_dir <file>`

Resolves and outputs the real physical path to the file's directory (excluding the filename).

```sh
  SCRIPT_DIR="$(get_real_dir "$0")"
  echo "${SCRIPT_DIR}"
  # Output: /home/user/project
```

---

### Batch Processing Functions (`real-path-list.sh`)

To prevent issues with spaces or newlines in filenames, all list functions separate elements using the **ASCII Record Separator (`RS` / `\036`)** character (with no trailing delimiter). If a file is not found, an empty value is inserted between delimiters so the item count always matches the argument count.

#### `get_real_path_map <file1> [file2 ...]`

Returns a `key:real_path` map separated by the `RS` character.

```sh
  path_map="$(get_real_path_map "file.txt" "missing.txt")"
  # Content: 'file.txt:/path/to/file/file.txt[RS]missing.txt:'
```

#### `get_real_path_list_by_key <map> <key1> [key2 ...]`

Extracts real paths from a previously generated map by the specified keys.

```sh
  paths="$(get_real_path_list_by_key "${path_map}" "file.txt" "missing.txt")"
  # Content: '/path/to/file/file.txt[RS]'
```

#### `get_real_path_list <file1> [file2 ...]`

Directly resolves multiple file paths at once and returns them separated by the `RS` character.

```sh
  paths="$(get_real_path_list "file.txt" "symlink.sh" "missing.txt")"
  # Content: '/path/to/file/file.txt[RS]/path/to/symlink/target/target.sh[RS]'
  
```

#### `get_real_dir_list <file1> [file2 ...]`

Directly resolves multiple directory paths at once and returns them separated by the `RS` character.

```sh
  dirs="$(get_real_dir_list "file.txt" "symlink.sh")"
  # Content: '/path/to/file[RS]/path/to/symlink/target'
```

### Safely Iterating Over an `RS`-Separated List

```sh
  remaining="$(get_real_path_list "a.txt" "b.txt")"
  has_more=1
  
  while [ "${has_more}" -eq 1 ]; do
    case "${remaining}" in
      ( *"${RS}"* )
        path="${remaining%%"${RS}"*}"
        remaining="${remaining#*"${RS}"}"
        ;;
      ( * )
        path="${remaining}"
        has_more=0
        ;;
    esac
    echo "Resolved path: '${path}'"
  done
```

## Testing

To run the automated test suite execute this commands (requires the `APPS_LIB` environment variable to be set):

```sh
  chmod +x test/real-path-test.sh
  ./test/real-path-test.sh
```
