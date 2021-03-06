#!/bin/bash
#test files separately to avoid name conflicts
if ! command -v cscript >/dev/null
then
	echo "#TAP testing WSH library scripts via $0"
	if [ -f "$1" ]
	then echo '1..1
not ok - cscript
#not installed'
	else echo '1..0 # Skipped: cscript not installed'
	fi
	exit
fi
	tdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TAPdir="$tdir/../TAP"
L=( "$TAPdir/TAP.js" "$TAPdir/TAP.vbs" "$TAPdir/TAPclass.vbs" )
printf '#TAP testing core WSH TAP library scripts via %s\n' "$0"
echo "1..${#L[@]}"
r=0
for f in "${L[@]}"
do
	if q=$(cscript //nologo "$f" 2>&1)
	then echo "ok - $f"
	else
		echo "not ok - $f"
		while read -r t
		do
			echo "#$t"
		done<<<"$q"
		((r++))
	fi
done
if [ "$r" -gt 0 ]
then
	printf '#Failed %i tests\n' "$r"
	if [ "$r" -gt 254 ]
	then exit 254
	fi
	exit $r
fi
