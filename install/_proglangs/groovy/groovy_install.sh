#!/usr/bin/env bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Groovy"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command awk curl unzip xargs xq; then
  exit 1
fi

if ! java --version > /dev/null 2>&1; then
  printf '%s\n\n' "Pirmiau įdiekite Javą!"
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$( curl -s https://groovy.apache.org/download.html#distro \
  | xq -q "button[id='big-download-button']" --attr "onclick" \
  | awk -F'["-]' '{print $(NF-1)}' | sed 's/\.zip$//' )"
CURRENT="$(groovy --version 2> /dev/null | awk '{print $3}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "groovy" "${HOME}/.opt/groovy"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t groovy_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos failą.
# Sulyginti failo patikros sumą su patikros suma iš tinklalapio.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://downloads.apache.org/groovy/${LATEST}/distribution/apache-groovy-sdk-${LATEST}.zip"
curl -sSLo - "https://downloads.apache.org/groovy/${LATEST}/distribution/apache-groovy-sdk-${LATEST}.zip.sha256" \
  | tr -d '\r' > "groovy-sdk-${LATEST}.zip.sha256"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! compare_checksums sha256sum \
  "groovy-sdk-${LATEST}.zip" \
  "groovy-sdk-${LATEST}.zip.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Išskelti iš repozitorijos atsisiųstą archyvą į laikiną katalogą.
# Ištrinti įdiegtą versiją.
# Perkelti išarchyvuotus failus į diegimo katalogą.
# Ištrinti laikiną aplanką.
unzip -q "groovy-sdk-${LATEST}.zip"
rm -rf "${HOME}/.opt/groovy"
mv -T "groovy-${LATEST}" "${HOME}/.opt/groovy"

# Sukurti aplinkos kintamųjų įkėlimo skriptą,
# įkeliantį programos aplinkos kintamuosius
# ir papildantį PATH kintamąjį
printf '%s\n' $'[ -z "$JAVA_HOME" ] && {
  JAVA_HOME="$(which java | xargs readlink -f | xargs dirname | xargs dirname)"
  export JAVA_HOME
}\n
[[ -d "${HOME}/.opt/groovy/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/groovy/bin:"* ]] && \
    export PATH="${HOME}/.opt/groovy/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/groovy/env.sh"

# Įvykdyti sukurtą skriptą, kad programą būtų galima kviesti,
# kad galima būtų ją kviesti, neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -s "${HOME}/.opt/groovy/env.sh" ]] && . "${HOME}/.opt/groovy/env.sh"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! groovy --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą.
CURRENT="$(groovy --version 2> /dev/null | awk '{print $3}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
printf '%s\n\n' "Groovy v${LATEST} is succesfully installed."

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti skripto įkėlimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
