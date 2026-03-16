#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
../../../utils/install_helpers/_set_helpers.sh ../../

# shellcheck disable=SC2190
declare -A LOCAL_MESSAGES=(
  'en.UTF-8.haxe_not_installed' $'Error! Haxe installation failed!'
  'en.UTF-8.hashlink_not_installed' $'Error! Hashlink installation failed!'

  'lt_LT.UTF-8.haxe_not_installed' $'Klaida! Haxe diegimas nepavyko!'
  'lt_LT.UTF-8.hashlink_not_installed' $'Klaida! Hashlink diegimas nepavyko!'
)

install_haxe() (

  APP_NAME="Haxe"

  # Įkelti pagalbines funkcijas
  . ../../_helpers_.sh

  echo ""

  # Gauti programos paskutinės versijos numerį
  # Gauti įdiegtos programos versijos numerį
  LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/HaxeFoundation/haxe/releases/latest" | xargs basename)"
  CURRENT="$(haxe --version 2> /dev/null)"

  # Atnaujinti pranešimų masyvą
  . ../../_helpers_.sh

  # Pasirinkti, ar įdiegti naujausią versiją
  if ! ask_to_install "haxe" "${HOME}/.opt/haxe"; then
    exit 1
  fi

  # Ištrinti įdiegtą versiją.
  # Parsiųsti naujausią programos failą ir išskleisti jį į diegimo katalogą.
  # Priskirti vykdomajam failui vartotojo rašymo leidimą (klaida?).
  rm -rf "${HOME}/.opt/haxe"
  curl -sSLo - "https://github.com/HaxeFoundation/haxe/releases/download/${LATEST}/haxe-${LATEST}-linux64.tar.gz" \
    | tar --transform "flags=r;s/^(haxe)[^\/]+/\1/x" --show-transformed-names -xzvC "${HOME}/.opt"
  echo "" 1>&2
  chmod u+w "${HOME}/.opt/haxe/haxe"

  # Sukurti aplinkos kintamųjų įkėlimo skriptą,
  # įkeliantį programos aplinkos kintamuosius
  # ir papildantį PATH kintamąjį
  printf '%s\n' $'[[ -d "${HOME}/.opt/haxe" ]] && \
    [[ ":${PATH}:" != *":${HOME}/.opt/haxe:"* ]] && \
      export PATH="${HOME}/.opt/haxe${PATH:+:${PATH}}"' > "${HOME}/.opt/haxe/env.sh"

  # Įvykdyti sukurtą skriptą, kad programą būtų galima kviesti,
  # neprisijungus prie vartotojo paskyros iš naujo.
  PATH_COMMAND=$'[[ -s "${HOME}/.opt/haxe/env.sh" ]] && . "${HOME}/.opt/haxe/env.sh"'
  eval "${PATH_COMMAND}"

  # Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
  if ! haxe --version > /dev/null 2>&1; then
    errorMessage "${LANG_MESSAGES[not_working]}"
    exit 1
  fi

  # Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
  CURRENT="$(haxe --version 2> /dev/null)"
  [[ "${CURRENT}" == "${LATEST}" ]] || {
    errorMessage "${LANG_MESSAGES[not_updated]}"
    exit 1
  }
  successMessage "${LANG_MESSAGES[installed_latest]}"

  # Išvesti į terminalą komandą, kurią reikia įvykdyti,
  # kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
  infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

  # Įrašyti skripto įkėlimo komandą į konfigūracinį failą
  insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
)

install_hashlink() (

  APP_NAME="Hashlink"

  # Įkelti pagalbines funkcijas
  . ../../_helpers_.sh

  # Jei nėra reikalingų komandų, nutraukti skripto vykdymą
  if ! install_missing_package curl unzip; then
    exit 1
  fi

  # Gauti programos paskutinės versijos numerį
  # Gauti įdiegtos programos versijos numerį
  COMMIT="$(curl -s "https://github.com/HaxeFoundation/hashlink/releases/tag/latest" | xq -q "code:first-of-type")"
  LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/HaxeFoundation/hashlink/releases/latest" | xargs basename).0"
  CURRENT="$(hl --version 2> /dev/null)"

  # Atnaujinti pranešimų masyvą
  . ../../_helpers_.sh

  # Pasirinkti, ar įdiegti naujausią versiją
  if ! ask_to_install "hl" "${HOME}/.opt/hashlink"; then
    exit 1
  fi

  # Išsaugoti esamą aplanką
  # Sukurti laikiną aplanką.
  # Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
  INIT_DIR="$PWD"
  TMP_DIR="$( mktemp -p . -d -t hashlink_.XXXXXXXX | xargs realpath )"
  trap cleanup EXIT

  # Pereiti į laikiną aplanką
  # Atsisiųsti į laikiną aplanką programos failą ir išskleisti jį į laikiną aplanką.
  cd "${TMP_DIR}" || exit 1
  curl -fsSLO "https://github.com/HaxeFoundation/hashlink/releases/download/latest/hashlink-${COMMIT}-linux-amd64.tar.gz"
  curl -fsSL "https://github.com/HaxeFoundation/hashlink/releases/expanded_assets/latest" \
    | xq -q "li > div:has(a span:contains('hashlink-latest-linux-amd64.tar.gz')) ~ div > div > span > span" \
    | awk -F':' '{print $NF}' > "hashlink-${COMMIT}-linux-amd64.tar.gz.sha256"

  # Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
  if ! compare_checksums sha256sum \
    "hashlink-${COMMIT}-linux-amd64.tar.gz" \
    "hashlink-${COMMIT}-linux-amd64.tar.gz.sha256"; then
    errorMessage "${LANG_MESSAGES[failed]}"
    exit 1
  fi

  # Ištrinti įdiegtą versiją.
  # Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
  rm -rf "${HOME}/.opt/hashlink"
  tar --file="hashlink-${COMMIT}-linux-amd64.tar.gz" \
    --transform 'flags=r;s/^(hashlink)[^\/]+/\1/x' \
    --show-transformed-names -xzvC "${HOME}/.opt"
  echo "" 1>&2

  # Sukurti aplinkos kintamųjų įkėlimo skriptą,
  # įkeliantį programos aplinkos kintamuosius
  # ir papildantį PATH kintamąjį
  printf '%s\n' $'[[ -d "${HOME}/.opt/hashlink" ]] && \
    [[ ":${PATH}:" != *":${HOME}/.opt/hashlink:"* ]] && \
      export PATH="${HOME}/.opt/hashlink${PATH:+:${PATH}}"' > "${HOME}/.opt/hashlink/env.sh"

  # Įvykdyti sukurtą skriptą, kad programą būtų galima kviesti,
  # neprisijungus prie vartotojo paskyros iš naujo.
  PATH_COMMAND=$'[[ -s "${HOME}/.opt/hashlink/env.sh" ]] && . "${HOME}/.opt/hashlink/env.sh"'
  eval "${PATH_COMMAND}"

  # Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
  if ! hl --version > /dev/null 2>&1; then
    errorMessage "${LANG_MESSAGES[not_working]}"
    exit 1
  fi

  # Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
  CURRENT="$(hl --version 2> /dev/null)"
  [[ ! "${CURRENT}" < "${LATEST}" ]] || {
    errorMessage "${LANG_MESSAGES[not_updated]}"
    exit 1
  }
  successMessage "${LANG_MESSAGES[installed_latest]}"

  # Išvesti į terminalą komandą, kurią reikia įvykdyti,
  # kad galima būtų kviesti programą, neprisijungus prie vartotojo paskyros iš naujo.
  infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

  # Įrašyti skripto įkėlimo komandą į konfigūracinį failą
  insert_path "${HOME}/.pathrc" "${PATH_COMMAND}"
)

if ! install_haxe; then
  errorMessage "${LOCAL_MESSAGES[${LANG}.haxe_not_installed]}"
  exit 1
fi

if ! install_hashlink; then
  errorMessage "${LOCAL_MESSAGES[${LANG}.hashlink_not_installed]}"
  exit 1
fi
