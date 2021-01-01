#!/bin/bash
Version=1.0a
dir=$(dirname "${BASH_SOURCE[0]}")
libver="$(bash --version|head -n1); $(gawk -v help=version -f "$dir/lintparse.awk")"
hasCScript=$(command -v cscript.exe)&&libver="$libver; $(cscript.exe //Nologo //Job:version "$dir/lint.wsf")"
hasShellcheck=$(command -v shellcheck)&&libver="$libver; shellcheck $(shellcheck --version|gawk '/^version:/{print $2;exit}')"
hasNode=$(node --version 2>/dev/null)&&libver="$libver; node $hasNode" #node alias w/o node in Msys
printf '#TAP lint.sh %s; %s\n' "$Version" "$libver"
[ "$1" = '--version' ]&&exit
if [ "$1" = '--help' ]||[ "$1" = '-h' ]
then
	printf 'tries to detect file types and use available linters to generate TAP output
Usage: [bash] %s [option] [list of files to lint]
Options:
-p do NOT check portability
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
	else y='?'
	fi
	if [[ "$y" =~ ^(bash|dash|ksh|sh)$ ]]
	then
		okname "$f lint $y" "$y" -n "$f"
		[ "$hasShellcheck" != '' ]&&okname "$f shellcheck" shellcheck -x "$f"
	elif [ "$y" = perl ]
	then okname "$f lint Perl" perl -wct "$f"
	elif [[ "$y" =~ ^g?awk$ ]]
	then gawk --lint -e 'BEGIN{exit 0}END{exit 0}' -f "$f" 2>&1|gawk -v file="$f" -v dialect="$y" -v shebang="$shebang" -f "$dir/lintparse.awk"||((TESTSFAILED++))
		((TESTSRUN++))
	# elif [ "$y" = sed ]
	# then
	elif [ "$y" = node ]
	then [ "$hasNode" != '' ]&&okname "$f lint node.js" node -c "$f"
	elif [[ "$y" =~ ^(js|vbs|wsf|wsc|hta|xhtml)$ ]]
	then
		[ "$hasCScript" != '' ]&&okname "$f lint cscript.exe" cscript.exe //Nologo //Job:lint "$dir/lint.wsf" "$f"
		[ "$y" = js ]&&[ "$hasNode" != '' ]&&okname "$f lint node.js" node -c "$f"
	else
		skip "$f Unknown lint type $y shebang: $shebang" 1
		fail 'no lint'
	fi
done
endtests
