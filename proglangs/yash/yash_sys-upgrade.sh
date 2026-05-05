#! /usr/bin/env -S yash
# shellcheck shell=ksh

# Klaidų ir sėkmės pranešimų masyvas - kiekvienas pranešimas naujoje eilutėje
messages="en_US.UTF-8.err:Error! Script execution was terminated!
en_US.UTF-8.succ:Successfully finished!
en_US.UTF-8.end:End of execution.
lt_LT.UTF-8.err:Klaida! Scenarijaus vykdymas sustabdytas!
lt_LT.UTF-8.succ:Komanda sėkmingai įvykdyta!
lt_LT.UTF-8.end:Scenarijaus vykdymas baigtas."

# Aplinkos kalbos nuostata
lang="${LANG}"
[ -z "${lang}" ] && lang="en_US.UTF-8"

# Pranešimai, atitinkantys aplinkos kalbą
langMessages="$(
  echo "${messages}" | while read -r item; do
    case ${item} in
    ("${lang}".*:*) echo "${item#"${lang}".}";;
    esac
  done
)"

# Funkcija pranešimui iš masyvo paimti pagal raktą
getMessage() {
  echo "${langMessages}" | while read -r item; do
    case ${item} in
    ("$1:"*) echo "${item#"$1":}" ; return ;;
    esac
  done
}

# Funkcija spalvotiems pranešimams išvesti
printMessage() {
  local color="32"; [[ "$1" == "err" ]] && color="31"
  local message; message="$(getMessage "$1")"
  printf '\n\033[%sm%s\033[39m\n' "${color}" "${message}" >&2
}

# Kodas, vykdomas baigiant programą
trap 'echo "" >&2' EXIT

# Išorinių komandų iškvietimo funkcija
runCmd() {

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command="sudo $*"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  separator=${command//?/'-'}

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  printf '\n%s\n%s\n%s\n\n' "${separator}" "${command}" "${separator}"

  # Įvykdoma komanda
  sudo "$@"

  # Komandos išėjimo kodas išsaugomas į kintamąjį
  exitCode="$?"

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if [[ "${exitCode}" -gt 0 ]]; then
    printMessage "err"
    exit "${exitCode}"
  fi

  # Kitu atveju išvedamas sėkmės pranešimas
  printMessage "succ"
}

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd apt-get update
runCmd apt-get upgrade -y
runCmd apt-get autoremove -y
runCmd snap refresh

# Scenarijaus baigties pranešimas
printMessage "end"
