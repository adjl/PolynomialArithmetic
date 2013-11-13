(test-case 'test-case-qsort
           '((test test-qsort
                   ((assert-equal '() (qsort '()))
                    (assert-equal '(1) (qsort '(1)))
                    (assert-equal '(1 1) (qsort '(1 1)))
                    (assert-equal '(1 2) (qsort '(1 2)))
                    (assert-equal '(1 2) (qsort '(2 1)))
                    (assert-equal '(1 2 2) (qsort '(2 1 2)))
                    (assert-equal '(1 2 3) (qsort '(3 2 1)))))))
