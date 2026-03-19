#!/usr/bin/env -S sbcl --script

(defun main ()
  (let*
    ( ;; Sukuriamas klaidų ir sėkmės pranešimų medis
      (messages (make-hash-table :test 'equal))
    )

    ;; Sukuriamos medžio šakos skirtingomis kalbomis
    (setf
      ;; Angliškai
      (gethash "en.UTF-8" messages) (make-hash-table :test 'equal)
      (gethash "err" (gethash "en.UTF-8" messages)) "Error! Script execution was terminated!"
      (gethash "succ" (gethash "en.UTF-8" messages)) "Command was successfully finished!"
      (gethash "end" (gethash "en.UTF-8" messages)) "End of script execution."

      ;; Lietuviškai
      (gethash "lt_LT.UTF-8" messages) (make-hash-table :test 'equal)
      (gethash "err" (gethash "lt_LT.UTF-8" messages)) "Klaida! Scenarijaus vykdymas sustabdytas!"
      (gethash "succ" (gethash "lt_LT.UTF-8" messages)) "Komanda sėkmingai įvykdyta!"
      (gethash "end" (gethash "lt_LT.UTF-8" messages)) "Scenarijaus vykdymas baigtas."
    )

    (let*
      ( ;; Aplinkos kalbos nuostata LANG
        (lang (sb-ext:posix-getenv "LANG"))

        ;; Pranešimų tekstai pagal aplinkos kalbos nuostatą
        (lang-messages (gethash lang messages))
      )

      ;; Funkcija pranešimų tekstams išvesti
      (defun print-message (key)
        (if ;; Jeigu klaidos pranešimas
          (equal key "err")
          (format t "~%~c[31m~a~c[39m~%" #\Esc (gethash key lang-messages) #\Esc)
          (format t "~%~c[32m~a~c[39m~%" #\Esc (gethash key lang-messages) #\Esc)
        )
      )

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

          (let
            ( ;; Įvykdoma komanda, proceso išėjimo kodas išsaugomas į kintamąjį
              (exit-code (process-exit-code (run-program "/usr/bin/sudo" cmd :input t :output t)))
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
      )

      ;; Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
      (run-cmd '("apt" "update"))
      (run-cmd '("apt-get" "upgrade" "-y"))
      (run-cmd '("apt-get" "autoremove" "-y"))
      (run-cmd '("snap" "refresh"))

      (print-message "end")

      (write-line "")

    )
  )
)

(main)
