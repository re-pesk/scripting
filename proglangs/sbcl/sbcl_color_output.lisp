#!/usr/bin/env -S sbcl --script

; (format t "~c[31m~a~c[0m~%" #\Esc "Raudonas tekstas" #\Esc)

; (format t "[31m~a[0m~%" "Raudonas tekstas")

; (defparameter *red* (format nil "~c[31m" #\Esc))
; (defparameter *reset* (format nil "~c[0m" #\Esc))

; (format t "~a~a~a~%" *red* "Raudonas tekstas" *reset*)

; (defmacro with-color (code &body body)
;   `(progn
;      (format t "~c[~am" #\Esc ,code)
;      (unwind-protect
;        (progn ,@body)
;        (format t "~c[0m" #\Esc))))

(defconstant +\e+ (code-char #x1B))

;; ----------------
;; Pirmas variantas
;; ----------------

;; Spalvos kodas
(defun esc-code (code)
  (format nil "~c[~am" +\e+ code))

(defconstant +red+ 31)
(defconstant +green+ 32)
(defconstant +yellow+ 33)
(defconstant +blue+ 34)
(defconstant +default+ 39)
(defconstant +\red+ (esc-code 31))
(defconstant +\default+ (esc-code 39))

(format t "~%~a~a~a~%" +\red+ "Šis tekstas bus raudonas" +\default+)
; (format t "~%~a~a~a~%" +esc-blue+ "Šis tekstas bus raudonas" +\default+)
(format t "~%O šis vėl įprastas~%")

; (sb-ext:exit)

;; Išvedimo funkcija
(defun print-with-color-1 (stream code fmt &rest args)
  (unless                                   ;; Sąlygos neigimas
    (and
      (integerp code)                       ;; Kodas integer tipo
      (or
        (<= 30 code 37)                     ;; Jeigu kodas yra nuo 30 iki 37
        (<= 90 code 97)                     ;; Jeigu kodas yra nuo 90 iki 97
      )
    )
    ;; Išvedamas klaidos pranešimas
    (format t "~%~c[~am~a~c[~am~%~%" +\e+ 31 "Klaida! Nežinomas spalvos kodas!" +\e+ 39)
    (sb-ext:exit)                           ;; Nutraukiamas programos vykdymas
  )
  (format stream "~c[~am" +\e+ code)       ;; Spalvos kodo išvedimas
  (unwind-protect                           ;; Kodas, vykdomas visada, - finally analogas
    (apply #'format stream fmt args)        ;; Pagrindinis kodas - teksto išvedimas
    (format stream "~c[39m" +\e+)          ;; Pradinio spalvos kodo išvedimas
  )
)

;; Naudojimas
(print-with-color-1 t +red+ "~%~a~%" "1. Šis tekstas bus raudonas")
(format t "~%O šis vėl įprastas~%")

;; ----------------
;; Antras variantas
;; ----------------

;; Spalvos kodo funkcija
(defun color-code (c)
  (case c                                    ;; Jeigu spalvos kodas yra
    (:red 31)
    (:green 32)
    (:yellow 33)
    (:blue 34)
    (otherwise                              ;; kitu atveju
      ;; Išvedamas klaidos pranešimas
      (format t "~%~c[31m~a~c[39m~%~%" +\e+ "Klaida! Nežinomas spalvos kodas!" +\e+)
      (sb-ext:exit) ;;                       Nutraukiamas programos vykdymas
    )
  )
)

;; Išvedimo funkcija
(defun print-with-color-2 (stream color fmt &rest args)
  (let
    ((code (color-code color))              ;; Gaunamas spalvos kodas iš spalvos kodo funkcijos
    )
    (format stream "~c[~am" +\e+ code)     ;; Spalvos kodo išvedimas
    (unwind-protect                         ;; Kodas, vykdomas visada, - finally analogas
      (apply #'format stream fmt args)      ;; Pagrindinis kodas - teksto išvedimas
      (format stream "~c[39m" +\e+)        ;; Pradinio spalvos kodo išvedimas
    )
  )
)

;; Naudojimas
(print-with-color-2 t :red "~%~a~%" "2. Šis tekstas bus raudonas")
(format t "~%O šis vėl įprastas~%")

;; -----------------
;; Trečias variantas
;; -----------------

;; Išvedimo funkcija
(defun print-with-color-3 (stream color fmt &rest args)
  (let
    ( ;; Spalvos kodas
      (code
        (cond
          ((string= color "red") 31)
          ((string= color "green") 32)
          ((string= color "yellow") 33)
          ((string= color "blue") 34)
          (t
            (format t "~%~c[31m~a~c[39m~%~%" +\e+ "Klaida! Nežinomas spalvos kodas!" +\e+)
            (sb-ext:exit)
          )
        )
      )
    )
    (format stream "~c[~am" +\e+ code)    ;; Spalvos kodo išvedimas
    (unwind-protect                        ;; Kodas, vykdomas visada, - finally analogas
      (apply #'format stream fmt args)     ;; Pagrindinis kodas - teksto išvedimas
      (format stream "~c[39m" +\e+)       ;; Pradinio spalvos kodo išvedimas
    )
  )
)

(print-with-color-3 t "red" "~%~a~%" "3. Šis tekstas bus raudonas")
(format t "~%O šis vėl įprastas~%")

;; -------------------
;; Ketvirtas variantas
;; -------------------

(defun print-with-color-4 (stream color fmt &rest args)
  (let
    ( ;; Spalvos kodas
      (code
        (case color
          (:red 31)
          (:green 32)
          (:yellow 33)
          (:blue 34)
          (otherwise
            (format t "~%~c[31m~a~c[39m~%~%" +\e+ "Klaida! Nežinomas spalvos kodas!" +\e+)
            (sb-ext:exit)
          )
        )
      )
    )
    (format stream "~c[~am" +\e+ code)
    (unwind-protect
      (apply #'format stream fmt args)
      (format stream "~c[39m" +\e+)
    )
  )
)

(print-with-color-4 t :red "~%~a~%" "4. Šis tekstas bus raudonas")
(format t "~%O šis vėl įprastas~%")

;; -----------------
;; Penktas variantas
;; -----------------

(defmacro with-color (code &body body)
  `(progn
     (format t "~c[~am" (code-char #x1B) ,code)
     (unwind-protect
       (progn ,@body)
       (format t "~c[39m" (code-char #x1B)))))

;; Naudojimas:
(with-color 31
  (format t "~%5.Šis tekstas bus raudonas~%"))
(format t "~%O šis vėl įprastas~%")

(write-line "")
