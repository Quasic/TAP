#!/bin/bash
source TAP/TAP.bash 'TAP.bash testcases' 23
pass 'TAP dummy pass'
skip 'TAP dummy' 2
	pass 'TAP dummy pass'
	fail 'TAP dummy fail'
todo 'TAP test' 10
	fail 'TAP dummy todo fail'
	is 5 6 isfail
	isnt 5 5 isntfail
	false;wasok wasokfail
	okrun 'printf "diag..."&&false' okrunfalsefail
	okname oknamefail false
	like abcde dc likefail
	unlike test test unlikefail
	subtestrun false subtestrunfalse
	subtestrun 'printf "not ok -"' subtestrunnotok
is 5 5 ispass
isnt 5 6 isntpass
true;wasok wasokpass
okrun '[ 5 -lt 9 ]' okrunmathpass
okname oknamepass [ 5 -lt 9 ]
like 'ab c de' '^ab c de$' likepass
unlike flags boat unlikepass
like "$(tr '~\n' '-~' <<<"$(bash -c '. TAP/TAP.bash bailout "?"&&bailout test';printf '%i' $?)")" ~~Bail\ out!\ \ test~255~$ Bailout
subtestrun 'printf "#TAP testing subtestrun\n1..1\nok - Subtest"' subtestrunpass
like "$(tr '~\n' '-~' <<<"$(bash -c '. TAP/TAP.bash subtest_bailout "?"&&subtestrun "printf \"Bail out!  test\"" test';printf '%i' $?)")" ~~Bail\ out!\ \ subtest\ test\ bailout~255~$ SubtestrunBailout
printf '    not ok - subtest2ignore\n'
diag <<<'redirection diag'
diag 'testing diag
not ok - diag
TAP tests END'
endtests
