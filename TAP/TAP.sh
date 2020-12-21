#!/bin/bash
echo "#TAP testing $1"
case "$2" in
*[!0-9]*|'') echo "1..0 #Skipped: $2";NUMTESTS=0;;
*) echo "1..$2";NUMTESTS=$2;;
esac
TESTSERIES=$1
TESTSRUN=0
TESTSFAILED=0
SKIPTESTS=0
endtests(){
	if [ "$TESTSFAILED" -ne 0 ]
	then
		echo "#Failed $TESTSFAILED tests"
		[ "$TESTSFAILED" -gt 254 ]&&TESTSFAILED=254
	fi
	if [ "$TESTSRUN" -ne "$NUMTESTS" ]
	then
		echo "#Planned $NUMTESTS tests, but ran $TESTSRUN tests"
		TESTSFAILED=255
	fi
	[[ $- == *i* ]]&&read -rn1 -p "Press a key to close log (will return $TESTSFAILED)">&2
	exit $TESTSFAILED
}
bailout(){
	echo "Bail out!  $1"
	exit 255
}
pass(){
	((TESTSRUN++))
	if [ "$SKIPTESTS" -gt 0 ]
	then
		((SKIPTESTS--))
		if [ "$SKIPTYPE" = TODO ]
		then echo "ok $TESTSRUN - $1 # TODO $SKIPWHY"
		else echo "ok $TESTSRUN # skip $SKIPWHY"
		fi
	else echo "ok - $1"
	fi
}
fail(){
	((TESTSRUN++))
	if [ "$SKIPTESTS" -gt 0 ]
	then
		((SKIPTESTS--))
		if [ "$SKIPTYPE" = TODO ]
		then
			echo "not ok $TESTSRUN - $1 # TODO $SKIPWHY"
			echo "#   Failed (TODO) test '$1'"
		else echo "ok $TESTSRUN # skip $SKIPWHY"
		fi
	else
		((TESTSFAILED++))
		echo "not ok - $1"
		[ "$2" = '' ]||echo "#$TESTSERIES: $2"
	fi
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
	[ "$1" = '' ]&&return
	local r
	while read -r r
	do
		echo "#$r"
	done<<<"$1"
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
