#lang r7rs

(import (scheme base)
        (scheme file)
        (scheme read)
        (scheme write)
        (scheme cxr))

(define (lire-fichier-r7rs chemin)
  (call-with-input-file chemin
    (lambda (port)
      (let loop ((ligne (read-line port)))
        (if (eof-object? ligne)
            '()
            (cons ligne (loop (read-line port))))))))

(define fichier (lire-fichier-r7rs "input.txt"))

(define (signes-opposes? a b)
  (< (* a b) 0))

(define (count-zero l count number)
  (if (null? l)
      count
      (let* ((first (car l))
             (rest (cdr l))
             (value (string->number (substring first 1 (string-length first))))
             (new-number (if (string=? "L" (substring first 0 1))
                             (modulo (- number value) 100)
                             (modulo (+ number value) 100)))
             (new-count (if (>= (modulo value 100) number)
                            (+ count (abs(+ (quotient value 100) 1)))
                            (+ count (abs(quotient value 100))))))
        (display first)
        (newline)
        (display number)
        (newline)
        (count-zero rest new-count new-number))))

(display (count-zero fichier 0 50))