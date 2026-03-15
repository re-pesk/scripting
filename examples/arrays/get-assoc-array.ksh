#!/usr/bin/env ksh

# function returning associative array
get_associative_array() {
  retarr=( [a]=true ["b and 15"]="true and false" )
  retstr="$(typeset -p retarr)"
  echo ${retstr#*=}
}

# create new associative array from returned values
eval "typeset -A assoc_array=$(get_associative_array)"

# show array definition
typeset -p assoc_array

# print array
echo "${!assoc_array[@]} ${assoc_array[@]}"

# iterate on array
for key in "${!assoc_array[@]}"; do
  echo "assoc_array[${key}]=${assoc_array[${key}]}"
done
