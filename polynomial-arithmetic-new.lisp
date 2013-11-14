(load "qsort.lisp")

(defun make-poly terms
  (list 'poly (polyreduce (sort-by-order terms))))

(defun terms (poly) (cadr poly))

(defun polyreduce (terms)
  (cond ((null terms) '())
        ((same-orderp (car terms) (cadr terms))
         (cons (term+ (car terms) (cadr terms)) (polyreduce (cddr terms))))
        (t (cons (car terms) (polyreduce (cdr terms))))))

(defun same-orderp (term1 term2)
  (equal (vars term1) (vars term2)))

(defun sort-by-order (terms)
  (qsort (qsort terms term-sym) term-pwr))

(defun term-sym (term)
  (sym->str (sym (car (vars term)))))

(defun term-pwr (term)
  (pwr (car (vars term))))

(defun poly+ (poly1 poly2)
  (make-poly (append (terms poly1) (terms poly2))))

(defun poly- (poly1 . poly2)
  (make-poly (if poly2 (append (terms poly1) (terms (poly- poly2)))
               (map term- (terms poly1)))))

(defun poly* (poly1 poly2)
  (make-poly (terms* (terms poly1) (terms poly2))))

(defun sort-by-sym (vars)
  (qsort vars (lambda (var) (sym->str (sym var)))))

(defun make-term (coeff . vars)
  (list coeff (sort-by-sym
                (cond ((or (null vars) (null (car vars))) '())
                      ((consp (caar vars)) (car vars))
                      (t vars)))))

(defun coeff (term) (car term))
(defun vars (term) (cadr term))

(defun term+ (term1 term2)
  (make-term (+ (coeff term1) (coeff term2)) (vars term1)))

(defun term- (term)
  (make-term (- (coeff term)) (vars term)))

(defun term* (term1 term2)
  (make-term (* (coeff term1) (coeff term2)) (vars* (vars term1) (vars term2))))

(defun terms* (terms1 terms2)
  (reduce (lambda (terms1 terms2) (poly+ (make-poly terms1) (make-poly terms2)))
          (terms*-inner terms1 terms2)))

(defun terms*-inner (terms1 terms2)
  (cond ((null terms1) '())
        (t (cons (map (lambda (term) (term* (car terms1) term)) terms2)
                 (terms*-inner (cdr terms1) terms2)))))

(defun make-var (sym pwr)
  (cons sym pwr))

(defun sym (var) (car var))
(defun pwr (var) (cdr var))

(defun sym->str (sym)
  (convert sym <string>))

(defun vars* (vars1 vars2)
  (cond ((and (null vars1) (null vars2)) '())
        ((or (null vars1) (null vars2)) (or vars1 vars2))
        ((< (sym->str (sym (car vars1))) (sym->str (sym (car vars2))))
         (cons (car vars1) (vars* (cdr vars1) vars2)))
        ((> (sym->str (sym (car vars1))) (sym->str (sym (car vars2))))
         (cons (car vars2) (vars* vars1 (cdr vars2))))
        (t (cons (make-var (sym (car vars1)) (+ (pwr (car vars1)) (pwr (car vars2))))
                 (vars* (cdr vars1) (cdr vars2))))))
