#! /usr/bin/env -S pwsh

# Klaidų ir sėkmės pranešimų medis
$messages = @{
  "en.UTF-8" = @{
    "err" = "Error! Script execution was terminated!"
    "succ" = "Successfully finished!"
    "end" = "End of execution."
  }
  "lt_LT.UTF-8" = @{
    "err" = "Klaida! Scenarijaus vykdymas sustabdytas!"
    "succ" = "Komanda sėkmingai įvykdyta!"
    "end" = "Scenarijaus vykdymas baigtas."
  }
}

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
$langMessages = $messages[$env:LANG]

# Funkcija spalvotiems pranešimams išvesti
function printMessage {
  param(
    [string]$key
  )
  $color = if ($key -eq "err") { "31" } else { "32" }
  $message = $langMessages[$key]
  $endLine = if ($key -eq "succ") { "" } else { "`n" }
  Write-Host "`n$([char]27)[$color`m$message$([char]27)[39m$endLine"
}

# Išorinių komandų iškvietimo funkcija
function runCmd {
  param(
    [string]$cmdArg
  )

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  $command = "sudo $cmdArg"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # "-" * - simbolio kartojimas
  # $command.length - komandos eilutės ilgis
  $separator = $("-" * $command.length)

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  Write-Host "`n$separator`n$command`n$separator`n"

  # Įvykdoma komanda
  &"sudo" $cmdArg.Split(" ")

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
  if ($LASTEXITCODE -ne 0) {
    printMessage "err"
    Exit 99
  }

  # Kitu atveju išvedamas sėkmės pranešimas
  printMessage "succ"
}

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd "snap refresh"

# Scenarijaus baigties pranešimas
printMessage "end"
