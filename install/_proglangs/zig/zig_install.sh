#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Zig"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl jq xargs; then
  exit 1
fi

# Vėliausią versijos numerį galima rasti https://ziglang.org/download/
# Gauti vėliausios programos versijos numerį.
# Gauti įdiegtos programos versijos numerį.
LATEST="$(curl -Lso - https://ziglang.org/download/index.json |\
  jq -r 'keys - ["master"] | sort_by(split(".") | map(tonumber)) | last')"
CURRENT="$(zig version 2> /dev/null)"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "zig" "${HOME}/.opt/zig"; then
  exit 1
fi

# Parsiųsti instaliacinio archyvo duomenis iš tinklalapio į asociatyvų masyvą
# shellcheck disable=SC2155
declare -A DATA="($(
  curl -s "https://ziglang.org/download/index.json" |\
  jq -r '.[] | select(.version == "'"${LATEST}"'") | .["x86-linux"] | "[tarball]=" + .tarball + " [shasum]=" + .shasum'
))"
URL="${DATA["tarball"]}"

# Atsisiųsti failą iš tinklalapio
TMP_DIR="$( mktemp -p . -d -t zig_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT


curl -sSLo "${TMP_DIR}/zig-x86_64-linux-${LATEST}.tar.xz" "${URL}"

# Išvesti į terminalą SHA256 kontrolines sumas, kad galima būtų sulyginti
# Jeigu kontrolinės sumos nesutampa, diegimą nutraukti, atsisiųstus failus ištrinti.
if ! compare_checksums_str sha256sum \
  "${TMP_DIR}/zig-x86_64-linux-${LATEST}.tar.xz" \
  "${DATA["shasum"]}"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/zig"
tar --file="${TMP_DIR}/zig-x86_64-linux-${LATEST}.tar.xz" \
  --transform='flags=r;s/^zig[^\/]+/zig/x' \
  --show-transformed-names -xJC "${HOME}/.opt"

# Sukurti aplinkos kintamųjų įkėlimo skriptą,
# įkeliantį programos aplinkos kintamuosius
# ir papildantį PATH kintamąjį
printf '%s\n' $'[[ -d "${HOME}/.opt/zig" ]] &&
  [[ ":${PATH}:" != *":${HOME}/.opt/zig:"* ]] &&
  export PATH="${HOME}/.opt/zig${PATH:+:${PATH}}"' > "${HOME}/.opt/zig/env.sh"

# Įvykdyti sukurtą skriptą, kad programą būtų galima kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -s "${HOME}/.opt/zig/env.sh" ]] && . "${HOME}/.opt/zig/env.sh"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! zig --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(zig version 2> /dev/null)"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti skripto įkėlimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
