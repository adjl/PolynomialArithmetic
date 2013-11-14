(load "qsort.lisp")

(defun sort-by-order (terms) terms)

(defun termreduce (term1 term2)
  (cond ((and term1 term2) (term+ term1 term2))
        (t (or term1 term2))))

(defun polyreduce (terms)
  (reduce termreduce (polyreduce-inner terms '())))

(defun polyreduce-inner (terms seen)
  (cond ((null terms) '())
        ((member (vars (car terms)) seen equal)
         (polyreduce-inner (cdr terms) seen))
        (t (cons
             (reduce termreduce
                     (map (lambda (term) (if (same-orderp (car terms) term) term))
                          terms))
             (polyreduce-inner (cdr terms) (cons (vars (car terms)) seen))))))

(defun make-poly terms
  (list 'poly (sort-by-order (polyreduce terms))))

(defun terms (poly) (cadr poly))

(defun poly+ (poly1 poly2)
  (make-poly (append (terms poly1) (terms poly2))))

(defun poly- (poly1 . poly2)
  (make-poly (if poly2 (append (terms poly1) (terms (poly- poly2)))
               (map term- (terms poly1)))))

(defun poly* (poly1 poly2)
  (make-poly (terms* (terms poly1) (terms poly2))))

(defun sort-by-sym (vars)
  (qsort vars (lambda (var) (sym->str (sym var)))))

(defun varreduce (vars)
  (cond ((null vars) '())
        ((null (car vars)) (varreduce (cdr vars)))
        (t (cons (car vars) (varreduce (cdr vars))))))

(defun varextract (vars)
  (cond ((or (null vars) (null (car vars))) '())
        ((consp (caar vars)) (car vars))
        (t vars)))

(defun make-term (coeff . vars)
  (cond ((zerop coeff) '())
        (t (list coeff (sort-by-sym (varreduce (varextract vars)))))))

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
        (t (cons
             (map (lambda (term) (term* (car terms1) term))
                  terms2)
             (terms*-inner (cdr terms1) terms2)))))

(defun make-var (sym pwr)
  (cond ((zerop pwr) '())
        (t (cons sym pwr))))

(defun sym (var) (car var))
(defun pwr (var) (cdr var))

(defun vars* (vars1 vars2)
  (cond ((or (null vars1) (null vars2)) (or vars1 vars2))
        ((< (sym->str (sym (car vars1))) (sym->str (sym (car vars2))))
         (cons (car vars1) (vars* (cdr vars1) vars2)))
        ((> (sym->str (sym (car vars1))) (sym->str (sym (car vars2))))
         (cons (car vars2) (vars* vars1 (cdr vars2))))
        (t (cons (make-var (sym (car vars1)) (+ (pwr (car vars1)) (pwr (car vars2))))
                 (vars* (cdr vars1) (cdr vars2))))))

(defun reduce (fun lst) (accumulate fun (car lst) (cdr lst)))
(defun same-orderp (term1 term2) (equal (vars term1) (vars term2)))
(defun sym->str (sym) (convert sym <string>))
