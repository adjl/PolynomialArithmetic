; Constructors and accessors

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
