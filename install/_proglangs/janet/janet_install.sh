#! /usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Janet"

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
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/janet-lang/janet/releases/latest" | xargs basename)"
CURRENT="v$(janet --version 2> /dev/null | awk -F'-' '{print $1}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "janet" "${HOME}/.opt/janet"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t janet_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
curl -sSLo "janet-${LATEST}-linux-x64.tar.gz" \
  "https://github.com/janet-lang/janet/releases/download/${LATEST}/janet-${LATEST}-linux-x64.tar.gz"
curl -sL "https://github.com/janet-lang/janet/releases/expanded_assets/${LATEST}" \
| xq -q "li > div:has(a span:contains('janet-${LATEST}-linux-x64.tar.gz')) ~ div > div > span > span" \
| awk -F ':' '{print $NF}' > "janet-${LATEST}-linux-x64.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! check_sha256 "janet-${LATEST}-linux-x64.tar.gz" \
  "janet-${LATEST}-linux-x64.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Įdiegti programą.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
rm -rf "${HOME}/.opt/janet"
tar --file="janet-${LATEST}-linux-x64.tar.gz" \
  --transform 'flags=r;s/^\.\/(janet)[^\/]+/\1/x' --show-transformed-names -xzC "${HOME}/.opt"

# Sukurti simbolines nuorodas į vykdomąjį failą ir dokumentacijos failą.
ln -sf "${HOME}/.opt/janet/bin/janet" "${HOME}/.local/bin/"
ln -sf "${HOME}/.opt/janet/man/man1/janet.1" "${HOME}/.local/man/man1/"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! janet --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar kompiuteryje įdiegta vėliausia programos versija.
# Išvesti pranešimą apie reultatą.
CURRENT="v$(janet --version 2> /dev/null | awk -F '-' '{print $1}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
