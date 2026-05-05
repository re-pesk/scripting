#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Abs"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command app-launcher curl xargs; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/abs-lang/abs/releases/latest" | xargs basename)"
CURRENT="$(abs --version 2> /dev/null)"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "abs" "${HOME}/.opt/abs"; then
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Parsiųsti naujausią programos failą.
# Sukurti diegimo aplanką ir perkelti į jį programos failą.
rm -rf "${HOME}/.opt/abs"
mkdir -p "${HOME}/.opt/abs/bin"
bash <(curl -fsSL https://www.abs-lang.org/installer.sh)
mv -T abs "${HOME}/.opt/abs/bin/abs"
ln -frsT "${HOME}/.bin/app-launcher" "${HOME}/.bin/abs"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! abs --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(abs --version 2> /dev/null)"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
