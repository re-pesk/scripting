#!/usr/bin/env bash

# Removes duplicates from the PATH

echo "${PATH}"
path="${PATH}"
path="${path//:/$'\n'}"

clear_path=""
for s in ${path[@]}; do
  [[ ":${clear_path}:" == *":${s}:"* ]] || clear_path="${clear_path:+${clear_path}:}${s}"
done

echo "${clear_path}"
