#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Swiftly"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs; then
  exit 1
fi

LATEST
CURRENT="$(swiftly --version 2> /dev/null)"

# Sukurti laikiną aplanką.
# Sukurti funkciją, ištrinančią jį iš disko.
# Nustatyti, jog ji bus paleista, kai bus nutrauktas šio skripto vykdymas.
TMP_DIR="$( mktemp -p . -d -t swiftly_.XXXXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisiųsti į laikiną aplanką diegimo programą.
curl -o - "https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz" \
| tar xzxC "${TMP_DIR}"

# Exportuoti Swiftly sistemos kintamuosius
export SWIFTLY_HOME_DIR="${HOME}/.opt/swiftly"
export SWIFTLY_BIN_DIR="${HOME}/.opt/swiftly/bin"
export SWIFTLY_TOOLCHAINS_DIR="${HOME}/.opt/swiftly/toolchains"

# Įdiegti programą
# Įkelti kelią į sistemos kintamąjį
# Ištrinti laikiną aplanką.
"${TMP_DIR}"/swiftly init
# shellcheck disable=SC1091
. "${HOME}/.opt/swiftly/env.sh"
hash -r
rm -rf "${TMP_DIR}"

if ! swiftly --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi
successMessage "${LANG_MESSAGES[installed]}"
