lisby
=====

Lisp interpreter written in Ruby, based off of Peter Norvig's Lispy Scheme interpreter in Python.

http://norvig.com/lispy.html

TODO
----

- Various little things result in errors.

- ;; overflows the stack
lisby> (define count (lambda (item L) (if L (+ (equal? item (first L)) (count item (rest L))) 0)))
lisby> (count 0 (list 0 1 2 3 0 0))

- Make certain parts more Ruby-ish
