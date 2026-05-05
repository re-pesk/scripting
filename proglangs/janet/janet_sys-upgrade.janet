#!/usr/bin/env janet

# Klaidų ir sėkmės pranešimų medis
(def messages
  {"en.UTF-8"
   {:err "Error! Script execution was terminated!"
    :succ '"Successfully finished!"
    :end "End of execution."}
   "lt_LT.UTF-8"
   {:err "Klaida! Scenarijaus vykdymas sustabdytas!"
    :succ "Komanda sėkmingai įvykdyta!"
    :end "Scenarijaus vykdymas baigtas."}})

# Aplinkos kalbos nuostata
(def lang (os/getenv "LANG"))

# Pranešimai, atitinkantys aplinkos kalbą
(def langMessages (get messages lang))

# Funkcija spalvotiems pranešimams išvesti
(defn printMessage (key)
  (def color (if (= key :err) "31" "32"))
  (def message (get langMessages key))
  (print "\n\e[" color "m" message "\e[39m")
  (if (not= key :succ) (print ""))
  )

# Išorinių komandų iškvietimo funkcija
(defn runCmd (cmdArg)
  (do
    # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
    (def command (string "sudo " cmdArg))

    # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
    (def separator (string/repeat "-" (length command)))

    # Išvedama komandos eilutė, apsupta skirtuko eilučių
    (print "\n" separator "\n" command "\n" separator "\n")

    # Įvykdoma komanda, išėjimo kodas išsaugomas
    (def exitCode (os/execute (string/split " " command) :p))

    # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
    (if (> exitCode 0)
      (do
        (printMessage :err)
        (os/exit 99)))

    # Kitu atveju išvedamas sėkmės pranešimas
    (printMessage :succ)))

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
(runCmd "apt-get update")
(runCmd "apt-get upgrade -y")
(runCmd "apt-get autoremove -y")
(runCmd "snap refresh")

# Scenarijaus baigties pranešimas
(printMessage :end)
