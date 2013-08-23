lisby
=====

Lisp interpreter written in Ruby, based off of Peter Norvig's Lispy Scheme interpreter in Python.

http://norvig.com/lispy.html

Usage
-----

	$ ruby lisby.rb 
	lisby> (cons 1 (list 2 3 4 5 6))
	(1 2 3 4 5 6)
	lisby> 3
	3
	lisby> 4.5
	4.5
	lisby> (define sqr (lambda (n) (* n n)))    
	#<Proc:0x00000100a198d8@lisby.rb:66 (lambda)>
	lisby> (sqr 5)
	25
	lisby> (equal? 5 5)
	true
	lisby> (length (list 1 2 3 4 5))
	5
	lisby> (cdr (list 1 2 3))
	(2 3)
	lisby> (car (quote (1 2 3 4 5)))
	1

Implemented Scheme functions
-----
	;; +
	lisby> (+ 1 1.5)
	2.5

	;; -
	lisby> (- 10 5)
	5

	;; *
	lisby> (* 5 5)
	25

	;; currently as integer division
	listby> (/ 10 3)
	3

	;; >
	lisby> (> 4 2)
	true

	;; <
	lisby> (< 4 2)
	false

	;; >=
	lisby> (>= 5 5)
	true

	;; <=
	lisby> (<= 3 4)
	true

	;; = ...a synonym of (equal?)
	lisby> (= 5 3)
	false

	;; append
	lisby> (append (list 1 2 3) (quote (7 6 5)))
	(1 2 3 7 6 5)

	;; car
	lisby> (car (quote (1 2 3 4 5)))
	1

	;; cdr
	lisby> (cdr (list 1 2 3))
	(2 3)

	;; cons
	lisby> (cons 1 (list 2 3 4 5 6))
	(1 2 3 4 5 6)

	lisby> (cons 1 (list)) 	; consing something on to an empty list:
	(1)

	;; equal?
	lisby> (equal? 5 5)
	true

	lisby> (equal? 5 5.0)
	false

	;; length
	lisby> (length (quote (1 2 3)))
	3

	;; list
	lisby> (list)
	()
	
	lisby> (list 1 2 3)
	(1 2 3)

	;; list?
	lisby> (list? (lambda (x) (quote x)))
	false
	
	lisby> (list? (list 1 2))
	true

	;; null?
	lisby> (null? (list))
	true

	lisby> (null? (quote (1 2 3)))
	false

	;; symbol?
	lisby> (symbol? (quote z))
	true

Notes
-----

- Various little things result in errors.

- ;; this example from Norvig's site overflows the stack  
lisby> (define count (lambda (item L) (if L (+ (equal? item (first L)) (count item (rest L))) 0)))  
lisby> (count 0 (list 0 1 2 3 0 0))

- There is some rudimentary error handling, but it's still super basic

- Check Norvig's site listed above for other limitations and the original Python implementation
