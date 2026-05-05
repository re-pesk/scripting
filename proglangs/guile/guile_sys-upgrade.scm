#!/usr/bin/env -S guile --no-auto-compile -s
!#

;; Klaidų ir sėkmės pranešimų medis
(define messages '(
  ("en.UTF-8" . (
    ("err" . "Error! Script execution was terminated!")
    ("succ" . "Successfully finished!")
    ("end" . "End of execution.")
  ))
  ("lt_LT.UTF-8" . (
    ("err" . "Klaida! Scenarijaus vykdymas sustabdytas!")
    ("succ" . "Komanda sėkmingai įvykdyta!")
    ("end" . "Vykdymas baigtas.")
  ))
))

;; Pranešimai pagal aplinkos kalbos nuostatą
(define langMessages (assoc-ref messages (getenv "LANG")))

;; Funkcija spalvotiems pranešimų tekstams išvesti
(define (print-message key)
  (define color (if (equal? key "err") "\x1B[31m" "\x1B[32m" ))
  (define message (assoc-ref langMessages key))
  (define defaultColor "\x1B[39m")
  (format #t "\n~a~a~a\n" color message defaultColor)
  (if (string<> key "succ") (format #t "\n" ))
)

;; Išorinių komandų iškvietimo funkcija
(define (runCmd cmdArg)

  ;; Sukuriama komanda iš funkcijos argumento
  (define command (string-append "sudo " cmdArg))

  ;; Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  ;; (make-string ... #\-) - kartojamas simbolis '-'
  ;; (string-length command) - gaunamas komandos ilgis
  (define separator (make-string (string-length command) #\- ))

  ;; Išvedama komanda, apsupta skirtuko eilučių
  (format #t "\n~a\n~a\n~a\n\n" separator command separator)

  ;; Įvykdoma komanda, proceso statusas išsaugomas į kintamąjį
  (define status (system command))

  ;; Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  (if (> (status:exit-val status) 0) (
    (print-message "err")
    (exit 99)
  ))

  ;; Kitu atveju išvedamas sėkmės pranešimas
  (print-message "succ")
)

;; Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
(runCmd "apt-get update")
(runCmd "apt-get upgrade -y")
(runCmd "apt-get autoremove -y")
(runCmd "snap refresh")

;; Scenarijaus baigties pranešimas
(print-message "end")
