(test-case
  'test-case-var
  '(; These tests are for functions and operations on variables
    ;
    ; N.B. Functions sym, pwr, var* and equal-symp will never be passed
    ; var == 1 == '() because '()'s will be filtered out before they are called
    (test
      test-varsimplify
      ((assert-equal nil       (varsimplify '(x . 0))) ; x^0 == 1 == '()
       (assert-equal '(x . 1)  (varsimplify '(x . 1))))) ; x
    (test
      test-make-var ; Calls varsimplify internally
      ((assert-equal nil       (make-var 'x 0)) ; x^0 == 1 == '()
       (assert-equal '(x . 1)  (make-var 'x 1)))) ; x
    (test
      test-sym
      ((assert-equal 'x  (sym (make-var 'x 1))))) ; x, symbol: 'x
    (test
      test-pwr
      ((assert-equal 1  (pwr (make-var 'x 1))))) ; x, power: 1
    (test
      test-var*
      (; x^2 == x * x
       (assert-equal (make-var 'x 2)  (var* (make-var 'x 1) (make-var 'x 1)))))
    (test
      test-equal-symp
      (; x and x have the same symbol
       (assert-equal t    ((equal-symp id (make-var 'x 1)) (make-var 'x 1)))
       ; x and y do not have the same symbol
       (assert-equal nil  ((equal-symp id (make-var 'x 1)) (make-var 'y 1)))))
    ; varsort
    (test
      test-varreduce ; Simplifies a term's variable list
      (; 1 == 1
       (assert-equal nil
                     (varreduce nil))
       ; 1 == x^0 == 1
       (assert-equal nil
                     (varreduce
                       (make-varlist '((make-var 'x 0)))))
       ; x == x
       (assert-equal (make-varlist '((make-var 'x 1)))
                     (varreduce
                       (make-varlist '((make-var 'x 1)))))
       ; x == x(x^0) == x
       (assert-equal (make-varlist '((make-var 'x 1)))
                     (varreduce
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'x 0)))))
       ; x^2 == xx
       (assert-equal (make-varlist '((make-var 'x 2)))
                     (varreduce
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'x 1)))))
       ; xy == xy
       (assert-equal (make-varlist '((make-var 'x 1)
                                     (make-var 'y 1)))
                     (varreduce
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'y 1)))))
       ; x^3 == xxx
       (assert-equal (make-varlist '((make-var 'x 3)))
                     (varreduce
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'x 1)
                                       (make-var 'x 1)))))
       ; (x^2)y == xxy
       (assert-equal (make-varlist '((make-var 'x 2)
                                     (make-var 'y 1)))
                     (varreduce
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'x 1)
                                       (make-var 'y 1)))))
       ; (x^2)y == xyx
       (assert-equal (make-varlist '((make-var 'x 2)
                                     (make-var 'y 1)))
                     (varreduce
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'y 1)
                                       (make-var 'x 1)))))
       ; xyz = xyz
       (assert-equal (make-varlist '((make-var 'x 1)
                                     (make-var 'y 1)
                                     (make-var 'z 1)))
                     (varreduce
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'y 1)
                                       (make-var 'z 1)))))))
    (test
      test-varlist* ; Multiplies two terms' variable lists and simplifies
      (; 1 == 1 * 1
       (assert-equal nil
                     (varlist* nil nil))
       ; x == x * 1
       (assert-equal (make-varlist '((make-var 'x 1)))
                     (varlist*
                       (make-varlist '((make-var 'x 1)))
                       nil))
       ; x^2 == x * x
       (assert-equal (make-varlist '((make-var 'x 2)))
                     (varlist*
                       (make-varlist '((make-var 'x 1)))
                       (make-varlist '((make-var 'x 1)))))
       ; xy == x * y
       (assert-equal (make-varlist '((make-var 'x 1)
                                     (make-var 'y 1)))
                     (varlist*
                       (make-varlist '((make-var 'x 1)))
                       (make-varlist '((make-var 'y 1)))))
       ; x^3 == xx * x
       (assert-equal (make-varlist '((make-var 'x 3)))
                     (varlist*
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'x 1)))
                       (make-varlist '((make-var 'x 1)))))
       ; (x^2)y == xx * y
       (assert-equal (make-varlist '((make-var 'x 2)
                                     (make-var 'y 1)))
                     (varlist*
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'x 1)))
                       (make-varlist '((make-var 'y 1)))))
       ; (x^2)y == xy * x
       (assert-equal (make-varlist '((make-var 'x 2)
                                     (make-var 'y 1)))
                     (varlist*
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'y 1)))
                       (make-varlist '((make-var 'x 1)))))
       ; xyz = xy * z
       (assert-equal (make-varlist '((make-var 'x 1)
                                     (make-var 'y 1)
                                     (make-var 'z 1)))
                     (varlist*
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'y 1)))
                       (make-varlist '((make-var 'z 1)))))
       ; x^4 == xx * xx
       (assert-equal (make-varlist '((make-var 'x 4)))
                     (varlist*
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'x 1)))
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'x 1)))))
       ; (x^2)yz == xx * yz
       (assert-equal (make-varlist '((make-var 'x 2)
                                     (make-var 'y 1)
                                     (make-var 'z 1)))
                     (varlist*
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'x 1)))
                       (make-varlist '((make-var 'y 1)
                                       (make-var 'z 1)))))
       ; (x^2)yz == xy * xz
       (assert-equal (make-varlist '((make-var 'x 2)
                                     (make-var 'y 1)
                                     (make-var 'z 1)))
                     (varlist*
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'y 1)))
                       (make-varlist '((make-var 'x 1)
                                       (make-var 'z 1)))))
       ; wxyz = wx * yz
       (assert-equal (make-varlist '((make-var 'w 1)
                                     (make-var 'x 1)
                                     (make-var 'y 1)
                                     (make-var 'z 1)))
                     (varlist*
                       (make-varlist '((make-var 'w 1)
                                       (make-var 'x 1)))
                       (make-varlist '((make-var 'y 1)
                                       (make-var 'z 1)))))))))
