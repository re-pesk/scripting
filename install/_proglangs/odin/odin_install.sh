#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Odin"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs xq; then
  exit 1
fi

# Gauti vėliausios programos versijos numerį.
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/odin-lang/Odin/releases/latest" | xargs basename)"
CURRENT="$(odin version 2> /dev/null | cut -c 14-24)"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "odin" "${HOME}/.opt/odin"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nutatyti automainį laikino aplanko trynimą išeinant iš skripto.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t odin_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisiųsti į laikiną aplanką programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://github.com/odin-lang/Odin/releases/download/${LATEST}/odin-linux-amd64-${LATEST}.tar.gz"
curl -sSLo - "https://github.com/odin-lang/Odin/releases/expanded_assets/${LATEST}" \
  | xq -q "li > div:has(a span:contains('odin-linux-amd64-${LATEST}.tar.gz')) ~ div > div > span > span" \
  | awk -F':' '{print $NF}' > "odin-linux-amd64-${LATEST}.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! compare_checksums sha256sum \
  "odin-linux-amd64-${LATEST}.tar.gz" \
  "odin-linux-amd64-${LATEST}.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Jeigu nesėkmė, nutraukti diegimą.
rm -rf "${HOME}/.opt/odin"
if ! tar --file "odin-linux-amd64-${LATEST}.tar.gz" \
  --transform 'flags=r;s/^(odin)[^\/]+/\1/x' \
  --show-transformed-names -xzC "${HOME}/.opt"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -fs "${HOME}/.opt/odin/odin" "${HOME}/.local/bin/"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! odin version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(odin version 2> /dev/null | awk -F'[ -]' '{print $3"-"$4"-"$5}')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"

