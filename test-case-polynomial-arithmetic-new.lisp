(test-case 'test-case-polynomial-arithmetic-new
           '(
             (test test-make-var
                   ((assert-equal '(x . 1) (make-var 'x 1))))

             (test test-sym
                   ((assert-equal 'x (sym (make-var 'x 1)))))

             (test test-pwr
                   ((assert-equal 1 (pwr (make-var 'x 1)))))

             (test test-sym->str
                   ((assert-equal "x" (sym->str 'x))))

             (test test-vars*
                   ((assert-equal '()        (vars* '() '()))
                    (assert-equal '((x . 1)) (vars* '((x . 1)) '()))
                    (assert-equal '((y . 1)) (vars* '() '((y . 1))))
                    (assert-equal '((x . 1) (y . 1)) (vars* '((x . 1)) '((y . 1))))
                    (assert-equal '((x . 1) (y . 1)) (vars* '((y . 1)) '((x . 1))))
                    (assert-equal '((x . 2)) (vars* '((x . 1)) '((x . 1))))))
             ))
