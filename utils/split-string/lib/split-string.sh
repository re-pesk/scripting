# shellcheck shell=sh

# Guard clause to ensure this file is ONLY used as a sourced library.
# If executed directly, $0 will contain the script name, matching this guard.
script_name="${0##*/}"
case "${script_name}" in
  (split-string.sh)
    case "${LANG%".UTF-8"}" in
      (lt_LT) printf 'Klaida: Šis failas - tai biblioteka, tad negali būti vydomas tiesiogiai.\nĮterpkite jį kaip šaltinį: . %s\n' "${script_name}" >&2 ;;
      (*)     printf 'Error: This file is a library and cannot be executed directly.\nPlease source it instead: . %s\n' "${script_name}" >&2 ;;
    esac
    exit 1
    ;;
esac

# Generate the control character RS (Record Separator, ASCII 30) according to POSIX
RS=$(printf '\036')

# ==============================================================================
# 1. FUNCTION: split_string
# ==============================================================================
# Description: Splits text by a given delimiter and returns parts joined by join_with.
# Arguments:
#   (-d=*|-delim=*|--delim=*)         : Input delimiter string.
#   (-j=*|-join_with=*|--join_with=*) : Output join string (default: "").
#   Last argument                     : Input text to be processed.
# ==============================================================================
split_string() (
  delim=""
  join_with=""
  input_string=""

  # Argument processing (with double parentheses for case patterns)
  while [ $# -gt 0 ]; do
    case "$1" in
      (-d=*|-delim=*|--delim=*)         delim="${1#*=}"; shift ;;
      (-j=*|-join_with=*|--join_with=*) join_with="${1#*=}"; shift ;;
      (*)                               input_string="$1"; shift ;;
    esac
  done

  if [ -z "$input_string" ]; then
    return
  fi

  # CASE A: Delimiter not provided or empty -> split character by character
  if [ -z "$delim" ]; then
    while [ "${#input_string}" -gt 1 ]; do
      char="${input_string%"${input_string#?}"}"
      printf '%s%s' "$char" "$join_with"
      input_string="${input_string#?}"
    done
    printf '%s' "$input_string"
    return
  fi

  # CASE B: Delimiter provided -> split by the specified string
  while [ "${input_string#*"$delim"}" != "$input_string" ]; do
    current_part="${input_string%%"$delim"*}"
    printf '%s%s' "$current_part" "$join_with"
    input_string="${input_string#*"$delim"}"
  done
  printf '%s' "$input_string"
)

# ==============================================================================
# 2. FUNCTION: normalize_indexes
# ==============================================================================
# Description: Accepts comma-separated indices, converts negative indices to
#            positive based on max value, and returns them joined by join_with.
# Arguments:
#   (-m=*|-max=*|--max=*)             : Maximum allowed index value.
#   (-j=*|-join_with=*|--join_with=*) : Output join string (default: " ").
#   Last argument                     : Comma-separated indices string.
# ==============================================================================
normalize_indexes() (
  max_val=""
  join_with=" "
  input_string=""

  # Argument processing (with double parentheses for case patterns)
  while [ $# -gt 0 ]; do
    case "$1" in
      (-m=*|-max=*|--max=*)             max_val="${1#*=}"; shift ;;
      (-j=*|-join_with=*|--join_with=*) join_with="${1#*=}"; shift ;;
      (*)                               input_string="$1"; shift ;;
    esac
  done

  if [ -z "$input_string" ] || [ -z "$max_val" ]; then
    return
  fi

  result=""

  # Leverage subshell () isolation for IFS and set -f
  IFS=","
  set -f
  # shellcheck disable=SC2046
  set -- $(split_string -d="," -j="," "$input_string")

  for idx in "$@"; do
    if [ -z "$idx" ]; then
      continue
    fi

    # Recalculate negative indices (with double parentheses for case patterns)
    case "$idx" in
      (-*)
        clean_neg="${idx#-}"
        real_idx=$((max_val - clean_neg + 1))
        ;;
      (*)
        real_idx="$idx"
        ;;
    esac

    # Select only valid indices falling into the [1; max_val] range
    if [ "$real_idx" -gt 0 ] && [ "$real_idx" -le "$max_val" ]; then
      result="${result:+${result}${join_with}}${real_idx}"
    fi
  done

  printf '%s' "$result"
)

# ==============================================================================
# 3. MAIN FUNCTION: filter_text
# ==============================================================================
# Description: Splits text, filters parts, and returns them joined by join_with.
# Arguments:
#  (-d=*|-delim=*|--delim=*)         : Input delimiter, if empty or omitted, splited by character.
#  (-i=*|-incl=*|--incl=*)           : Comma-separated included indices.
#  (-e=*|-excl=*|--excl=*)           : Comma-separated excluded indices.
#  (-j=*|-join_with=*|--join_with=*) : Output join string (default: "").
#  Last argument                     : Input text to be processed.
# ==============================================================================
filter_text() (
  delim=""
  raw_incl=""
  raw_excl=""
  join_with=""
  input_string=""

  # Argument processing (fully parenthesized case patterns, including (*))
  while [ $# -gt 0 ]; do
    case "$1" in
      (-d=*|-delim=*|--delim=*)         delim="${1#*=}"; shift ;;
      (-i=*|-incl=*|--incl=*)           raw_incl="${1#*=}"; shift ;;
      (-e=*|-excl=*|--excl=*)           raw_excl="${1#*=}"; shift ;;
      (-j=*|-join_with=*|--join_with=*) join_with="${1#*=}"; shift ;;
      (*)                               input_string="$1"; shift ;;
    esac
  done

  if [ -z "$input_string" ]; then
    return
  fi

  # Create positional parameters from the split text parts using an internal RS separator
  IFS="$RS"
  set -f
  # shellcheck disable=SC2046
  set -- $(split_string ${delim:+-d="$delim"} -j="$RS" "$input_string")
  total_parts=$#

  if [ "$total_parts" -eq 0 ]; then
    return
  fi

  # Normalize filter indices using the second function (defaulting internally to space separation)
  incl_indices=""
  excl_indices=""

  if [ -n "$raw_incl" ]; then
    incl_indices=" $(normalize_indexes -max="$total_parts" -j=" " "$raw_incl") "
  fi
  if [ -n "$raw_excl" ]; then
    excl_indices=" $(normalize_indexes -max="$total_parts" -j=" " "$raw_excl") "
  fi

  current_idx=1
  result=""

  # Loop through all parts and verify filter conditions
  for part in "$@"; do
    # Filter matching logic (with double parentheses for case patterns, including (*))
    case "$excl_indices" in
      (*" $current_idx "*)
        ;;
      (*)
        if [ -n "$incl_indices" ]; then
          case "$incl_indices" in
            (*" $current_idx "*) result="${result:+${result}${join_with}}${part}" ;;
          esac
        else
          result="${result:+${result}${join_with}}${part}"
        fi
        ;;
    esac
    current_idx=$((current_idx + 1))
  done

  # Output the custom joined data stream (no trailing newline)
  printf '%s' "$result"
)
