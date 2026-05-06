#!/usr/bin/env -S eui
include std/os.e
include std/map.e

-- Klaidų ir sėkmės pranešimų medis
map messages = new_from_kvpairs({
    {"en.UTF-8", new_from_kvpairs({
      {"err", "Error! Script execution was terminated!"},
      {"succ", "Successfully finished!"},
      {"end", "End of execution."}
    })},
    {"lt_LT.UTF-8", new_from_kvpairs({
      {"err", "Klaida! Scenarijaus vykdymas sustabdytas!"},
      {"succ", "Komanda sėkmingai įvykdyta!"},
      {"end", "Scenarijaus vykdymas baigtas."}
    })}
})

-- Aplinkos kalbos nuostata
sequence lang = getenv("LANG")

-- Pranešimai pagal aplinkos kalbos nuostatą
map langMessages = get(messages, lang)

-- Funkcija spalvotiems pranešimams išvesti
procedure printMessage(sequence key)
  integer color = 32
  if equal(key, "err") then
    color = 31
  end if
  sequence message = get(langMessages, key)
  sequence endLine = "\n"
  if equal(key, "succ") then
    endLine = ""
  end if
  printf(1, "\n\e[%dm%s\e[39m\n%s", { color, message, endLine })
end procedure

-- Išorinių komandų iškvietimo funkcija
procedure runCmd(sequence cmdArg)

  -- Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  sequence command = sprintf("sudo %s", { cmdArg })

  -- Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  -- repeat('-', n) - pakartoja n '-' simbolių
  -- length(command) - komandinės eilutės ilgis
  sequence separator = repeat('-', length(command))

  -- Išvedama komandos eilutė, apsupta skirtuko eilučių
  printf(1, "\n%s\n%s\n%s\n\n", { separator, command, separator })

  -- Įvykdoma komanda, išėjimo kodas išsaugomas į kintamąjį
  integer exit_code = system_exec(command)

  -- Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exit_code > 0 then
    printMessage("err")
    abort(exit_code)
  end if

  -- Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ")
end procedure

-- Komandų vykdymo funkcijos iškvietimai su vykdytinų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")

-- Scenarijaus baigties pranešimas
printMessage("end")
