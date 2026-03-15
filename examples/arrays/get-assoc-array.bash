#!/usr/bin/env bash

# function returning associative array
get_associative_array() {
  local -A local_array=( [a]=true ["15 and ab"]="true and false" )
  echo "${local_array[@]@K}"
}

# create new associative array from returned values
declare -A assoc_array="($(get_associative_array))"

# show array definition
declare -p assoc_array

# print array 
echo assoc_array: ${assoc_array[@]@K}

# iterate on array
for key in "${!assoc_array[@]}"; do
  echo "assoc_array[${key}]=${assoc_array[${key}]}" 
done

