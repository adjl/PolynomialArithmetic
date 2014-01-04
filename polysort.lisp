; Term and variable sorting

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
  (< (->str (sym (car (vars term1))))
     (->str (sym (car (vars term2))))))

; Compare two terms' first variables by power
(defun termpwr> (term1 term2)
  (> (pwr (car (vars term1))) (pwr (car (vars term2)))))

; Compare two variables in lexicographical order
(defun var< (var1 var2)
  (< (->str (sym var1)) (->str (sym var2))))
