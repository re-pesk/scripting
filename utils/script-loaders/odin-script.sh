#!/usr/bin/env -S bash

last="${*: -1}"
out="${last%.*}.bin"

# shellcheck disable=2068
/usr/bin/env -S odin run "${last}" -file -out:"${out}" -- ${@:1:$(($#-1))}
