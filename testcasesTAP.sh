#!/bin/bash
source ./TAP.sh 'gitscript shell testcases' 10
pass 'TAP dummy pass'
skip 'TAP dummy' 2
	pass 'TAP dummy pass'
	fail 'TAP dummy fail'
todo 'TAP test' 4
	fail 'TAP dummy todo fail'
	is 5 6 isfail
	isnt 5 5 isntfail
	false
	wasok wasokfail
is 5 5 ispass
isnt 5 6 isntpass
true
wasok wasokpass
diag 'testing diag
not ok - diag
TAP tests END'
endtests
