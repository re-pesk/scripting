#! /usr/bin/env -S elvish

# Klaidų ir sėkmės pranešimų medis
var messages = [
  &en.UTF-8= [
    &succ= "Successfully finished!"
    &err= "Error! Script execution was terminated!"
    &end= "End of execution."
  ]
  &lt_LT.UTF-8= [
    &succ= "Komanda sėkmingai įvykdyta!"
    &err= "Klaida! Scenarijaus vykdymas sustabdytas!"
    &end= "Scenarijaus vykdymas baigtas."
  ]
]

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
var lang = (get-env LANG)
var langMessages = $messages[$lang]

use str

fn printMessage {| key |
  var color = "32"
  if (==s $key "err") { set color = "31" }
  var message = $langMessages[$key]
  var endLine = "\n"
  if (==s $key "succ") { set end = "" }
  echo "\n\x1b["$color"m"$message"\x1b[39m"$endLine
}

# Išorinių komandų iškvietimo funkcija
fn runCmd {| @cmdArgs |
  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  var command = "sudo "(str:join ' ' $cmdArgs)

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # (count $command) grąžina eilutės ilgį
  # str:repeat  - generuoja seką iš "-" simbolių
  var separator = (str:repeat "-" (count $command) )

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  echo "\n"$separator"\n"$command"\n"$separator"\n"

  # Vykdoma komanda
  try {
    sudo $@cmdArgs
  } catch err {
      # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
      # echo $err[reason][exit-status] - spausdina klaidos priežastį
      printMessage "err"
      exit 99
  }

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
