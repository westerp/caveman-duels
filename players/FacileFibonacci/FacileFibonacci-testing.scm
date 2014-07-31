#!r6rs
(import (rnrs base)
        (only (rnrs) fold-left display command-line)
        (only (srfi :78) check check-set-mode!))

(define %SHARPEN "S")
(define %POKE    "P")
(define %BLOCK   "B")

(define (fibonacci? n)
  (let loop ((a 1) (b 1))
    (cond ((> a n) #f)
          ((= a n) #t)
          (else (loop b (+ a b))))))

(check-set-mode! 'report-failed)

;; tests
(check (fibonacci? 0)  => #f)
(check (fibonacci? 1)  => #t)
(check (fibonacci? 13) => #t)


(define (poke? num-sp)
  (if (< num-sp 8)
      (even? (div num-sp 2))
      (= 2 (mod num-sp 3))))

(check (poke? 1)  => #t)
(check (poke? 2)  => #f)
(check (poke? 3)  => #f)
(check (poke? 8)   => #t)
(check (poke? 9)   => #f)
(check (poke? 10)  => #f)

(define (split-string x)
  (let ((len (div (string-length x) 2)))
    (substring x 0 len)))
             
(check (split-string "S,X")  => "S")

(define (num-sp x)
  (fold-left (lambda (a x) 
               (if (eqv? x #\B) a (+ a 1)))
             0 
             (string->list x)))

(check (num-sp "BBBBB")    => 0)
(check (num-sp "BSBBBB")   => 1)
(check (num-sp "BSBBPPBB") => 3)

(define (advanced-strategy me)
  (cond ((fibonacci? (string-length me)) %BLOCK)
        ((poke? (num-sp me)) %POKE)
        (else %SHARPEN)))

(check (advanced-strategy "SBB") => %BLOCK)
(check (advanced-strategy "SBBB") => %POKE)
(check (advanced-strategy "SBBBPB") => %SHARPEN)

(define (decide args)
  (if (= (length args) 1)
      %SHARPEN
      (advanced-strategy (split-string (cadr args)))))

(check (decide '(1))       => %SHARPEN)
(check (decide '(1 "S,S")) => %BLOCK)

;; The dirty imperative code:
(display (decide (command-line)))

