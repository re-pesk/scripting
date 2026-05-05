#!/usr/bin/env -S julia

import Printf: @printf

# Klaidų ir sėkmės pranešimų medis
messages = Dict(
  "en.UTF-8" => Dict(
    "err" => "Error! Script execution was terminated!",
    "succ" => "Successfully finished!",
    "end" => "End of execution.",
  ),
  "lt_LT.UTF-8" => Dict(
    "err" => "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" => "Komanda sėkmingai įvykdyta!",
    "end" => "Scenarijaus vykdymas baigtas.",
  ),
)

# Pranešimai, atitinkantys aplinkos kalbą
lang = ENV["LANG"]
langMessages = messages[lang]

# Funkcija spalvotiems pranešimams išvesti
function printMessage(key)
  color = key == "err" ? "31" : "32"
  message = langMessages[key]
  endLine = key == "succ" ? "" : "\n"
  @printf("\n\e[%sm%s\e[39m\n%s", color, message, endLine)
end

# Išorinių komandų iškvietimo funkcija
function runCmd(cmdArg)

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command = "sudo $cmdArg"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # repeat("-", n) - kartoja '-' simbolį, length(command) - paima komandinės eilutės ilgį
  separator = repeat("-", length(command))

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  @printf("\n%s\n%s\n%s\n\n", separator, command, separator)

  # Paverčia komandos argumentą masyvu
  args = split(cmdArg, " ")

  # Sukuria komandos objektą
  objCmd = Cmd(`sudo $args`, ignorestatus = true)

  # Vykdoma komanda ir išaugo išėjimo kodą
  exitCode = run(objCmd).exitcode

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exitCode != 0
    printMessage("err")
    exit(exitCode)
  end

  # Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ")
end

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")

# Scenarijaus baigties pranešimas
printMessage("end")
