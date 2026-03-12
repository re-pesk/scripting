#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="CurlyPy"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei nėra reikalingų komandų, nutraukti skripto vykdymą
if ! check_command python3 xargs xq; then
  exit 1
fi

# Įdiegti trūkstamus paketus
( readarray -t NOT_INSTALLED < <(packages_to_install python3-venv)
  (( ${#NOT_INSTALLED[@]} > 0 )) && sudo apt-get install -y "${NOT_INSTALLED[@]}"
)

if [ -d "${HOME}/.pyvenvs/tests" ]; then
  # shellcheck disable=SC1091
  source "${HOME}/.pyvenvs/tests/bin/activate"
  if curlypy --help &> /dev/null; then
    infoMessage "${LANG_MESSAGES[already]}"
    deactivate
    exit 0
  fi
fi

# Nustatyti laukiamą atsakymą
# Gauti reikalingą eilutę iš komandos išvedimo
LATEST="curlypy"
CURRENT="$(curlypy --help 2> /dev/null | head -n 1 | awk '{print $2}')"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "CurlyPy" "${HOME}/.pyvenvs/tests/bin"; then
  exit 1
fi

# Sukurti virtualių aplankų aplanką
# Sukurti pythono virtualią aplinką
# Įdiegti curlypy
# Aktyvuoti virtualią aplinką
mkdir -p "${HOME}/.pyvenvs"
python3 -m venv ~/.pyvenvs/tests
# shellcheck disable=SC1091
source "${HOME}/.pyvenvs/tests/bin/activate"
python -m pip install curlypy

# Patikrinti, ar įdiegta versija veikia. Išvesti atitinkamą pranešimą
CURRENT="$(curlypy --help 2> /dev/null | head -n 1 | awk '{print $2}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
