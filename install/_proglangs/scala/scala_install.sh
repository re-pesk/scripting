#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmėeškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Scala"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs; then
  exit 1
fi

# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/scala/scala3/releases/latest" | xargs basename)"
CURRENT="$(scala version 2> /dev/null | tail -n +2 | awk '{print $NF}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "scala" "${HOME}/.opt/scala3"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Sukurti funkciją, ištrinančią jį iš disko.
# Nustatyti, jog ji bus paleista, kai bus nutrauktas šio skripto vykdymas.
TMP_DIR="$( mktemp -p . -d -t scala_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos ir patikros sumos failus.
curl -sSLo "${TMP_DIR}/scala3-${LATEST}-x86_64-pc-linux.tar.gz" \
  "https://github.com/scala/scala3/releases/download/${LATEST}/scala3-${LATEST}-x86_64-pc-linux.tar.gz"
curl -sSLo "${TMP_DIR}/scala3-${LATEST}-x86_64-pc-linux.tar.gz.sha256" \
  "https://github.com/scala/scala3/releases/download/${LATEST}/scala3-${LATEST}-x86_64-pc-linux.tar.gz.sha256"

# Sulyginti failo patikros sumą su patikros suma iš tinklalapio.
# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! check_sha256 \
  "${TMP_DIR}/scala3-${LATEST}-x86_64-pc-linux.tar.gz" \
  "${TMP_DIR}/scala3-${LATEST}-x86_64-pc-linux.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/scala3"
tar --file="${TMP_DIR}/scala3-${LATEST}-x86_64-pc-linux.tar.gz" \
  --transform='flags=r;s/^(scala3)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
rm -rf "${TMP_DIR}"

# Įtraukti įdiegtos programos kelius, kad galima būtų ją kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -d "${HOME}/.opt/scala3/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/scala3/bin:"* ]] && \
    export PATH="${HOME}/.opt/scala3/bin${PATH:+:${PATH}}"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! scala --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(scala version 2> /dev/null | tail -n +2 | awk '{print $NF}')"
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
