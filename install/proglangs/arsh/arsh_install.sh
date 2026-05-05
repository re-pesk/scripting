#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Arsh"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

# Gauti įdiegtos programos versijos numerį.
# Gauti įdiegtos programos versijos numerį
LATEST="$(
  curl -sL -o /dev/null -w "%{url_effective}" "https://github.com/sekiguchi-nagisa/arsh/releases/latest" \
    | xargs basename | cut -c 2-
)"
CURRENT="$(arsh --version 2> /dev/null | awk '{print $3}' | sed 's/,$//g')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "arsh" "${HOME}/.opt/arsh"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką.
# Nustatyti automainį laikino aplanko trynimą išeinant iš skripto.
INIT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMP_DIR="$( mktemp -p . -d -t arsh_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Klonuoti arsh repozitoriją į laikiną aplanką
cd "${TMP_DIR}" || exit 1
git clone https://github.com/sekiguchi-nagisa/arsh.git
mkdir -p arsh/build
cd arsh/build || exit 1
cmake -DCMAKE_INSTALL_PREFIX="${HOME}/.opt/arsh" ..
make -j4
rm -rf "${HOME}/.opt/arsh"
make install
cd "${INIT_DIR}" || exit 1

# Sukurti simbolines nuorodas į vykdomąjį skriptą.
ln -frsT "${HOME}/.bin/app-launcher" "${HOME}/.bin/arsh"
ln -frsT "${HOME}/.bin/app-launcher" "${HOME}/.bin/arshd"
ln -frsT "${HOME}/.bin/app-launcher" "${HOME}/.bin/arcolorize"

# Sukurti įrašus faile .app_map
grep -qP 'arshd:arsh' "${HOME}/.app_map" || printf $'arshd:arsh\n' >> "${HOME}/.app_map"
grep -qP 'arcolorize:arsh' "${HOME}/.app_map" || printf $'arcolorize:arsh\n' >> "${HOME}/.app_map"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! arsh --version &> /dev/null; then
  printf "Error! Arsh is not working as expected!\n\n"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(arsh --version 2> /dev/null | awk '{print $3}' | sed 's/,$//g')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  printf '%s\n\n' "Arsh ${CURRENT} is not up to date!"
  exit 1
}
printf '%s\n\n' "Arsh ${LATEST} is succesfully installed"
