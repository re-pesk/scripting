#! /usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Chapel"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs; then
  exit 1
fi

# Gauti paskutinės programos versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(basename -- "$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/chapel-lang/chapel/releases/latest")")"
CURRENT="$(chpl --version 2>/dev/null | head -n 1 | awk '{print $NF}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "chpl" "/usr/share/chapel"; then
  exit 1
fi

# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t chapel_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos instaliacinį failą.
# Atsisųsti failo patikros sumą iš programos tinklalapio ir išsaugoti į kintamąjį.
# Sulyginti failo patikros sumą su tinklalapio patikros suma.
cd "${TMP_DIR}" || exit 1
curl -LO "https://github.com/chapel-lang/chapel/releases/download/${LATEST}/chapel-${LATEST}-1.ubuntu24.amd64.deb"
curl -sL "https://github.com/chapel-lang/chapel/releases/expanded_assets/${LATEST}" \
| xq -q "li > div:has(a span:contains('chapel-${LATEST}-1.ubuntu24.amd64.deb')) ~ div > div > span > span" \
| cut -c 8- > "chapel-${LATEST}-1.ubuntu24.amd64.deb.sha256"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! compare_checksums sha256sum \
  "chapel-${LATEST}-1.ubuntu24.amd64.deb" \
  "chapel-${LATEST}-1.ubuntu24.amd64.deb.sha256"; then
  errorMessage "${LANG_MESSAGES[failed_latest]}"
  exit 1
fi

# Įdiegti programą. Ištrinti laikiną aplanką.
sudo dkpg -i "chapel-${LATEST}-1.ubuntu24.amd64.deb"
sudo apt-get install -f

# Pataisyti failų nuosavybę
sudo chown root:root /usr/bin/chpl*
sudo chown -R root:root /usr/share/chapel

# Jeigu nepavyko įdiegti Chapel, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! chpl --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi
# Patikrinti, ar kompiuteryje įdiegta Chapel versija yra vėliausia
CURRENT="$(chpl --version 2>/dev/null | head -n 1 | awk '{print $NF}')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
