#!/bin/bash
Version=0.1
# finds and runs perl files through checks
# By Quasic
# Report bugs to https://github.com/Quasic/TAP/issues
# Released under Creative Commons Attribution (BY) 4.0 license
if [ -f "$1" ]
then
	L=( "$@" )
	printf '#TAP testing perl scripts via lintTAPperl.sh %s\n' "$Version"
else
	shopt -s nullglob globstar
	L=( ./**/*.pl ./**/*.plx ./**/*.pm )
	printf '#TAP testing %s\n' "$(realpath .)/*.pl via lintTAPperl.sh $Version"
fi
printf '1..%i\n' "${#L[@]}"
r=0
for f in "${L[@]}"
do
	if q=$(perl -wct "$f" 2>&1)
	then printf 'ok - %s\n' "$f"
	else
		printf 'not ok - %s\n' "$f"
		while read -r t
		do
			printf '#%s\n' "$t"
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
	exit "$r"
fi
