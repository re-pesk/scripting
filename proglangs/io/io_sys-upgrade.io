///usr/bin/env io "$0" "$@"; exit $?

// Klaidų ir sėkmės pranešimų medis
messages := Object clone do(
  setSlot("en.UTF-8", Object clone do(
    err := "Error! Script execution was terminated!"
    succ := "Successfully finished!"
    end := "End of execution."
  ))
  setSlot("lt_LT.UTF-8", Object clone do(
    err := "Klaida! Scenarijaus vykdymas sustabdytas!"
    succ := "Komanda sėkmingai įvykdyta!"
    end := "Scenarijaus vykdymas baigtas."
  ))
)

// Aplinkos kalbos nuostata
lang := System getEnvironmentVariable("LANG")

// Pranešimai pagal aplinkos kalbos nuostatą
langMessages := messages getSlot(lang)

printMessage := method(key,
  code := 0x1B asCharacter
  color := "32"
  message := langMessages getSlot(key)
  end := "\n"
  (key == "err") ifTrue(color = "31")
  "\n#{code}[#{color}m#{message asUTF8}#{code}[39m" interpolate println
  (key == "succ") ifFalse("" println)
)

// Išorinių komandų iškvietimo funkcija
runCmd := method(cmdArg, do(

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command := "sudo #{cmdArg}" interpolate

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  separator := ""
  for(a, 0, command size,
    separator = "#{separator}-" interpolate
  )

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  "\n#{separator}\n#{command}\n#{separator}\n" interpolate println

  // Įvykdoma komanda, išeities kodas išsaugomas į kintamąjį
  exitCode := System system(command)

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  (exitCode > 0) ifTrue(
    printMessage("err")
    System exit 99
  )

  // Kitu atveju išvedamas sėkmės pranešimas
  printMessage("succ")
))

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")

// Scenarijaus baigties pranešimas
printMessage("end")
