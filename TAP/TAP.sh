#!/bin/bash
#TAP format testcase library for bash
#by Quasic
#released under Creative Commons Attribution (BY) 4.0 license
#Please report bugs at https://github.com/Quasic/TAP/issues

printf '#TAP testing %s\n' "$1"
case "$2" in
*[!0-9]*|'') printf '1..0 #Skipped: %s\n' "$2";NUMTESTS=0;;
*) printf '1..%i\n' "$2";NUMTESTS=$2;;
esac
TESTSERIES=$1
TESTSRUN=0
TESTSFAILED=0
SKIPTESTS=0
endtests(){
	if [ "$TESTSFAILED" -ne 0 ]
	then
		printf '#Failed %i tests\n' "$TESTSFAILED"
		[ "$TESTSFAILED" -gt 254 ]&&TESTSFAILED=254
	fi
	if [ "$TESTSRUN" -ne "$NUMTESTS" ]
	then
		printf '#Planned %i tests, but ran %i tests\n' "$NUMTESTS" "$TESTSRUN"
		TESTSFAILED=255
	fi
	[[ $- == *i* ]]&&read -rn1 -p "Press a key to close log (will return $TESTSFAILED)">&2
	exit $TESTSFAILED
}
bailout(){
	printf 'Bail out!  %s\n' "$1"
	exit 255
}
pass(){
	((TESTSRUN++))
	if [ "$SKIPTESTS" -gt 0 ]
	then
		((SKIPTESTS--))
		printf 'ok %i - %s # %s\n' "$TESTSRUN" "$1" "$SKIPTYPE $SKIPWHY"
	else printf 'ok - %s\n' "$1"
	fi
	return 0
}
fail(){
	((TESTSRUN++))
	if [ "$SKIPTESTS" -gt 0 ]
	then
		((SKIPTESTS--))
		if [ "$SKIPTYPE" = TODO ]
		then
			printf 'not ok %i - %s # TODO %s\n' "$TESTSRUN" "$1" "$SKIPWHY"
			printf '#   Failed (TODO) test "%s"\n' "$1"
		else printf 'ok %i # %s\n' "$TESTSRUN" "$SKIPTYPE $SKIPWHY"
		fi
	else
		((TESTSFAILED++))
		printf 'not ok - %s\n' "$1"
	fi
	return 1
}
skip(){
	if [ "$SKIPTESTS" -gt 0 ]
	then
		diag "skip called during $SKIPTYPE, nesting unsupported"
	fi
	SKIPWHY=$1
	SKIPTESTS=$2
	SKIPTYPE='skip'
}
todo(){
	if [ "$SKIPTESTS" -gt 0 ]
	then
		diag "todo called during $SKIPTYPE, nesting unsupported"
	fi
	SKIPWHY=$1
	SKIPTESTS=$2
	SKIPTYPE='TODO'
}
diag(){
	if [ "$1" = '' ]
	then prefixblock '#'
	else prefixblock '#'<<<"$1"
	fi
}
subtest(){
	if [ "$1" = '' ]
	then prefixblock '    '
	else prefixblock '    '<<<"$1"
	fi
}
prefixblock(){
	local r
	while read -r r
	do
		printf '%s\n' "$1$r"
	done
}
wasok(){
	local r=$?
	if [ "$r" -eq 0 ]
	then pass "$1"
	else fail "$1, code $r"
	fi
}
okrun(){
	local r
	if r=$(eval "$1")
	then pass "$2"
	else
		fail "$2 {$1} code $?"
		diag "$r"
		return 1
	fi
}
is(){
	if [ "$1" = "$2" ]
	then pass "$3"
	else fail "$3, got $1"
	fi
}
isnt(){
	if [ "$1" = "$2" ]
	then fail "$3, got $1"
	else pass "$3"
	fi
}
like(){
	if [[ "$1" =~ $2 ]]
	then pass "$3"
	else fail "$3, got $1, which didn't match $2"
	fi
}
unlike(){
	if [[ "$1" =~ $2 ]]
	then IFS=')(' fail "$3, got $1, which matched $2 for (${BASH_REMATCH[*]})"
	else pass "$3"
	fi
}
