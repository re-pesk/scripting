#!/usr/bin/env bash

last="${@: -1}"
out="${last%.*}.bin"

/usr/bin/env -S odin run ${last} -file -out:${out} -- ${@:1:$(($#-1))}
