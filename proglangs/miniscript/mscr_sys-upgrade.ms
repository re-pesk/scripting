///usr/bin/env -S miniscript "$0" "$@"; exit "$?"
// #!/usr/bin/env -S miniscript

// Klaidų ir sėkmės pranešimų medis
messages = {
  "en.UTF-8" : {
    "err" : "Error! Script execution was terminated!",
    "succ" : "Successfully finished!",
    "end" : "End of execution.",
  },
  "lt_LT.UTF-8" : {
    "err" : "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" : "Komanda sėkmingai įvykdyta!",
    "end" : "Scenarijaus vykdymas baigtas.",
  },
}

// Pranešimai, atitinkantys aplinkos kalbą
langMessages = messages[env.LANG]

// Funkcija spalvotiems pranešimams išvesti
printMessage = function (key)
  color = "32"
  if key == "err" then color = "31"
  message = langMessages[key]
  print(char(10) + char(27) + "[" + color + "m" + message + char(27) + "[39m")
  if key != "succ" then print("")
end function

// Išorinių komandų iškvietimo funkcija
runCmd = function (cmdArg)
  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command = "sudo " + cmdArg

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // command.len - komandinės eilutės ilgis
  // "-" * n - kartojamas '-' simbolis
  separator = "-" * command.len

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  print(char(10) + separator + char(10) + command + char(10) + separator)

  // vykdoma komanda, statusas ir išėjimo kodas išsaugomi
  result = exec(command, 300)

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if result.status > 0 then
    print(result.errors)
    printMessage("err")
    exit(result.status)
  end if

  // Kitu atveju išvedama komandos išvestis ir sėkmės pranešimas
  if result.output.len > 0 then
    print(char(10) + result.output)
  end if
  printMessage("succ")
end function

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")

// Scenarijaus baigties pranešimas
printMessage("end")
