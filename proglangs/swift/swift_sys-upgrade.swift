///usr/bin/env -S swift "$0" "$@"; exit $?

import Foundation

// Klaidų ir sėkmės pranešimų medis
let messages: [String: [String: String]] = [
  "en.UTF-8": [
    "err": "Error! Script execution was terminated!",
    "succ": "Successfully finished!",
    "end": "End of execution.",
  ],
  "lt_LT.UTF-8": [
    "err": "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ": "Komanda sėkmingai įvykdyta!",
    "end": "Scenarijaus vykdymas baigtas.",
  ],
]

// Pranešimai, atitinkantys aplinkos kalbą
let env: [String: String] = ProcessInfo.processInfo.environment
let lang: String = env["LANG"] ?? ""
let langMessages: [String: String] = messages[lang] ?? [:]

// Funkcija spalvotiems pranešimams išvesti
func printMessage(_ key: String) {
  let color: String = key == "err" ? "31" : "32"
  let message: String = langMessages[key] ?? ""
  print("\n\u{001B}[\(color)m\(message)\u{001B}[39m")
  if key != "succ" { print() }
}

// Išorinių komandų iškvietimo funkcija
func runCmd(_ cmdArg: String) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  let command = "sudo \(cmdArg)"

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
	// String(repeating: "-", count: n) - simbolio kartojimas, command.count - komandos simbolių skaičius
  let separator = String(repeating: "-", count: command.count)

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  print("\n\(separator)\n\(command)\n\(separator)\n")

  // Vykdoma komanda, išsaugo išėjimo kodą į kintamąjį
  let exitCode: Int32 = system(command)

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exitCode != 0 {
    printMessage("err")
    exit(99)
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
