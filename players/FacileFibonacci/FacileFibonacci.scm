#!r6rs
(import (rnrs base)
        (only (rnrs) fold-left display command-line))

(define %SHARPEN "S")
(define %POKE    "P")
(define %BLOCK   "B")

(define (fibonacci? n)
  (let loop ((a 1) (b 1))
    (cond ((> a n) #f)
          ((= a n) #t)
          (else (loop b (+ a b))))))

(define (poke? num-sp)
  (if (< num-sp 8)
      (even? (div num-sp 2))
      (= 2 (mod num-sp 3))))

(define (split-string x)
  (let ((len (div (string-length x) 2)))
    (substring x 0 len)))
             
(define (num-sp x)
  (fold-left (lambda (a x) 
               (if (eqv? x #\B) a (+ a 1)))
             0 
             (string->list x)))

(define (advanced-strategy me)
  (cond ((fibonacci? (string-length me)) %BLOCK)
        ((poke? (num-sp me)) %POKE)
        (else %SHARPEN)))

(define (decide args)
  (if (= (length args) 1)
      %SHARPEN
      (advanced-strategy (split-string (cadr args)))))

;; The dirty imperative code:
(display (decide (command-line)))

