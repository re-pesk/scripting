#! /usr/bin/env -S ruby

# Klaidų ir sėkmės pranešimų medis
messages = {
  :"en.UTF-8" => {
    :"err" => "Error! Script execution was terminated!",
    :"succ" => "Successfully finished!",
    :"end" => "End of execution.",
  },
  :"lt_LT.UTF-8" => {
    :"err" => "Klaida! Scenarijaus vykdymas sustabdytas!",
    :"succ" => "Komanda sėkmingai įvykdyta!",
    :"end" => "Scenarijaus vykdymas baigtas.",
  },
}

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
lang = ENV['LANG']
$langMessages = messages[:"#{lang}"]

# Funkcija spalvotiems pranešimams išvesti
def printMessage(key)
  color = "32"
  if key == :err
    color = "31"
  end
  message = $langMessages[:"#{key}"]
  endLine = "\n"
  if key == :succ
    endLine = ""
  end
  puts "\n\e[#{color}m#{message}\e[39m\n#{endLine}"
end

# Išorinių komandų iškvietimo funkcija
def runCmd(cmdArg)

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command = "sudo #{cmdArg}"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # '-' * simbolio kartojimas
  # comand.lengh - komandos eilutės ilgis
  separator = '-' * command.length

   # Išvedama komandos eilutė, apsupta skirtuko eilučių
  puts "", separator, command, separator, ""

  # Įvykdoma komanda, statusas išsaugomas į kintamąjį
  status = system( command )

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
  if !status
    printMessage(:err)
    exit(99)
  end

  # Kitu atveju išvedamas sėkmės pranešimas
  printMessage(:succ)
end

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")

# Scenarijaus baigties pranešimas
printMessage(:end)
