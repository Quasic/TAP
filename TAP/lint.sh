#!/bin/bash
printf '#TAP lint.sh 1.0e'
[ "$1" = '--version' ]&&printf '\n'&&exit
dir=$(dirname "${BASH_SOURCE[0]}")
declare -A has
if command -v bash>/dev/null
then
	printf '; %s' "$(bash --version|head -n1)"
	has[bash]=1
else printf '; Unknown shell'
fi
if command -v awk>/dev/null
then
	has[awk]='awk'
	y='found'
elif command -v gawk>/dev/null
then
	has[awk]='gawk'
	alias awk=gawk
	y=$(gawk -v help=version -f "$dir/lintparse.awk")&&has[gawk]="$y"
elif command -v mawk>/dev/null&&y="$(mawk --version|head -n1)"
then
	has[awk]='mawk'
	alias awk=mawk
	has[mawk]="$y"
else y='not found'
fi
printf '; awk: %s' "(${has[awk]}) $y"
hasCScript(){
	local t
	if [ "${has[CScript]+set}" ]
	then [ "${has[CScript]}" = '' ]&&return 1
	else
		if command -v cscript.exe>/dev/null
		then
			has[CScript]=1
			t=$(cscript.exe //Nologo //Job:version "$dir/lint.wsf")&&has[lint.wsf]="$t"
		else has[CScript]=''
		fi
	fi
}
hasnode(){
	local t
	if [ ${has[node]+set} ]
	then [ "${has[node]}" = '' ]&&return 1
	else
		if command -v node>/dev/null&&
			t=$(node --version 2>/dev/null)
		then has[node]="$t";return 0
		else has[node]='';return 1
		fi
	fi
}
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
elif [ $# = 0 ]
then
	printf '# use lint.sh --help or -h option for help\n1..0 # skipped without tests'
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
	elif [[ "$f" =~ \.(g?awk|bash|dash|hta|js|ksh|sed|sh|vbs|ws[cf]|xhtml|xht)$ ]]
	#aspx? html?
	then y="${BASH_REMATCH[1]}"
	elif [[ "$f" =~ \.(b|d)sh$ ]]
	then y="${BASH_REMATCH[1]}ash"
	elif [[ "$f" =~ \.p(lx?|m)$ ]]
	then y=perl
	elif [[ "$f" =~ \.[ch]$ ]]
	then y=c
	elif [ "$f" = Makefile ]
	then y='make'
	else y='?'
	fi
	if [[ "$y" =~ ^(bash|dash|ksh|sh)$ ]]
	then
		[ ${has["$y"]+set} ]||has["$y"]=$(command -v "$y")
		[ "${has["$y"]}" = '' ]&&skip "$y not found" 1
		okname "$f lint $y" "$y" -n "$f"
		if ! [ "${has[shellcheck]+set}" ]
		then
			if command -v shellcheck>/dev/null&&
				y=$(shellcheck --version)
			then
				if [ "${has[awk]}" = '' ]
				then has[shellcheck]=$(grep ^version:<<<"$y")
				else has[shellcheck]=$(awk '/^version:/{print $2;exit}'<<<"$y")
				fi
			else has[shellcheck]=''
			fi
		fi
		[ "${has[shellcheck]}" != '' ]&&okname "$f shellcheck ${has[shellcheck]}" shellcheck -x "$f"
	elif [ "$y" = perl ]
	then okname "$f lint Perl" perl -wct "$f"
	elif [[ "$y" =~ ^g?awk$ ]]
	then
		[ "$y" = awk ]&&okname "$f lint awk by immediate exit" "${has[awk]}" -e 'BEGIN{exit 0}END{exit 0}' -f "$f"
		if ! [ ${has[gawk]+set} ]
		then
			if command -v gawk>/dev/null&&
				y=$(gawk -v help=version -f "$dir/lintparse.awk")
			then has[gawk]=1
			else has[gawk]=''
			fi
		fi
		if [ "${has[gawk]}" != '' ]
	then
		#shellcheck disable=SC2031
		gawk --lint -e 'BEGIN{exit 0}END{exit 0}' -f "$f" 2>&1|gawk -v file="$f" -v dialect="$y" -v shebang="$shebang" -f "$dir/lintparse.awk"||((TAP_TestsFailed++))
		#shellcheck disable=SC2031
		((TAP_TestsRun++))
		fi
	# elif [ "$y" = sed ]
	# then
	elif [ "$y" = make ]
	then
		if ! [ ${has[make]+set} ]
		then
			if command -v make>/dev/null&&
				y=$(make --version)
			then
				if [ "${has[awk]}" = '' ]
				then has[make]=$(head -n1<<<"$y")
				else has[make]=$(awk '{sub(/,.*$/,"");print;exit}'<<<"$y")
				fi
			else has[make]=''
			fi
		fi
		[ "${has[make]}" = '' ]&&skip 'no make found' 1
		okname "$f lint make ${has[make]}" make -n
	elif [ "$y" = node ]&&hasnode
	then okname "$f lint node.js ${has[node]}" node -c "$f"
	elif [[ "$y" = js ]]
	then
		hasCScript&&[ "${has[lint.wsf]}" != '' ]&&okname "$f lint cscript.exe ${has[lint.wsf]}" cscript.exe //Nologo //Job:lint "$dir/lint.wsf" "$f"
		hasnode&&okname "$f lint node.js ${has[node]}" node -c "$f"
		if [ "${has[node]}${has[lint.wsf]}" = '' ]
		then
			skip "$f unable to lint JavaScript" 1
			fail 'no lint'
		fi
	elif [[ "$y" =~ ^(vbs|wsf|wsc|hta|xhtml)$ ]]&&hasCScript
	then [ "${has[lint.wsf]}" != '' ]&&okname "$f lint cscript.exe ${has[lint.wsf]}" cscript.exe //Nologo //Job:lint "$dir/lint.wsf" "$f"
		if [ "$y" = wsf ]
		then
			F='lint_wsf_unjob_'
			b=0
			while grep -F "$F$b" "$f"
			do ((b++))
			done
			is "$(cscript.exe //nologo "//job:$F$b" "$f")" "Input Error: Unable to find job \"$F$b\"." 'lint wsf unjob test'
		fi
	elif [ "$y" = c ]
	then
		if ! [ ${has[gcc]+set} ]
		then
			if command -v gcc>/dev/null&&
				y=$(gcc -dumpversion 2>/dev/null)
			then has[gcc]="$y ($(gcc -dumpmachine))"
			else has[gcc]=''
			fi
		fi
		[ "${has[gcc]}" = '' ]&&skip 'no gcc found' 3
		okname "preprocess $f gcc ${has[gcc]}" gcc -E "$f" -o /dev/null
		okname "compile $f" gcc -S "$f" -o /dev/null
		okname "assemble $f" gcc -c "$f" -o /dev/null
	else
		skip "$f unable to lint type $y shebang: $shebang" 1
		fail 'no lint'
	fi
done
endtests
