(defun test-suite (test-cases)
  (cond (test-cases (load (car test-cases))
                    (test-suite (cdr test-cases)))))

(defun test-case (test-case-name tests)
  (labels
    ((get-test-name (tests) (cadar tests))
     (get-asserts (tests) (caddar tests))
     (test-case-inner (tests tests-passed tests-failed)
       (cond ((null tests)
              (format t "(~a) ~d tests run: ~d passed, ~d failed~%"
                      test-case-name (+ tests-passed tests-failed)
                      tests-passed tests-failed))
             (t (let* ((test-name (get-test-name tests))
                       (asserts (get-asserts tests))
                       (test-passedp (test test-case-name test-name asserts))
                       (tests-passed (+ tests-passed (if test-passedp 1 0)))
                       (tests-failed (+ tests-failed
                                        (if (not test-passedp) 1 0))))
                  (test-case-inner (cdr tests) tests-passed tests-failed))))))
    (test-case-inner tests 0 0)))

(defun test (test-case-name test-name asserts)
  (labels
    ((get-assert (asserts) (caar asserts))
     (get-argument1 (asserts) (cadar asserts))
     (get-argument2 (asserts) (caddar asserts))
     (test-inner (asserts passedp)
       (cond ((null asserts) passedp)
             (t (let* ((assert (get-assertf (get-assert asserts)))
                       (argument1 (eval (get-argument1 asserts)))
                       (argument2 (eval (get-argument2 asserts)))
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
