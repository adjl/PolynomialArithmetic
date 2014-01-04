; Simplifying

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
