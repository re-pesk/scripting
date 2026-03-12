#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Bun"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams sukurti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# shellcheck disable=SC2190
declare -A LOCAL_MESSAGES=(
  'en.UTF-8.not_supported' $'This script can not be used on {PLATFORM}! Use script provided by the author!'
  'lt_LT.UTF-8.not_supported' $'Šis skriptas negali būti naudojamas {PLATFORM} platformoje! Naudokite autoriaus pateikiamą skriptą!'
)

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl unzip xargs; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$( \
  curl -sLo /dev/null -w "%{url_effective}" "https://github.com/oven-sh/bun/releases/latest" | \
  xargs basename | sed 's/bun-v//' \
)"
CURRENT="$(bun --version 2> /dev/null)"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "bun" "${HOME}/.opt/bun"; then
  exit 1
fi

# shellcheck disable=SC2190
declare -A PLATFORM_LIST=(
  'Linux x86_64' 'linux-x64'
  'Linux aarch64' 'linux-aarch64'
  'Linux arm64' 'linux-aarch64'
)

# Pasirinkti platformą
PLATFORM="$(uname -ms)"
TARGET="${PLATFORM_LIST[$PLATFORM]}"

[[ -z "${TARGET}" ]] || {
  errorMessage "${LOCAL_MESSAGES[${LANG}.not_supported]//'{PLATFORM}'/"${PLATFORM}"}"
  exit 1
}

# Pasirinkti failo variantą
if [ -f /etc/alpine-release ]; then
    TARGET="$TARGET-musl"
fi
if [[ $(cat /proc/cpuinfo | grep avx2) = '' ]]; then
  TARGET="$TARGET-baseline"
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t bun_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Pereiti į laikiną aplanką
# Atsisiųsti į laikiną aplanką programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
curl -fsSLO "https://github.com/oven-sh/bun/releases/latest/download/bun-${TARGET}.zip"
curl -sSL "https://github.com/oven-sh/bun/releases/expanded_assets/bun-v${LATEST}" \
  | xq -q "li > div:has(a[href$='/bun-${TARGET}.zip']) ~ div > div > span > span:contains('sha256:')" \
  > "bun-${TARGET}.sha256"

# Jei failas neatitinka patikros sumos, nutraukti diegimą
if ! check_sha256 "bun-${TARGET}.zip" "bun-${TARGET}.sha256" "'{print \$1}'" "-F':' '{print \$2}'"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Sukurti diegimo aplanką.
# Išskleisti atsisiųstą archyvą į diegimo aplanką.
rm -rf "$HOME/.opt/bun"
mkdir -p "$HOME/.opt/bun/bin"
unzip -jqd "$HOME/.opt/bun/bin" "bun-${TARGET}.zip" 2> /dev/null \
  || errorMessage 'Failed to extract bun'

# Įtraukti įdiegtos programos kelią, kad galima būtų ją kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'export BUN_INSTALL="${HOME}/.opt/bun"
[[ -d "${BUN_INSTALL}/bin" ]] && \
  [[ ":${PATH}:" != *":${BUN_INSTALL}/bin:"* ]] && \
  export PATH="${BUN_INSTALL}/bin${PATH:+:${PATH}}"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if  ! bun --version &> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(bun --version 2> /dev/null)"
if ! [[ "${CURRENT}" == "${LATEST}" ]]; then
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
fi
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

IS_BUN_AUTO_UPDATE=true bun completions &>/dev/null

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
