#!/usr/bin/env -S bash

# Get the absolute path of the directory where the script is targeted
TARGET_DIR="$( cd -- "${PWD}/${1}" &> /dev/null && pwd )"

# Get the absolute path of the directory where this script is located
UTILS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd )"

# Sukurti simbolines nuorodas į pagalbinius failus
[[ "${UTILS_DIR}/_helpers.sh" == "$(realpath "${TARGET_DIR}/_helpers_.sh" 2> /dev/null)" ]] || \
  ln -frs "${UTILS_DIR}/_helpers.sh" "${TARGET_DIR}/_helpers_.sh"
[[ "${UTILS_DIR}/_messages.sh" == "$(realpath "${TARGET_DIR}/_messages_.sh" 2> /dev/null)" ]] || \
  ln -frs "${UTILS_DIR}/_messages.sh" "${TARGET_DIR}/_messages_.sh"
