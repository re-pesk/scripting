#!/usr/bin/env bash

echo

declare -Ar array1=( [5]=true [10]=true [15]="true and false" )
declare -Ar array2=( [20]=true [25]=true [30]=false )

echo 'Definition of arrays:'
declare -p array1
declare -p array2

echo "Size of array1 = ${#array1[@]}"
echo "Size of array2 = ${#array2[@]}"
echo

# convert both associative arrays to combined string
printf -v merged_string '[%s]="%s" ' "${array1[@]@k}" "${array2[@]@k}"

echo 'Definition of merged string:'
declare -p merged_string
echo

# create new associative array from string
declare -A merged_array="($merged_string)"

echo 'Definition of merged_array:'
declare -p merged_array

echo "Size of merged_array = ${#merged_array[@]}"
echo

echo 'Iterate on merged_array:'
for key in "${!merged_array[@]}"; do
  echo "merged_array[\"${key}\"] = \"${merged_array[${key}]}\""
done
echo
