(load "polynomial-arithmetic.lisp")

(test-case 'test-case-polynomial-arithmetic
           '((test test-make-term
                   ((assert-equal '(term 0 ())  (make-term 0 (make-var-list)))
                    (assert-equal '(term 1 ())  (make-term 1 (make-var-list)))
                    (assert-equal '(term -1 ()) (make-term -1 (make-var-list)))

                    (assert-equal '(term 1 ((x . 1)))
                                  (make-term 1 (make-var-list (make-var 'x 1))))

                    (assert-equal '(term 2 ((x . 1)))
                                  (make-term 2 (make-var-list (make-var 'x 1))))

                    (assert-equal '(term 1 ((x . 2)))
                                  (make-term 1 (make-var-list (make-var 'x 2))))

                    (assert-equal '(term 2 ((x . 2)))
                                  (make-term 2 (make-var-list (make-var 'x 2))))

                    (assert-equal '(term 1 ((x . 1) (y . 1)))
                                  (make-term 1 (make-var-list (make-var 'x 1)
                                                              (make-var 'y 1))))

                    (assert-equal '(term 2 ((x . 1) (y . 1)))
                                  (make-term 2 (make-var-list (make-var 'x 1)
                                                              (make-var 'y 1))))

                    (assert-equal '(term 1 ((x . 2) (y . 1)))
                                  (make-term 1 (make-var-list (make-var 'x 2)
                                                              (make-var 'y 1))))

                    (assert-equal '(term 1 ((x . 2) (y . 2)))
                                  (make-term 1 (make-var-list (make-var 'x 2)
                                                              (make-var 'y 2))))

                    (assert-equal '(term 2 ((x . 2) (y . 2)))
                                  (make-term 2 (make-var-list (make-var 'x 2)
                                                              (make-var 'y 2))))))

             (test test-coeff
                   ((assert-equal '0  (coeff '(term 0 ())))
                    (assert-equal '1  (coeff '(term 1 ((x . 1)))))
                    (assert-equal '-2 (coeff '(term -2 ((x . 2)))))))

             (test test-vars
                   ((assert-equal '()                (vars '(term 0 ())))
                    (assert-equal '((x . 1))         (vars '(term 1 ((x . 1)))))
                    (assert-equal '((x . 2))         (vars '(term 2 ((x . 2)))))
                    (assert-equal '((x . 2) (y . 2)) (vars '(term 3 ((x . 2) (y . 2)))))
                    ))))
