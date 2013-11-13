(defun make-poly (terms) (list 'poly terms))
(defun make-term-list terms terms)

(defun make-term (coeff vars) (list 'term coeff vars))
(defun make-var-list vars vars)

(defun make-var (var power) (cons var power))

(defun coeff (term) (cadr term))
(defun vars (term) (caddr term))

(defun same-orderp (term1 term2) (equal (vars term1) (vars term2)))

(defun term+ (term1 term2)
  (cond ((same-orderp term1 term2)
         (make-term (+ (coeff term1) (coeff term2)) (vars term1)))
        (t (make-poly (make-term-list term1 term2)))))
