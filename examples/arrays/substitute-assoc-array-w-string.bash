#!/usr/bin/env bash

# substitution of associative array
substitution_string1=$'5::true
10::true
15::true and false
15::penkiolika'
echo "$substitution_string1"
echo

# iterating on substitution_string1
echo "$substitution_string1" | while read -r item; do
  echo "[${item%::*}]=\"${item#*::}\""
done
echo

# function to get item from substitution string by key
getItemByKey() {
  echo "$1" | grep -P "^$2"
}

echo '$(getItemByKey "$substitution_string1" 15) == '"$(getItemByKey "$substitution_string1" 15)"
echo

# function to get value from substitution string by key
getValueByKey() {
  echo "$1" | grep -P "^$2" | sed -E "s/^$2:://"
}


echo '$(getValueByKey "$substitution_string1" 15) == '"\"$(getValueByKey "$substitution_string1" 15)\""
echo

setValueByKey() {
  arr_str="$1"
  new_item="$2"
  key="${new_item%::*}"
  replaced="false"
  result=""

  while read -r item; do

    if [[ "$item" != "${key}::"* ]]; then 
      result+="$item
"
      continue
    fi
    result+="${new_item}
"
    replaced="true"
  done <<< "$arr_str"
  
  if [[ $replaced == false ]]; then
    result+="$new_item"
  fi

  echo "$result"
}

echo 'substitution_string1=$(setValueByKey "$substitution_string1" '25::"false and false"')'
substitution_string1=$(setValueByKey "$substitution_string1" '25::"false and false"')
echo "substitution_string1:"
echo "$substitution_string1"
echo 

# Second substitution string
substitution_string2=$'20::true
25::true and true
Labas vakaras::true'
echo "substitution_string2:"
echo "$substitution_string2"
echo

# function to merge substitution strings
merge_array_strings() {
  arr_str1="$1"
  arr_str2="$2"
  while read -r item; do
    arr_str1=$(setValueByKey "$arr_str1" "$item")
  done <<< "$arr_str2"
  echo "$arr_str1"
}

# merge two substitution strings of associative array
merged_substitution_string="$(merge_array_strings "$substitution_string1" "$substitution_string2")"
echo "merged_substitution_string:"
echo "$merged_substitution_string"
echo

# iterate on merged substitution string
echo "iterating on merged_substitution_string:"
while read -r item; do
  echo "[${item%::*}]=${item#*::}"
done <<< "$merged_substitution_string"
echo
