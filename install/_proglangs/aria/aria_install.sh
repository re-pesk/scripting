#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Aria"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs; then
  exit 1
fi

# Gauti vėliausios programos versijos numerį.
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/arialang/aria/releases/latest" | xargs basename)"
CURRENT="$(aria --version | awk '{print "v"$NF}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "aria" "${HOME}/.opt/aria"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nutatyti automatinį laikino aplanko trynimą išeinant iš skripto.
# shellcheck disable=SC2034
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t aria_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisiųsti į laikiną aplanką programos failą ir patikros sumą.
URL="https://github.com$(
  curl -sSL "https://github.com/arialang/aria/releases/expanded_assets/${LATEST}" | \
  xq -q "a[href*='aria-${LATEST#v}-x86_64-unknown-linux-gnu-'][href$='.tgz']" --attr href
)"
FILE_NAME="$(basename "${URL}")"

cd "${TMP_DIR}" || exit 1
curl -LO "${URL}"
curl -LO "${URL}.sha256"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! compare_checksums sha256sum "${FILE_NAME}" \
  "${FILE_NAME}.sha256"; then
  errorMessage "${LANG_MESSAGES[failed_latest]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Jeigu nesėkmė, nutraukti diegimą.
rm -rf "${HOME}/.opt/aria"
if ! tar --file "${FILE_NAME}" \
  --transform 'flags=r;s/^(aria)[^\/]+/\1/x' \
  --show-transformed-names -xzC "${HOME}/.opt"; then
  errorMessage "${LANG_MESSAGES[failed_latest]}"
  exit 1
fi

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -fs "${HOME}/.opt/aria/bin/aria" "${HOME}/.local/bin/"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! aria --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(aria --version | awk '{print "v"$NF}')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"

