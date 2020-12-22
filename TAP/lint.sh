#!/bin/bash
if [ $# -eq 0 ]||[ "$1" = '--help' ]||[ "$1" = '-h' ]
then
	printf 'Usage: %s [options] [list of files to lint]\nOptions:\n-n use bash -n instead of shellcheck\n-h or --help for this display\n' "$0"
	[[ $- == *i* ]]&&read -rn1 -p "Press a key to close help">&2
	exit
fi
hasCScript=$(command -v cscript.exe)
hasNode=$(command -v node)
hasShellcheck=$(command -v shellcheck)
if [ "$1" = '-n' ]
then
	usebash="$hasShellcheck"
	shift
fi
if [ $# -eq 1 ]
then t="lint.sh $1"
else t='lint.sh [list of files]'
fi
#shellcheck source=TAP/TAP.sh
source "$(dirname "${BASH_SOURCE[0]}")/TAP.sh" "$t" $(( $# * 3 ))
while [ $# -gt 0 ]
do
	okname "$1 existance" [ -f "$1" ]
	okname "$1 read" read -r shebang < "$1"
	if [[ "$1" =~ \.(ba?|)sh$ ]]||[[ "$shebang" =~ ^\#!(.*/)?bash( |$) ]]
	then
		if ! [ "$hasShellcheck" = "$usebash" ]
		then okname "$1 shellcheck" shellcheck -x "$1"
		else okname "$1 lint bash" bash -n "$1"
		fi
	elif ! [ "$hasShellcheck" = '' ]&&[[ "$1" =~ \.zsh$ ]]
	then okname "$1 shellcheck" shellcheck -x "$1"
	elif ! [ "$hasShellcheck" = '' ]&&[[ "$shebang" =~ ^\#!(.*/)?zsh( |$) ]]
	then okname "$1 shellcheck" shellcheck -x "$1"
	elif [[ "$1" =~ \.p(lx?|m)$ ]]||[[ "$shebang" =~ ^\#!(.*/)?perl( |$) ]]
	then okname "$1 lint Perl" perl -wct "$1"
	elif [[ "$1" =~ \.g?awk$ ]]||[[ "$shebang" =~ ^\#!(.*[/g])?awk\ .*-f$ ]]
	then gawk --lint -e 'BEGIN{exit 0}END{exit 0}' -f "$1" 2>&1| gawk -v file="$1" -e '
		/ (is|are) a gawk extension$/{next}
		/^gawk: ( *|In file included) from /{P=P"\n#"$0;next}
		/ warning: (already included source file |POSIX does not allow `\\x'\'' escapes$)/{
			W=W"\n#"$0
			P=""
			next
		}
		match($0,/^gawk: warning: function( .*) defined but never called directly$/,M){
			if(M[1]!~/hook/){
				LIB=LIB M[1]
				next
			}
		}
		match($0,/^gawk: warning: function( .*) called but never defined$/,M){
			if(M[1]~/hook/){
				HOOKS=HOOKS M[1]
				next
			}
		}
		{
			X=X P"\n#"$0
			P=""
		}
		END{
			if(LIB)W=W"\n#Unused Library functions:"LIB
			if(HOOKS)W=W"\n#Unused hooks:"HOOKS
			if(X){
				print"not ok - "file"\n#Errors:"X
				if(W)print"#Warnings/Info:"W
				exit 1
			}
			print"ok - "file
			if(W)print"#Warnings/Info:"W
		}
	'
	# elif [ "$1" = '.sed' ]||[[ "$shebang" =~ ^\#!(.*/)?sed( .*)? (-f|--file=)$ ]]
	# then
		
	# elif command -v node>/dev/null&&([[ "$shebang" =~ or (no cscript and .js))
	# cscript shebang wrappers?
	elif ! [ "$hasCScript" = '' ]&&[[ "$1" =~ \.(js|vbs|wsf)$ ]]
	then okname "$1 lint cscript" cscript //Nologo //Job:cscriptlint cscriptlint.wsf "$1"
	else
		skip "Unknown lint type, shebang: $shebang" 1
		fail "$1: I don't yet lint this type of file"
	fi
	shift
done
endtests
