[\[&nbsp;&uarr;&nbsp;\]](./README.md "Go toward the start page")

*Read description: [English](./README.en.md),  [Lithuanian](./README.lt.md).*

# Installation of `real-path`

*Read this in other languages: [Lithuanian](install.lt.md).*

This document describes how to install and configure the `real-path` library.

---

## Installation with `app-launcher`

The library relies on the `APPS_LIB` environment variable to locate its modules.

`APPS_LIB` must already exist, if the `app-launcher` package is installed on the system. In that case, download and extract the library files to the directory specified in the `${APPS_STORE}` variable and run the following command:

```sh
  curl -sSLo - "https://github.com/re-pesk/scripting/archive/refs/heads/main.tar.gz" \
  | tar -xz --strip-components=2 -C "${APPS_STORE}" scripting-main/utils/real-path
  config-link "${APPS_STORE}/real-path/lib/real-path.sh" "${APPS_LIB}" "real-path-full.sh"
```

Installation is completed

## Installation without `app-launcher`

### 1. Environment Setup

If `app-launcher` is not installed, follow these steps:

1. Create a shared library directory (if you do not have one yet), for example:

    ```sh
       mkdir -p "${HOME}/.apps/lib"
    ```

2. Export `APPS_LIB` in your shell configuration file (`~/.profile`, `~/.bashrc`, or `~/.zshrc`):

    ```sh
       export APPS_LIB="${HOME}/.apps/lib"
    ```

3. Apply the changes to your current session:

    ```sh
      . ~/.profile
    ```

### 2. Extracting the Library and creating the Symbolic Link

When sourced, the main entry file `lib/real-path.sh` automatically resolves its true physical location on disk. Therefore, you **only** need to symlink `lib/real-path.sh` into `$APPS_LIB` (there is no need to symlink `lib/real-path-list.sh` — the library will locate it automatically relative to its physical directory).

1. Go to the directory where you want to extract the library. Download and extract the library files:

    ```sh
      cd /the/directory/where/will/be/extracted/the/library 
      curl -sSLo - "https://github.com/re-pesk/scripting/archive/refs/heads/main.tar.gz" \
      | tar -xz --strip-components=2 -C . scripting-main/utils/real-path
    ```

2. Navigate to the `real-path` project root directory:

    ```sh
      cd real-path
    ```

3. Create the symbolic link using the relative path:

    ```sh
      ln -frs "(pwd -P)/lib/real-path.sh" "{APPS_LIB}/real-path.sh"
    ```

## Verifying the Installation

1. Verify that the symbolic link was created properly and is not broken:

    ```sh
      ls -l "${APPS_LIB}/real-path.sh"
    ```

2. Run the automated test suite to ensure all modules load and function correctly:

    * with `app-launcher`:

    ```sh
      "${APPS_STORE}/real-path/test/real-path-test.sh"
    ```

    * without `app-launcher`

    ```sh
      /path/to/real-path/test/real-path-test.sh
    ```

## Uninstallation

To remove the library from your system

1. delete the symbolic link from your `$APPS_LIB` directory:

    ```sh
      rm -f "${APPS_LIB}/real-path.sh"
    ```

2. delete the library directory:

    * with `app-launcher`:

    ```sh
      rm -rf -- "${APPS_STORE}/real-path"
    ```

    * without `app-launcher`

    ```sh
      rm -rf -- /path/to/real-path
    ```
