#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Brush"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/reubeno/brush/releases/latest" | \
  xargs basename | awk -F'-' '{print $NF}')"
CURRENT="$(brush --version 2> /dev/null | awk '{print "v"$2}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "brush" "${HOME}/.opt/brush"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką
# Nustatyti automatinį laikino aplanko trynimą išeinant iš skripto.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t brush_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Pereiti į laikiną aplanką
# Atsisiųsti į laikiną aplanką programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
URL="https://github.com/reubeno/brush/releases/download/brush-shell-${LATEST}/brush-x86_64-unknown-linux-musl"
curl -LO "${URL}.tar.gz"
curl -LO "${URL}.sha256"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! compare_checksums sha256sum \
  "brush-x86_64-unknown-linux-musl.tar.gz" \
  "brush-x86_64-unknown-linux-musl.sha256"; then
  errorMessage "${LANG_MESSAGES[failed_latest]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Jeigu nesėkmė, nutraukti diegimą.
rm -rf "${HOME}/.opt/brush"
if ! tar --file "${TMP_DIR}/brush-x86_64-unknown-linux-musl.tar.gz" \
  --transform 'flags=r;s//brush\//x' \
  --show-transformed-names -xzC "${HOME}/.opt" 2> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_extracted]}"
  exit 1
fi

ln -fs "${HOME}/.opt/brush/brush" -t "${HOME}/.local/bin/"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! brush --version &> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(brush --version 2> /dev/null | awk '{print $2}')"
if [[ "${CURRENT}" != "${LATEST#v}" ]]; then
  errorMessage "${LANG_MESSAGES[not_installed]}"
  exit 1
fi
successMessage "${LANG_MESSAGES[installed_latest]}"
