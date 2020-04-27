#lang racket

(define (ask-file string)

  (let ((name! (read)))
    (if (eq? name! name!) name! (ask-file string))))

; fetches employee file
(define employees "")

(define (getEmployeeFile)
(let ((p (open-input-file "input/coop_e_10x10.csv")))
  (let f ((x (read p))) ;reading from file
    (if (eof-object? x)
        (begin
          (close-input-port p)
            '())
        (cons x (f (read p))))))
  )

; fetches student file
(define students "")


(define (getStudentFile)
(let ((v (open-input-file "input/coop_s_10x10.csv")))
  (let f ((x (read v))) ;reading from file
    (if (eof-object? x)
        (begin
          (close-input-port v)
            '())
        (cons x (f (read v))))))
  )



(define (stableMatching L_employer_preference L_student_preference)
  (cond ((null? L_employer_preference) #f)
        ((null? L_student_preference) #f)
        ((cons (list (car L_employer_preference) (car L_student_preference))
        (stableMatching (cdr L_employer_preference) (cdr L_student_preference))))
        )
)

(define proc-out-file
  (lambda (filename proc)
    ; Optional arguements are a racket extension
    (let ((p (open-output-file filename #:exists 'replace)))
      (let ((v (proc p)))
        (close-output-port p)
        v))))

; writing to a file
(proc-out-file "output/output.csv"
  (lambda (p)
    (let ((list-to-be-printed (car (stableMatching (getStudentFile) (getEmployeeFile)))))
      (let f((l list-to-be-printed))
        (if (not (null? l))
            (begin
              (write (car l) p)
              (newline p)
              (f (cdr l)))
            null)))))


(stableMatching (getStudentFile) (getEmployeeFile))