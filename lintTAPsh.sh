#!/bin/bash
shopt -s nullglob
if [ -f "$1" ]
then
	L=( "$@" )
	echo "#TAP testing perl scripts via $0"
else
	L=( ./*.sh ./*.bsh ./*.bash )
	echo "#TAP testing $(realpath .)/*.{sh|bsh|bash} via $0"
fi
echo "1..${#L[@]}"
r=0
for f in "${L[@]}"
do
	if q=$(bash -n $f 2>&1) #or shellcheck?
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
