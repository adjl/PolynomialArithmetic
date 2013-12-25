(test-case
  'test-case-polynomial-arithmetic
  '((test
      test-make-var
      ((assert-equal '()       (make-var 'x 0))
       (assert-equal '(x . 1)  (make-var 'x 1))
       (assert-equal '(x . 2)  (make-var 'x 2))))
    (test
      test-var-simplify
      ((assert-equal '()       (var-simplify '(x . 0)))
       (assert-equal '(x . 1)  (var-simplify '(x . 1)))))
    (test
      test-sym
      ((assert-equal 'x  (sym (make-var 'x 1)))))
    (test
      test-pwr
      ((assert-equal 1  (pwr (make-var 'x 1)))))
    (test
      test-make-varlist
      ((assert-equal '()         (make-varlist '()))
       (assert-equal '(())       (make-varlist '((make-var 'x 0))))
       (assert-equal '((x . 1))  (make-varlist '((make-var 'x 1))))
       (assert-equal '((x . 1) (y . 1))
                     (make-varlist '((make-var 'x 1) (make-var 'y 1))))))
    (test
      test-make-term
      ((assert-equal '()             (make-term 0 '()))
       (assert-equal '(1 ())         (make-term 1 '()))
       (assert-equal '(2 ((x . 1)))  (make-term 2 '((make-var 'x 1))))
       (assert-equal '(3 ((x . 2)))  (make-term 3 '((make-var 'x 2))))
       (assert-equal '(4 ((x . 1) (y . 1)))
                     (make-term 4 '((make-var 'x 1) (make-var 'y 1))))))
    (test
      test-term-simplify
      ((assert-equal '()             (term-simplify '(0 ((x . 1)))))
       (assert-equal '(1 ((x . 1)))  (term-simplify '(1 ((x . 1)))))))
    (test
      test-coeff
      ((assert-equal 1  (coeff (make-term 1 '((make-var 'x 1)))))))
    (test
      test-vars
      ((assert-equal '((x . 1))  (vars (make-term 1 '((make-var 'x 1)))))))
    ))
