#! /usr/bin/env -S bash

DEBUG=

# shellcheck disable=SC2034
APP_NAME="VSCode"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../utils/install_helpers/_set_helpers.sh ../
. ../_helpers_.sh

echo ""

# Įdiegti trūkstamus paketus
install_missing_packages apt-transport-https curl

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! chech_command curl gpg wget; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/microsoft/vscode/releases/latest" | xargs basename)"
CURRENT="$(code --version 2> /dev/null | head -n 1)"

# Atnaujinti pranešimų masyvą
. ../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "code" "/usr/share/code/bin/code"; then
  exit 1
fi

# Jeigu nėra gpg rakto ir programa nėra įdiegta, įdiegti gpg raktą ir sukurti resursą
[ -f /usr/share/keyrings/microsoft-prod.gpg ] || \
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
    | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg

[ -f /etc/apt/sources.list.d/vscode.sources ] || \
  sudo tee /etc/apt/sources.list.d/vscode.sources <<SOURCES
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/microsoft-prod.gpg
SOURCES

# Atnaujinti paketų sąrašą po resurso pridėjimo
sudo apt update

# Jeigu nėra įdiegtas, įdiegiamas VSCode
dpkg -s code &> /dev/null || sudo apt install code

# Atnaujinamas VSCode
sudo apt upgrade

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! code --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(code --version 2> /dev/null | head -n 1)"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
