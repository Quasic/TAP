#!/bin/bash
printf '#TAP lint.sh 1.0d'
[ "$1" = '--version' ]&&printf '\n'&&exit
dir=$(dirname "${BASH_SOURCE[0]}")
declare -A has
printf '; %s' "$(bash --version|head -n1)"
command -v gawk>/dev/null&&
	y=$(gawk -v help=version -f "$dir/lintparse.awk")&&
	has[gawk]="$y"&&
	printf '; %s' "$y"
command -v make>/dev/null&&
	y=$(make --version)&&
	has[make]="$y"&&
	awk '{sub(/,.*$/,"");printf "; %s",$0;exit}'<<<"$y"
command -v cscript.exe>/dev/null&&
	y=$(cscript.exe //Nologo //Job:version "$dir/lint.wsf")&&
	has[CScript]="$y"&&
	printf '; %s' "$y"
command -v shellcheck>/dev/null&&
	y=$(shellcheck --version)&&
	has[shellcheck]="$y"&&
	awk '/^version:/{printf "; shellcheck %s",$2;exit}'
command -v node>/dev/null&&
	y=$(node --version 2>/dev/null)&&
	has[node]="$y"&&
	printf '; node %s' "$y" #node alias w/o node in Msys
command -v gcc>/dev/null&&
	y=$(gcc -dumpversion 2>/dev/null)&&
	has[gcc]="$y"&&
	printf '; gcc %s' "$y ($(gcc -dumpmachine))"
printf '\n'
[ "$1" = '--versions' ]&&exit
if [ "$1" = '--help' ]||[ "$1" = '-h' ]
then
	printf 'tries to detect file types and use available linters to generate TAP output
Usage: [bash] %s [option] [list of files to lint]
Options:
-p do NOT check portability
--version shows lint.sh version and exits
--versions gives versions of lint.sh, dependencies and available linters, then exits
-h or --help for this display

by Quasic [https://quasic.github.io]
Please report bugs at https://github.com/Quasic/TAP/issues
Released under Creative Commons Attribution (BY) 4.0 license
' "$0"
	[[ $- == *i* ]]&&read -rn1 -p "Press a key to close help">&2
	exit
fi
if [ "$1" = '-p' ]
then
	portability='n'
	shift
fi
#shellcheck source=TAP/TAP.bash
source "$dir/TAP.bash" "$*" '?'
for f in "$@"
do
	F="$f"
	isnt "$f" '' "Empty path test <$f>"
	unlike "$f" ^- "POSIX (non-switch) $f"||f="./$f"
	b=$(basename "$f")
	if [ "$portability" != 'n' ]
	then
		[ "$F" != "$b" ]&&unlike "$b" ^- "POSIX (non-switch) $b"
		is "$(printf "%s" "$b" | LC_ALL=C tr -d '[ -~]\0' | wc -c)" 0 "portable (ASCII-only) $b" #from git's default pre-commit hook
	fi
	if [ -d "$f" ]
	then
		pass "$f is directory"
		okname "$f read" ls "$f/"
		continue
	fi
	okname "$f is file" [ -f "$f" ]
	okname "$f has contents" [ -s "$f" ]||continue
	read -r shebang<"$f";wasok "$f read"
	if [[ "$shebang" =~ ^\#!(.*/)?(bash|dash|ksh|node|perl|sh)( |$) ]]||[[ "$shebang" =~ ^\#!(.*/)?(g?awk|sed)( .*|)\ -f$ ]]
	then y="${BASH_REMATCH[2]}"
	elif [[ "${shebang,,}" =~ ^(\'|//|/*|rem |<!--)\#!(.*/|)cscript\.exe( |$) ]]
	then
		case "${BASH_REMATCH[1]}" in
		"'"|'rem ')y=vbs;;
		'//'|'/*')y=js;;
		'<!--')y=wsf;;
		*)y='?';;
		esac
	elif [[ "$f" =~ \.(g?awk|bash|dash|hta|js|ksh|sed|sh|vbs|ws[cf]|xhtml)$ ]]
	then y="${BASH_REMATCH[1]}"
	elif [[ "$f" =~ \.(b|d)sh$ ]]
	then y="${BASH_REMATCH[1]}ash"
	elif [[ "$f" =~ \.p(lx?|m)$ ]]
	then y=perl
	elif [[ "$f" =~ \.[ch]$ ]]
	then y=c
	elif [ "$f" = Makefile ]
	then y=make
	else y='?'
	fi
	if [[ "$y" =~ ^(bash|dash|ksh|sh)$ ]]
	then
		okname "$f lint $y" "$y" -n "$f"
		[ "${has[shellcheck]}" != '' ]&&okname "$f shellcheck" shellcheck -x "$f"
	elif [ "$y" = perl ]
	then okname "$f lint Perl" perl -wct "$f"
	elif [[ "$y" =~ ^g?awk$ ]]&&
		[ "${has[gawk]}" != '' ]
	then gawk --lint -e 'BEGIN{exit 0}END{exit 0}' -f "$f" 2>&1|gawk -v file="$f" -v dialect="$y" -v shebang="$shebang" -f "$dir/lintparse.awk"||((TAP_TestsFailed++))
		((TAP_TestsRun++))
	# elif [ "$y" = sed ]
	# then
	elif [ "$y" = make ]&&
		[ "${has[make]}" != '' ]
	then okname "$f lint make" make -n
	elif [ "$y" = node ]&&
		[ "${has[node]}" != '' ]
	then okname "$f lint node.js" node -c "$f"
	elif [[ "$y" = js ]]&&
		[ "${has[CScript]}${has[node]}" != '' ]
	then
		[ "${has[CScript]}" != '' ]&&
			okname "$f lint cscript.exe" cscript.exe //Nologo //Job:lint "$dir/lint.wsf" "$f"
		[ "${has[node]}" != '' ]&&
			okname "$f lint node.js" node -c "$f"
	elif [[ "$y" =~ ^(vbs|wsf|wsc|hta|xhtml)$ ]]&&
		[ "${has[CScript]}" != '' ]
	then okname "$f lint cscript.exe" cscript.exe //Nologo //Job:lint "$dir/lint.wsf" "$f"
	elif [ "$y" = c ]&&[ "${has[gcc]}" != '' ]
	then
		okname "preprocess $f" gcc -E "$f" -o /dev/null
		okname "compile $f" gcc -S "$f" -o /dev/null
		okname "assemble $f" gcc -c "$f" -o /dev/null
	else
		skip "$f Unknown lint type $y shebang: $shebang" 1
		fail 'no lint'
	fi
done
endtests
