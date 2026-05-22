#! /usr/bin/env -S nu

# Klaidų ir sėkmės pranešimų medis
let messages = {
  "en.UTF-8" : {
    'succ' : "Successfully finished!",
    'err' : "Error! Script execution was terminated!",
    'end' : "End of execution."
  },
  'lt_LT.UTF-8' : {
    'succ' : "Komanda sėkmingai įvykdyta!",
    'err' : "Klaida! Scenarijaus vykdymas sustabdytas!",
    'end' : "Scenarijaus vykdymas baigtas."
  },
}

# Pranešimai, atitinkantys aplinkos kalbą
let lang = $env.LANG
let langMessages = $messages | get $lang

# Funkcija spalvotiems pranešimams išvesti
def printMessage [key] {
  let color = if $key == "err" { $'(ansi red)' } else { $'(ansi green)' }
  let reset = $'(ansi reset)'
  let message = $langMessages | get $key
  let endLine = if $key == "succ" { "" } else { "\n" }
  print "" $"($color)($message)($reset)($endLine)"
}

# Išorinių komandų iškvietimo funkcija
def runCmd [...cmdArgs] {

  # Sukuria komandos tekstinę eilutę iš funkcijos argumentų
  let command = ["sudo" ...$cmdArgs] | str join " "

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # Visi komandos eilutės simboliai pakeičiami "-" simboliu
  let separator = $command | str replace --all --regex "." "-"

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  print "" $separator $command $separator ""

  # Vykdoma komanda. Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  try { run-external "sudo" ...$cmdArgs } catch {
    printMessage "err"
    exit 1
  }

  # Kitu atveju išvedamas sėkmės pranešimas
  printMessage "succ"
}

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd apt-get update
runCmd apt-get upgrade "-y"
runCmd apt-get autoremove "-y"
runCmd snap refresh

# Scenarijaus baigties pranešimas
printMessage "end"
