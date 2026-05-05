#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="SBCL"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl make xq; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(
  curl -sSL https://www.sbcl.org/platform-table.html \
  | xq -q "table > tbody > tr.system-header > th:contains('linux') ~ td > a[href$='x86-64-linux-binary.tar.bz2']" \
  | awk '{print $1}'
)"
CURRENT="$(sbcl --version | awk '{print $NF}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "sbcl" "${HOME}/.opt/sbcl"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t sbcl_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Pereiti į laikiną aplanką
# Atsisiųsti į laikiną aplanką programos failą ir išskleisti jį į laikiną aplanką.
cd "${TMP_DIR}" || exit 1
curl -sSLo - "http://prdownloads.sourceforge.net/sbcl/sbcl-${LATEST}-x86-64-linux-binary.tar.bz2" \
  | tar --transform "flags=r;s/^[^\/]+/tmp_.sbcl-${LATEST}/x" --show-transformed-names -xjv
curl -sSLo - "http://prdownloads.sourceforge.net/sbcl/sbcl-${LATEST}-documentation-html.tar.bz2" \
  | tar --transform "flags=r;s/^[^\/]+/tmp_.sbcl-${LATEST}/x" --show-transformed-names -xjv

# Pereiti į išskleistą aplanką.
# Ištrinti įdiegtą versiją.
# Įdiegti programą.
cd "tmp_.sbcl-${LATEST}" || exit 1
rm -rf "${HOME}/.opt/sbcl"
INSTALL_ROOT="${HOME}/.opt/sbcl" sh install.sh

# Sukurti aplinkos kintamųjų įkėlimo skriptą,
# įkeliantį programos aplinkos kintamuosius
# ir papildantį PATH kintamąjį
printf '%s\n' $'export SBCL_HOME="${HOME}/.opt/sbcl/lib/sbcl"
[[ -d "${HOME}/.opt/sbcl/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/sbcl/bin:"* ]] && \
    export PATH="${HOME}/.opt/sbcl/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/sbcl/env.sh"

# Įvykdyti sukurtą skriptą, kad programą būtų galima kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -s "${HOME}/.opt/sbcl/env.sh" ]] && . "${HOME}/.opt/sbcl/env.sh"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! sbcl --version &> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(sbcl --version | awk '{print $NF}')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti programos aplinkos kintamųjų įkėlimo skripto įkėlimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
