#! /usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Murex"

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
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/lmorg/murex/releases/latest" | xargs basename)"
CURRENT="$(murex --version | head -n 1 | awk '{print $2}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "murex" "${HOME}/.opt/murex"; then
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Sukurti diegimo aplanką.
# Parsiųsti į diegimo katalogą iš tinklalapio ir išskleisti į diegimo aplanką.
# Suteikti vykdomajam failui vykdymo privilegijas.
rm -r "${HOME}/.opt/murex"
mkdir -p "${HOME}/.opt/murex"
curl "https://nojs.murex.rocks/bin/latest/murex-linux-amd64.gz" | gunzip > "${HOME}/.opt/murex/murex"
chmod +x "${HOME}/.opt/murex/murex"

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -sf "${HOME}/.opt/murex/murex" -t "${HOME}/.local/bin"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! murex --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(murex --version | head -n 1 | awk '{print $2}')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
