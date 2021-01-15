#!/bin/bash
Version='1.0m'
# runs checks on awk files
# By Quasic
# Report bugs to https://github.com/Quasic/TAP/issues
# Released under Creative Commons Attribution (BY) 4.0 license
if [ -f "$1" ]
then
	L=( "$@" )
	printf '#TAP testing awk scripts'
else
	shopt -s nullglob globstar
	L=( ./**/*.awk )
	printf '#TAP testing %s' "$(realpath .)/*.awk"
fi
dir=$(dirname "${BASH_SOURCE[0]}")
printf ' via %s\n' "lintTAPawk.sh $Version; $(gawk -v help=version -f "$dir/lintparse.awk")
1..${#L[@]}"
r=0
for f in "${L[@]}"
do
	gawk --lint -e 'BEGIN{exit 0}END{exit 0}' -f "$f" 2>&1|gawk -v file="$f" -v shebang="$(head -n1 "$f")" -f "$dir/lintparse.awk"||((r++))
done
if [ "$r" -gt 0 ]
then
	printf '#Failed %i tests\n' "$r"
	if [ "$r" -gt 254 ]
	then exit 254
	fi
	exit "$r"
fi
