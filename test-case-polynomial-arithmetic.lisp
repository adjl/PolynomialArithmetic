(test-case
  'test-case-polynomial-arithmetic
  '((test
      test-make-var
      ((assert-equal '()       (make-var 'x 0))
       (assert-equal '(x . 1)  (make-var 'x 1))))
    (test
      test-var-simplify
      ((assert-equal '()       (var-simplify '(x . 0)))
       (assert-equal '(x . 1)  (var-simplify '(x . 1)))))
    (test
      test-sym
      ((assert-equal 'x  (sym (make-var 'x 1)))))
    ))
