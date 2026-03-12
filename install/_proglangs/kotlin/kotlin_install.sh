#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Kotlin"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymąipto vykdymą
if ! check_command curl xargs; then
  exit 1
fi

# Jeigu nėra įdiegtas, įdiegiamas Kotlinas
[[ "$(snap list kotlin | tail -n +2 | wc -l)" -gt 0 ]] || {
  sudo snap install --classic kotlin
  kotlin -version
}

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/JetBrains/kotlin/releases/latest" \
  | xargs basename | sed 's/v//')"
CURRENT="$(kotlinc-native -version 2> /dev/null | awk '{print $NF}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "kotlin" "${HOME}/.opt/kotlin-native"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t kotlin_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisiųsti į laikiną katalogą programos ir patikros sumos failus.
# Sutikrinti failo patikros sumą su tinklalapio patikros suma, jei patikros sumos nesutampa, nutraukti diegimą.
cd "${TMP_DIR}" || exit 1
curl -sSLO \
  "https://github.com/JetBrains/kotlin/releases/download/v${LATEST}/kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz"
curl -sSLO \
  "https://github.com/JetBrains/kotlin/releases/download/v${LATEST}/kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz.sha256"
if ! check_sha256 "${TMP_DIR}/kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz" \
  "${TMP_DIR}/kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
rm -rf "${HOME}/.opt/kotlin-native"
tar --file="kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz" \
  --transform 'flags=r;s/^(kotlin-native)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"

# Įtraukti įdiegtos programos kelią, kad galima būtų ją kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -d "${HOME}/.opt/kotlin-native/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/kotlin-native/bin:"* ]] && \
    export PATH="${HOME}/.opt/kotlin-native/bin${PATH:+:${PATH}}"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! kotlinc-native -version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(kotlinc-native -version 2> /dev/null | awk '{print $NF}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  printf '%s\n\n' "Kotlin v${CURRENT} is not up to date!"
  exit 1
}
printf '%s\n\n' "Kotlin v${LATEST} is succesfully installed."

# Įšvesti į terminale komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
