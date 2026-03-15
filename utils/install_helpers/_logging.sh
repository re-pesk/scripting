# shellcheck shell=bash

# FC_BLACK='\033[30m' # Foreground Black
FC_RED='\033[31m' # Foreground Red
FC_GREEN='\033[32m' # Foreground Green
FC_YELLOW='\033[33m' # Foreground Yellow
# FC_BLUE='\033[34m' # Foreground Blue
# FC_MAGENTA='\033[35m' # Foreground Magenta
# FC_CYAN='\033[36m' # Foreground Cyan
# FC_WHITE='\033[37m' # Foreground White
FC_DEFAULT='\033[39m' # Foreground Color Off

# BC_BLACK='\033[40m' # Background Black
# BC_RED='\033[41m' # Background Red
# BC_GREEN='\033[42m' # Background Green
# BC_YELLOW='\033[43m' # Background Yellow
# BC_BLUE='\033[44m' # Background Blue
# BC_MAGENTA='\033[45m' # Background Magenta
# BC_CYAN='\033[46m' # Background Cyan
# BC_WHITE='\033[47m' # Background White
# BC_DEFAULT='\033[49m' # Background Color Off

# BOLD_ON='\033[1m' # Bold
# BOLD_OFF='\033[22m' # Bold

# UNDERLINE_ON='\033[4m' # Underline
# UNDERLINE_OFF='\033[24m' # Underline

# Prints an info message
: <<"USAGE"
debugVariable <VARIABKE_NAME> ?<FUNCTION_NAME>
USAGE
: <<"EXAMPLE"
debugVariable abc
debugVariable abc "my_function"
EXAMPLE

debugVariable() {
  local -n variable="${1}"
  printf "%s%s: ⟪%s⟫\n\n" "${2}" "${1}" "${variable}" 1>&2
}

# Prints an info message
: <<"USAGE"
infoMessage <MESSAGE> ?<FUNCTION_NAME>
USAGE
: <<"EXAMPLE"
infoMessage "Info!"
infoMessage "Info!" "my_function"
EXAMPLE

infoMessage() {
  printf "%s%s\n\n" "${2}" "${1}" 1>&2
}

# Prints a warning message
: <<"USAGE"
warningMessage <MESSAGE> ?<FUNCTION_NAME>
USAGE
: <<"EXAMPLE"
warningMessage "Warning!"
warningMessage "Warning!" "my_function"
EXAMPLE

warningMessage() {
  printf "%s${FC_YELLOW}%s${FC_DEFAULT}\n\n" "${2}" "${1}" 1>&2
}

# Prints an error message
: <<"USAGE"
errorMessage <MESSAGE> ?<FUNCTION_NAME>
USAGE
: <<"EXAMPLE"
errorMessage "Error!"
errorMessage "Error!" "my_function"
EXAMPLE

errorMessage() {
  printf "%s${FC_RED}%s${FC_DEFAULT}\n\n" "${2}" "${1}" 1>&2
}

# Prints a success message
: <<"USAGE"
successMessage <MESSAGE> ?<FUNCTION_NAME>
USAGE
: <<"EXAMPLE"
successMessage "Success!"
successMessage "Success!" "my_function"
EXAMPLE

successMessage() {
  printf "%s${FC_GREEN}%s${FC_DEFAULT}\n\n" "${2}" "${1}" 1>&2
}
