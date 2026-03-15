#!/usr/bin/env bash

echo

string=$'zx ccc aaa perl bbb python3 "labas rytas" "žavus vakaras"'
declare -p string
declare -a array="("${string}")"
declare -p array
declare -A assoc="("${string}")"
declare -p assoc
echo

string=$'zx ccc aaa perl bbb python3 labas\ rytas žavus\ vakaras'
declare -p string
declare -a array="("${string}")"
declare -p array
declare -A assoc="("${string}")"
declare -p assoc
echo

string=$'zx\nccc\naaa\nperl\nbbb\npython3\n"labas rytas"\n"žavus vakaras"'
declare -p string
declare -a array="("${string}")"
declare -p array
declare -A assoc="("${string}")"
declare -p assoc
echo

string=$'zx\nccc\naaa\nperl\nbbb\npython3\nlabas\ rytas\nžavus\ vakaras'
declare -p string
declare -a array="("${string}")"
declare -p array
declare -A assoc="("${string}")"
declare -p assoc
echo

string=$'zx\nccc\naaa\nperl\nbbb\npython3\nlabas rytas\nžavus vakaras'
declare -p string
readarray -td $'\n' array <<< "${string}" 
declare -p array
declare -A assoc="("$(printf '"%s"\n' "${array[@]}")")"
declare -p assoc
echo

declare -p string
declare -a array="("$(IFS=$'\n'; printf '"%s"\n' ${string})")"
declare -p array
declare -A assoc="("$(IFS=$'\n'; printf '[%s]="%s"\n' ${string})")"
declare -p assoc
echo

declare -p string
declare -a array="("$(sed -E 's/ /\\ /' <<< "${string}")")"
declare -p array
declare -A assoc="("$(sed -E 's/ /\\ /' <<< "${string}")")"
declare -p assoc
echo
