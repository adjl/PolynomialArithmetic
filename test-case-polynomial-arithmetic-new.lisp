(test-case 'test-case-polynomial-arithmetic-new
           '((test test-make-var
                   ((assert-equal '()                    (make-var 'x 0))
                    (assert-equal '(x . 1)               (make-var 'x 1))))

             (test test-sym
                   ((assert-equal 'x                     (sym '(x . 1)))))

             (test test-pwr
                   ((assert-equal 1                      (pwr '(x . 1)))))

             (test test-vars*
                   ((assert-equal '()                    (vars* '() '()))
                    (assert-equal '((x . 1))             (vars* '((x . 1)) '()))
                    (assert-equal '((y . 1))             (vars* '() '((y . 1))))
                    (assert-equal '((x . 1) (y . 1))     (vars* '((x . 1)) '((y . 1))))
                    (assert-equal '((x . 1) (y . 1))     (vars* '((y . 1)) '((x . 1))))
                    (assert-equal '((x . 2))             (vars* '((x . 1)) '((x . 1))))))

             (test test-sort-by-sym
                   ((assert-equal '((x . 1) (y . 1) (z . 1))
                                  (sort-by-sym '((z . 1) (x . 1) (y . 1))))))

             (test test-varreduce
                   ((assert-equal '()                    (varreduce '()))
                    (assert-equal '()                    (varreduce '(())))
                    (assert-equal '((x . 1))             (varreduce '((x . 1))))))

             (test test-varextract
                   ((assert-equal '()                    (varextract '()))
                    (assert-equal '()                    (varextract '(())))
                    (assert-equal '((x . 1))             (varextract '(((x . 1)))))
                    (assert-equal '((x . 1))             (varextract '((x . 1))))))

             (test test-make-term
                   ((assert-equal '()                    (make-term 0))
                    (assert-equal '(1 ((x . 1)))         (make-term 1 (make-var 'x 1)))))

             (test test-coeff
                   ((assert-equal 1                      (coeff '(1 ())))))

             (test test-vars
                   ((assert-equal '((x . 1))             (vars '(1 ((x . 1)))))))

             (test test-term+
                   ((assert-equal '(2 ((x . 1)))         (term+ '(1 ((x . 1)))
                                                                '(1 ((x . 1)))))))

             (test test-term-
                   ((assert-equal '(-1 ((x . 1)))        (term- '(1 ((x . 1)))))))

             (test test-term*
                   ((assert-equal '(2 ((x . 2)))         (term* '(2 ((x . 1)))
                                                                '(1 ((x . 1)))))
                    (assert-equal '(3 ((x . 1) (y . 1))) (term* '(3 ((x . 1)))
                                                                '(1 ((y . 1)))))))

             (test test-terms*-inner
                   ((assert-equal '()                    (terms*-inner '()
                                                                       '((2 ((x . 1)))
                                                                         (3 ((y . 1))))))
                    (assert-equal '(((2 ((x . 2)))
                                     (3 ((x . 1) (y . 1)))))
                                  (terms*-inner '((1 ((x . 1))))
                                                '((2 ((x . 1))) (3 ((y . 1))))))))

             (test termreduce
                   ((assert-equal '(2 ((x . 1))) (termreduce '(1 ((x . 1)))
                                                             '(1 ((x . 1)))))
                    (assert-equal '(1 ((x . 1))) (termreduce '(1 ((x . 1))) '()))
                    (assert-equal '(1 ((x . 1))) (termreduce '() '(1 ((x . 1)))))
                    (assert-equal '() (termreduce '() '()))))

             (test test-same-orderp
                   ((assert-equal t    (same-orderp '(1 ((x . 1))) '(1 ((x . 1)))))))

             (test test-sym->str
                   ((assert-equal "x"  (sym->str 'x))))
             ))
