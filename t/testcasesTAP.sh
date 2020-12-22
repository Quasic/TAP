#!/bin/bash
source TAP/TAP.sh 'gitscript shell testcases' 16
pass 'TAP dummy pass'
skip 'TAP dummy' 2
	pass 'TAP dummy pass'
	fail 'TAP dummy fail'
todo 'TAP test' 7
	fail 'TAP dummy todo fail'
	is 5 6 isfail
	isnt 5 5 isntfail
	false;wasok wasokfail
	okrun 'printf "diag..."&&false' okrunfalsefail
	like abcde dc likefail
	unlike test test unlikefail
is 5 5 ispass
isnt 5 6 isntpass
true;wasok wasokpass
okrun '[ 5 -lt 9 ]' okrunmathpass
like 'ab c de' '^ab c de$' likepass
unlike flags boat unlikepass
diag 'testing diag
not ok - diag
TAP tests END'
endtests
