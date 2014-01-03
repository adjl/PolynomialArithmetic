(test-case
  'test-case-polynomial-arithmetic
  '((test
      test-make-poly
      ((assert-equal '()
                     (make-poly '((make-term 0 '((make-var 'x 1))))))
       (assert-equal '((1 ()))
                     (make-poly '((make-term 1 '()))))
       (assert-equal '((1 ((x . 1))))
                     (make-poly '((make-term 1 '((make-var 'x 1))))))
       (assert-equal '((1 ((x . 2))))
                     (make-poly '((make-term 1 '((make-var 'x 2))))))
       (assert-equal '((1 ((x . 1) (y . 1))))
                     (make-poly '((make-term 1 '((make-var 'x 1)
                                                 (make-var 'y 1))))))
       (assert-equal '((2 ((x . 1))) (1 ()))
                     (make-poly '((make-term 2 '((make-var 'x 1)))
                                  (make-term 1 '()))))
       (assert-equal '((3 ((x . 2))) (1 ()))
                     (make-poly '((make-term 3 '((make-var 'x 2)))
                                  (make-term 1 '()))))
       (assert-equal '((4 ((x . 1) (y . 1))) (1 ()))
                     (make-poly '((make-term 4 '((make-var 'x 1)
                                                 (make-var 'y 1)))
                                  (make-term 1 '()))))
       (assert-equal '((5 ((x . 1))) (2 ((y . 1))))
                     (make-poly '((make-term 5 '((make-var 'x 1)))
                                  (make-term 2 '((make-var 'y 1))))))))
    (test
      test-polynegate
      ((assert-equal '((-2 ((x . 1))) (-1 ((y . 1))))
                     (polynegate
                       (make-poly
                         '((make-term 2 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))))))
       (assert-equal '((2 ((x . 1))) (1 ((y . 1))))
                     (polynegate
                       (make-poly
                         '((make-term -2 '((make-var 'x 1)))
                           (make-term -1 '((make-var 'y 1)))))))))))
