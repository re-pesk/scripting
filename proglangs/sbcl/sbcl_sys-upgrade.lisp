#!/usr/bin/env -S sbcl --script

;; Sukuriamas klaidų ir sėkmės pranešimų medis
(defvar *messages* (make-hash-table :test 'equal))

;; Aplinkos kalbos nuostata LANG
(defvar *lang* (sb-ext:posix-getenv "LANG"))

;; Pranešimų tekstai pagal aplinkos kalbos nuostatą
(defvar *lang-messages* (make-hash-table :test 'equal))

;; Sukuriamos medžio šakos skirtingomis kalbomis
(setf
  ;; Angliškai
  (gethash "en_US.UTF-8" *messages*) (make-hash-table :test 'equal)
  (gethash "err" (gethash "en_US.UTF-8" *messages*)) "Error! Script execution was terminated!"
  (gethash "succ" (gethash "en_US.UTF-8" *messages*)) "Command was successfully finished!"
  (gethash "end" (gethash "en_US.UTF-8" *messages*)) "End of execution."

  ;; Lietuviškai
  (gethash "lt_LT.UTF-8" *messages*) (make-hash-table :test 'equal)
  (gethash "err" (gethash "lt_LT.UTF-8" *messages*)) "Klaida! Scenarijaus vykdymas sustabdytas!"
  (gethash "succ" (gethash "lt_LT.UTF-8" *messages*)) "Komanda sėkmingai įvykdyta!"
  (gethash "end" (gethash "lt_LT.UTF-8" *messages*)) "Scenarijaus vykdymas baigtas."

  *lang-messages* (gethash *lang* *messages*)
)

;; Funkcija pranešimų tekstams išvesti
(defun print-message (key) (let
  ( ;; Spalva pagal pranešimo raktą
    (color (if (equal key "err") "31" "32" ))
    ;; Pranešimo tekstas
    (message (gethash key *lang-messages*))
  )

  (format t "~%~c[~am~a~c[39m~%" #\Esc color message #\Esc)
  (if (not (equal key "succ")) (format t "~%"))
))

;; Deklaruojama išorinių komandų iškvietimo funkcija
(defun run-cmd (cmd)

  (let*
    ( ;; Sukuriama komandos tekstinė eilutė iš funkcijos argumento
      (command (format nil "~{~a~^ ~}" (cons "sudo" cmd)))

      ;; Sukuriamas komandos ilgio skirtukas iš \"-\" simbolių
      ;; (length command) - gaunamas komandinės eilutės ilgis
      ;; (make-list <ilgis> :initial-element #\-) - sukuriamas nurodyto ilgio simbolių \"-\" sąrašas
      ;; (format nil "~{~a~}" <sąrašas>) - sukuriama teksto eilutė iš sąrašo elementų
      (separator (format nil "~{~a~}" (make-list (length command) :initial-element #\-)))
    )

    ;; Išvedama komandos eilutė, apsupta skirtuko eilučių
    (format t "~%~a~%~a~%~a~%~%" separator command separator)
  )

  (let
    ( ;; Įvykdoma komanda, proceso išėjimo kodas išsaugomas į kintamąjį
      (exit-code (process-exit-code (sb-ext:run-program "/usr/bin/sudo" cmd :input t :output t)))
    )

    (when ;; Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
      (> exit-code 0)
      (print-message "err")
      (exit :code exit-code)
    )

    ;; Kitu atveju išvedamas sėkmės pranešimas
    (print-message "succ")
  )
)

;; Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
(run-cmd '("apt" "update"))
(run-cmd '("apt-get" "upgrade" "-y"))
(run-cmd '("apt-get" "autoremove" "-y"))
(run-cmd '("snap" "refresh"))

;; Scenarijaus baigties pranešimas
(print-message "end")
