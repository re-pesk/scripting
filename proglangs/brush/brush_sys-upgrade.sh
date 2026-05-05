#! /usr/bin/env -S brush
# shellcheck shell=bash

# Klaidų ir sėkmės pranešimų medis - asociatyvusis masyvas
declare -A messages=(
  [en.UTF-8.err]="Error! Script execution was terminated!"
  [en.UTF-8.succ]="Successfully finished!"
  [en.UTF-8.end]="End of execution."
  [lt_LT.UTF-8.err]="Klaida! Scenarijaus vykdymas sustabdytas!"
  [lt_LT.UTF-8.succ]="Komanda sėkmingai įvykdyta!"
  [lt_LT.UTF-8.end]="Scenarijaus vykdymas baigtas."
)

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
declare -A langMessages=()
for key in "${!messages[@]}"; do
  [[ "${key}" == "${LANG}"* ]] || continue
  langMessages["${key#"${LANG}".}"]="${messages[${key}]}"
done

declare -p langMessages

# Funkcija spalvotiems pranešimams išvesti
printMessage() {
  local key="$1"
  local message="${langMessages[$key]}"
  local color="32"
  [[ "${key}" == "err" ]] && color="31"
  printf "\n\033[${color}m%s\033[39m\n" "${message}" >&2
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

  # Išsaugomas įvykdytos komandos išėjimo kodas
  # exitCode="$?"

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  # shellcheck disable=SC2181
  if (( $? > 0 )); then
    printMessage "err"
    exit "$?"
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
