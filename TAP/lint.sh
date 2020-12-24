#!/bin/bash
if [ $# -eq 0 ]||[ "$1" = '--help' ]||[ "$1" = '-h' ]
then
	printf 'Usage: %s [options] [list of files to lint]\nOptions:\n-p do NOT check portability\n-h or --help for this display\n' "$0"
	[[ $- == *i* ]]&&read -rn1 -p "Press a key to close help">&2
	exit
fi
hasCScript=$(command -v cscript.exe)
hasNode=$(command -v node)
hasShellcheck=$(command -v shellcheck)
if [ "$1" = '-p' ]
then
	portability='n'
	shift
fi
if [ $# -eq 1 ]
then t="lint.sh $1"
else t='lint.sh [list of files]'
fi
dir=$(dirname "${BASH_SOURCE[0]}")
#shellcheck source=TAP/TAP.sh
source "$dir/TAP.sh" "$t" '?'
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
	if [[ "$f" =~ \.(ba?|)sh$ ]]||[[ "$shebang" =~ ^\#!(.*/)?bash( |$) ]]
	then
		okname "$f lint bash" bash -n "$f"
		[ "$hasShellcheck" != '' ]&&okname "$f shellcheck" shellcheck -x "$f"
	elif [ "$hasShellcheck" != '' ]&&[[ "$f" =~ \.zsh$ ]]
	then okname "$f shellcheck" shellcheck -x "$f"
	elif [ "$hasShellcheck" != '' ]&&[[ "$shebang" =~ ^\#!(.*/)?zsh( |$) ]]
	then okname "$f shellcheck" shellcheck -x "$f"
	elif [[ "$f" =~ \.p(lx?|m)$ ]]||[[ "$shebang" =~ ^\#!(.*/)?perl( |$) ]]
	then okname "$f lint Perl" perl -wct "$f"
	elif [[ "$f" =~ \.g?awk$ ]]||[[ "$shebang" =~ ^\#!(.*/|)g?awk\ .*-f$ ]]
	then gawk --lint -e 'BEGIN{exit 0}END{exit 0}' -f "$f" 2>&1|gawk -v file="$f" -v shebang="$shebang" -f "$dir/lintparse.awk"||((TESTSFAILED++))
		((TESTSRUN++))
	# elif [ "$f" = '.sed' ]||[[ "$shebang" =~ ^\#!(.*/)?sed( .*)? (-f|--file=)$ ]]
	# then
	elif [ "$hasNode" != '' ]&&[[ "$shebang" =~ ^#!(.*/)?node( |$) ]]
	then okname "$f lint node.js" node -c "$f"
	elif [ "$hasCScript" != '' ]&&[[ "$shebang" =~ ^(\'|//|/*|[Rr][Ee][Mm] |<!--)\#!(.*/|)cscript\.exe( |$) ]]
	then okname "$f lint cscript" cscript //Nologo //Job:lint lint.wsf "$f"
	elif [ "$hasNode" != '' ]&&[[ "$f" =~ \.js$ ]]
	then okname "$f lint node.js" node -c "$f"
	elif [ "$hasCScript" != '' ]&&[[ "$f" =~ \.(js|vbs|wsf)$ ]]
	then okname "$f lint cscript" cscript //Nologo //Job:lint lint.wsf "$f"
	else
		skip "Unknown lint type <$f> shebang: $shebang" 1
		fail 'no lint'
	fi
done
endtests
