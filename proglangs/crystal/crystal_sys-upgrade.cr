#!/usr/bin/env crystal


# Klaidų ir sėkmės pranešimų medis
Messages = {
  "en.UTF-8": {
    "err": "Error! Script execution was terminated!",
    "succ": "Successfully finished!",
    "end": "End of execution."
  },
  "lt_LT.UTF-8": {
    "err": "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ": "Komanda sėkmingai įvykdyta!",
    "end": "Scenarijaus vykdymas baigtas."
  },
}

# Pranešimai pagal aplinkos kalbos nuostatą
Lang = ENV["LANG"]
LangMessages = Messages[Lang]
# ErrorMessage = Messages[Lang]["err"]
# SuccessMessage = Messages[Lang]["succ"]

def printMessage(key : String)
  color = key == "err" ? "31" : "32"
  message = LangMessages[key]
  endLine = key == "succ" ? "" : "\n"
  puts "", "\x1b[#{color}m#{message}\x1b[39m\n#{endLine}"
end # def printMessage

# Išorinių komandų iškvietimo funkcija
def runCmd(cmdArg : String)

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command = "sudo " + cmdArg

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # "-" * - simbolio kartojimas, command.size - komandos simbolių skaičius
  separator = "-" * command.size

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  puts "", separator, command, separator, ""

  # Argumentų eilutė suskaidoma į masyvą
  args = cmdArg.split(' ')

  # Vykdoma komanda, komandos stausas išsaugomas į kintamąjį, išvedimas nukreipiamas į pagrindinį procesą
  status = Process.run(
    "sudo",
    args,
    input: Process::Redirect::Inherit,
    output: Process::Redirect::Inherit,
    error: Process::Redirect::Inherit,
  )

  # Jeigu įvyko klaida, išvedamas klaidos pranešimas ir išeinama iš programos
  if !status.success?
    printMessage "err"
    Process.exit(99)
  end

  # Jeigu klaidos nėra, išvedamas sėkmės pranešimas
  printMessage "succ"

end # def runCmd

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd "apt-get update"
runCmd "apt-get upgrade -y"
runCmd "apt-get autoremove -y"
runCmd "snap refresh"

# Scenarijaus baigties pranešimas
printMessage "end"
