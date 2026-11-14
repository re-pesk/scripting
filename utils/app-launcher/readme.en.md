[\[&nbsp;&uarr;&nbsp;\]](../readme.en.md "Go toward the start page")

*[Lithuanian](readme.lt.md)*

# app-launcher

Helper scripts that locate application executables when their installation directories are not in the `PATH` variable and they do not have symbolic links in directories included in `PATH`.

# Preparation

If the `${HOME}/.apps/bin` directory does not exist, create it and add the instruction to include it in the `PATH` variable to the `${HOME}/.profile` file.

## Installation

```bash
mkdir -p "${HOME}/.apps/store/app_launcher/bin"
mkdir -p "${HOME}/.apps/store/app_launcher/share/doc"
cp -t "${HOME}/.apps/store/app_launcher" _install.sh
cp -t "${HOME}/.apps/store/app_launcher/bin" bin/*
cp -t "${HOME}/.apps/store/app_launcher/share/doc" readme.md

chmod +x ~/.apps/store/app_launcher/bin/*

[ -f "${HOME}/.app_paths.conf" ] || printf '%s\n' "# Configuration template for app-launcher
# Format: command=directory_path:actual_executable (colon and executable are optional)
# ----" > "${HOME}/.app_paths.conf"

# Create a multi-line string using a Heredoc
read -r -d '' NEW_PATH << 'STR'
# begin init of custom ecosystem

# Define the root of custom ecosystem
export APPS_HOME="${HOME}/.apps"

# Define the paths for internal structure
export APPS_BIN="${APPS_HOME}/bin"
export APPS_LIB="${APPS_HOME}/lib"
export APPS_STORE="${APPS_HOME}/store"

# Safely add the custom bin directory to PATH
case ":$PATH:" in
  ( *":$APPS_BIN:"* ) ;;
  ( * ) export PATH="${APPS_BIN}PATH:+:{PATH}}" ;;
esac

# end init of custom ecosystem
STR

# Check if the configuration is already there to avoid duplicates
# shellcheck disable=SC2016
if grep -q 'PATH="${APPS_BIN}${PATH:+:PATH"' "{HOME}/.profile"; then
  echo "Configuration already exists in ${HOME}/.profile"
else
  eval "${NEW_PATH}"
  [ -d "${APPS_BIN}" ] \vert{}\vert{} mkdir -p "${APPS_BIN}"
  # Create a timestamped backup
  cp -T "${HOME}/.profile" "HOME/.profile.(date "+%Y%m%d-%H%M%S-%3N")"
  # Append a blank line ($'\n') followed by the multi-line text
  # shellcheck disable=SC1003,SC2016
  awk -v new_code="${NEW_PATH}" '{ print }
  /PATH="$HOME\/\.local\/bin:$PATH"/ { found=1; next }
  found && /fi/ { print ""; print new_code; found=0 }' \
  "HOME/.profile" > "{HOME}/.profile.tmp" && mv "HOME/.profile.tmp" "{HOME}/.profile"
  echo "Multi-line text with a leading blank line added to ${HOME}/.profile"
fi

"${APPS_STORE}/app-launcher/bin/config-manager.sh" --mode=config-link "${APPS_STORE}/app-launcher/bin/config-manager.sh" "${APPS_BIN}" config-link
config-link "${APPS_STORE}/app-launcher/bin/config-manager.sh" "${APPS_BIN}" config-app-links config-insert config-remove config-sort
config-link "${APPS_STORE}/app-launcher/bin/app-launcher.sh" "${APPS_BIN}" app-launcher
config-link "${APPS_STORE}/app-launcher/bin/app-docs.sh" "${APPS_BIN}" app-docs app-man app-md
```

Before using, install [glow](../../install/misc/glow/glow_install.md).

## Usage

```bash
# Install Ballerina to ${APPS_STORE}/ballerina and then execute commands
config-link "${APPS_BIN}/app-launcher" "${APPS_BIN}" bal
config-insert "${HOME}/.app_paths.conf" "bal=${APPS_STORE}/ballerina/bin"
bal --version

# Install hyperfine to ${APPS_STORE}/hyperfine and then execute commands
config-link "${APPS_BIN}/app-launcher" "${APPS_BIN}" hyperfine
config-insert "${HOME}/.app_paths.conf" "hyperfine=${APPS_STORE}/hyperfine/bin"
hyperfine --version

app-docs hyperfine
app-man hyperfine
app-md hyperfine
```
