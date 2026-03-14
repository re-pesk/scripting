#! /usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Ballerina"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl unzip xargs; then
  exit 1
fi

# Gauti paskutinės programos versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(
  curl -sLo /dev/null -w "%{url_effective}" "https://github.com/ballerina-platform/ballerina-distribution/releases/latest" \
  | xargs basename | cut -c 2-
)"
CURRENT="$(bal --version 2>/dev/null | head -n 1 | awk '{print $2}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "bal" "${HOME}/.opt/ballerina"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t ballerina_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Gauti programos failo nuorodą
URL="https://github.com/ballerina-platform/ballerina-distribution/releases/download/v${LATEST}/ballerina-${LATEST}-swan-lake.zip"

# Sukurti laikiną aplanką ir atsisųsti programos ir sha256sum failus.
# Patikrinti, ar failas atitinka patikros sumą
# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
cd "${TMP_DIR}" || exit 1
curl -sSLO "${URL}"
curl -sSLO "${URL}.sha256"
# shellcheck disable=SC2016
if ! compare_checksums sha256sum \
  "ballerina-${LATEST}-swan-lake.zip" \
  "ballerina-${LATEST}-swan-lake.zip.sha256" \
  "'{print $1}'" "'{print $NF}'"; then
  errorMessage "${LANG_MESSAGES[failed_latest]}"
  exit 1
fi

# compare_checksums sha256sum "ballerina-${LATEST}-swan-lake.zip;'{print $1}'" "ballerina-${LATEST}-swan-lake.zip.sha256;'{print $NF}'"

# Išskleisti programos failą į laikiną aplanką. Ištrinti įdiegtą versiją.
# Perkelti išarchyvuotus failus į diegimo katalogą. Ištrinti laikiną aplanką su turiniu
unzip -q "ballerina-${LATEST}-swan-lake.zip"
rm -rf "${HOME}/.opt/ballerina"
mv -T "ballerina-${LATEST}-swan-lake" "${HOME}/.opt/ballerina"

# Įtraukti įdiegtos programos kelią, kad galima būtų ją kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -d "${HOME}/.opt/ballerina/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/ballerina/bin:"* ]] && \
    export PATH="${HOME}/.opt/ballerina/bin${PATH:+:${PATH}}"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! bal --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(bal --version 2>/dev/null | head -n 1 | awk '{print $2}')"
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
