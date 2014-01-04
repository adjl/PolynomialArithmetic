; Pretty printing

; Pretty print polynomial string
;; Remove leading + or prepend -
(defun polypretty (poly)
  (string-append
    (if (equal #\- (string-ref (poly->str poly) 0))
      "-" "")
    (substring (poly->str poly) 2)))

; Polynomial string representation
(defun poly->str (poly)
  (if poly
    (string-append
      (term->str (car poly))
      (if (cdr poly) " " "")
      (poly->str (cdr poly)))
    ""))

; Term string representation
(defun term->str (term)
  (string-append
    (if (> (coeff term) 0) "+ " "- ")
    (if (= (abs (coeff term)) 1) ""
      (->str (abs (coeff term))))
    (varlist->str (vars term))))

; Variable list string representation
(defun varlist->str (vars)
  (if vars
    (string-append
      (var->str (car vars))
      (varlist->str (cdr vars)))
    ""))

; Variable string representation
(defun var->str (var)
  (if (= (pwr var) 1)
    (->str (sym var))
    (string-append
      "(" (->str (sym var))
      "^" (->str (pwr var)) ")")))

; Convert token to string
(defun ->str (token)
  (convert token <string>))
