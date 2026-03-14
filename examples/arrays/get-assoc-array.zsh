#!/usr/bin/env zsh

# function returning associative array
get_associative_array() {
  local -A array=( [a]=true ["15 and ab"]='true and false' )
  echo ${(q-kv)array}
}

# create new associative array from returned values
eval "typeset -A assoc_array=($(get_associative_array))"

# show array definition
typeset -p assoc_array

# print array
echo assoc_array: ${(q-kv)assoc_array}

# iterate on array
for key val in ${(q-kv)assoc_array}; do
  echo "assoc_array[${key}]=${val}"
done
