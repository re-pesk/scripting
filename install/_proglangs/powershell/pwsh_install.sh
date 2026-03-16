#! /usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmėeškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="PowerShell"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs; then
  exit 1
fi

# Įdiegti trūkstamus paketus
if ! install_missing_package wget apt-transport-https software-properties-common; then
  exit 1
fi

# Įdiegti pagrindinį Microsoft paketą
dpkg -s packages-microsoft-prod &> /dev/null || (
  # Gauti operacinės sistemos pavadinimą ir versiją
  source /etc/os-release

  # Atsisiųsti Microsoft'o repositorijos raktus
  wget -q "https://packages.microsoft.com/config/${NAME,,}/${VERSION_ID}/packages-microsoft-prod.deb"

  # Įdiegti raktus
  sudo dpkg -i packages-microsoft-prod.deb

  # Ištrinti raktų failą
  rm -f packages-microsoft-prod.deb
)

# Atnaujinti paketų sąrašą po packages.microsoft.com pridėjimo
sudo apt-get update

# Įdiegti PowerShell
dpkg -s powershell &> /dev/null || sudo apt-get install -y powershell

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! pwsh -Version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Išvesti sėkmės pranešimą
# shellcheck disable=SC2034
LATEST="$(pwsh -Version | awk '{print $2}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

successMessage "${LANG_MESSAGES[installed_latest]}"
