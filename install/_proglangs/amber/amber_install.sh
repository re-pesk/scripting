#!/usr/bin/env -S bash

# DEBUG: production mode - null or unset, debug mode - any other value
DEBUG=

APP_NAME="Amber"

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
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/amber-lang/amber/releases/latest" | xargs basename)"
CURRENT="$(amber --version 2> /dev/null | awk '{print $2}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "amber" "${HOME}/.opt/amber"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką.
# Nustatyti automatinį laikino aplanko trynimą, išeinant iš skripto.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t amber_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

cd "${TMP_DIR}" || exit 1

FILE_NAME="amber-$(uname -s | sed -E 's/^(.)/\L\1/')-$(
  (( $(find /lib /usr/lib -name "ld-musl-*.so.1" | wc -l ) > 0 )) && echo "musl" || echo "gnu"
)-$(uname -m).tar.xz"

curl -LO "https://github.com/amber-lang/amber/releases/download/${LATEST}/${FILE_NAME}"
curl -sL "https://github.com/amber-lang/amber/releases/expanded_assets/${LATEST}" \
    | xq -q "li > div:has(a span:contains('${FILE_NAME}')) ~ div > div > span > span" \
    | awk -F':' '{print $NF}' > "${FILE_NAME}.sha256"

if ! compare_checksums sha256sum \
  "${FILE_NAME}" \
  "${FILE_NAME}.sha256"; then
  errorMessage "${LANG_MESSAGES[failed_latest]}"
  exit 1
fi

tar --file "${FILE_NAME}" \
  --transform "flags=r;s/^/amber\/lib\/$(uname -m)\/amber\//x" \
  --show-transformed-names -xvC "${HOME}/.opt"

mkdir -p "${HOME}/.opt/amber/bin"
ln -frs "${HOME}/.opt/amber/lib/x86_64/amber/amber" "${HOME}/.opt/amber/bin/"
ln -fs "${HOME}/.opt/amber/bin/amber" "${HOME}/.local/bin/"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! amber --version 1> /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(amber --version 2> /dev/null | awk '{print $2}')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
