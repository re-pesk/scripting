#!/usr/bin/env bash
/usr/bin/env -S php -r "$(tail -n +1 "$1")" -- "$@"
