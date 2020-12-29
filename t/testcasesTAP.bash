#!/bin/bash
source TAP/TAP.bash 'TAP.bash testcases' 30
pass 'TAP dummy pass'
skip 'TAP dummy' 5
	pass 'TAP dummy pass'
	fail 'TAP dummy fail'
	okrun 'printf "not ok - okrunskip\n";false' okrunskip
	okname oknameskip false
	subtest subtestoutskip 1 bailout
todo 'TAP test' 11
	fail 'TAP dummy todo fail'
	is 5 6 isfail
	isnt 5 5 isntfail
	false;wasok wasokfail
	okrun 'printf "diag..."&&false' okrunfalsefail
	okname oknamefail false
	like abcde dc likefail
	unlike test test unlikefail
	subtest subtestfail 1 fail subfail
	subtest subtestmissing 2 pass subpass
	subtest subtestwrongnum 2 "pass subpass;is 5 5 ispass
isnt 5 6 isntpass"
is 5 5 ispass
isnt 5 6 isntpass
true;wasok wasokpass
okrun '[ 5 -lt 9 ]' okrunmathpass
okname oknamepass [ 5 -lt 9 ]
like 'ab c de' '^ab c de$' likepass
unlike flags boat unlikepass
like "$(tr '~\n' '-~' <<<"$(bash -c '. TAP/TAP.bash bailout "?"&&printf "#"&&bailout test';printf '%i' $?)")" ~#~Bail\ out!\ \ test~255~$ Bailout
subtest subtestinskip skiptest bailout
subtest subtestfuncpass 1 is 5 5 subispass
subtest subtestevalpass 3 'pass subpass;is 5 5 subispass
isnt 5 6 subisntpass'
subtest subtestpass 1 pass
#internal false should be replaced by endtests
subtest subtestfalse 1 'pass subpass;false'
printf '    not ok - subtest2ignore\n'
diag <<<'redirection diag'
diag 'testing diag
not ok - diag
TAP tests END'
endtests
