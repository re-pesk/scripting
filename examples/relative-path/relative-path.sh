#!/usr/bin/env -S bash

realpath --relative-to="/home/redas/Projektai/shell/scripting/install/aria" "/home/redas/Projektai/shell/scripting/utils/install_helpers"

unset s1 s2 result
s1="$(sed 's/\//\n/g' <<<"/home/redas/Projektai/shell/scripting/install/aria")"
s2="$(sed 's/\//\n/g' <<<"/home/redas/Projektai/shell/scripting/utils/install_helpers")"
  # shellcheck disable=SC2207
result=(
  $(grep -Fxvf <(printf '%s\n' "$s2") <<<"$s1" | sed -E 's/.+/../g')
  $(grep -Fxvf <(printf '%s\n' "$s1") <<<"$s2")
)
sed -E 's/\s+/\//g' <<<"${result[*]}"

# result=($(grep -Fxv -f <(echo "${s2}") <(echo "${s1}") | sed -E 's/.+/../g') $(grep -Fxv -f <(echo "${s1}") <(echo "${s2}")))

