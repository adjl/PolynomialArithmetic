(test-case
  'test-case-polynomial-arithmetic
  '((test
      test-make-var
      ((assert-equal '()       (make-var 'x 0))
       (assert-equal '(x . 1)  (make-var 'x 1))))
    ))
