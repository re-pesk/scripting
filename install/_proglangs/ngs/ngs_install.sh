#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="NGS"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei curl neįdigta, išeiti iš skripto
if ! check_command curl xargs; then
  exit 1
fi

# Gauti naujausią versiją iš repozitorijos
# Gauti įdiegtos programos versijos numerį
LATEST="$(
  curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/ngs-lang/ngs/releases/latest" | \
  xargs basename
)"
CURRENT="v$(ngs --version)"

# Atnaujinti pranešimų masyvą
. ../../_helpers_.sh

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "ngs" "${HOME}/.opt/ngs"; then
  exit 1
fi

# Įdiegti naujausią versiją
curl https://ngs-lang.org/install.sh | bash

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! ngs --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="v$(ngs --version)"
[[ "${CURRENT}" < "${LATEST}" ]] && {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"
