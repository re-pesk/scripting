#!/usr/bin/env -S clojure -M

;; Įkeliamas clojure.string modulis, sukuriant kai kurių funkcijų pravardes
(use '[clojure.string :rename {
  replace str-replace, split str-split, reverse str-reverse
}])

;; Klaidų ir sėkmės pranešimų medis
(def messages {
  "en.UTF-8" {
    :err "Error! Script execution was terminated!"
    :succ "Successfully finished!"
    :end "End of execution."
  }
  "lt_LT.UTF-8" {
    :err "Klaida! Scenarijaus vykdymas sustabdytas!"
    :succ "Komanda sėkmingai įvykdyta!"
    :end "Scenarijaus vykdymas baigtas."
  }
})

;; Pranešimai pagal aplinkos kalbos nuostatą
(def lang (System/getenv "LANG"))
(def langMessages (get messages lang))

;; Funkcija spalvotiems pranešimams išvesti
(defn printMessage [key]
  (def color (if (= key :err) "31" "32"))
  (def message (get langMessages key))
  (println (str "\n\033[" color "m" message "\033[39m"))
  (when (not= key :succ) (println))
)

;; Išorinių komandų iškvietimo funkcija
(defn runCmd [cmdArg]
  ;; Sukuriama komanda iš funkcijos argumento
  (def command (str "sudo " cmdArg))

  ;; Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  ;; (Str/replace command #"." "-") - sukuria neują eilutę,
  ;; bet kurį "command" eilutės simbolį pakeisdamas "-"
  (def separator (str-replace command #"." "-"))

  ;; Išvedama komanda, apsupta skirtuko eilučių
  (println (str "\n" separator "\n" command "\n" separator "\n"))

  ;; Įvykdoma komanda, proceso išėjimo kodas išsaugomas į kintamąjį
  (def exitCode (-> (ProcessBuilder. (str-split command #" ")) .inheritIO .start .waitFor))

  ;; Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  (if (not(= exitCode 0)) (
    (printMessage :err)
    (System/exit 99)
  ))

  ;; Kitu atveju išvedamas sėkmės pranešimas
  (printMessage :succ)
)

;; Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
(runCmd "apt-get update")
(runCmd "apt-get upgrade -y")
(runCmd "apt-get autoremove -y")
(runCmd "snap refresh")

;; Scenarijaus baigties pranešimas
(printMessage :end)
