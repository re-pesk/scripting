#! /usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Nushell"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs xq; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/nushell/nushell/releases/latest" | xargs basename)"
CURRENT="$(nu -v 2> /dev/null)"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "nu" "${HOME}/.opt/nu"; then
  exit 1
fi

# Sukurti laikiną aplanką ir atsisųsti į jį programos failą.
# Sukurti failą su patikros suma iš tinklalapio.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t nushell_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

cd "${TMP_DIR}" || exit 1
curl -sSLO \
  "https://github.com/nushell/nushell/releases/download/${LATEST}/nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz"
curl -sSL "https://github.com/nushell/nushell/releases/expanded_assets/${LATEST}" \
  | xq -q "li > div:has(a span:contains('nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz')) ~ div > div > span > span" \
  | awk -F ':' '{print $NF}' \
  > "nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! check_sha256 \
  "nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz" \
  "nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/nu"
tar --file="${TMP_DIR}/nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz" \
  --transform 'flags=r;s/nu.+gnu/nu/x' --show-transformed-names -xzvC "${HOME}/.opt"

# Įtraukti įdiegtos programos kelią, kad galima būtų ją kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
# Išvesti šią komandą į terminalą.
PATH_COMMAND=$'[[ -d "${HOME}/.opt/nu" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/nu:"* ]] \
    && export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"'
eval "${PATH_COMMAND}"
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! nu -v > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą.
CURRENT="$(nu -v 2> /dev/null)"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
# shellcheck disable=SC2016
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
