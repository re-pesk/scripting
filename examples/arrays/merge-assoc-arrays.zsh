#!/usr/bin/env zsh

echo

declare -Ar array1=( [5]=true [10]=true ["15 and ab"]="true and false" )
declare -Ar array2=( [20]=true [25]=true [30]=false )

echo 'Show definition of arrays:'
declare -p array1
declare -p array2

echo "Size of array1 is ${#array1[@]}"
echo "Size of array2 is ${#array2[@]}"
echo

# convert both associative arrays to new associative array
declare -A merged_array=(${(kv)array1} ${(kv)array2})

echo 'Definition of merged_array:'
declare -p merged_array
echo "Size of merged_array is ${#merged_array[@]}"
echo

echo 'Iterate on merged_array:'
for key val in "${(@kv)merged_array}"; do
  echo "merged_array[\"${key}\"] = \"${val}\""
done
echo
