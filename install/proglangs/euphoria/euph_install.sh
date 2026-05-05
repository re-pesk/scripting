#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Euphoria"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

# shellcheck disable=SC2190
declare -A EUPH_MESSAGES=(
  'en.UTF-8.end' 'Installation is completed!'
  'en.UTF-8.wo_relogin' $'To use without relogin, execute the following command in the terminal before:\n\n{COMMAND}'
  'lt_LT.UTF-8.end' 'Diegimas baigtas!'
  'lt_LT.UTF-8.wo_relogin' $'Norėdami tęsti neprisijungdami iš naujo, prieš tai paleiskite šią komandą terminale:\n\n{COMMAND}'
)

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs xq; then
  exit 1
fi

if ! install_missing_package build-essential git; then
  exit 1
fi

INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t euphoria_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

. "${INIT_DIR}/euph_install-4.1.sh"
. "${INIT_DIR}/euph_install-4.2.sh"
. "${INIT_DIR}/euph_install-addon.sh"

install_euphoria_4.1 || exit 1
install_euphoria_4.2 || exit 1
install_euphoria_addon eudoc creole || exit 1

printf '%s\n\n' "${EUPH_MESSAGES[${LANG}.end]}"
