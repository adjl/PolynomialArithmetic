(test-case
  'test-case-poly
  '((test
      test-make-poly
      ((assert-equal nil
                     (make-poly nil))
       (assert-equal nil
                     (make-poly '((make-term 0 nil))))
       (assert-equal '((1 ()))
                     (make-poly '((make-term 1 nil))))
       (assert-equal '((2 ((x . 1)))
                       (1 ()))
                     (make-poly
                       '((make-term 2 '((make-var 'x 1)))
                         (make-term 1 nil))))
       (assert-equal '((3 ((x . 2)))
                       (4 ((x . 1) (y . 1)))
                       (1 ()))
                     (make-poly
                       '((make-term 3 '((make-var 'x 2)))
                         (make-term 4 '((make-var 'x 1)
                                        (make-var 'y 1)))
                         (make-term 1 nil))))
       (assert-equal '((3 ((x . 2)))
                       (4 ((x . 1) (y . 1)))
                       (2 ((x . 1)))
                       (1 ()))
                     (make-poly
                       '((make-term 3 '((make-var 'x 2)))
                         (make-term 4 '((make-var 'x 1)
                                        (make-var 'y 1)))
                         (make-term 2 '((make-var 'x 1)))
                         (make-term 1 nil))))))
    (test
      test-polynegate
      ((assert-equal nil
                     (polynegate (make-poly nil)))
       (assert-equal (make-poly
                       '((make-term -3 '((make-var 'x 2)))
                         (make-term -4 '((make-var 'x 1)
                                        (make-var 'y 1)))
                         (make-term -2 '((make-var 'x 1)))
                         (make-term -1 nil)))
                     (polynegate
                       (make-poly
                         '((make-term 3 '((make-var 'x 2)))
                           (make-term 4 '((make-var 'x 1)
                                          (make-var 'y 1)))
                           (make-term 2 '((make-var 'x 1)))
                           (make-term 1 nil)))))))
    (test
      test-poly+
      ((assert-equal nil
                     (poly+ nil nil))
       (assert-equal (make-poly
                       '((make-term 1 '((make-var 'x 1)))
                         (make-term 1 '((make-var 'y 1)))
                         (make-term 1 nil)))
                     (poly+
                       nil
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))))
       (assert-equal (make-poly
                       '((make-term 1 '((make-var 'x 1)))
                         (make-term 1 '((make-var 'y 1)))
                         (make-term 1 nil)))
                     (poly+
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))
                       nil))
       (assert-equal (make-poly
                       '((make-term 2 '((make-var 'x 1)))
                         (make-term 2 '((make-var 'y 1)))
                         (make-term 2 nil)))
                     (poly+
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))))))
    (test
      test-poly-
      ((assert-equal nil
                     (poly- nil nil))
       (assert-equal (make-poly
                       '((make-term -1 '((make-var 'x 1)))
                         (make-term -1 '((make-var 'y 1)))
                         (make-term -1 nil)))
                     (poly-
                       nil
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))))
       (assert-equal (make-poly
                       '((make-term 1 '((make-var 'x 1)))
                         (make-term 1 '((make-var 'y 1)))
                         (make-term 1 nil)))
                     (poly-
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))
                       nil))
       (assert-equal nil
                     (poly-
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))))
       ))
    ))
