///usr/bin/env -S odin run "$0" -file -out:"${0%.*}.bin" -- "$@"; exit $?
#+feature dynamic-literals

package main

import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:strings"

// Funkcija spalvotiems pranešimams išvesti
printMessage :: proc(key: string, langMessages: map[string]string) {
  color := "31" if key == "err" else "32"
  message := langMessages[key]
  endLine := "" if key == "succ" else "\n"
  fmt.printfln("\n\033[%vm%v\033[39m%v", color, message, endLine)
}

// Išorinių komandų iškvietimo funkcija
runCmd :: proc(cmdArg: string, langMessages: map[string]string) {

  //Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command := strings.join({"sudo", cmdArg}, " ")

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // strings.repeat("-", ...) - simbolio kartojimas, len(command) - komandos ilgis
  separator := strings.repeat("-", len(command))

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  fmt.printfln("\n%v\n%v\n%v\n", separator, command, separator)

  // Kovertuoja komandos teksto eilutę į C kalbos eilutę
  csCommand := strings.clone_to_cstring(command)

  // Vykdoma komanda, išėjimo kodas išsaugomas į kintamąjį
  exitCode := libc.system(csCommand);

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exitCode != 0 {
    printMessage("err", langMessages)
    os.exit(99)
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ", langMessages)
}

// Pagrindinė funkcija - programos įeigos taškas
main :: proc() {

  // Klaidų ir sėkmės pranešimų medis
  messages := map[string]map[string]string{
    "en.UTF-8" = {
      "err" = "Error! Script execution was terminated!",
      "succ" = "Successfully finished!",
      "end" = "End of execution.",
    },
    "lt_LT.UTF-8" = {
      "err" = "Klaida! Scenarijaus vykdymas sustabdytas!",
      "succ" = "Komanda sėkmingai įvykdyta!",
      "end" = "Scenarijaus vykdymas baigtas.",
    },
  }

  // Pranešimai, atitinkantys aplinkos kalbą
  lang : string = os.get_env_alloc("LANG", context.temp_allocator)
  langMessages := messages[lang]

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd("apt-get update", langMessages)
  runCmd("apt-get upgrade -y", langMessages)
  runCmd("apt-get autoremove -y", langMessages)
  runCmd("snap refresh", langMessages)

  // Scenarijaus baigties pranešimas
  printMessage("end", langMessages)
}
