[\[&nbsp;&uarr;&nbsp;\]](../../readme.en.md "Go toward the start page")

*[Lithuanian](readme.lt.md)*

# Nemo Plugins

Plugins for the Nemo file manager

* copy-full-path
  Copies the full file path from the root directory

* create-appimage-config
  Creates an AppImage configuration directory in the same directory as the AppImage file

* create-appimage-launcher
  Creates a bash script to launch an AppImage package with the `--no-sandbox` flag

* create-file-description
  Creates a description file for the selected file in Markdown

* make-file-executable
  Grants/revokes file execution permissions

* remove-spaces-from-filename
  Replaces spaces in the file name with an underscore (`_`)

## Installation

In the directory containing this file, run the following commands

```bash
cp -r -t \${HOME}/.local/share/nemo .local/share/nemo/actions
```

### Debugging

```bash
nemo --quit
NEMO_DEBUG=Actions nemo --debug
```
