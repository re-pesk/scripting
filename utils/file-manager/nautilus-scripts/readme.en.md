[\[&nbsp;&uarr;&nbsp;\]](../../readme.en.md "Go toward the start page")

*[Lithuanian](readme.lt.md)*

# Nautilus scripts

Scripts for the Nautilus file manager

* Copy File Location
  Copies the file name with its full file path from the root directory

## Installation

In the directory containing this file, run the following commands

```bash
cp -r -t \${HOME}/.local/share/nautilus .local/share/nautilus/scripts
```

### Debugging

```bash
nautilus -q
G_MESSAGES_DEBUG=all NAUTILUS_DEBUG=Window nautilus
```
