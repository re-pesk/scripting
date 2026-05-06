#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmėeškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Phix"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs xq; then
  exit 1
fi

# Versiją galima rasti http://phix.x10.mx/index.php
# Gauti programos paskutinės versijos numerį iš tinklalapio
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl http://phix.x10.mx/download.php 2> /dev/null | \
  xq -nq 'body > div#wrap > div#content > div#left > p:first-of-type' | \
  head -n 1 | awk '{print $3}')"
CURRENT="$(p -version 2> /dev/null)"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "phix" "${HOME}/.opt/phix"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
# shellcheck disable=SC2034
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t phix_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Pereiti į laikiną aplanką
cd "${TMP_DIR}" || exit 1

# Sukurti zip failų pavadinimo dalių sąrašą
# Atsisiųsti zip failus į laikiną aplanką
# Išskleisti zip failus į phix aplanką
part_array=("" 1 2 3 4)
for part in "${part_array[@]}";do wget "http://phix.x10.mx/phix.${LATEST}${part:+.$part}.zip"; done
for part in "${part_array[@]}";do unzip "phix.${LATEST}${part:+.$part}.zip" -d phix; done

# Atsisiųsti p64 ir p32 failus į phix aplanką
# Suteikti p64 ir p32 failams vykdymo privilegijas
# Perkelti p64 ir p32 failus į phix aplanką
wget http://phix.x10.mx/p64
wget http://phix.x10.mx/p32
chmod 777 p64
chmod 777 p32
mv p64 phix/p
mv p32 phix/p32

# Sukurti phix diegimo aplanką
# Perkelti phix failą į phix diegimo aplanką
mkdir -p "${HOME}/.opt/phix/bin"
mv phix "${HOME}/.opt/phix/"

# Perkelti katalogus į phix/bin aplanką
mv -T "${HOME}/.opt/phix/phix/builtins" "${HOME}/.opt/phix/bin/builtins"
mv -T "${HOME}/.opt/phix/phix/test" "${HOME}/.opt/phix/bin/test"
mv -T "${HOME}/.opt/phix/phix/demo" "${HOME}/.opt/phix/bin/demo"

# Sukurti phix/bin aplanke simbolines nuorodas
cd "${HOME}/.opt/phix/bin" || exit 1
find "${HOME}/.opt/phix" -type f -executable -exec ln -s {} \;

# Sukurti aplinkos kintamųjų įkėlimo skriptą,
# įkeliantį programos aplinkos kintamuosius
# ir papildantį PATH kintamąjį
printf '%s\n' $'[[ -d "${HOME}/.opt/phix/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/phix/bin:"* ]] \
    && export PATH="${HOME}/.opt/phix/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/phix/env.sh"

# Įvykdyti sukurtą skriptą, kad programą būtų galima kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -s "${HOME}/.opt/phix/env.sh" ]] && . "${HOME}/.opt/phix/env.sh"'
eval "${PATH_COMMAND}"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! p -version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Įvykdyti phix testus
p -test

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(p -version 2> /dev/null)"
if [[ "${CURRENT}" == "${LATEST}" ]]; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programa, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti skripto įkėlimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
