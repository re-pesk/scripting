# shellcheck shell=bash

# DEBUG: production mode - null or unset, debug mode - any other value
DEBUG="${DEBUG:-}"

APP_NAME="${APP_NAME:-}"
CURRENT="${CURRENT:-}"
LATEST="${LATEST:-}"

# shellcheck disable=SC1094
UTILS_DIR="$(cd -- "$(realpath "${BASH_SOURCE[0]}" | xargs dirname)" &> /dev/null && pwd )"
. "${UTILS_DIR}/_messages.sh"


# Check if the commands are available
: <<"USAGE"
check_command <COMMAND_1> ...
USAGE
: <<"EXAMPLE"
check_command curl xargs
EXAMPLE

check_command() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  # If there are no arguments, exit the script
  # shellcheck disable=SC2128
  (( $# > 0)) || {
    errorMessage "${LANG_MESSAGES[missing_arguments]}" "${FUNC_NAME}"
    exit 1
  };

  # Get names
  readarray -t NAMES < <( printf '%s\n' "$@" | sort -u )

  # Get names that are not commands
  readarray -t NOT_COMMANDS < <( printf "%s\n" "${NAMES[@]}" | grep -Fvxf <(compgen -c | sort -u))

  # If there are names not in the commands' list, exit the script
  (( ${#NOT_COMMANDS[@]} > 0 )) && {
    errorMessage "$(
      printf '%s\n\n  %s\n\n' \
      "${LANG_MESSAGES[missing_commands]}" \
      "${NOT_COMMANDS[*]}"
    )" "${FUNC_NAME}"
    exit 1
  }

  exit 0
)

# Check if the packages are available.

: <<"USAGE"
check_package_name ?-q <NAME_LIST>
USAGE
: <<"EXAMPLE"
check_package_name gcc make
check_package_name -q gcc make
EXAMPLE

check_package_name() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  if [[ "${1}" == "-q" ]]; then
    local -r QUIET="-q"
    shift
  fi

  # If there are no arguments, exit the script
  # shellcheck disable=SC2128
  (( $# > 0)) || {
    errorMessage "${LANG_MESSAGES[missing_arguments]}" "${FUNC_NAME}"
    exit 1
  };

  # Get names
  readarray -t NAMES < <( printf '%s\n' "$@" | sort -u )

  # Get names that are not packages
  readarray -t NOT_PKGNAMES < <( printf "%s\n" "${NAMES[@]}" | grep -Fvxf <(apt-cache pkgnames | sort -u ))

  # If there are names that are not packages, exit the script
  (( ${#NOT_PKGNAMES[@]} > 0 )) && {
    errorMessage \
      "${LANG_MESSAGES[erroneous_names]//'{LIST}'/"${NOT_PKGNAMES[*]}"}" \
      "${FUNC_NAME}"
    [[ -z "${QUIET}" ]] && printf '%s\n' "${NOT_PKGNAMES[@]}"
    exit 1
  }

  exit 0
)

# Check if the packages are installed
: <<"USAGE"
check_package ?-q <NAME_LIST>
USAGE
: <<"EXAMPLE"
check_package gcc make
check_package -q gcc make
EXAMPLE

check_package() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  if [[ "${1}" == "-q" ]]; then
    local -r QUIET="-q"
    shift
  fi

  # If there are no arguments, exit the script
  # shellcheck disable=SC2128
  (( $# > 0)) || {
    errorMessage "${LANG_MESSAGES[missing_arguments]}" "${FUNC_NAME}"
    exit 1
  };

  # Get names
  readarray -t NAMES < <( printf '%s\n' "$@" | sort -u )

  # Get names that are not packages
  # If there is an error, exit the script
  # shellcheck disable=SC2207
  check_package_name -q "${NAMES[@]}" || exit 1

  # Get names of the packages that are not installed # "${NOT_PKGNAMES[@]}" | sort | uniq -u |
  readarray -t NOT_INSTALLED < <( printf "%s\n" "${NAMES[@]}" \
    | grep -Fvxf <( dpkg-query -f '${Package}\n' -W 2> /dev/null | sort -u ))

  # If there are packages that are not installed, exit the script
  (( ${#NOT_INSTALLED[@]} > 0 )) && {
    errorMessage \
      "${LANG_MESSAGES[missing_packages]//'{LIST}'/"${NOT_INSTALLED[*]}"}" \
      "${FUNC_NAME}"
    [[ -z "${QUIET}" ]] && printf '%s\n' "${NOT_INSTALLED[@]}"
    exit 1
  }

  exit 0
)

# Installs packages that are not installed
: <<"USAGE"
install_missing_package <NAME_LIST>
USAGE
: <<"EXAMPLE"
install_missing_package gcc make
EXAMPLE

install_missing_package() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  # If there are no arguments, exit the script
  # shellcheck disable=SC2128
  (( $# > 0)) || {
    errorMessage "${LANG_MESSAGES[missing_arguments]}" "${FUNC_NAME}"
    exit 1
  };

  # Get packages that are not installed
  # shellcheck disable=SC2207
  NOT_INSTALLED=($(check_package "$@")) && exit 0

  (( ${#NOT_INSTALLED[@]} > 0 )) && {
    if ! sudo apt-get install -y "${NOT_INSTALLED[@]}"; then
      errorMessage \
        "${LANG_MESSAGES[missing_packages_are_not_installed]//'{LIST}'/"${NOT_INSTALLED[*]}"}" \
        "${FUNC_NAME}"
      exit 1
    fi
  }
  exit 0
)

# Cleanup function
: << "USAGE"
trap cleanup EXIT
USAGE

cleanup() {
  # shellcheck disable=SC2164
  [[ -n "${INIT_DIR}" ]] && [[ -d "${INIT_DIR}" ]] && cd "${INIT_DIR}"
  [[ -n "${TMP_DIR}" ]] && [[ -d "${TMP_DIR}" ]] && rm -rf "${TMP_DIR}"
}

# Ask the user to install a program.
: << "USAGE"
ask_to_install <COMMAND NAME> <INSTALL DIR>
USAGE
: << "EXAMPLE"
ask_to_install "bal" "${HOME}/.opt/ballerina"
EXAMPLE

ask_to_install() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  local -r COMMAND_NAME="${1}"
  local -r COMMAND_PATH="${COMMAND_NAME:+$(command -v "${COMMAND_NAME}" | xargs realpath)}"
  local -r INSTALL_DIR="${2}"
  local TO_CONTINUE=""

  # Vykdoma išeinant iš funkcijos
  # shellcheck disable=SC2329
  on_exit() {
    EXIT_CODE=$?
    (( EXIT_CODE > 0 )) && warningMessage "${LANG_MESSAGES[no_changes]}" "${FUNC_NAME}"
    exit "${EXIT_CODE}"
  }
  trap on_exit EXIT

  # If there is no command name, exit the script
  [[ -z "${COMMAND_NAME}" ]] && {
    errorMessage "${LANG_MESSAGES[no_command_name]}" "${FUNC_NAME}"
    exit 1
  }

  # If there is no installation directory, exit the script
  [[ -z "${INSTALL_DIR}" ]] && {
    errorMessage "${LANG_MESSAGES[no_install_dir]}" "${FUNC_NAME}"
    exit 1
  }

  if [[ -z "${CURRENT}" ]]; then
    # The current version is not provided
    if [[ -n "${COMMAND_PATH}" ]]; then
      # but the command path is found
      # This is a contradiction, so you are asked to check the app code, and the script is exited
      errorMessage "${LANG_MESSAGES[no_current]}" "${FUNC_NAME}"
      exit 1
    fi
    # The current version is not provided,
    # so app is not installed and you are asked to install a new version
    infoMessage \
      "${LANG_MESSAGES[install_new]}" \
      "${FUNC_NAME}"
  fi

  if [[ -z "${COMMAND_PATH}" ]]; then
    # The current version is provided
    # but the command path is not found, so app is not installed
    # This is a contradiction, so you are asked to check the app code, and the script is exited
    errorMessage \
      "${LANG_MESSAGES[no_app]}" \
      "${FUNC_NAME}"
    exit 1
  fi

  # The command path is found, the current version is provided, app is installed,
  # but the installation directory is different.
  # so you are asked about deleting the current version manually, and the script is exited
  if [[ ! "${COMMAND_PATH}" =~ ^${INSTALL_DIR}.*$ ]]; then
    infoMessage \
    "${LANG_MESSAGES[installed_not_in_dir]//'{INSTALL_DIR}'/"${INSTALL_DIR}"}" \
    "${FUNC_NAME}"
    exit 1
  else
    # and the installation directory is the same as the directory of the current version
    # so you are asked about overwriting the current version
    infoMessage "${LANG_MESSAGES[overwrite]}" "${FUNC_NAME}"
  fi

  # If the program is not installed or this installation directory is not different from ${INSTALL_DIR},
  # ask the user to install the program.
  if [[ "${TO_CONTINUE}" != "n" ]]; then
    printf '%s: \e[s' "${LANG_MESSAGES[prompt]}" 1>&2
    read -e -r TO_CONTINUE
    [[ "${TO_CONTINUE}" == "" ]] && printf '\e[u%s\n' "${LANG_MESSAGES[enter]}" 1>&2
    echo ""
  fi

  # If the user does not want to continue, print a message and exit the script.
  if [[ "${TO_CONTINUE}" != "y" ]]; then
    exit 1
  fi

  # If the installation will be continued, print a info message.
  infoMessage \
    "${LANG_MESSAGES[installing]}" \
    "${FUNC_NAME}"
)

# Compare checksums of a file.
# The awk commands ($3 and $4) must be quoted with single quotes inside
# and use escaped \$ to prevent expansion of variables
: << "USAGE"
compare_checksums_awk <CHECKSUM_1> <CHECKSUM_2> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
compare_checksums_awk \
  "0cf2650e53c353b0643ce1c518c99852 hilbish-v2.3.4-linux-amd64.tar.gz" \
  "sha256:0cf2650e53c353b0643ce1c518c99852" "'{print \$1}'" "-F':' '{print \$2}'"
EXAMPLE

compare_checksums_awk() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  # Check if the checksums are provided
  for i in {1..2}; do
    if [[ -z "${!i}" ]] ; then
      errorMessage "${LANG_MESSAGES[empty_parameter]//'{i}'/${i}}" "${FUNC_NAME}"
      exit 1
    fi
  done
  CHECKSUM_1="${1}"
  CHECKSUM_2="${2}"

  # shellcheck disable=SC2016
  AWK_1="'{print"'$1'"}'"
  # shellcheck disable=SC2016
  AWK_2="'{print"'$1'"}'"

  [[ "${3}" == "" ]] || AWK_1="${3}"
  [[ "${4}" == "" ]] || AWK_2="${4}"

  [ -n "${DEBUG}" ] && {
    debugVariable AWK_1 "${FUNC_NAME}"
    debugVariable AWK_2 "${FUNC_NAME}"
  }

  CHECKSUM_1="$(bash -c "awk ${AWK_1}" <<< "${CHECKSUM_1}")"
  CHECKSUM_2="$(bash -c "awk ${AWK_2}" <<< "${CHECKSUM_2}")"

  # If the checksums do not match, print an error message and exit the script
  [[ "${CHECKSUM_1}" != "${CHECKSUM_2}" ]] && {
    errorMessage "${LANG_MESSAGES[mismatch]}" "${FUNC_NAME}"
    exit 1
  }

  # If the checksums match, print a success message
  successMessage "${LANG_MESSAGES[match]}" "${FUNC_NAME}"
)

# Compare checksum of a file with a string.
# The awk commands ($4 and $5) must be quoted with single quotes to prevent expansion of variables
: << "USAGE"
compare_checksums_str <CHECKSUM TYPE> <FILE_NAME> <CHECKSUM_STRING> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
compare_checksums_str sha1 "./file_name.ext" \
  "sha1:acca7d792b95f66af8c62f261775ef1b6fb0e92c" \
  "'{print \$1}'" "-F':' '{print \$2}'"
EXAMPLE

compare_checksums_str() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  [[ -z "${1}" ]] && {
    errorMessage "${LANG_MESSAGES[missing_checksum_type]}" "${FUNC_NAME}"
    exit 1
  }

  [[ -z "${2}" ]] && {
    errorMessage "${LANG_MESSAGES[missing_filename]}" "${FUNC_NAME}"
    exit 1
  }

  if ! compare_checksums_awk "$("${1}" "${2}")" "${3}" "${4}" "${5}"; then
    exit 1
  fi
)

# Compare checksums of a file.
# The awk commands ($4 and $5) must be quoted with single quotes to prevent expansion of variables
: << "USAGE"
compare_checksums <CHECKSUM_TYPE> <FILE_NAME> <CHECKSUM_FILE_NAME> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
compare_checksums sha1 "./file_name.ext" "./checksum_file_name.ext" "'{print \$1}'" "'{print \$2}'"
EXAMPLE

compare_checksums() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  [[ -z "${3}" ]] && {
    errorMessage "${LANG_MESSAGES[missing_chksum_fname]}" "${FUNC_NAME}"
    exit 1
  }
  if ! compare_checksums_str "${1}" "${2}" "$(cat "${3}")" "${4}" "${5}"; then
    exit 1
  fi
)

# Create a ${HOME}/.pathrc file if it does not exist.
: << "USAGE"
create_file_if_not_exists <FILE_NAME>
USAGE
: << "EXAMPLE"
create_file_if_not_exists "${HOME}/.pathrc"
EXAMPLE

create_file_if_not_exists() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  FILE_NAME="${1}"
  CONTENT="${2}"

  # Create a file if it does not exist
  if [ -f "${FILE_NAME}" ]; then
    infoMessage "${LANG_MESSAGES[file_exists]//'{FILE_NAME}'/"${FILE_NAME}"}" "${FUNC_NAME}"
  else
    touch -c "${FILE_NAME}"
    [ -n "${CONTENT}" ] && printf '%s\n\n' "${CONTENT}" >> "${FILE_NAME}"
  fi
)

# Insert a path record to the certain file.
: << "USAGE"
insert_path <FILE NAME> <STRING TO INSERT>
USAGE
: << "EXAMPLE"
insert_path "${HOME}/.pathrc" \
'[[ -d "${HOME}/.opt/go/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/go/bin:"* ]] \
  && export PATH="${HOME}/.opt/go/bin${PATH:+:${PATH}}"

[[ -d "${HOME}/.opt/go/bin" ]] \
  && [[ ":${PATH}:" == *":${HOME}/go/bin:"* ]] \
  && export PATH="${HOME}/go/bin${PATH:+:${PATH}}"'
EXAMPLE

insert_path() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  FILE_NAME="${1}"
  INSERT_STR="${2}"

  # Check if the record already exists in the file.
  if [[ "$(grep -c -F "#begin ${APP_NAME,,} init" < "${FILE_NAME}")" -gt 0 ]]; then
    infoMessage \
      "${LANG_MESSAGES[record_exists]//'{FILE_NAME}'/"${FILE_NAME}"}" \
      "${FUNC_NAME}"
    exit 0
  fi

  # Create a backup otherwise.
  cp -T "${FILE_NAME}" "${FILE_NAME}.$(date "+%Y%m%d-%H%M%S-%3N")"

  # Delete empty lines from the file
  sed -i '/^[[:space:]]*$/N; /^\n$/D' "${FILE_NAME}"

  # Add an empty line to the file, if it doesn't already exist
  [[ "$( tail -n 1 "${FILE_NAME}" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${FILE_NAME}"

  # Append the record to the file
  printf '%s\n\n' '#begin '"${APP_NAME,,}"' init

'"${INSERT_STR}"'

#end '"${APP_NAME,,}"' init' >> "${FILE_NAME}"
)
