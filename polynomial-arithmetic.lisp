(import "sort")

(load "polymake.lisp")   ; Constructors and accessors
(load "polypretty.lisp") ; Pretty printing
(load "polyreduce.lisp") ; Simplifying
(load "polysort.lisp")   ; Term and variable sorting
(load "polyutil.lisp")   ; Utility and higher-order functions

; Add two polynomials
;; Append them and add terms of the same order
(defun poly+ (poly1 poly2)
  (termreduce (append poly1 poly2)))

; Subtract a polynomial by another
(defun poly- (poly1 poly2)
  (poly+ poly1 (polynegate poly2)))

; Multiply two polynomials
;; Multiply out one by the other and add the resulting polynomials
(defun poly* (poly1 poly2)
  (reduce poly+ (termlist* poly1 poly2)))

; Negate a polynomial
(defun polynegate (poly)
  (map termnegate poly))

; Multiply out a polynomial by another
;; Multiply the first by each term in the second
(defun termlist* (poly1 poly2)
  (if poly2 (cons (map (term*-out (car poly2)) poly1)
                  (termlist* poly1 (cdr poly2)))
    nil))

(defun term*-out (term2)
  (lambda (term1) (term* term1 term2)))

; Add two terms
;; Only used with terms of the same order
(defun term+ (term1 term2)
  (make-term-internal (+ (coeff term1) (coeff term2))
                      (vars term1)))

; Multiply two terms
(defun term* (term1 term2)
  (make-term-internal (* (coeff term1) (coeff term2))
                      (varlist* (vars term1) (vars term2))))

; Negate a term
(defun termnegate (term)
  (make-term-internal (- (coeff term)) (vars term)))

; Multiply two variable lists
;; Append them and multiply variables with the same symbol
(defun varlist* (vars1 vars2)
  (varreduce (append vars1 vars2)))

; Multiply two variables
;; Only used with variables with the same symbol
(defun var* (var1 var2)
  (make-var (sym var1)
            (+ (pwr var1) (pwr var2))))
