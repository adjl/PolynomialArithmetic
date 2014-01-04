(test-case
  'test-case-poly
  '(; These tests are for functions and operations on polynomials
    (test
      test-make-poly ; Call termreduce internally
      (; 0 == '()
       (assert-equal nil
                     (make-poly nil))
       ; 0 == '()
       (assert-equal nil
                     (make-poly '((make-term 0 nil))))
       ; 3x^2 + 4xy + 2x + 1
       (assert-equal '((3 ((x . 2)))
                       (4 ((x . 1) (y . 1)))
                       (2 ((x . 1)))
                       (1 ()))
                     (make-poly
                       '((make-term 3 '((make-var 'x 2)))
                         (make-term 4 '((make-var 'x 1)
                                        (make-var 'y 1)))
                         (make-term 2 '((make-var 'x 1)))
                         (make-term 1 nil))))
       ; 6x^2 + 8xy + 4x + 2
       ; == 3x^2 + 4xy + 2x + 1 + 3x^2 + 4xy + 2x + 1
       (assert-equal '((6 ((x . 2)))
                       (8 ((x . 1) (y . 1)))
                       (4 ((x . 1)))
                       (2 ()))
                     (make-poly
                       '((make-term 3 '((make-var 'x 2)))
                         (make-term 4 '((make-var 'x 1)
                                        (make-var 'y 1)))
                         (make-term 2 '((make-var 'x 1)))
                         (make-term 1 nil)
                         (make-term 3 '((make-var 'x 2)))
                         (make-term 4 '((make-var 'x 1)
                                        (make-var 'y 1)))
                         (make-term 2 '((make-var 'x 1)))
                         (make-term 1 nil))))
       ; 5x^2 + 4xy + 2x + 3
       ; == 3x^2 + 4xy + 2x + 1 + 2x^2 + 2
       (assert-equal '((5 ((x . 2)))
                       (4 ((x . 1) (y . 1)))
                       (2 ((x . 1)))
                       (3 ()))
                     (make-poly
                       '((make-term 3 '((make-var 'x 2)))
                         (make-term 4 '((make-var 'x 1)
                                        (make-var 'y 1)))
                         (make-term 2 '((make-var 'x 1)))
                         (make-term 1 nil)
                         (make-term 2 '((make-var 'x 2)))
                         (make-term 2 nil))))
       ; 0 == 3x^2 + 4xy + 2x + 1 - 3x^2 - 4xy - 2x - 1
       (assert-equal nil
                     (make-poly
                       '((make-term 3 '((make-var 'x 2)))
                         (make-term 4 '((make-var 'x 1)
                                        (make-var 'y 1)))
                         (make-term 2 '((make-var 'x 1)))
                         (make-term 1 nil)
                         (make-term -3 '((make-var 'x 2)))
                         (make-term -4 '((make-var 'x 1)
                                         (make-var 'y 1)))
                         (make-term -2 '((make-var 'x 1)))
                         (make-term -1 nil))))
       ; x^2 + 2xy - 1
       ; == 3x^2 + 4xy + 2x + 1 - 2x^2 - 2xy - 2x - 2
       (assert-equal '((1 ((x . 2)))
                       (2 ((x . 1) (y . 1)))
                       (-1 ()))
                     (make-poly
                       '((make-term 3 '((make-var 'x 2)))
                         (make-term 4 '((make-var 'x 1)
                                        (make-var 'y 1)))
                         (make-term 2 '((make-var 'x 1)))
                         (make-term 1 nil)
                         (make-term -2 '((make-var 'x 2)))
                         (make-term -2 '((make-var 'x 1)
                                         (make-var 'y 1)))
                         (make-term -2 '((make-var 'x 1)))
                         (make-term -2 nil))))))
    (test
      test-polynegate
      (; -0 == 0 == '()
       (assert-equal nil
                     (polynegate (make-poly nil)))
       ; -3x^2 - 4xy - 2x - 1 == (3x^2 + 4xy + 2x + 1) * -1
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
      test-poly+ ; Call termreduce internally
                 ; Exceptional use cases are already covered in
                 ; test-make-poly and test-termreduce
                 ; (see the implementation of poly+)
      (; 0 == 0 + 0
       (assert-equal nil
                     (poly+ nil nil))
       ; x + y + 1 == 0 + (x + y + 1)
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
       ; x + y + 1 == (x + y + 1) + 0
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
       ; 2x + 2y + 2 == (x + y + 1) + (x + y + 1)
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
      test-poly- ; Call poly+ and polynegate
                 ; Exceptional use cases are already covered in
                 ; test-make-poly, test-polynegate and
                 ; test-termreduce
                 ; (see the implementation of poly-)
      (; 0 == 0 - 0
       (assert-equal nil
                     (poly- nil nil))
       ; -x - y - 1 == 0 - (x + y + 1)
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
       ; x + y + 1 == (x + y + 1) - 0
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
       ; 0 == (x + y + 1) - (x + y + 1)
       (assert-equal nil
                     (poly-
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))))))
    (test
      test-poly* ; Call poly+ and termlist* internally
                 ; Exceptional use cases are already covered in
                 ; test-make-poly, test-termreduce and
                 ; test-termlist*
                 ; (see the implementation of poly*)
      (; 0 == 0 * 0
       (assert-equal nil
                     (poly* nil nil))
       ; 0 == 0 * (x + y + 1)
       (assert-equal nil
                     (poly*
                       nil
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))))
       ; 0 == (x + y + 1) * 0
       (assert-equal nil
                     (poly*
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))
                       nil))
       ; x^2 + 2xy + 2x + y^2 + 2y + 1
       ; == (x + y + 1) * (x + y + 1)
       (assert-equal (make-poly
                       '((make-term 1 '((make-var 'x 2)))
                         (make-term 2 '((make-var 'x 1)
                                        (make-var 'y 1)))
                         (make-term 2 '((make-var 'x 1)))
                         (make-term 1 '((make-var 'y 2)))
                         (make-term 2 '((make-var 'y 1)))
                         (make-term 1 nil)))
                     (poly*
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))
                       (make-poly
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 nil)))))))))
