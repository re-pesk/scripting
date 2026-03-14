#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Yash"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl make xargs xq; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/magicant/yash/releases/latest" | xargs basename)"
CURRENT="$(yash --version 2> /dev/null | head -n 1 | awk '{print $NF}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "yash" "${HOME}/.opt/yash"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t yash_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Sukurti laikiną aplanką ir atsisųsti į jį programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://github.com/magicant/yash/releases/download/${LATEST}/yash-${LATEST}.tar.gz"
curl -sSL "https://github.com/magicant/yash/releases/expanded_assets/${LATEST}" \
| xq -q "li > div:has(a span:contains('yash-${LATEST}.tar.gz')) ~ div > div > span > span" \
| awk -F':' '{print $NF}' > "yash-${LATEST}.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! compare_checksums sha256sum \
  "yash-${LATEST}.tar.gz" \
  "yash-${LATEST}.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Išskleisti iš repozitorijos atsisiųstą archyvą į laikiną aplanką.
# Pereiti į išskleisto archyvo aplanką.
# Sukonfiguruoti diegimo programą, nurodant diegimo aplanką.
# Sukompiliuoti programą.
tar --file="yash-${LATEST}.tar.gz" -xzv
cd "yash-${LATEST}" || exit 1
./configure --prefix="${HOME}/.opt/yash"
make

# Ištrinti įdiegtą versiją.
# Įdiegti programą.
# Grįžti į pradinį aplanką.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/yash"
make install

# Įtraukti įdiegtos programos kelią, kad galima būtų ją kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
# shellcheck disable=SC2016
PATH_COMMAND=$'[[ -d "${HOME}/.opt/yash/bin" ]] &&
  [[ ":${PATH}:" != *":${HOME}/.opt/yash/bin:"* ]] &&
    export PATH="${HOME}/.opt/yash/bin${PATH:+:${PATH}}"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! yash --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(yash --version 2> /dev/null | head -n 1 | awk '{print $NF}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
