; Append the second polynomial to the first
; and simplify (i.e. collect like terms)
(defun poly+ (poly1 poly2)
  (polyreduce (append poly1 poly2)))

; Negate the second polynomial and add
(defun poly- (poly1 poly2)
  (polyreduce (append poly1 (polynegate poly2))))

; Multiply the first polynomial by each term
; in the second and add the resulting
; polynomials together
(defun poly* (poly1 poly2)
  (reduce poly+ (termlist* poly1 poly2)))

; Negate each term
(defun polynegate (poly)
  (map termnegate poly))

; Multiply all of the terms in the first
; polynomial by each term in the second
;
; Used when multiplying polynomials together
(defun termlist* (poly1 poly2)
  (if poly2 (cons (map (term*-out (car poly2)) poly1)
                  (termlist* poly1 (cdr poly2)))
    nil))

; Append the second variable list to the first
; and simplify (i.e. combine variables)
;
; Used when multiplying terms together
(defun varlist* (vars1 vars2)
  (varreduce (append vars1 vars2)))

; Add the coefficients together
; and use the same variable list
;
; Only used with like terms
(defun term+ (term1 term2)
  (cons (+ (coeff term1) (coeff term2))
        (list (vars term1))))

; Multiply the coefficients
; and the variables together
(defun term* (term1 term2)
  (cons (* (coeff term1) (coeff term2))
        (list (varlist* (vars term1) (vars term2)))))

(defun term*-out (term2)
  (lambda (term1) (term* term1 term2)))

; Negate the coefficient
(defun termnegate (term)
  (cons (- (coeff term)) (list (vars term))))

; Add the powers together
(defun var* (var1 var2)
  (make-var (sym var1)
            (+ (pwr var1) (pwr var2))))

; Add terms of the same order
(defun polyreduce (poly)
  ((tokenreduce term+ equal-order) poly))

; Multiply variables with the same symbol
(defun varreduce (variables)
  ((tokenreduce var* equal-sym) variables))

(defun tokenreduce (reduce-fun equal-fun)
  (lambda (tokens)
    (if tokens
      (cons (reduce reduce-fun
                    (filter (equal-fun id (car tokens)) tokens))
            ((tokenreduce reduce-fun equal-fun)
             (filter (equal-fun not (car tokens)) (cdr tokens))))
      nil)))

; Return whether two terms
; are of the same order
(defun equal-order (fun term)
  ((equal-token vars) fun term))

; Return whether two variables
; have the same symbol
(defun equal-sym (fun var)
  ((equal-token sym) fun var))

(defun equal-token (attr)
  (lambda (fun token1)
    (lambda (token2)
      (fun (equal (attr token1) (attr token2))))))

; Return an empty list if the term
; evaluates to zero
(defun term-simplify (term)
  ((token-simplify coeff) term))

; Return an empty list of the variable
; evaluates to one (i.e. power is zero)
(defun var-simplify (variable)
  ((token-simplify pwr) variable))

(defun token-simplify (attr)
  (lambda (token)
    (if (zerop (attr token)) nil token)))

; Construct the terms of a polynomial
(defun make-termlist (terms)
  (make-tokenlist terms))

; Construct the variables of a term
(defun make-varlist (variables)
  (make-tokenlist variables))

(defun make-tokenlist (tokens)
  (if tokens (cons (eval (car tokens))
                   (make-tokenlist (cdr tokens)))
    nil))

; Construct a polynomial
(defun make-poly (terms)
  (polyreduce (filter id (make-termlist terms))))

; Construct a term
(defun make-term (coefficient variables)
  (term-simplify (cons coefficient
                       (list (filter id (make-varlist variables))))))

; Construct a variable
(defun make-var (symbol power)
  (var-simplify (cons symbol power)))

(defun coeff (term) (car term)) ; Term coefficient
(defun vars (term) (cadr term)) ; Term variables
(defun sym (var) (car var)) ; Variable symbol
(defun pwr (var) (cdr var)) ; Variable power

(defun id (val) val) ; Identity function

(defun reduce (fun lst)
  (accumulate fun (car lst) (cdr lst)))

(defun filter (fun lst)
  (cond ((null lst) nil)
        ((fun (car lst))
         (cons (car lst) (filter fun (cdr lst))))
        (t (filter fun (cdr lst)))))
