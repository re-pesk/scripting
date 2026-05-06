#!/usr/bin/env -S bash

trukme="5m"

if [ "$1" != "" ]; then
  trukme="$1"
fi

priminiklis.sh "$trukme" "Koldūnai!"
