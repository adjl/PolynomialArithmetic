(test-case
  'test-case-term
  '(; These tests are for functions and operations on terms
    ;
    ; N.B. Functions coeff, vars, term+, term*, termnegate and equal-orderp
    ; will never be passed term == 0 == '() because '()'s will be filtered
    ; out before they are called
    (test
      test-termsimplify
      (; 0x == 0 == '()
       (assert-equal nil             (termsimplify '(0 ((x . 1)))))
       ; x
       (assert-equal '(1 ((x . 1)))  (termsimplify '(1 ((x . 1)))))))
    (test
      test-make-term-internal ; Call termsimplify internally
      (; 0 == '()
       (assert-equal nil
                     (make-term-internal 0 nil))
       ; 0x == 0 == '()
       (assert-equal nil
                     (make-term-internal 0 '((x . 1))))
       ; 1
       (assert-equal '(1 ())
                     (make-term-internal 1 nil))
       ; 2x
       (assert-equal '(2 ((x . 1)))
                     (make-term-internal 2 '((x . 1))))
       ; 3x^2
       (assert-equal '(3 ((x . 2)))
                     (make-term-internal 3 '((x . 2))))
       ; 4xy
       (assert-equal '(4 ((x . 1) (y . 1)))
                     (make-term-internal 4 '((x . 1) (y . 1))))))
    (test
      test-make-term ; Call termsimplify internally
      (; 0 == '()
       (assert-equal nil
                     (make-term 0 nil))
       ; 0x == 0 == '()
       (assert-equal nil
                     (make-term 0 '((make-var 'x 1))))
       ; 1
       (assert-equal '(1 ())
                     (make-term 1 nil))
       ; 2x
       (assert-equal '(2 ((x . 1)))
                     (make-term 2 '((make-var 'x 1))))
       ; 3x^2
       (assert-equal '(3 ((x . 2)))
                     (make-term 3 '((make-var 'x 2))))
       ; 4xy
       (assert-equal '(4 ((x . 1) (y . 1)))
                     (make-term 4 '((make-var 'x 1) (make-var 'y 1))))))
    (test
      test-coeff
      (; 1, coefficient: 1
       (assert-equal 1  (coeff (make-term 1 nil)))
       ; 2x, coefficient: 2
       (assert-equal 2  (coeff (make-term 2 '((make-var 'x 1)))))))
    (test
      test-vars
      (; 1, variables: '()
       (assert-equal nil
                     (vars (make-term 1 nil)))
       ; 2x, variables: x
       (assert-equal (make-varlist '((make-var 'x 1)))
                     (vars (make-term 2 '((make-var 'x 1)))))
       ; 3x^2, variables: x^2
       (assert-equal (make-varlist '((make-var 'x 2)))
                     (vars (make-term 3 '((make-var 'x 2)))))
       ; 4xy, variables: xy
       (assert-equal (make-varlist '((make-var 'x 1) (make-var 'y 1)))
                     (vars (make-term 4 '((make-var 'x 1) (make-var 'y 1)))))))
    (test
      test-term+
      (; 2 == 1 + 1
       (assert-equal (make-term 2 nil)
                     (term+ (make-term 1 nil)
                            (make-term 1 nil)))
       ; 2x == x + x
       (assert-equal (make-term 2 '((make-var 'x 1)))
                     (term+ (make-term 1 '((make-var 'x 1)))
                            (make-term 1 '((make-var 'x 1)))))))
    (test
      test-term*
      (; 1 == 1 * 1
       (assert-equal (make-term 1 nil)
                     (term* (make-term 1 nil)
                            (make-term 1 nil)))
       ; 2x == x * 2
       (assert-equal (make-term 2 '((make-var 'x 1)))
                     (term* (make-term 1 '((make-var 'x 1)))
                            (make-term 2 nil)))
       ; 6x^2 = 2x * 3x
       (assert-equal (make-term 6 '((make-var 'x 2)))
                     (term* (make-term 2 '((make-var 'x 1)))
                            (make-term 3 '((make-var 'x 1)))))
       ; 12xy = 3x * 4y
       (assert-equal (make-term 12 '((make-var 'x 1) (make-var 'y 1)))
                     (term* (make-term 3 '((make-var 'x 1)))
                            (make-term 4 '((make-var 'y 1)))))))
    (test
      test-termnegate
      (; -x == x * -1
       (assert-equal (make-term -1 '((make-var 'x 1)))
                     (termnegate (make-term 1 '((make-var 'x 1)))))))
    (test
      test-equal-orderp
      (; 1 and 2 are of the same order
       (assert-equal t    ((equal-orderp id (make-term 1 nil))
                           (make-term 2 nil)))
       ; 2x and 3x are of the same order
       (assert-equal t    ((equal-orderp id (make-term 2 '((make-var 'x 1))))
                           (make-term 3 '((make-var 'x 1)))))
       ; 3x^2 and 4x are not of the same order
       (assert-equal nil  ((equal-orderp id (make-term 3 '((make-var 'x 2))))
                           (make-term 4 '((make-var 'x 1)))))
       ; 4(x^2)y and 5x(y^2) are not of the same order
       (assert-equal nil  ((equal-orderp id (make-term 4 '((make-var 'x 2)
                                                           (make-var 'y 1))))
                           (make-term 5 '((make-var 'x 1)
                                          (make-var 'y 2)))))))
    (test
      test-termsym<
      (; x comes before y
       (assert-equal t    (termsym< (make-term 1 '((make-var 'x 1)))
                                    (make-term 1 '((make-var 'y 1)))))
       ; y does not come before x
       (assert-equal nil  (termsym< (make-term 1 '((make-var 'y 1)))
                                    (make-term 1 '((make-var 'x 1)))))
       ; x does not come before x
       (assert-equal nil  (termsym< (make-term 1 '((make-var 'x 1)))
                                    (make-term 1 '((make-var 'x 1)))))
       ; x comes before y
       (assert-equal t    (termsym< (make-term 1 '((make-var 'x 1)
                                                   (make-var 'y 1)))
                                    (make-term 1 '((make-var 'y 1)
                                                   (make-var 'z 1)))))))
    (test
      test-termpwr>
      (; 2 > 1
       (assert-equal t    (termpwr> (make-term 1 '((make-var 'x 2)))
                                    (make-term 1 '((make-var 'x 1)))))
       ; 1 < 2
       (assert-equal nil  (termpwr> (make-term 1 '((make-var 'x 1)))
                                    (make-term 1 '((make-var 'x 2)))))
       ; 1 does not come before 1
       (assert-equal nil  (termpwr> (make-term 1 '((make-var 'x 1)))
                                    (make-term 1 '((make-var 'x 1)))))
       ; 2 > 1
       (assert-equal t    (termpwr> (make-term 1 '((make-var 'x 2)
                                                   (make-var 'y 1)))
                                    (make-term 1 '((make-var 'x 1)
                                                   (make-var 'y 3)))))))
    (test
      test-termcompare
      (; constants come last
       (assert-equal nil  (termcompare (make-term 1 nil)
                                       (make-term 1 '((make-var 'x 1)))))
       ; constants come last
       (assert-equal t    (termcompare (make-term 1 '((make-var 'x 1)))
                                       (make-term 1 nil)))
       ; termsym<
       (assert-equal nil  (termcompare (make-term 1 '((make-var 'x 1)))
                                       (make-term 1 '((make-var 'x 1)))))
       ; termpwr>
       (assert-equal t    (termcompare (make-term 1 '((make-var 'x 1)))
                                       (make-term 1 '((make-var 'y 1)))))))

    (test
      test-termsort
      ((assert-equal nil
                     (termsort nil))
       ; 1 is 1 sorted
       (assert-equal (make-termlist
                       '((make-term 1 nil)))
                     (termsort
                       (make-termlist
                         '((make-term 1 nil)))))
       ; (x + 1) is (1 + x) sorted
       (assert-equal (make-termlist
                       '((make-term 1 '((make-var 'x 1)))
                         (make-term 1 nil)))
                     (termsort
                       (make-termlist
                         '((make-term 1 nil)
                           (make-term 1 '((make-var 'x 1)))))))
       ; (x + y) is (y + x) sorted
       (assert-equal (make-termlist
                       '((make-term 1 '((make-var 'x 1)))
                         (make-term 1 '((make-var 'y 1)))))
                     (termsort
                       (make-termlist
                         '((make-term 1 '((make-var 'y 1)))
                           (make-term 1 '((make-var 'x 1)))))))
       ; (x + y + 1) is (1 + y + x) sorted
       (assert-equal (make-termlist
                       '((make-term 1 '((make-var 'x 1)))
                         (make-term 1 '((make-var 'y 1)))
                         (make-term 1 nil)))
                     (termsort
                       (make-termlist
                         '((make-term 1 nil)
                           (make-term 1 '((make-var 'y 1)))
                           (make-term 1 '((make-var 'x 1)))))))
       ; (x^2 + xy + y^2) is (y^2 + x^2 + xy) sorted
       (assert-equal (make-termlist
                       '((make-term 1 '((make-var 'x 2)))
                         (make-term 1 '((make-var 'x 1)
                                        (make-var 'y 1)))
                         (make-term 1 '((make-var 'y 2)))))
                     (termsort
                       (make-termlist
                         '((make-term 1 '((make-var 'y 2)))
                           (make-term 1 '((make-var 'x 2)))
                           (make-term 1 '((make-var 'x 1)
                                          (make-var 'y 1)))))))))
    (test
      test-termreduce ; Simplify term list
      (; 0
       (assert-equal nil
                     (termreduce nil))
       ; 0
       (assert-equal nil
                     (termreduce
                       (make-termlist
                         '((make-term 0 nil)))))
       ; 1
       (assert-equal (make-termlist
                       '((make-term 1 nil)))
                     (termreduce
                       (make-termlist
                         '((make-term 1 nil)))))
       ; x
       (assert-equal (make-termlist
                       '((make-term 1 '((make-var 'x 1)))))
                     (termreduce
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))))))
       ; x == x + 0
       (assert-equal (make-termlist
                       '((make-term 1 '((make-var 'x 1)))))
                     (termreduce
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 0 nil)))))
       ; x + 1 == x + 1
       (assert-equal (make-termlist
                       '((make-term 1 '((make-var 'x 1)))
                         (make-term 1 nil)))
                     (termreduce
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil)))))
       ; 2x == x + x
       (assert-equal (make-termlist
                       '((make-term 2 '((make-var 'x 1)))))
                     (termreduce
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'x 1)))))))
       ; 3x + 2y == 3x + 2y
       (assert-equal (make-termlist
                       '((make-term 3 '((make-var 'x 1)))
                         (make-term 2 '((make-var 'y 1)))))
                     (termreduce
                       (make-termlist
                         '((make-term 3 '((make-var 'x 1)))
                           (make-term 2 '((make-var 'y 1)))))))))
    (test
      test-termlist*
      ; Multiply the first term list by each term in the second
      (; (x + 1) == (x + 1) * (1)
       (assert-equal (list
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil)))
                       (make-termlist
                         '((make-term 1 nil)))))
       ; (2x + 2) == (x + 1) * (2)
       (assert-equal (list
                       (make-termlist
                         '((make-term 2 '((make-var 'x 1)))
                           (make-term 2 nil))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil)))
                       (make-termlist
                         '((make-term 2 nil)))))
       ; (x^2 + x) == (x + 1) * (x)
       (assert-equal (list
                       (make-termlist
                         '((make-term 1 '((make-var 'x 2)))
                           (make-term 1 '((make-var 'x 1))))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil)))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))))))
       ; (xy + y) == (x + 1) * (y)
       (assert-equal (list
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)
                                          (make-var 'y 1)))
                           (make-term 1 '((make-var 'y 1))))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil)))
                       (make-termlist
                         '((make-term 1 '((make-var 'y 1)))))))
       ; (x + y) == (x + y) * (1)
       (assert-equal (list
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1))))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))))
                       (make-termlist
                         '((make-term 1 nil)))))
       ; (2x + 2y) == (x + y) * (2)
       (assert-equal (list
                       (make-termlist
                         '((make-term 2 '((make-var 'x 1)))
                           (make-term 2 '((make-var 'y 1))))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))))
                       (make-termlist
                         '((make-term 2 nil)))))
       ; (x^2 + xy) == (x + y) * (x)
       (assert-equal (list
                       (make-termlist
                         '((make-term 1 '((make-var 'x 2)))
                           (make-term 1 '((make-var 'x 1)
                                          (make-var 'y 1))))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))))))
       ; (x^2 + x) + (x + 1) == (x + 1) * (x + 1)
       (assert-equal (list
                       (make-termlist
                         '((make-term 1 '((make-var 'x 2)))
                           (make-term 1 '((make-var 'x 1)))))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil)))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil)))))
       ; (x^2 + x) + (2x + 2) == (x + 1) * (x + 2)
       (assert-equal (list
                       (make-termlist
                         '((make-term 1 '((make-var 'x 2)))
                           (make-term 1 '((make-var 'x 1)))))
                       (make-termlist
                         '((make-term 2 '((make-var 'x 1)))
                           (make-term 2 nil))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil)))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 2 nil)))))
       ; (x^2 + x) + (xy + y) == (x + 1) * (x + y)
       (assert-equal (list
                       (make-termlist
                         '((make-term 1 '((make-var 'x 2)))
                           (make-term 1 '((make-var 'x 1)))))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)
                                          (make-var 'y 1)))
                           (make-term 1 '((make-var 'y 1))))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil)))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))))))
       ; (x^2 + xy) + (x + y) == (x + y) * (x + 1)
       (assert-equal (list
                       (make-termlist
                         '((make-term 1 '((make-var 'x 2)))
                           (make-term 1 '((make-var 'x 1)
                                          (make-var 'y 1)))))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1))))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 nil)))))
       ; (x^2 + xy) + (2x + 2y) == (x + y) * (x + 2)
       (assert-equal (list
                       (make-termlist
                         '((make-term 1 '((make-var 'x 2)))
                           (make-term 1 '((make-var 'x 1)
                                          (make-var 'y 1)))))
                       (make-termlist
                         '((make-term 2 '((make-var 'x 1)))
                           (make-term 2 '((make-var 'y 1))))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 2 nil)))))
       ; (x^2 + xy) + (xy + y^2) == (x + y) * (x + y)
       (assert-equal (list
                       (make-termlist
                         '((make-term 1 '((make-var 'x 2)))
                           (make-term 1 '((make-var 'x 1)
                                          (make-var 'y 1)))))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)
                                          (make-var 'y 1)))
                           (make-term 1 '((make-var 'y 2))))))
                     (termlist*
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))))
                       (make-termlist
                         '((make-term 1 '((make-var 'x 1)))
                           (make-term 1 '((make-var 'y 1)))))))))))
