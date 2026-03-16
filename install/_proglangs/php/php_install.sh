#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmėeškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="PHP"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs; then
  exit 1
fi

if (( $(add-apt-repository -L ondrej/php | grep -c "ondrej/php") < 1 )); then
  sudo add-apt-repository ppa:ondrej/php
  sudo apt update
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/php/php-src/releases/latest" \
  | xargs basename | sed 's/^php-//')"
CURRENT="$(php -v 2> /dev/null | head -n 1 | awk '{print $2}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "php" "$(which php | xargs realpath)"; then
  exit 1
fi

MINOR="${LATEST%.*}"

sudo apt install "php${MINOR} php${MINOR}-mbstring php${MINOR}-curl php${MINOR}-phpdbg php${MINOR}-xdebug" -y

echo

if ! php -v > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(php -v 2> /dev/null | head -n 1 | awk '{print $2}')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
