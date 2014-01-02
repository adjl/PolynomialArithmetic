(import "sort")

; Add two polynomials
;; Append them and add terms of the same order
(defun poly+ (poly1 poly2)
  (polyreduce (append poly1 poly2)))

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

; Simplify polynomial
;; Add terms of the same order
(defun polyreduce (poly)
  ((tokenreduce term+ equal-orderp) (filter id poly)))

; Simplify variable list
;; Multiply variables with the same symbol
(defun varreduce (variables)
  (varsort ((tokenreduce var* equal-symp) (filter id variables))))

(defun tokenreduce (reduce-fun equal-funp)
  (lambda (tokens)
    (if tokens
      (cons (reduce reduce-fun
                    (filter (equal-funp id (car tokens)) tokens))
            ((tokenreduce reduce-fun equal-funp)
             (filter (equal-funp not (car tokens)) (cdr tokens))))
      nil)))

; Sort variable list
;; Sort in lexicographical order
(defun varsort (variables)
  (sort variables var<))

; Compare two variables
;; Check if the first comes before the second in lexicographical order
(defun var< (var1 var2)
  (< (sym->str (sym var1)) (sym->str (sym var2))))

; Check if two terms are of the same order
(defun equal-orderp (fun term)
  ((equal-tokenp vars) fun term))

; Check if two variables have the same symbol
(defun equal-symp (fun var)
  ((equal-tokenp sym) fun var))

(defun equal-tokenp (attr)
  (lambda (fun token1)
    (lambda (token2)
      (fun (equal (attr token1) (attr token2))))))

; Simplify term
;; Return an empty list if it simplifies to zero
(defun termsimplify (term)
  ((tokensimplify coeff) term))

; Simplify variable
;; Return an empty list if it simplifies to one
(defun varsimplify (variable)
  ((tokensimplify pwr) variable))

(defun tokensimplify (attr)
  (lambda (token)
    (if (zerop (attr token)) nil token)))

; Construct term list
;; Eval each make-term
(defun make-termlist (terms)
  (make-tokenlist terms))

; Construct variable list
;; Eval each make-var
(defun make-varlist (variables)
  (make-tokenlist variables))

(defun make-tokenlist (tokens)
  (if tokens (cons (eval (car tokens))
                   (make-tokenlist (cdr tokens)))
    nil))

; Construct polynomial
(defun make-poly (terms)
  (polyreduce (make-termlist terms)))

; Construct term
(defun make-term (coefficient variables)
  ((make-term-lambda make-varlist) coefficient variables))

; Construct term (internal)
(defun make-term-internal (coefficient variables)
  ((make-term-lambda id) coefficient variables))

(defun make-term-lambda (fun)
  (lambda (coefficient variables)
    (termsimplify (cons coefficient
                         (list (varreduce (fun variables)))))))

; Construct variable
(defun make-var (symbol power)
  (varsimplify (cons symbol power)))

(defun coeff (term) (car term)) ; Term coefficient
(defun vars (term) (cadr term)) ; Term variable list
(defun sym (var) (car var)) ; Variable symbol
(defun pwr (var) (cdr var)) ; Variable power

; Convert symbol to string
;; To compare by ASCII value
(defun sym->str (symbol)
  (convert symbol <string>))

(defun id (val) val) ; Identity

(defun reduce (fun lst)
  (accumulate fun (car lst) (cdr lst)))

(defun filter (fun lst)
  (cond ((null lst) nil)
        ((fun (car lst)) (cons (car lst) (filter fun (cdr lst))))
        (t (filter fun (cdr lst)))))
