#!/bin/env bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Elvish"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs; then
  exit 1
fi

# Gauti programos paskutinės versijos failo pavadinimą iš repozitorijos
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/elves/elvish/releases/latest" | xargs basename )"
CURRENT="v$(elvish --version | cut -c -6)"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "elvish" "${HOME}/.opt/elvish"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t elvish_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos failą.
# Sulyginti failo patikros sumą su patikros suma iš tinklalapio.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://dl.elv.sh/linux-amd64/elvish-${LATEST}.tar.gz"
# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! check_sha256_str "elvish-${LATEST}.tar.gz" \
  "$(curl -sSLo - "https://dl.elv.sh/linux-amd64/elvish-${LATEST}.tar.gz.sha256sum")"; then
  errorMessage "${LANG_MESSAGES[failed_latest]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/elvish"
tar -f "elvish-${LATEST}.tar.gz" --transform 'flags=r;s/^/elvish\//x' -xzC "${HOME}/.opt"

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -fs "${HOME}/.opt/elvish/elvish" "${HOME}/.local/bin"

# Jeigu nepavyko įdiegti Elvish, išvesti pranešimą ir nutraukti skripto vykdymą
if ! elvish --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi
# Patikrinti, ar kompiuteryje įdiegta Elvish versija yra vėliausia
CURRENT="v$(elvish --version | cut -c -6)"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
