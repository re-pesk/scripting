#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Racket"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command curl xargs xq; then
  exit 1
fi

# Gauti vėliausios programos versijos numerį.
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sL https://download.racket-lang.org/releases/ | xq -q "tbody > tr:first-of-type a" --attr href)"
CURRENT="$(racket --version 2>/dev/null | awk '{print "v"$4}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "racket" "${HOME}/.opt/racket"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką.
# Nustatyti automainį laikino aplanko trynimą išeinant iš skripto.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t racket_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

cd "${TMP_DIR}" || exit 1

# Atsisiųsti į laikiną aplanką programos failą ir patikros sumą.
curl -Lo "tmp_.racket-${LATEST}.sh" "https://download.racket-lang.org/releases/${LATEST}/installers/racket-${LATEST}-x86_64-linux-buster-cs.sh"
curl -sL https://download.racket-lang.org/releases/9.1/ \
    | xq -q "tr > td:has(span > a[href*='racket-9.1-x86_64-linux-buster']) ~ td span.checksum" > "tmp_.racket-${LATEST}.sh.sha256"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! compare_checksums sha256sum \
  "tmp_.racket-${LATEST}.sh" \
  "tmp_.racket-${LATEST}.sh.sha256"; then
  exit 1
fi

"tmp_.racket-${LATEST}.sh" --in-place --dest "${HOME}/.opt/racket"

printf '%s\n' $'[[ -d "${HOME}/.opt/racket/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/racket/bin:"* ]] \
    && export PATH="${HOME}/.opt/racket/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/racket/env.sh"
PATH_COMMAND=$'[[ -f "${HOME}/.opt/racket/env.sh" ]] && . "${HOME}/.opt/racket/env.sh"'
eval "${PATH_COMMAND}"

# Jeigu nepavyko įdiegti Racket, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! racket --version &> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(racket --version 2>/dev/null | awk '{print "v"$4}')"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti,
# kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti skripto įkėlimo komandą į konfigūracinį failą
insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"

raco pkg config --scope user --set default-scope installation
