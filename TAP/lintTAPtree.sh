#!/bin/bash
#This comes from git's default pre-commit hook to check filenames for less portable characters
shopt -s nullglob globstar
if [ -f "$1" ]
then
	L=( "$@" )
else
	L=( ./**/* )
fi
#shellcheck source=TAP/TAP.sh
source "$(dirname "${BASH_SOURCE[0]}")/TAP.bash" "$(basename "$0")" "${#L[@]}"
for f in "${L[@]}"
do is "$(printf "%s" "$f" | LC_ALL=C tr -d '[ -~]\0' | wc -c)" 0 "ASCII-only $f"
done
endtests
