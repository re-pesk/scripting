#! /usr/bin/env -S dash

# Klaidų ir sėkmės pranešimų masyvas - kiekvienas pranešimas naujoje eilutėje
messages="en.UTF-8.err:Error! Script execution was terminated!
en.UTF-8.succ:Successfully finished!
en.UTF-8.end:End of execution.
lt_LT.UTF-8.err:Klaida! Scenarijaus vykdymas sustabdytas!
lt_LT.UTF-8.succ:Komanda sėkmingai įvykdyta!
lt_LT.UTF-8.end:Scenarijaus vykdymas baigtas."

# Pranešimai, atitinkantys aplinkos kalbą
langMessages="$(
  echo "${messages}" | while read -r item; do
    case ${item} in
    ("${LANG}".*:*) echo "${item#"${LANG}".}";;
    esac
  done
)"

# Funkcija pranešimui iš masyvo paimti pagal raktą
getMessage() {
  echo "${langMessages}" | while read -r item; do
    case ${item} in
    ("$1:"*) echo "${item#"$1":}"; return ;;
    esac
  done
}

# Funkcija spalvotiems pranešimams išvesti
printMessage() {
  local color="32"; [ "$1" = "err" ] && color="31"
  local message; message="$(getMessage "$1")"
  printf '\n\033[%sm%s\033[39m\n' "${color}" "${message}" >&2
}

trap 'echo "" >&2' EXIT


# Išorinių komandų iškvietimo funkcija
runCmd() {

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command="sudo $*"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # Kol separatoriaus ilgis mažesnis už komandos ilgį,
  # '-' simbolis pridedamas prie separatoriaus
  separator=""
  while [ "${#separator}" -lt "${#command}" ]; do
    separator="${separator}-"
  done

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  printf '\n%s\n%s\n%s\n\n' "${separator}" "${command}" "${separator}"

  # Įvykdoma komanda
  sudo "$@"

  # Komandos išėjimo kodas išsaugomas į kintamąjį
  exitCode="$?"

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if [ "${exitCode}" -gt 0 ]; then
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
