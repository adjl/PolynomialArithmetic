; Utility and higher-order functions

(defun id (val) val) ; Identity

(defun reduce (fun lst)
  (if lst (accumulate fun (car lst) (cdr lst)) nil))

(defun filter (fun lst)
  (cond ((null lst) nil)
        ((fun (car lst)) (cons (car lst) (filter fun (cdr lst))))
        (t (filter fun (cdr lst)))))
