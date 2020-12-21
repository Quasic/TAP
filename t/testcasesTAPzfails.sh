#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"||exit 255
B=(bailoutTAP*.*)
T=(TODOpassTAP*.*)
N=(/dev/null -)
source TAP.sh 'gitscript all fail testcases' "$(( ${#B[@]}+${#T[@]}+${#N[@]} ))"
for f in "${N[@]}"
do
	perl TAPharness.pl "$f" >/dev/null 2>/dev/null <<<''
	if [ $? -eq 1 ]
	then pass "$f"
	else fail "$f"
	fi
done
for f in "${T[@]}"
do
	s=$(perl TAPharness.pl "$f" 2>/dev/null)
	if [ $? -eq 1 ]&&[[ "$s" == *TODO\ passed:* ]]
	then pass "$f"
	elif [[ "$s" == *Result:\ NOTESTS* ]]
	then pass "$f skipped"
	else
		fail "$f"
		diag "$s"
	fi
done
for f in "${B[@]}"
do
	s=$(perl TAPharness.pl "$f" 2>/dev/null)
	if [ $? -eq 255 ]&&[[ "$s" == *Bailout\ called* ]]
	then pass "$f"
	elif [[ "$s" == *Result:\ NOTESTS* ]]
	then pass "$f skipped"
	else
		fail "$f"
		diag "$s"
	fi
done
endtests
