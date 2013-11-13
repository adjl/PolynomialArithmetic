(load "qsort.lisp")

(defun var-sym (var) (convert (car var) <string>))
(defun sort-vars (vars) (qsort vars var-sym))

(defun make-poly (terms) (list 'poly terms))
(defun make-term-list terms terms)

(defun make-term (coeff vars) (list 'term coeff (sort-vars vars)))
(defun make-var-list vars vars)

(defun make-var (var power) (cons var power))

(defun coeff (term) (cadr term))
(defun vars (term) (caddr term))

(defun var (var) (car var))
(defun power (var) (cdr var))

(defun vars* (vars1 vars2)
  (cond ((and (null vars1) (null vars2)) '())
        ((null vars1) vars2)
        ((null vars2) vars1)
        (t (vars*-inner vars1 vars2))))

(defun vars*-inner (vars1 vars2)
  (let* ((var1 (car vars1))
         (var2 (car vars2))
         (var-sym1 (var-sym var1))
         (var-sym2 (var-sym var2)))
    (cond ((< var-sym1 var-sym2)
           (cons var1 (vars* (cdr vars1) vars2)))
          ((> var-sym1 var-sym2)
           (cons var2 (vars* vars1 (cdr vars2))))
          (t (cons (make-var (var var1) (+ (power var1) (power var2)))
                   (vars* (cdr vars1) (cdr vars2)))))))

(defun same-orderp (term1 term2) (equal (vars term1) (vars term2)))

(defun term+ (term1 term2)
  (cond ((same-orderp term1 term2)
         (make-term (+ (coeff term1) (coeff term2)) (vars term1)))
        (t (make-poly (make-term-list term1 term2)))))

(defun term- (term1 term2)
  (cond ((same-orderp term1 term2)
         (make-term (- (coeff term1) (coeff term2)) (vars term1)))
        (t (make-poly
             (make-term-list term1
                             (make-term (- (coeff term2)) (vars term2)))))))

(defun term* (term1 term2)
  (make-term (* (coeff term1) (coeff term2)) (vars* (vars term1) (vars term2))))
