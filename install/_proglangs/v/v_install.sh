#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmėeškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="V"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl realpath unzip xargs xq; then
  exit 1
fi

# Gauti įdiegtos programos versijos numerį
TAG="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/vlang/v/releases/latest" | xargs basename)"
COMMIT="$(curl -sSL "https://github.com/vlang/v/releases/tag/${TAG}" | xq -q "div:has(span:contains('${TAG}')) ~ div > a > code")"
LATEST="$(curl -sSL "https://raw.githubusercontent.com/vlang/v/refs/heads/master/v.mod" |
awk -F"[' ]" '/version: / {print $3}') ${COMMIT}"
CURRENT="$(v -v 2> /dev/null | awk '{print $2, $NF}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "v" "${HOME}/.opt/v"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti diegimo aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t v_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

cd "${TMP_DIR}" || exit 1
# Atsisiųsti į diegimo aplanką programos failą.
curl -sSLo "v_${TAG}_linux.zip" "https://github.com/vlang/v/releases/download/${TAG}/v_linux.zip"
curl -sSL "https://github.com/vlang/v/releases/expanded_assets/${TAG}" |
  xq -q "li > div:has(a span:contains('v_linux.zip')) ~ div > div > span > span" \
  > "v_${TAG}_linux.zip.sha256"

# Patikrinti, ar failas atitinka patikros sumą
if ! check_sha256 "v_${TAG}_linux.zip" \
  "v_${TAG}_linux.zip.sha256" \
  "'{print \$1}'" "-F':' '{print \$NF}'"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo aplanką.
rm -r "${HOME}/.opt/v"
unzip "v_${TAG}_linux.zip" -d "${HOME}/.opt" > /dev/null 2>&1

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -fs "${HOME}/.opt/v/v" -t "${HOME}/.local/bin"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! v -v > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}" 1>&2
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(v -v 2> /dev/null)"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"

