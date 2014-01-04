(import "sort")

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

; Simplify term list
;; Add terms of the same order
(defun termreduce (terms)
  (termsort (filter id ((tokenreduce term+ equal-orderp)
                        (filter id terms)))))

; Simplify variable list
;; Multiply variables with the same symbol
(defun varreduce (vars)
  (varsort (filter id ((tokenreduce var* equal-symp)
                       (filter id vars)))))

;; Reduce similar tokens and recurse on the remaining ones
(defun tokenreduce (reduce-fun equal-funp)
  (lambda (tokens)
    (if tokens
      (cons (reduce reduce-fun
                    (filter (equal-funp id (car tokens)) tokens))
            ((tokenreduce reduce-fun equal-funp)
             (filter (equal-funp not (car tokens)) (cdr tokens))))
      nil)))

; Sort term list
(defun termsort (terms)
  (sort terms termcompare))

; Sort variable list
(defun varsort (vars)
  (sort vars var<))

; Compare two terms in lexicographical order and by variable power
(defun termcompare (term1 term2)
  (cond ((null (vars term1)) nil)
        ((null (vars term2)) t)
        ((equal (sym (car (vars term1)))
                (sym (car (vars term2))))
         (termpwr> term1 term2))
        (t (termsym< term1 term2))))

; Compare two terms' first variables in lexicographical order
(defun termsym< (term1 term2)
  (< (sym->str (sym (car (vars term1))))
     (sym->str (sym (car (vars term2))))))

; Compare two terms' first variables by power
(defun termpwr> (term1 term2)
  (> (pwr (car (vars term1))) (pwr (car (vars term2)))))

; Compare two variables in lexicographical order
(defun var< (var1 var2)
  (< (sym->str (sym var1)) (sym->str (sym var2))))

; Check if two terms are of the same order
(defun equal-orderp (fun term)
  ((equal-tokenp vars) fun term))

; Check if two variables have the same symbol
(defun equal-symp (fun var)
  ((equal-tokenp sym) fun var))

;; When fun is id, check if tokens are equal
;; when fun is not, check if tokens are not equal
(defun equal-tokenp (attr)
  (lambda (fun token1)
    (lambda (token2)
      (fun (equal (attr token1) (attr token2))))))

; Simplify term
(defun termsimplify (term)
  ((tokensimplify coeff) term))

; Simplify variable
(defun varsimplify (var)
  ((tokensimplify pwr) var))

;; Return an empty list if a term simplifies to zero
;; or a variable simplifies to one
(defun tokensimplify (attr)
  (lambda (token)
    (if (zerop (attr token)) nil token)))

; Construct term list
(defun make-termlist (terms)
  (make-tokenlist terms))

; Construct variable list
(defun make-varlist (vars)
  (make-tokenlist vars))

;; Eval each make-term or make-var
(defun make-tokenlist (tokens)
  (if tokens (cons (eval (car tokens))
                   (make-tokenlist (cdr tokens)))
    nil))

; Construct polynomial
(defun make-poly (terms)
  (termreduce (make-termlist terms)))

; Construct term
(defun make-term (coeff vars)
  ((make-term-lambda make-varlist) coeff vars))

; Construct term (internal)
(defun make-term-internal (coeff vars)
  ((make-term-lambda id) coeff vars))

;; Pass variable list to fun, simplify it and simplify term
(defun make-term-lambda (fun)
  (lambda (coeff vars)
    (termsimplify (cons coeff
                         (list (varreduce (fun vars)))))))

; Construct variable
(defun make-var (sym pwr)
  (varsimplify (cons sym pwr)))

(defun coeff (term) (car term)) ; Term coefficient
(defun vars (term) (cadr term)) ; Term variable list
(defun sym (var) (car var)) ; Variable symbol
(defun pwr (var) (cdr var)) ; Variable power

; Convert symbol to string
;; To compare by ASCII value
(defun sym->str (sym)
  (convert sym <string>))

(defun id (val) val) ; Identity

(defun reduce (fun lst)
  (if lst (accumulate fun (car lst) (cdr lst)) nil))

(defun filter (fun lst)
  (cond ((null lst) nil)
        ((fun (car lst)) (cons (car lst) (filter fun (cdr lst))))
        (t (filter fun (cdr lst)))))
