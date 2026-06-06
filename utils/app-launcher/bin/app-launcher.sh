#!/usr/bin/env -S bash

# Get the symlink name used to invoke this script (removes path, leaves only filename)
CALLED_AS=$(basename "$0")
CONFIG_FILE="${HOME}/.app_paths.conf"

# Check if the configuration file exists
if [ ! -f "${CONFIG_FILE}" ]; then
  echo "Error: Configuration file ${CONFIG_FILE} not found." >&2
  exit 1
fi

# Extract the configuration line corresponding to the command name
CONF_LINE=$(grep "^${CALLED_AS}=" "${CONFIG_FILE}" | cut -d'=' -f2)

# Check if the command mapping exists in the configuration file
if [ -z "${CONF_LINE}" ]; then
  echo "Error: Command '${CALLED_AS}' is not defined in ${CONFIG_FILE}." >&2
  exit 1
fi

# Parse the directory path and the actual executable name
APP_DIR="${CONF_LINE}"
EXE_NAME=""

# If a colon is present, split the configuration line into path and filename
if [[ "${CONF_LINE}" == *":"* ]]; then
  APP_DIR=$(echo "${CONF_LINE}" | cut -d':' -f1)
  EXE_NAME=$(echo "${CONF_LINE}" | cut -d':' -f2)
fi

# If the executable name is empty (either no colon, or trailing colon),
# fallback to using the symlink's command name
if [ -z "${EXE_NAME}" ]; then
  EXE_NAME="${CALLED_AS}"
fi

# Verify that the target executable exists and has execution permissions
REAL_EXE="${APP_DIR}/${EXE_NAME}"
if [ ! -x "${REAL_EXE}" ]; then
  echo "Error: File ${REAL_EXE} does not exist or is not executable." >&2
  exit 1
fi

# Inject the program's directory into library search paths so it finds its .so files
export LD_LIBRARY_PATH="${APP_DIR}:${APP_DIR}/lib:${LD_LIBRARY_PATH}"

# Execute the binary using its absolute path without changing the user's current directory
# This guarantees that all relative paths passed by the user are resolved perfectly
exec "${REAL_EXE}" "$@"
