#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Oils"

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
LATEST="$(curl -sSLo - https://raw.githubusercontent.com/oils-for-unix/oils/refs/heads/master/oils-version.txt | head -n 1)"
CURRENT="$(osh --version | head -n 1 | awk '{print $2}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "osh" "${HOME}/.opt/oils"; then
  exit 1
fi

# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t oils_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisiųsti į laikiną aplanką programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
curl -fsSLO "https://oils.pub/download/oils-for-unix-${LATEST}.tar.gz"
curl -fssL "https://oils.pub/release/${LATEST}/" \
  | xq -q "div.file-table tr:has(td.filename > a:contains('oils-for-unix-${LATEST}.tar.gz')) + tr > td.checksum" \
  > "oils-for-unix-${LATEST}.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! check_sha256 "oils-for-unix-${LATEST}.tar.gz" "oils-for-unix-${LATEST}.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

tar -f "oils-for-unix-${LATEST}.tar.gz" -xz
cd "oils-for-unix-${LATEST}" || exit 1
./configure --prefix "${HOME}/.opt/oils" --datarootdir "${HOME}/.opt/oils/share"
_build/oils.sh
rm -rf "${HOME}/.opt/oils"
./install

ln -sfT "${HOME}/.opt/oils/bin/oils-for-unix" "${HOME}/.local/bin/osh"
ln -sfT "${HOME}/.opt/oils/bin/oils-for-unix" "${HOME}/.local/bin/ysh"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! osh --version &> /dev/null || ! ysh --version &> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar kompiuteryje įdiegta vėliausia programos versija.
CURRENT="$(osh --version | head -n 1 | awk '{print $2}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
