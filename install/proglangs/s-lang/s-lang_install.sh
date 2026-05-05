#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Slang"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl unzip xargs xq; then
  exit 1
fi

# Gauti duomenis iš slang tinklalapio
# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
# shellcheck disable=SC2207
DATA=($(
  curl -sSL "https://www.jedsoft.org/snapshots/#slang" \
    | xq -q "dd > a[href^='slang'],dd:has(a[href^='slang']) > em:contains('md5:') + span"
))
LATEST="$(sed 's/^slang-//;s/\.tar\.gz$//' <<<"${DATA[0]}")"
CURRENT="$(slsh --version | head -n 1 | awk '{print $NF}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "slsh" "${HOME}/.opt/slang"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t slang_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Pereiti į laikiną aplanką
cd "${TMP_DIR}" || exit 1

# Sukurti laikiną aplanką ir atsisųsti į jį programos failą.
curl -LO "https://www.jedsoft.org/snapshots/slang-${LATEST}.tar.gz"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! compare_checksums_str md5sum \
  "slang-${LATEST}.tar.gz" \
  "${DATA[1]}"; then
  exit 1
fi

# Išskleisti programos failą į laikiną aplanką. Pereiti į iškleistą aplanką.
tar --file="slang-${LATEST}.tar.gz" -xzv
cd "slang-${LATEST}" || exit 1

# Sukompiliuoti programą.
# Ištrinti įdiegtą versiją.
# Įdiegti naują versiją.
./configure --prefix="${HOME}/.opt/slang"
make -j"$(nproc)"
rm -rf "${HOME}/.opt/slang"
make install

# Sukurti aplinkos kintamųjų įkėlimo skriptą,
# įkeliantį programos aplinkos kintamuosius
# ir papildantį PATH kintamąjį
printf '%s\n' $'[[ -d "${HOME}/.opt/slang/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/slang/bin:"* ]] && \
    export PATH="${HOME}/.opt/slang/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/slang/env.sh"

# Įvykdyti sukurtą skriptą, kad programą būtų galima kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
PATH_COMMAND=$'[[ -f "${HOME}/.opt/slang/env.sh" ]] && . "${HOME}/.opt/slang/env.sh"'
eval "${PATH_COMMAND}"

echo ""

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! slsh --version &> /dev/null; then
   errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(slsh --version | head -n 1 | awk '{print $NF}')"
if [[ "${CURRENT}" != "${LATEST}" ]]; then
  errorMessage "${LANG_MESSAGES[not_installed]}"
  exit 1
fi
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti skripto įkėlimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
