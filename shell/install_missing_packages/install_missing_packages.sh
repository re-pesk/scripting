#!/usr/bin/env -S bash

( PKGNAMES="$(apt-cache pkgnames | sort -u)"
  NOT_PKGNAMES=(); NOT_INSTALLED=()
  for name in wget apt-transport-https software-properties-common; do
    [[ $'\n'"${PKGNAMES}"$'\n' =~ $'\n'"${name}"$'\n' ]] || { NOT_PKGNAMES+=("${name}"); continue; }
    dpkg -s "${name}" &> /dev/null || NOT_INSTALLED+=("${name}")
  done
  (( "${#NOT_PKGNAMES[*]}" > 0 )) && echo "Not packages: ${NOT_PKGNAMES[*]}" 1>&2
  (( "${#NOT_INSTALLED[*]}" > 0 )) && echo "Not installed: ${NOT_INSTALLED[*]}" 1>&2
  (( "${#NOT_INSTALLED[*]}" > 0 )) && sudo apt-get install -y "${NOT_INSTALLED[*]}"
)