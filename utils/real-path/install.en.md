# Manual Installation

*Read this in other languages: [Lietuvių](install.lt.md)*

This document describes how to manually install and configure the `real-path` library without using the `install.sh` script.

---

## 1. Environment Setup

The library relies on the `APPS_LIB` environment variable to locate its modules. `APPS_LIB` must already exist, if the `app-launcher` package is installed on the system. In that case, copy the library directory to the directory specified in the `${APPS_STORE}` variable and run the following command:

```sh
  config-link "${APPS_STORE}/real-path/lib/real-path.sh" "${APPS_LIB}" "real-path-full.sh"
```

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

## 2. Creating the Symbolic Link

When sourced, the main entry file `lib/real-path.sh` automatically resolves its true physical location on disk. Therefore, you **only** need to symlink `lib/real-path.sh` into `$APPS_LIB` (there is no need to symlink `lib/real-path-list.sh` — the library will locate it automatically relative to its physical directory).

1. Navigate to the `real-path` project root directory:

    ```sh
      cd /path/to/real-path
    ```

2. Create the symbolic link using the absolute path:

    ```sh
      ln -frs "(pwd -P)/lib/real-path.sh" "{APPS_LIB}/real-path.sh"
    ```

## 3. Verifying the Installation

1. Verify that the symbolic link was created properly and is not broken:

    ```sh
      ls -l "${APPS_LIB}/real-path.sh"
    ```

2. Run the automated test suite to ensure all modules load and function correctly:

    ```sh
      ./test/real-path-test.sh
    ```

## 4. Manual Uninstallation

1. To remove the library from your system, simply delete the symbolic link from your `$APPS_LIB` directory:

    ```sh
      rm -f "${APPS_LIB}/real-path.sh"
    ```
