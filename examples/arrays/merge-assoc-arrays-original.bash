#!/usr/bin/env bash

# This is the best answer https://stackoverflow.com/a/29818702/29179535 in the thread on the Stack Overflow
# https://stackoverflow.com/questions/29804909/how-to-combine-associative-arrays-in-bash/79352629#79352629

declare -Ar array1=( [5]=true [10]=true [15]=true )
declare -Ar array2=( [20]=true [25]=true [30]=true )

# convert associative arrays to string
a1="$(declare -p array1)"
a2="$(declare -p long_name2)"

#combine the two strings trimming where necessary 
array_both_string="${a1:0:${#a1}-1} ${a2:20}"

# create new associative array from string
eval "declare -A array_both="${array_both_string#*=}

# show array definition
for key in ${!array_both[@]}; do
    echo "array_both[${key}]=${array_both[${key}]}"
done
