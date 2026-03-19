#!/usr/bin/env -S racket

#lang racket
(require racket/dict)

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
(define langMessages (dict-ref messages (getenv "LANG")))

;; Funkcija spalvotiems tekstams išvesti
(define (display-strings code . args)
  ( let ([code (case code [(red)   "\x1B[31m"]
                          [(green) "\x1B[32m"]
                          [else    "\x1B[39m"])]
        [defcol "\x1B[39m"])
  (printf "\n~a~a~a\n" code (string-join args "") defcol))
)

;; Funkcija spalvotiems pranešimų tekstams išvesti
(define (print-message key)
  (if (equal? key "err")
    (display-strings 'red (dict-ref langMessages key) "")
    (display-strings 'green (dict-ref langMessages key) "")
  )
)

;; Išorinių komandų iškvietimo funkcija
(define
  (runCmd cmdArg)

  ;; Sukuriama komanda iš funkcijos argumento
  (define command (string-append "sudo " cmdArg))

  ;; Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  ;; (make-string ... #\-) - kartojamas simbolis '-'
  ;; (string-length command) - gaunamas komandos ilgis
  (define separator (make-string (string-length command) #\- ))

  ;; Išvedama komanda, apsupta skirtuko eilučių
  (display-strings "" separator "\n" command "\n" separator "\n" )


  ;; Įvykdoma komanda, proceso statusas išsaugomas į kintamąjį
  (define status (system/exit-code command))

  ;; Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  (when (> status 0)
    (print-message "err")
    (exit 99)
  )

  ;; Kitu atveju išvedamas sėkmės pranešimas
  (print-message "succ")
)

;; Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
(runCmd "apt-get update")
(runCmd "apt-get upgrade -y")
(runCmd "apt-get autoremove -y")
(runCmd "snap refresh")

(print-message "end")

(newline)
