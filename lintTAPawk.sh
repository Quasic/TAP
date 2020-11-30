#!/bin/bash
shopt -s nullglob
if [ -f "$1" ]
then
	L=( "$@" )
	echo "#TAP testing awk scripts via $0"
else
	L=( ./*.awk )
	echo "#TAP testing $(realpath .)/*.awk via $0"
fi
echo "1..${#L[@]}"
r=0
for f in "${L[@]}"
do
	gawk --lint -e 'BEGIN{exit 0}END{exit 0}' -f "$f" 2>&1| gawk -v file="$f" -e '
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
	'||((r++))
done
if [ "$r" -gt 0 ]
then
	printf '#Failed %i tests\n' "$r"
	if [ "$r" -gt 254 ]
	then exit 255
	fi
	exit $r
fi
