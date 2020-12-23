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
for f in "$@"
do
	if [ -d "$f" ]
	then
		pass "$f is directory"
		skip 'dirtest goes here' 2
		pass 'dirtest goes here'
		pass 'dirtest here 2'
		continue
	fi
	okname "$f is file" [ -f "$f" ]
	okname "$f read" read -r shebang < "$f"
	if [[ "$f" =~ \.(ba?|)sh$ ]]||[[ "$shebang" =~ ^\#!(.*/)?bash( |$) ]]
	then
		if ! [ "$hasShellcheck" = "$usebash" ]
		then okname "$f shellcheck" shellcheck -x "$f"
		else okname "$f lint bash" bash -n "$f"
		fi
	elif ! [ "$hasShellcheck" = '' ]&&[[ "$f" =~ \.zsh$ ]]
	then okname "$f shellcheck" shellcheck -x "$f"
	elif ! [ "$hasShellcheck" = '' ]&&[[ "$shebang" =~ ^\#!(.*/)?zsh( |$) ]]
	then okname "$f shellcheck" shellcheck -x "$f"
	elif [[ "$f" =~ \.p(lx?|m)$ ]]||[[ "$shebang" =~ ^\#!(.*/)?perl( |$) ]]
	then okname "$f lint Perl" perl -wct "$f"
	elif [[ "$f" =~ \.g?awk$ ]]||[[ "$shebang" =~ ^\#!(.*[/g])?awk\ .*-f$ ]]
	then gawk --lint -e 'BEGIN{exit 0}END{exit 0}' -f "$f" 2>&1| gawk -v file="$f" -e '
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
	# elif [ "$f" = '.sed' ]||[[ "$shebang" =~ ^\#!(.*/)?sed( .*)? (-f|--file=)$ ]]
	# then
		
	# elif command -v node>/dev/null&&([[ "$shebang" =~ or (no cscript and .js))
	# cscript shebang wrappers?
	elif ! [ "$hasCScript" = '' ]&&[[ "$f" =~ \.(js|vbs|wsf)$ ]]
	then okname "$f lint cscript" cscript //Nologo //Job:cscriptlint cscriptlint.wsf "$f"
	else
		skip "Unknown lint type, shebang: $shebang" 1
		fail "$f: I don't yet lint this type of file"
	fi
done
endtests
