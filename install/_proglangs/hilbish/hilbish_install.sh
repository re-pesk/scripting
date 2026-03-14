#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Hilbish"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs; then
  exit 1
fi

# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" https://github.com/Rosettea/Hilbish/releases/latest | xargs basename)"
CURRENT="$(hilbish --version 2> /dev/null | head -n 1 | awk '{print $2}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "hilbish" "${HOME}/.opt/hilbish"; then
  exit 1
fi

# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t hilbish_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://github.com/sammy-ette/Hilbish/releases/download/${LATEST}/hilbish-${LATEST}-linux-amd64.tar.gz"
curl -sSLO "https://github.com/sammy-ette/Hilbish/releases/download/${LATEST}/hilbish-${LATEST}-linux-amd64.tar.gz.md5"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! compare_checksums md5sum \
  "hilbish-${LATEST}-linux-amd64.tar.gz" \
  "hilbish-${LATEST}-linux-amd64.tar.gz.md5"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/hilbish"
tar --file="hilbish-${LATEST}-linux-amd64.tar.gz" \
  --transform 'flags=r;s/^/hilbish\//x' --show-transformed-names -xzvC "${HOME}/.opt"

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -si "${HOME}/.opt/hilbish/hilbish" "${HOME}/.local/bin/"

# Nukopijuoti konfigūracius failus į naują katalogą
[[ ! -d "${HOME}/.config/hilbish" ]] && mkdir "${HOME}/.config/hilbish"
cp -iT "${HOME}/.opt/hilbish/.hilbishrc.lua" "${HOME}/.config/hilbish/init.lua"
printf "hilbish.opts.tips = false\n" >> "${HOME}/.config/hilbish/init.lua"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! hilbish --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar kompiuteryje įdiegta vėliausia programos versija.
CURRENT="$(hilbish --version 2> /dev/null | head -n 1 | awk '{print $2}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
