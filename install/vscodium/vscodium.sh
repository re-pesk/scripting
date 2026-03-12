#!/usr/bin/env -S bash

DEBUG=

# shellcheck disable=SC2034
APP_NAME="VSCodium"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../utils/install_helpers/_set_helpers.sh ../
. ../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl gpg wget; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/VSCodium/vscodium/releases/latest" | xargs basename)"
CURRENT="$(codium --version 2> /dev/null | head -n 1)"

# Atnaujinti pranešimų masyvą
. ../_helpers_.sh

#Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "codium" "/usr/share/codium/bin/codium"; then
  exit 1
fi

# Jeigu nėra gpg rakto ir programa nėra įdiegta, įdiegti gpg raktą ir sukurti resursą
[ -f /usr/share/keyrings/vscodium-archive-keyring.gpg ] && [ -n "${CURRENT}" ] || {
  wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | sudo gpg --dearmor -o /usr/share/keyrings/vscodium-archive-keyring.gpg
  sudo tee /etc/apt/sources.list.d/vscodium.sources <<SOURCES
Types: deb
URIs: https://download.vscodium.com/debs
Suites: vscodium\nComponents: main
Architectures: amd64
Signed-by: /usr/share/keyrings/vscodium-archive-keyring.gpg
SOURCES
}

# Atnaujinti paketų sąrašą po resurso pridėjimo
sudo apt update

# Jeigu nėra įdiegtas, įdiegiamas VSCodium
(( $(apt list --installed 2> /dev/null | grep -c '^codium') > 0 )) || {
  sudo apt install codium
}

# Atnaujinamas VSCodium
sudo apt upgrade

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! codium --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(codium --version 2> /dev/null | head -n 1)"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
