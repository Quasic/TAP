#!/bin/bash
TESTING='TAP'
printf '\e]0;%s testcases\e\\%s testcases:\n' "$TESTING" "$TESTING"
if cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
then
	if perl TAPharness.pl lintTAP*.sh testcasesTAP*.*
	then printf '\e]0;[Passed] %s testcases\e\\Passed testcases\n' "$TESTING"
		r=0
	else printf '\e]0;[Failed] %s testcases\e\\Failed testcases\n' "$TESTING"
		r=1
	fi
else
	r=1
	printf '\e]0;[Failed to start] %s testcases\e\\Failed to chdir!\n' "$TESTING"
fi
[[ "$-" =~ 'i' ]]&&read -rn1 -p 'Press a key to close log...'
exit $r
