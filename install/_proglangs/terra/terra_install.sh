#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Terra"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl jq xargs; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/terralang/terra/releases/latest" | \
  xargs basename | awk -F'-' '{print $NF}')"
CURRENT="$(terra -h 2> /dev/null | head -n 3 | tail -n +3 | awk '{print $NF}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "terra" "${HOME}/.opt/terra"; then
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Parsiųsti naujausią programos failą ir
# išskleisti jį į diegimo aplanką.
rm -rf "${HOME}/.opt/terra"
# shellcheck disable=SC2031
curl -sSLo - https://api.github.com/repos/terralang/terra/releases/latest \
  | jq -cr '.assets[].browser_download_url' \
  | grep -P "${APP_NAME,,}-$(uname -sm | sed -e 's/ /-/')-[^-]+\.tar.xz$" \
  | xargs curl -Lo - \
  | tar --transform "flags=r;s/^(terra)[^\/]+/\1/x" --show-transformed-names -xvC "${HOME}/.opt"

# Sukurti aplinkos kintamųjų įkėlimo skriptą,
# įkeliantį programos aplinkos kintamuosius
# ir papildantį PATH kintamąjį
printf '%s\n' $'[[ -d "${HOME}/.opt/terra/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/terra/bin:"* ]] \
    && export PATH="${HOME}/.opt/terra/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/terra/env.sh"

# Įvykdyti sukurtą skriptą, kad programą būtų galima kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -s "${HOME}/.opt/terra/env.sh" ]] && . "${HOME}/.opt/terra/env.sh"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! terra -h &> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(terra -h 2> /dev/null | head -n 3 | tail -n +3 | awk '{print $NF}')"
if [[ "${CURRENT}" != "${LATEST}" ]]; then
  errorMessage "${LANG_MESSAGES[not_installed]}"
  exit 1
fi
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti programos aplinkos kintamųjų įkėlimo skripto įkėlimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
