(load "qsort.lisp")

(defun poly+ (poly1 poly2)
  (make-poly (append (terms poly1) (terms poly2))))

(defun poly- (poly1 . poly2)
  (make-poly (if poly2 (append (terms poly1) (terms (poly- poly2)))
               (map term- (terms poly1)))))

(defun poly* (poly1 poly2)
  (make-poly (terms* (terms poly1) (terms poly2))))

(defun make-poly terms
  (list 'poly (polyreduce (sort-by-order terms))))

(defun terms (poly) (cadr poly))

(defun polyreduce (terms)
  (cond ((null terms) '())
        ((same-orderp (car terms) (cadr terms))
         (cons (term+ (car terms) (cadr terms))
               (polyreduce (cddr terms))))
        (t (cons (car terms) (polyreduce (cdr terms))))))

(defun same-orderp (term1 term2)
  (equal (vars term1) (vars term2)))

(defun terms* (terms1 terms2)
  (reduce poly+ (terms*-inner terms1 terms2)))

(defun terms*-inner (terms1 terms2)
  (cond ((null terms1) '())
        (t (cons (map (lambda (term) (term* (car terms1) term)) terms2)
                 (terms*-inner (cdr terms1) terms2)))))

(defun term+ (term1 term2)
  (make-term (+ (coeff term1) (coeff term2)) (vars term1)))

(defun term- (term)
  (make-term (- (coeff term)) (vars term)))

(defun term* (term1 term2)
  (make-term (* (coeff term1) (coeff term2)) (vars* (vars term1) (vars term2))))

(defun vars* (vars1 vars2)
  (cond ((and (null vars1) (null vars2)) '())
        ((or (null vars1) (null vars2)) (or vars1 vars2))
        ((< (sym->val (sym (car vars1))) (sym->val (sym (car vars2))))
         (cons (car vars1) (vars* (cdr vars1) vars2)))
        ((> (sym->val (sym (car vars1))) (sym->val (sym (car vars2))))
         (cons (car vars2) (vars* vars1 (cdr vars2))))
        (t (cons (make-var (sym (car vars1)) (+ (power (car vars1)) (power (car vars2))))
                 (vars* (cdr vars1) (cdr vars2))))))

(defun make-term (coeff . vars)
  (list 'term coeff (sort-by-sym vars)))

(defun coeff (term) (cadr term))
(defun vars (term) (caddr term))

(defun make-var (sym power)
  (cons sym power))

(defun sym (var) (car var))
(defun power (var) (cdr var))

(defun sym->val (sym)
  (convert sym <string>))

(defun sort-by-order (terms)
  (qsort (qsort terms term-sym) term-power))

(defun term-sym (term)
  (sym->val (sym (car (vars term)))))

(defun term-power (term)
  (power (car (vars term))))

(defun sort-by-sym (vars)
  (qsort vars sym->val))
