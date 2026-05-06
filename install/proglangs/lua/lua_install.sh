#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Lua"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl make xargs xq; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/lua/lua/releases/latest" | \
  xargs basename | sed 's/^v//')"
CURRENT="$(lua -v 2> /dev/null | awk '{print $2}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "lua" "${HOME}/.opt/lua"; then
  exit 1
fi

# Sukurti laikiną aplanką ir atsisųsti į jį programos failą ir patikros sumą.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t lua_.XXXXXXXXXX | xargs realpath )"
trap cleanup EXIT

curl -sLo "${TMP_DIR}/lua-${LATEST}.tar.gz" "https://www.lua.org/ftp/lua-${LATEST}.tar.gz"
curl -sL https://lua.org/ftp/ \
  | xq -q "body > table:first-of-type td.name:has(a:contains('lua-${LATEST}.tar.gz')) ~ td.sum" \
  > "${TMP_DIR}/lua-${LATEST}.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! compare_checksums sha256sum \
  "${TMP_DIR}/lua-${LATEST}.tar.gz" \
  "${TMP_DIR}/lua-${LATEST}.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Išskleisti iš repozitorijos atsisiųstą archyvą į laikiną katalogą.
# Ištrinti įdiegtą versiją.
# Sukompiliuoti programą ir instaliuoti į diegimo katalogą.
# Ištrinti laikiną aplanką.
tar --file="${TMP_DIR}/lua-${LATEST}.tar.gz" -xzC "${TMP_DIR}"
cd "${TMP_DIR}/lua-${LATEST}" || exit 1
make all test
rm -rf "${HOME}/.opt/lua"
make install INSTALL_TOP="${HOME}/.opt/lua"
cd "${INIT_DIR}" || exit 1

# Sukurti aplinkos kintamųjų įkėlimo skriptą,
# įkeliantį programos aplinkos kintamuosius
# ir papildantį PATH kintamąjį
printf '%s\n' $'[[ -d "${HOME}/.opt/lua/bin" ]] &&
  [[ ":${PATH}:" != *":${HOME}/.opt/lua/bin:"* ]] &&
  export PATH="${HOME}/.opt/lua/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/lua/env.sh"

# Įvykdyti sukurtą skriptą, kad programą būtų galima kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -s "${HOME}/.opt/lua/env.sh" ]] && . "${HOME}/.opt/lua/env.sh"'
eval "${PATH_COMMAND}"

echo ""

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! lua -v > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(lua -v 2> /dev/null | awk '{print $2}')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
printf '%s\n\n' "Lua ${LATEST} is succesfully installed."

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad gali būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti skripto įkėlimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
