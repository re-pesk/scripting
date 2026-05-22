#!/usr/bin/env -S lua

-- Klaidų ir sėkmės pranešimų medis
local messages = {
  ["en.UTF-8"] = {
    ["err"] = "Error! Script execution was terminated!",
    ["succ"] = "Successfully finished!",
    ["end"] = "End of execution.",
  },
  ["lt_LT.UTF-8"] = {
    ["err"] = "Klaida! Scenarijaus vykdymas sustabdytas!",
    ["succ"] = "Komanda sėkmingai įvykdyta!",
    ["end"] = "Scenarijaus vykdymas baigtas.",
  }
}

-- Aplinkos kalbos nuostata
local lang = os.getenv("LANG")

-- Pranešimai pagal aplinkos kalbos nuostatą
local langMessages = messages[lang]

local function printMessage(key)
  local code = string.char(27)
  local color = (key == "err" and "31" or "32" )
  local message = langMessages[key]
  print(string.format("\n%s[%sm%s%s[39m", code, color, message, code))
  if (key ~= "succ") then print() end
end

-- Išorinių komandų iškvietimo funkcija
local function runCmd(cmdArg)
  -- Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  local command = "sudo " .. cmdArg

  -- Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  -- #command - komandinės eilutės ilgis
  -- string.rep("-",  n) - kartojamas '-' simbolis
  local separator = string.rep("-", #command)

  -- Išvedama komandos eilutė, apsupta skirtuko eilučių
  print(string.format("\n%s\n%s\n%s\n", separator, command, separator))

  -- vykdoma komanda, statusas ir išėjimo kodas išsaugomi
  local status, _, exitCode = os.execute(command)

  -- Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (not status) and exitCode > 0 then
    printMessage("err")
    os.exit(exitCode)
  end

  -- Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ")
end

-- Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")

-- Scenarijaus baigties pranešimas
printMessage("end")
