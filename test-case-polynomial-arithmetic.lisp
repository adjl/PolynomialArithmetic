(test-case
  'test-case-polynomial-arithmetic
  '(
    (test
      test-make-term
      ((assert-equal '()             (make-term 0 '()))
       (assert-equal '(1 ())         (make-term 1 '()))
       (assert-equal '(2 ((x . 1)))  (make-term 2 '((make-var 'x 1))))
       (assert-equal '(3 ((x . 2)))  (make-term 3 '((make-var 'x 2))))
       (assert-equal '(4 ((x . 1) (y . 1)))
                     (make-term 4 '((make-var 'x 1) (make-var 'y 1))))
       ))
    (test
      test-termsimplify
      ((assert-equal '()             (termsimplify '(0 ((x . 1)))))
       (assert-equal '(1 ((x . 1)))  (termsimplify '(1 ((x . 1)))))
       ))
    (test
      test-coeff
      ((assert-equal 1  (coeff (make-term 1 '((make-var 'x 1)))))
       ))
    (test
      test-vars
      ((assert-equal '((x . 1))  (vars (make-term 1 '((make-var 'x 1)))))
       ))
    (test
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
                                  (make-term 2 '((make-var 'y 1))))))
       ))
    (test
      test-equal-orderp
      ((assert-equal t    ((equal-orderp id (make-term 1 '()))
                           (make-term 2 '())))
       (assert-equal t    ((equal-orderp id (make-term 1 '((make-var 'x 1))))
                           (make-term 2 '((make-var 'x 1)))))
       (assert-equal t    ((equal-orderp id (make-term 1 '((make-var 'x 2))))
                           (make-term 2 '((make-var 'x 2)))))
       (assert-equal t    ((equal-orderp id (make-term 1 '((make-var 'x 1)
                                                          (make-var 'y 1))))
                           (make-term 2 '((make-var 'x 1)
                                          (make-var 'y 1)))))
       ))
    (test
      test-term+
      ((assert-equal '(2 ())         (term+ (make-term 1 '()) (make-term 1 '())))
       (assert-equal '(2 ((x . 1)))  (term+ (make-term 1 '((make-var 'x 1)))
                                            (make-term 1 '((make-var 'x 1)))))
       (assert-equal '(2 ((x . 2)))  (term+ (make-term 1 '((make-var 'x 2)))
                                            (make-term 1 '((make-var 'x 2)))))
       (assert-equal '(2 ((x . 1) (y . 1)))
                     (term+ (make-term 1 '((make-var 'x 1) (make-var 'y 1)))
                            (make-term 1 '((make-var 'x 1) (make-var 'y 1)))))
       ))
    (test
      test-termreduce
      ((assert-equal '()               (termreduce '()))
       (assert-equal '((1 ((x . 1))))  (termreduce '((1 ((x . 1))))))
       (assert-equal '((2 ((x . 1))))  (termreduce '((1 ((x . 1)))
                                                     (1 ((x . 1))))))
       (assert-equal '((1 ((x . 1))) (1 ((y . 1))))
                     (termreduce '((1 ((x . 1))) (1 ((y . 1))))))
       ))
    (test
      test-term*
      ((assert-equal '(1 ((x . 1)))  (term* (make-term 1 '())
                                            (make-term 1 '((make-var 'x 1)))))
       (assert-equal '(2 ((x . 1)))  (term* (make-term 2 '())
                                            (make-term 1 '((make-var 'x 1)))))
       (assert-equal '(3 ((x . 2)))  (term* (make-term 1 '((make-var 'x 1)))
                                            (make-term 3 '((make-var 'x 1)))))
       (assert-equal '(4 ((x . 1) (y . 1)))
                     (term* (make-term 2 '((make-var 'x 1)))
                            (make-term 2 '((make-var 'y 1)))))
       ))
    (test
      test-term*-out
      ((assert-equal '(1 ((x . 1)))  ((term*-out (make-term 1 '()))
                                      (make-term 1 '((make-var 'x 1)))))
       (assert-equal '(2 ((x . 1)))  ((term*-out (make-term 1 '((make-var 'x 1))))
                                      (make-term 2 '())))
       (assert-equal '(3 ((x . 2)))  ((term*-out (make-term 3 '((make-var 'x 1))))
                                      (make-term 1 '((make-var 'x 1)))))
       (assert-equal '(4 ((x . 1) (y . 1)))
                     ((term*-out (make-term 2 '((make-var 'y 1))))
                                 (make-term 2 '((make-var 'x 1)))))
       ))
    (test
      test-termnegate
      ((assert-equal '(-1 ((x . 1)))  (termnegate (make-term 1 '((make-var 'x 1)))))
       (assert-equal '(1  ((x . 1)))  (termnegate (make-term -1 '((make-var 'x 1)))))
       ))
    (test
      test-termlist*
      ((assert-equal '(((1 ((x . 1))) (1 ())))
                     (termlist*
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '())))
                       (make-poly
                         '((make-term 1 '())))))
       (assert-equal '(((2 ((x . 1))) (2 ())))
                     (termlist*
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '())))
                       (make-poly
                         '((make-term 2 '())))))
       (assert-equal '(((1 ((x . 2))) (1 ((x . 1)))))
                     (termlist*
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '())))
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))))))
       (assert-equal '(((1 ((x . 1) (y . 1))) (1 ((y . 1)))))
                     (termlist*
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '())))
                       (make-poly
                         '((make-term 1 '((make-var 'y 1)))))))
       (assert-equal '(((1 ((x . 1) (y . 1))) (1 ((y . 1))))
                       ((1 ((x . 1))) (1 ())))
                     (termlist*
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '())))
                       (make-poly
                         '((make-term 1 '((make-var 'y 1)))
                           (make-term 1 '())))))
       ))
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
                           (make-term -1 '((make-var 'y 1)))))))
       ))
    ))
