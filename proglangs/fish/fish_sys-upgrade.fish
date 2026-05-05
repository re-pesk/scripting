#! /usr/bin/env -S fish

# set fish_trace 1

set -g messages \
"[en_US.UTF-8.err]=Error! Script execution was terminated!" \
"[en_US.UTF-8.succ]=Successfully finished!" \
"[en_US.UTF-8.end]=End of execution." \
"[lt_LT.UTF-8.err]=Klaida! Scenarijaus vykdymas sustabdytas!" \
"[lt_LT.UTF-8.succ]=Komanda sėkmingai įvykdyta!" \
"[lt_LT.UTF-8.end]=Scenarijaus vykdymas baigtas."

# Pranešimai pagal aplinkos kalbos nuostatą
  # -a - visi atitikimai, f - tik atitinkančios eilutės, r - regexas
set -g langMessages (
  string replace -afr -- "^\[$LANG\.(?<key>.*)\]=(?<value>.*)\$" '[$key]=$value' $messages
)

echo "langMessages: $langMessages"

# Funkcija pranešimui iš masyvo paimti pagal raktą
function getMessage --argument-names key
  # -q - vykdoma be pranešimų, -r - regexas
  string replace -fr -- "^\[$key\]=(?<value>.*)\$" '$value' $langMessages
end

# Funkcija spalvotiems pranešimams išvesti
function printMessage --argument-names key
  set -l color "32"
  if test "$key" = "err"
    set color "31"
  end
  set -l message (getMessage $key)
  set -l endLine "\n"
  if test "$key" = "succ"
    set endLine ""
  end
  printf "\n\e[%sm%s\e[39m\n$endLine" $color $message
end

# Išorinių komandų iškvietimo funkcija
function runCmd ()

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  set -l command "sudo $argv"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # -a - visi atitikmenys, -r - regexas, '.' - bet koks simbolis, '-' - į '-' simbolį
  set -l separator (string replace -ar '.' '-' $command)

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  printf '\n%s\n%s\n%s\n\n' $separator $command $separator

  # Vykdoma komanda
  sudo $argv

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  # Įvykdymo rezultatas programos kintamajame $status išsaugomas automatiškai
  if test $status -gt 0
    printMessage "err"
    exit 99
  end

  # Kitu atveju išvedamas sėkmės pranešimas
  printMessage "succ"
end

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd apt-get update
runCmd apt-get upgrade -y
runCmd apt-get autoremove -y
runCmd snap refresh

# Scenarijaus baigties pranešimas
printMessage "end"
