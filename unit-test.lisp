(defun test-suite (test-cases)
  (cond (test-cases (load (car test-cases))
                    (if (cdr test-cases) (newline))
                    (test-suite (cdr test-cases)))))

(defun test-case (test-case-name tests)
  (labels
    ((get-test-name () (cadar tests))
     (get-asserts () (caddar tests))
     (test-case-inner (tests tests-passed tests-failed)
       (cond ((null tests)
              (format t "(~a) ~d tests run: ~d passed, ~d failed~%"
                      test-case-name (+ tests-passed tests-failed)
                      tests-passed tests-failed))
             (t (let* ((test-name (get-test-name))
                       (asserts (get-asserts))
                       (test-passedp (test test-case-name test-name asserts))
                       (tests-passed (+ tests-passed (if test-passedp 1 0)))
                       (tests-failed (+ tests-failed
                                        (if (not test-passedp) 1 0))))
                  (test-case-inner (cdr tests) tests-passed tests-failed))))))
    (test-case-inner tests 0 0)))

(defun test (test-case-name test-name asserts)
  (labels
    ((get-assert () (caar asserts))
     (get-argument1 () (cadar asserts))
     (get-argument2 () (caddar asserts))
     (test-inner (asserts passedp)
       (cond ((null asserts) passedp)
             (t (let* ((assert (get-assertf (get-assert)))
                       (argument1 (eval (get-argument1)))
                       (argument2 (eval (get-argument2)))
                       (assert-passedp (assert test-case-name test-name
                                               argument1 argument2))
                       (passedp (and passedp assert-passedp)))
                  (test-inner (cdr asserts) passedp))))))
    (test-inner asserts t)))

(defun get-assertf (assert)
  (cond ((eq assert 'assert-equal) assert-equal)))

(defun assert-equal (test-case-name test-name param1 param2)
  (let ((passedp (equal param1 param2)))
    ; if assert passes, return t, else print assert error and return nil
    (not (if (not passedp) (format t "(~a) ~a: ~a != ~a~%"
                                   test-case-name test-name param1 param2)))))
