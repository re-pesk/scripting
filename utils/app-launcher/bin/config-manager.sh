#!/usr/bin/env -S bash

# Get the symlink name used to invoke this script
CALLED_AS=$(basename "$0")

# ==============================================================================
# INTERNAL HELPER FUNCTIONS
# ==============================================================================

_execute_help() {
  case "${CALLED_AS}" in
    (config-app-links)
      cat << EOF
Usage: ${CALLED_AS} <path_to_config_file> <target_executable> <dest_dir>

Options:
  -h|-help|--help            - Show this help message and exit

Description:
  Creates absolute, relative-safe symlinks inside the destination directory
  pointing to the given core launcher or binary executable for all active commands from the configuration file.
EOF
      ;;
    (config-insert)
      cat << EOF
Usage: ${CALLED_AS} <path_to_config_file> <command=path[:executable]> [command2=path2 ...]

Options:
  -h|-help|--help            - Show this help message and exit

Description:
  Inserts or updates active paths or commented configuration entries into the file.
  Automatically performs a code-aware sort after a successful insertion.
  Creates a timestamped backup before any operation takes place.
EOF
      ;;
    (config-link)
      cat << EOF
Usage: ${CALLED_AS} <target_executable> <destination_directory> <link_name> [link_name2 ...]

Options:
  -h|-help|--help            - Show this help message and exit

Description:
  Creates absolute, relative-safe symlinks inside the destination directory
  pointing to the given core launcher or binary executable.
EOF
      ;;
    (config-manager|config-manager.sh)
      cat << EOF
Usage:
  ${CALLED_AS} <options>
  ${CALLED_AS} <options> <arguments ...>

Options:
  -h|-help|--help            - Show this help message and exit
  -m|-mode|--mode=<command>  - Specify the command to execute

Available commands:
  config-app-links
  config-insert
  config-link
  config-remove
  config-sort

Arguments:
  for arguments see the command-specific help messages

Description:
  Executes the specified command with the remaining arguments
EOF
      ;;
    (config-remove)
      cat << EOF
Usage: ${CALLED_AS} <path_to_config_file> <command_name> [command_name2 ...]

Options:
  -h|-help|--help            - Show this help message and exit

Description:
  Removes one or more configuration entries or command lines from the file.
  Prompts for a manual confirmation (y/N) for each targeted command name.
  Creates a timestamped backup before completing the removal.
EOF
      ;;
    (config-sort)
      cat << EOF
Usage: ${CALLED_AS} <path_to_config_file>

Options:
  -h|-help|--help            - Show this help message and exit

Description:
  Sorts all lines logically below the top header zone (marked by # ----).
  Orders records alphabetically by command name, ensuring commented targets
  naturally rank directly above their active duplicates.
  Creates a timestamped backup if called independently.
EOF
      ;;
    (*)
      cat << 'EOF'
Error: Invalid script invocation.
Available utilities: config-insert, config-remove, config-sort
EOF
      ;;
  esac
  exit 0
}

_execute_sort() {
  TARGET_CONFIG="$1"
  TMP_FILE="${TARGET_CONFIG}.tmp"

  if ! : > "${TMP_FILE}"; then
    echo "Error: Failed to initialize temporary file." >&2
    exit 1
  fi

  HEADER_LINES=0

  # Find the exact line number of the header separator (# ----)
  if grep -q "^# ----" "${TARGET_CONFIG}"; then
    HEADER_LINES=$(grep -n "^# ----" "${TARGET_CONFIG}" | head -n 1 | cut -d':' -f1)
  fi

  # Copy the top header documentation comments entirely to the temporary file
  if [ "${HEADER_LINES}" -gt 0 ]; then
    head -n "${HEADER_LINES}" "${TARGET_CONFIG}" >> "${TMP_FILE}"
  fi

  # Process and sort all entries below the header section using your custom pipeline
  tail -n +"$((HEADER_LINES + 1))" "${TARGET_CONFIG}" | awk '/^[[:space:]]*$/ { next } { print }' | \
    sed -E 's/^([^#= ]+)=(.*)/\1=\t\0/ ; s/^# ([^= ]+)(.)(.*)/\1#\2\t\0/' | \
    sort -t$'\t' -k1,1 | \
    sed -E 's/^[^\t]*\t//' >> "${TMP_FILE}"

  if ! mv "${TMP_FILE}" "${TARGET_CONFIG}"; then
    echo "Error: Failed to update the original configuration file." >&2
    exit 1
  fi
}

# ==============================================================================
# GLOBAL HELP INTERCEPTOR
# ==============================================================================

if [[ " $* " =~ [[:space:]]-(-?mode|m)=.*[[:space:]] ]]; then
  NEW_ARGS=()
  for arg in "$@"; do
    case "$arg" in
      (-m=*|-mode=*|--mode=*)
        # Remove prefix and get value
        CALLED_AS="${arg#*=}"
        ;;
      (*)
        # Other arguments go to the new list
        NEW_ARGS+=("${arg}")
        ;;
    esac
  done
  # Replace the positional parameters ($1, $2, ...) with the new array
  set -- "${NEW_ARGS[@]}"
fi

# Check all parameters to catch a help argument anywhere in the line
if [[ " $* " =~ [[:space:]]-(-?help|h)[[:space:]] ]]; then
  _execute_help
fi

# ==============================================================================
# FUNCTIONS FOR EACH UTILITY
# ==============================================================================

config_app_links() {
  if [ "$#" -ne 3 ]; then
    echo "Usage: ${CALLED_AS} <path_to_config_file> <target_executable> <dest_dir>" >&2
    exit 1
  fi

  # Set values
  CONFIG_FILE="$1"
  TARGET_EXE="$2"
  DEST_DIR="$3"

  # Verify that the configuration file exists
  if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Error: Configuration file ${CONFIG_FILE} not found." >&2
    exit 1
  fi

  # Verify that the main app-launcher executable exists
  if [ ! -f "${TARGET_EXE}" ]; then
    echo "Error: Target launcher executable ${TARGET_EXE} not found." >&2
    exit 1
  fi

  # Verify that the destination directory exists
  if [ ! -d "${DEST_DIR}" ]; then
    echo "Error: Destination directory ${DEST_DIR} does not exist." >&2
    exit 1
  fi

  # Extract all active command names from the configuration file
  COMMAND_NAMES=$(grep -v "^#" "${CONFIG_FILE}" | grep "=" | cut -d'=' -f1 | tr '\n' ' ')

  # If no active commands are found, exit early
  if [ -z "${COMMAND_NAMES}" ]; then
    echo "Notice: No active commands found in ${FILE}."
    exit 0
  fi

  echo "Generating symlinks for: ${COMMAND_NAMES}"

  # Execute config-link with the target launcher, destination folder, and all extracted command names
  # shellcheck disable=SC2086
  config_link "${TARGET_EXE}" "${DEST_DIR}" ${COMMAND_NAMES}
}

config_insert() {
  if [ $# -lt 2 ]; then
    echo "Usage: ${CALLED_AS} <path_to_config_file> <command=path[:executable]> [command2=path2 ...]" >&2
    exit 1
  fi

  TARGET_CONFIG="$1"
  shift

  if [ ! -f "${TARGET_CONFIG}" ]; then
    echo "Error: Configuration file ${TARGET_CONFIG} not found." >&2
    exit 1
  fi

  # Create a single timestamped backup copy BEFORE any insertion and sorting takes place
  if ! cp -T "${TARGET_CONFIG}" "${TARGET_CONFIG}.$(date "+%Y%m%d-%H%M%S-%3N").${FUNCNAME[0]}"; then
    echo "Error: Failed to create initial configuration backup." >&2
    exit 1
  fi

  ORIGINAL_PWD="${PWD}"
  CONFIG_DIR=$(dirname "${TARGET_CONFIG}")

  if ! cd "${CONFIG_DIR}"; then
    echo "Error: Could not change directory to ${CONFIG_DIR}." >&2
    exit 1
  fi

  TMP_FILE=$(mktemp --tmpdir=. tmp_.XXXXXX)
  if [ -z "${TMP_FILE}" ]; then
    echo "Error: Failed to create temporary file." >&2
    cd "${ORIGINAL_PWD}" || exit 1
    exit 1
  fi

  cat "$(basename "${TARGET_CONFIG}")" > "${TMP_FILE}"

  for NEW_LINE in "$@"; do
    if [[ "${NEW_LINE}" != *"="* ]]; then
      echo "Error: Invalid format for '${NEW_LINE}'. Input must contain '='." >&2
      continue
    fi

    NEW_CMD=$(echo "${NEW_LINE}" | cut -d'=' -f1)

    if grep -Fxq "${NEW_LINE}" "${TMP_FILE}"; then
      echo "Notice: Record '${NEW_LINE}' already exists and is identical. Skipping."
      continue
    fi

    EXISTING_LINE=$(grep "^${NEW_CMD}=" "${TMP_FILE}")

    if [ -n "${EXISTING_LINE}" ]; then
      echo "Record for command '${NEW_CMD}' already exists with a different value:"
      echo "  Current: ${EXISTING_LINE}"
      echo "  New:     ${NEW_LINE}"
      echo -n "Do you want to overwrite it? (y/N): "
      read -r RESPONSE < /dev/tty

      if [[ ! "${RESPONSE}" =~ ^[Yy]$ ]]; then
        echo "Skipping update for '${NEW_CMD}'."
        continue
      fi

      NESTED_TMP=$(mktemp --tmpdir=. tmp.XXXXXX)
      grep -v "^${NEW_CMD}=" "${TMP_FILE}" > "${NESTED_TMP}"
      mv "${NESTED_TMP}" "${TMP_FILE}"
    fi

    echo "${NEW_LINE}" >> "${TMP_FILE}"
    echo "Record for '${NEW_CMD}' successfully staged."
  done

  if ! mv "${TMP_FILE}" "$(basename "${TARGET_CONFIG}")"; then
    echo "Error: Failed to update the configuration file." >&2
    rm -f "${TMP_FILE}"
    cd "${ORIGINAL_PWD}" || exit 1
    exit 1
  fi

  cd "${ORIGINAL_PWD}" || exit 1
  echo "New entries successfully inserted. Starting automatic sorting..."

  # Perform sorting automatically without creating a second backup file
  _execute_sort "${TARGET_CONFIG}"
  echo "Configuration update and sorting completed successfully."
}

config_link() {
  if [ $# -lt 3 ]; then
    echo "Usage: ${CALLED_AS} <target_executable> <destination_directory> <link_name> [link_name2 ...]" >&2
    exit 1
  fi

  TARGET_EXE="$1"
  DEST_DIR="$2"
  shift 2

  # Verify that the target binary or script exists
  if [ ! -f "${TARGET_EXE}" ]; then
    echo "Error: Target executable '${TARGET_EXE}' not found." >&2
    exit 1
  fi

  # Verify that the destination folder exists
  if [ ! -d "${DEST_DIR}" ]; then
    echo "Error: Destination directory '${DEST_DIR}' does not exist." >&2
    exit 1
  fi

  # Loop through all provided link names and create relative symlinks
  for LINK_NAME in "$@"; do
    if ! ln -frs "${TARGET_EXE}" -T "${DEST_DIR}/${LINK_NAME}"; then
      echo "Error: Failed to create symlink for '${LINK_NAME}'." >&2
      continue
    fi
    echo "Symlink successfully created: ${DEST_DIR}/${LINK_NAME} -> ${TARGET_EXE}"
  done
}

config_remove() {
  if [ $# -lt 2 ]; then
    echo "Usage: ${CALLED_AS} <path_to_config_file> <command_name> [command_name2 ...]" >&2
    exit 1
  fi

  TARGET_CONFIG="$1"
  shift

  if [ ! -f "${TARGET_CONFIG}" ]; then
    echo "Error: Configuration file ${TARGET_CONFIG} not found." >&2
    exit 1
  fi

  ORIGINAL_PWD="${PWD}"
  CONFIG_DIR=$(dirname "${TARGET_CONFIG}")

  if ! cd "${CONFIG_DIR}"; then
    echo "Error: Could not change directory to ${CONFIG_DIR}." >&2
    exit 1
  fi

  TMP_FILE=$(mktemp --tmpdir=. tmp.XXXXXX)
  if [ -z "${TMP_FILE}" ]; then
    echo "Error: Failed to create temporary file." >&2
    cd "${ORIGINAL_PWD}" || exit 1
    exit 1
  fi

  cat "$(basename "${TARGET_CONFIG}")" > "${TMP_FILE}"

  for REMOVE_CMD in "$@"; do
    EXISTING_LINE=$(grep "^${REMOVE_CMD}=" "${TMP_FILE}")

    if [ -z "${EXISTING_LINE}" ]; then
      echo "Notice: Record for command '${REMOVE_CMD}' not found. Skipping."
      continue
    fi

    echo "Found record for command '${REMOVE_CMD}':"
    echo "  ${EXISTING_LINE}"
    echo -n "Do you really want to remove it? (y/N): "
    read -r RESPONSE < /dev/tty

    if [[ ! "${RESPONSE}" =~ ^[Yy]$ ]]; then
      echo "Skipping removal for '${REMOVE_CMD}'."
      continue
    fi

    NESTED_TMP=$(mktemp --tmpdir=. tmp.XXXXXX)
    if ! grep -v "^${REMOVE_CMD}=" "${TMP_FILE}" > "${NESTED_TMP}"; then
      if [ -s "${TMP_FILE}" ] && [ ! -s "${NESTED_TMP}" ] && [ "$(grep -vc "^${REMOVE_CMD}=" "${TMP_FILE}")" -ne 0 ]; then
        echo "Error: Failed to filter the command '${REMOVE_CMD}'." >&2
        rm -f "${NESTED_TMP}" "${TMP_FILE}"
        cd "${ORIGINAL_PWD}" || exit 1
        exit 1
      fi
    fi
    mv "${NESTED_TMP}" "${TMP_FILE}"
    echo "Record for '${REMOVE_CMD}' successfully staged for removal."
  done

  # Create a timestamped backup copy just before replacing the original configuration file
  if ! cp -T "$(basename "${TARGET_CONFIG}")" "$(basename "${TARGET_CONFIG}").$(date "+%Y%m%d-%H%M%S-%3N").${FUNCNAME[0]}"; then
    echo "Error: Failed to create configuration backup." >&2
    rm -f "${TMP_FILE}"
    cd "${ORIGINAL_PWD}" || exit 1
    exit 1
  fi

  if ! mv "${TMP_FILE}" "$(basename "${TARGET_CONFIG}")"; then
    echo "Error: Failed to update the configuration file." >&2
    rm -f "${TMP_FILE}"
    cd "${ORIGINAL_PWD}" || exit 1
    exit 1
  fi

  cd "${ORIGINAL_PWD}" || exit 1
  echo "Configuration removal process completed."
}

config_sort() {
  if [ $# -ne 1 ]; then
    echo "Usage: ${CALLED_AS} <path_to_config_file>" >&2
    exit 1
  fi

  TARGET_CONFIG="$1"

  if [ ! -f "${TARGET_CONFIG}" ]; then
    echo "Error: File ${TARGET_CONFIG} not found or is not a regular file." >&2
    exit 1
  fi

  # Create a timestamped backup copy ONLY when config_sort is executed independently
  if ! cp -T "${TARGET_CONFIG}" "${TARGET_CONFIG}.$(date "+%Y%m%d-%H%M%S-%3N").${FUNCNAME[0]}"; then
    echo "Error: Failed to create configuration backup." >&2
    exit 1
  fi

  # Call the internal shared sorting routine
  _execute_sort "${TARGET_CONFIG}"

  echo "Successfully sorted: ${TARGET_CONFIG}"
}

# ==============================================================================
# MAIN EXECUTION DISPATCHER
# ==============================================================================

case "${CALLED_AS}" in
  (config-app-links)
    config_app_links "$@"
    ;;
  (config-insert)
    config_insert "$@"
    ;;
  (config-link)
    config_link "$@"
    ;;
  (config-remove)
    config_remove "$@"
    ;;
  (config-sort)
    config_sort "$@"
    ;;
  (*)
    echo "Error: Invalid script invocation." >&2
    echo "Please call this script via authorized symlinks." >&2
    exit 1
    ;;
esac
