#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Dart"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command gpg tee wget; then
  exit 1
fi

if ! install_missing_package apt-transport-https; then
  exit 1
fi

# Diegiamas raktas ir Darto šaltinis
[ -s "/usr/share/keyrings/dart.gpg" ] || \
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub |\
  sudo gpg  --dearmor -o /usr/share/keyrings/dart.gpg
[ -s "/etc/apt/sources.list.d/dart_stable.list" ] || \
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/dart.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' |\
  sudo tee /etc/apt/sources.list.d/dart_stable.list

# Instaliuojamas Dartas
sudo apt-get update && {
  dpkg -s dart &>/dev/null || sudo apt-get install dart
}

# Tikrinamas Darto veikimas
echo ""

if ! dart --version > /dev/null 2>&1; then
  printf 'Error! Dart is not working as expected!\n\n'
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi
successMessage "${LANG_MESSAGES[installed]}"
