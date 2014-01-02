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

(defun term*-out (term2)
  (lambda (term1) (term* term1 term2)))

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
  ((tokenreduce term+ equal-order) poly))

; Simplify variable list
;; Multiply terms with the same symbol
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

; Whether two terms are of the same order
(defun equal-order (fun term)
  ((equal-token vars) fun term))

; Whether two variables have the same symbol
(defun equal-sym (fun var)
  ((equal-token sym) fun var))

(defun equal-token (attr)
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

(defun make-termlist (terms)
  (make-tokenlist terms))

(defun make-varlist (variables)
  (make-tokenlist variables))

(defun make-tokenlist (tokens)
  (if tokens (cons (eval (car tokens))
                   (make-tokenlist (cdr tokens)))
    nil))

(defun make-poly (terms)
  (polyreduce (filter id (make-termlist terms))))

(defun make-term (coefficient variables)
  ((make-term-lambda make-varlist) coefficient variables))

(defun make-term-internal (coefficient variables)
  ((make-term-lambda id) coefficient variables))

(defun make-term-lambda (fun)
  (lambda (coefficient variables)
    (termsimplify (cons coefficient
                         (list (filter id (fun variables)))))))

(defun make-var (symbol power)
  (varsimplify (cons symbol power)))

(defun coeff (term) (car term)) ; Term coefficient
(defun vars (term) (cadr term)) ; Term variable list
(defun sym (var) (car var)) ; Variable symbol
(defun pwr (var) (cdr var)) ; Variable power

(defun id (val) val) ; Identity

(defun reduce (fun lst)
  (accumulate fun (car lst) (cdr lst)))

(defun filter (fun lst)
  (cond ((null lst) nil)
        ((fun (car lst)) (cons (car lst) (filter fun (cdr lst))))
        (t (filter fun (cdr lst)))))
