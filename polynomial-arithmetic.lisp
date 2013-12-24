(defun poly+ (poly1 poly2)
  (polyreduce (append poly1 poly2)))

(defun poly- (poly1 poly2)
  (polyreduce (append poly1 (polynegate poly2))))

(defun poly* (poly1 poly2)
  (reduce poly+ (terms* poly1 poly2)))

(defun polynegate (poly)
  (map termnegate poly))

(defun terms* (poly1 poly2)
  (if poly2 (cons (map (term*-out (car poly2)) poly1)
                  (terms* poly1 (cdr poly2)))
    nil))

(defun term*-out (term1)
  (lambda (term2) (term* term1 term2)))

(defun vars* (vars1 vars2)
  (varreduce (append vars1 vars2)))

(defun term+ (term1 term2)
  (make-term (+ (coeff term1) (coeff term2))
             (vars term1)))

(defun term* (term1 term2)
  (make-term (* (coeff term1) (coeff term2))
             (vars* (vars term1) (vars term2))))

(defun termnegate (term)
  (make-term (- (coeff term)) (vars term)))

(defun var* (var1 var2)
  (make-var (sym var1)
            (+ (pow var1) (pow var2))))

(defun polyreduce (poly)
  ((tokenreduce term+ equal-order) poly))

(defun varreduce (variables)
  ((tokenreduce var* equal-sym) variables))

(defun equal-order (fun term)
  ((equal-token vars) fun term))

(defun equal-sym (fun var)
  ((equal-token sym) fun var))

(defun tokenreduce (reduce-fun equal-fun)
  (lambda (tokens)
    (if tokens
      (cons (reduce reduce-fun
                    (filter (equal-fun id (car tokens)) tokens))
            ((tokenreduce reduce-fun equal-fun)
             (filter (equal-fun not (car tokens)) (cdr tokens))))
      nil)))

(defun equal-token (attr)
  (lambda (fun token1)
    (lambda (token2)
      (fun (equal (attr token1) (attr token2))))))

(defun term-simplify (term)
  ((token-simplify coeff) term))

(defun var-simplify (variable)
  ((token-simplify pow) variable))

(defun token-simplify (attr)
  (lambda (token)
    (if (zerop (attr token)) nil val)))

(defun make-poly (terms)
  (polyreduce (filter id terms)))

(defun make-term (coefficient variables)
  (term-simplify (cons coefficient (filter id variables))))

(defun make-var (symbol power)
  (var-simplify (cons symbol power)))

(defun coeff (term) (car term))
(defun vars (term) (cdr term))
(defun sym (var) (car var))
(defun pow (var) (cdr var))

(defun id (val) val)

(defun reduce (fun lst)
  (accumulate fun (car lst) (cdr lst)))

(defun filter (fun lst)
  (cond ((null lst) nil)
        ((fun (car lst))
         (cons (car lst) (filter fun (cdr lst))))
        (t (filter fun (cdr lst)))))
