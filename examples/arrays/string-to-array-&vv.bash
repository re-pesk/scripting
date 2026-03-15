#!/bin/bash

# Sample:

# Coverts string to array on selected delimiter
split_string() {
  local string="$1"
  local delimiter="$2"
  local -n result_array=$3  # Named parameter to pass array

  result_array=()

  readarray -td "${delimiter}" chunks <<< "${string}"
  
  local current=""
  for item in ${chunks[@]}; do
    if [[ "${item}" =~ .+\\$ ]] ; then
      current="${current/%\\/${delimiter}}${item}"
    else [[ "$current" =~ .+\\$ ]]
      result_array+=("${current/%\\/${delimiter}}${item}")
      current=""
    fi
  done
}

echo 
echo 'Sample1: split string with function'
echo 
echo '-'
string="one two\ with\ spaces three four"
declare -p string

declare -a array
split_string "$string" " " array
declare -p array
echo 

echo 'Sample2: create array from string with "declare -a array"'
declare -p string
declare -a array="("$string")"
declare -p array
echo 

echo 'Sample3: create associative array with "declare -A ass_array"'
declare -p string
declare -A ass_array="("$string")"
declare -p ass_array
echo 

echo $'Sample4: convert array to string suitable to convert back to array'
declare -p array
string="$(printf '"%s" ' "${array[@]}")"
declare -p string
declare -a array="("$string")"
declare -p array
echo 

echo $'Sample5: convert array to string and then to associative array'
declare -p array
string="$(printf '"%s" "%s" ' "${array[@]@k}")"
declare -p string
declare -A ass_array="("$string")"
declare -p ass_array
echo 

echo $'Sample6: convert array to associative array directly'
declare -p array
declare -A ass_array="("${array[@]@K}")"
declare -p ass_array
echo

echo $'Sample7: print associative array (ordered is not guaranted)'
declare -p ass_array
printf '[%s]="%s"\n' "${ass_array[@]@k}"
for item in "${ass_array[@]@K}"; do
  echo $item
done
echo 

echo $'Sample8: get values of associative array (ordered is not guaranted)'
declare -p ass_array
declare -a values="("$(printf '"%s" ' "${ass_array[@]}")")"
declare -p values
echo

echo $'Sample9: get keys of associative array (ordered is not guaranted)'
declare -p ass_array
declare -a keys="("$(printf '"%s" ' "${!ass_array[@]}")")"
declare -p keys
echo

echo $'Sample10: print associative array ordered by keys'
declare -A ass_array=([3]="four" [2]="three" [1]="two with commas" [0]="one" )
declare -p ass_array
printf '[%s]="%s"\n' "${ass_array[@]@k}" | sort
for item in "$(printf '%s "%s"\n' "${ass_array[@]@k}" | sort)"; do
  echo $item
done
echo 

echo $'Sample11: get values of associative array (order is forced)'
declare -p ass_array
declare -a values="("$(printf '[%s]="%s"\n' "${ass_array[@]@k}" | sort | sed -E 's/^[^=]+=(.+)$/\1/')")"
declare -p values
echo

echo $'Sample11: get keys of associative array (order is forced)'
declare -p ass_array
declare -a keys="("$(printf '%s\n' "${!ass_array[@]}" | sort)")"
declare -p keys
echo
