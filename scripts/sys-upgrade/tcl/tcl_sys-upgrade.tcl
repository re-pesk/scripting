#!/usr/bin/env tclsh

# Klaidų ir sėkmės pranešimų medis - žodynas
set messages {
  en.UTF-8 {
    err "Error! Script execution was terminated!"
    succ "Successfully finished!"
    end "End of execution."
  }
  lt_LT.UTF-8 {
    err "Klaida! Scenarijaus vykdymas sustabdytas!"
    succ "Komanda sėkmingai įvykdyta!"
    end "Scenarijaus vykdymas baigtas."
  }
}

# Aplinkos kalbos nuostata
set lang $env(LANG)

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
set langMessages [dict get $messages $lang]
set errorMessage [dict get $messages $lang err]
set successMessage [dict get $messages $lang succ]

# Funkcija spalvotiems pranešimams išvesti
proc printMessage {key} {
  global langMessages
  set color 32
  if {$key eq "err"} { set color 31 }
  set message [dict get $langMessages $key]
  puts "\n\033\[${color}m${message}\033\[39m"
  if {$key ne "succ"} { puts "" }
}

# Išorinių komandų iškvietimo procedūra
proc runCmd {cmdArg} {
  # Globaliniai kintamieji, naudojami procedūroje
  global errorMessage successMessage

  # Sukuriama komandos tekstinė eilutė iš procedūros argumento
  set command "sudo ${cmdArg}"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  set separator [string repeat "-" [string length $command]]

    # Išvedama komandos eilutė, apsupta skirtuko eilučių
  puts "\n${separator}\n${command}\n${separator}\n"

  # Įvykdoma komanda, rezultatas išsaugomas kintamajame
  set result [catch {exec >@stdout 2>@stderr {*}$command} _ options]

  # Jeigu vykdant komandą įvyko klaida,
  if {$result} {
    # išvedamas klaidos pranešimas
    printMessage err

    # Gaunami klaidos duomenys
    set errorDetails [dict get $options -errorcode]

    # Jeigu klaida įvyko vykdytoje komandoje
    if {[lindex $errorDetails 0] eq "CHILDSTATUS"} {

      # Programos vykdymas nutraukiamas, išvedant vykdytos komandos išeities kodą
      exit [lindex $errorDetails 2]
    }

    # Kitu atveju programos vykdymas nutraukiamas su laisvai pasirinktu klaidos kodu
    exit 1
  }

  # Jeigu klaidos nėra, išvedamas sėkmės pranešimas
  printMessage succ
}

runCmd {apt-get update}
runCmd {apt-get upgrade -y}
runCmd {apt-get autoremove -y}
runCmd {snap refresh}

# Scenarijaus baigties pranešimas
printMessage end
