#!/usr/bin/env bash
echo

declare -A aa1=([1]="vienas" [2]="du ir daugiau")
declare -A aa2=([3]="trys" [4]="keturi")
declare -p aa1
declare -p aa2
echo

declare -p aa1
declare -p aa2
declare -A aa3="(${aa1[@]@K} ${aa2[@]@K})"
declare -p aa3
echo

declare -a ar1=(a b c d)
declare -p ar1
echo

declare -A aa4="(${ar1[@]})"
declare -p aa4

declare -A aa5="(a b c d)"
declare -p aa5
echo

string=$'a b c "d e"'
declare -p string
declare -A aa6="(${string})"
declare -p aa6
echo

declare -a ar2="("$'a b c "d e"'")"
declare -p ar2
echo

string="bla@some.com;john@home.com"
declare -p string
arr3=(${string//;/$'\n'})
declare -p arr3
echo '"${arr3[1]}": '"${arr3[1]}"
echo

string=$'bla@some.com;john@home.com;*;broken apart'
declare -p string
string=${string// /$'\ '}
declare -p string
string=${string//\*/$'\*'}
declare -p string
string=${string//;/$'\n'}
declare -p string
declare -a arr4="(""${string}"")"
declare -p arr4
echo "${arr4[1]}"
echo 

string=$'bla@some.com;john@home.com;*;broken apart'
declare -p string
readarray -td ';' arr5 <<< "${string}"
declare -p arr5
echo "${arr5[1]}"
echo 

declare -p string
set -f
echo "$(IFS=';'; printf '%s\n' ${string})"
declare -a arr6="("$(IFS=';'; printf '%s\n' ${string})")"
set +f
declare -p arr6
echo "${arr5[2]}"
echo 

printf '%q\n' "$IFS"
