///usr/bin/env groovy "$0" "$@"; exit $?

// Klaidų ir sėkmės pranešimų medis
def messages = [
  'en.UTF-8' : [
    'err' : "Error! Script execution was terminated!",
    'succ' : "Successfully finished!",
    'end' : "End of execution."
  ],
  'lt_LT.UTF-8' : [
    'err' : "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ' : "Komanda sėkmingai įvykdyta!",
    'end' : "Scenarijaus vykdymas baigtas."
  ],
]

// Aplinkos kintamasis su aplinkos kalbos nuostata
def lang = System.getenv('LANG')

// Globalūs kintamieji su pranešimais, atitinkančiais aplinkos kalbą,
langMessages = messages[lang]

def printMessage(String key) {
  def color = "32"
  if (key == "err") {
    color = "31"
  }
  def message = langMessages[key]
  def endLine = "\n"
  if (key == "succ") {
    endLine = ""
  }
  println "\n\u001b[${color}m${message}\u001b[39m${endLine}"
}

// Išorinių komandų iškvietimo funkcija
def runCmd(String cmdArg) {
  // Komanda iš funkcijos argumento
  def command = "sudo $cmdArg"

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // '-'* - kartoja '-' simbolį
  // command.length() - komandos ilgis
  def separator = '-'*command.length()

  // Komanda išvedama, apsupta skirtuko eilučių
  println "\n${separator}\n${command}\n${separator}\n"

  // Įvykdoma komanda, procesas išsaugomas į kintamąjį
  Process proc = command.execute()

  // Sulaukiama, kol procesas baigs išvedimą į kviečiančio proceso išvedimo srautus.
  proc.waitForProcessOutput(System.out, System.err)

  // Komandos išėjimo kodas išsaugomas į kintamąjį
  def exitCode = proc.exitValue()

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode > 0) {
    printMessage("err")
    System.exit(99)
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ")
}

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")

// Scenarijaus baigties pranešimas
printMessage("end")
