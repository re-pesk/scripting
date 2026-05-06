#!/usr/bin/env -S bash

trukme="20m"

if [ "$1" != "" ]; then
  trukme="$1"
fi

priminiklis.sh "$trukme" "Maistas ant viryklės!"
