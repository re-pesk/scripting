#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Miniscript"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs xq; then
  exit 1
fi

# Gauti naujausią versiją
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sSL https://github.com/JoeStrout/miniscript/tags | \
  xq -q "div[id^=header]:contains('Tags') ~ div a[href*='miniscript/releases']")"
CURRENT="$(miniscript -? 2> /dev/null | tail -n +2 | head -n 1 | awk '{print $5}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "miniscript" "${HOME}/.opt/miniscript"; then
  exit 1
fi

# Pašalinti esamą versiją ir įkelti naujausią
rm -rf "${HOME}/.opt/miniscript"
curl -sSLo - https://miniscript.org/files/miniscript-linux.tar.gz | \
  tar --transform "flags=r;s//miniscript\//x" -xzC "${HOME}/.opt/" 2> /dev/null

# Sukurti simbolinę nuorodą į vykdomąjį failą
ln -sf "${HOME}/.opt/miniscript/miniscript" -t "${HOME}/.local/bin/"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! miniscript -? &> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(miniscript -? 2> /dev/null | tail -n +2 | head -n 1 | awk '{print $5}')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
