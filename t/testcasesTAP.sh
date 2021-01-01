#!/bin/sh
cd "$(dirname "$0")/.."||printf 'Given path %s, stuck in %s\n' "$0" "$(pwd)"
. TAP/TAP.sh 'gitscript shell testcases' 31
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
(. TAP/TAP.sh bailout "?"&&bailout test)>/dev/null
is $? 255 BailoutExitCode
like "$(sh -c '. TAP/TAP.sh bailout "?"&&bailout test'|tr '~\n' '-~')" ~~Bail\ out!\ \ test~$ Bailout
subtest subtestinskip skiptest bailout
subtest subtestfuncpass 1 is 5 5 subispass
subtest subtestevalpass 3 'pass subpass;is 5 5 subispass
isnt 5 6 subisntpass'
subtest subtestpass 1 pass
#internal false should be replaced by endtests
subtest subtestfalse 1 'pass subpass;false'
printf '    not ok - subtest2ignore\n'
printf 'redirection diag'|diag
diag 'testing diag
not ok - diag
TAP tests END'
endtests
