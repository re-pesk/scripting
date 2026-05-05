#!/usr/bin/env -S bash

install_euphoria_4.2() {

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  printf '%s' "${FUNC_NAME:+"${FUNC_NAME}"$'\n\n'}"

  # Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
  # Įkelti pagalbines funkcijas
  ../../../utils/install_helpers/_set_helpers.sh ../../
  . ../../_helpers_.sh

  # Gauti įdiegtos programos versijos numerį
  # Gauti programos paskutinės versijos numerį
  # shellcheck disable=SC1003
  LATEST="$(
    curl -sSLo - "https://raw.githubusercontent.com/OpenEuphoria/euphoria/refs/heads/master/source/version_info.rc" |
    grep -P 'VALUE "ProductVersion"' | awk -F'"|\' '{print $4}'
  )"
  CURRENT="$(euc --version &> /dev/null && euc --version | head -n 1 | awk '{print $5}' | sed 's/v//')"

  # Atnaujinti pranešimų masyvą
  . ../../_helpers_.sh

  # Pasirinkti, ar įdiegti kitą versiją
  if ! ask_to_install "euc" "${HOME}/.opt/euphoria"; then
    return 1
  fi

  # Pereiti į laikiną aplanką
  # Klonuoti git repozitoriją iš OpenEuphoria
  # Pereiti į aplanką euphoria/source
  cd "${TMP_DIR}" || exit 1
  git clone https://github.com/OpenEuphoria/euphoria "${TMP_DIR}/euphoria"
  cd "${TMP_DIR}/euphoria/source" || exit 1

  # Sukompiliuoti Euphoria 4.2
  ./configure
  make
  find build -maxdepth 1 -type f ! -name "*.*" -exec mv -t ../bin/ {} \+
  cp ./build/eu.cfg -t "${TMP_DIR}/euphoria/bin/"

  cd "${TMP_DIR}/euphoria/bin" || exit 1
  for file in *.{ex,exw} ;do
    [ -f "${file%.*}" ] && continue
    if ! euc "$file"; then
      exit "$?"
    fi
  done

  cd "${TMP_DIR}" || exit 1
  rm -rf "${HOME}/.opt/euphoria-${CURRENT}"
  mv "${HOME}/.opt/euphoria" "${HOME}/.opt/euphoria-${CURRENT}"
  mv "${TMP_DIR}/euphoria" -t "${HOME}/.opt/"

  echo ""

  # Sukurti aplinkos kintamųjų įkėlimo skriptą,
  # įkeliantį programos aplinkos kintamuosius
  # ir papildantį PATH kintamąjį
  printf '%s\n' $'[[ -d "${HOME}/.opt/euphoria/bin" ]] &&
  [[ ":${PATH}:" != *":${HOME}/.opt/euphoria/bin:"* ]] &&
    export PATH="${HOME}/.opt/euphoria/bin${PATH:+:${PATH}}"' > "${HOME}/.opt/euphoria/env.sh"

  # Įvykdyti sukurtą skriptą, kad programą būtų galima kviesti,
  # neprisijungus prie vartotojo paskyros iš naujo.
  PATH_COMMAND=$'[[ -s "${HOME}/.opt/euphoria/env.sh" ]] && . "${HOME}/.opt/euphoria/env.sh"'
  eval "${PATH_COMMAND}"

  # Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
  if ! euc --version &> /dev/null || ! eui --version &> /dev/null ; then
    errorMessage "${LANG_MESSAGES[not_working]}"
    return 1
  fi

  cd "${HOME}/.opt/euphoria/source" || exit 1
  ./configure
  find build -maxdepth 1 -type f -exec mv -t "${HOME}/.opt/euphoria/bin/" {} \+
  rm -rf build
  sed -i 's/source\/build/bin/g' "${HOME}/.opt/euphoria/bin/eu.cfg"

  # Patikrinti, ar įdiegta versija yra naujausia.
  # Išvesti atitinkamą pranešimą
  CURRENT="$(euc --version &> /dev/null && euc --version | head -n 1 | awk '{print $5}' | sed 's/v//')"
  [[ "${CURRENT}" < "${LATEST}" ]] && {
    errorMessage "${LANG_MESSAGES[not_latest]}"
    return 1
  }
  successMessage "${LANG_MESSAGES[installed_latest]}"

  # Išvesti į terminalą komandą, kurią reikia įvykdyti,
  # kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
  infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

  # Įrašyti skripto įkėlimo komandą į konfigūracinį failą
  create_file_if_not_exists "${HOME}/.pathrc" '# shellcheck shell=bash'
  insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
}
