#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Deno"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams sukurti
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
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/denoland/deno/releases/latest" | xargs basename)"
CURRENT="$(deno --version 2> /dev/null | head -n 1 | awk '{print "v"$2}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "deno" "${HOME}/.opt/deno"; then
  exit 1
fi

# Ištrinti diegimo katalogą, jei jis yra
# Įdiegti naujausią deno versiją į nurodytą katalogą
rm -rf "${HOME}/.opt/deno"
curl -sSLo - "https://deno.land/x/install/install.sh" | DENO_INSTALL="${HOME}/.opt/deno" sh

# Įtraukti įdiegtos programos kelią, kad galima būtų ją kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -d "${HOME}/.opt/deno/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/deno/bin:"* ]] && \
    export PATH="${HOME}/.opt/deno/bin${PATH:+:${PATH}}"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if  ! deno --version &> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(deno --version 2> /dev/null | head -n 1 | awk '{print "v"$2}')"
if ! [[ "${CURRENT}" == "${LATEST}" ]]; then
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
fi
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
