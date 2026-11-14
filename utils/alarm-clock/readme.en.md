[\[&nbsp;&uarr;&nbsp;\]](../readme.en.md "Go toward the start page")

*[Lithuanian](readme.lt.md)*

# Reminder Scripts

Reminder scripts: when launched from the command line, the program runs in the background; once the set time expires, a notification window pops up on the screen.

* `priminiklis.sh` - the main script. When launched in the foreground, it relaunches itself in the background.

* Other launcher scripts - examples of how the main script should be used.

## Installation

Place the files in a chosen subdirectory inside `${HOME}` and create symbolic links to them in `${HOME}/.local/bin/`, or copy them directly into `${HOME}/.local/bin/`.
