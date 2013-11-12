(defun make-term (coeff vars) (list 'term coeff vars))
(defun make-var-list vars vars)
(defun make-var (var power) (cons var power))

(defun coeff (term) (cadr term))
