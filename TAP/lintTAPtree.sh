#!/bin/bash
shopt -s nullglob globstar
if [ -f "$1" ]
then
	L=( "$@" )
else
	L=( ./**/* )
fi
source "$(dirname "${BASH_SOURCE[0]}")/TAP.sh" "$(basename "$0")" "${#L[@]}"
for f in "${L[@]}"
do is "$(printf "%s" "$f" | LC_ALL=C tr -d '[ -~]\0' | wc -c)" 0 "ASCII-only $f"
done
endtests
