#!/usr/bin/env -S bash

install_euphoria_4.1() {

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  printf '%s' "${FUNC_NAME:+"${FUNC_NAME}"$'\n\n'}"

  # Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
  # Įkelti pagalbines funkcijas
  ../../../utils/install_helpers/_set_helpers.sh ../../
  . ../../_helpers_.sh

  # Gauti įdiegtos programos versijos numerį
  # Gauti programos paskutinės versijos numerį
  # Vėliausią versiją galima rasti https://github.com/OpenEuphoria/euphoria/releases/latest
  LATEST="$(curl -sL -o /dev/null -w "%{url_effective}" https://github.com/OpenEuphoria/euphoria/releases/latest | xargs basename)"
  CURRENT="$(eui --version &> /dev/null && eui --version  | head -n 1 | awk '{print $3}' | sed 's/v//')"

  # Atnaujinti pranešimų masyvą
  . ../../_helpers_.sh

  # Pasirinkti, ar įdiegti kitą versiją
  if ! ask_to_install "eui" "${HOME}/.opt/euphoria"; then
    return 1
  fi

  # Gauti atsiuntimo nuorodą
  # Ištrinti esamą versiją.
  # Atsisiųsti archyvo failą iš repozitorijos išskleisti jį į diegimo aplanką.
  # Sukurti tekstinį failą su versijos numeriu.
  # URL="$(curl -sL https://api.github.com/repos/OpenEuphoria/euphoria/releases/latest | grep -o 'https.*Linux-x64.*tar.gz')"
  URL="https://github.com$(
    curl -sSLo - "https://github.com/OpenEuphoria/euphoria/releases/expanded_assets/${LATEST}" |
    xq -q "a[href*='euphoria-${LATEST}-Linux-x64-'][href$='.tar.gz']" --attr href
  )"

  rm -rf "${HOME}/.opt/euphoria"
  curl -sSLo - "${URL}" \
  | tar --transform "flags=r;s/^(euphoria)-${LATEST}[^\/]+/\1/x" --show-transformed-names -xzC "${HOME}/.opt"

  touch "${HOME}/.opt/euphoria/v${LATEST}.txt"

  # Išvalyti kelią iš sistemos kintamojo PATH
  # [[ ":${PATH}:" == *":${HOME}/.opt/euphoria/bin:"* ]] &&
  #   export PATH="${PATH/"${HOME}/.opt/euphoria/bin:"/}"

  # Įkelti kelią į PATH
  [[ -d "${HOME}/.opt/euphoria/bin" ]] &&
    [[ ":${PATH}:" != *":${HOME}/.opt/euphoria/bin:"* ]] &&
      export PATH="${HOME}/.opt/euphoria/bin${PATH:+:${PATH}}"

  # Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
  if ! euc --version &> /dev/null || ! eui --version &> /dev/null ; then
    errorMessage "${LANG_MESSAGES[not_working]}"
    return 1
  fi

  # Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
  CURRENT="$(eui --version &> /dev/null && eui --version  | head -n 1 | awk '{print $3}' | sed 's/v//')"
  [[ "${CURRENT}" < "${LATEST}" ]] && {
    errorMessage "${LANG_MESSAGES[not_latest]}"
    return 1
  }
  successMessage "${LANG_MESSAGES[installed_latest]}"
}
