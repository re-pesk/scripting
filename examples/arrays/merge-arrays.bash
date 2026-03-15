#!/usr/bin/env bash

# Proposed solution https://stackoverflow.com/a/79352629/29179535 in the thread on the Stack Overflow
# https://stackoverflow.com/questions/29804909/how-to-combine-associative-arrays-in-bash/79352629#79352629

echo

declare -ar array1=( one two three\ and\ four )
declare -ar array2=( "five" "six" "seven and eight" )

echo 'Definition of arrays:'
declare -p array1
declare -p array2

echo "Size of array1 is ${#array1[@]}"
echo "Size of array2 is ${#array2[@]}"
echo

# merge both arrays to new array
merged_array=( "${array1[@]}" "${array2[@]}" )

echo 'Definition of merged_array:'
declare -p merged_array
echo "Size of merged_array is ${#merged_array[@]}"
echo

echo 'Iterate on merged_array:'
for key in "${!merged_array[@]}"; do
  echo "merged_array[\"${key}\"] = \"${merged_array[${key}]}\"" 
done
echo
