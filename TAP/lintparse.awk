#!/bin/gawk -v help=usage -f
BEGIN{
	if(help)print "lintparse.awk 1.0; GNU Awk "PROCINFO["version"]", API: "PROCINFO["api_major"]"."PROCINFO["api_minor"]"; "PROCINFO["mpfr_version"]"; "PROCINFO["gmp_version"]
	else if(!"file" in SYMTAB){
		print "ERROR: file variable is required"
		help="err"
	}
	if(help&&help!~/^[Vv][Ee][Rr]/){
print"Parses gawk --lint output to a TAP item"
print"gawk -v help={version|usage} -f lintparse.awk"
print"gawk -v file=\"$file\" [-v dialect={awk|gawk}] [-v shebang=\"$(head -n 1 \"$file\")\"] -f lintparse.awk <<(gawk --lint -e 'BEGIN{exit 0}END{exit 0}' -f \"$file\" 2>&1)"
print"designed for use by lint.sh"
print"by Quasic"
print"released under Creative Commons Attribution (BY) 4.0 license"
print"Please report bugs at https://github.com/Quasic/TAP/issues"
	}
	if(help)exit help=="err"?1:0
	gawk=dialect=="gawk"||file~/\.gawk$/||shebang~/^#!?(.*\/|)gawk /
}
/ (is|are) a gawk extension$/{
	if(!gawk){
		X=X P"\n#"$0
		P=""
	}
	next
}
/^gawk: ( *|In file included) from /{P=P"\n#"$0;next}
/ warning: POSIX does not allow `\\x'\'' escapes$/{
	if(gawk){
		W=W P"\n#"$0
	}else{
		X=X P"\n#"$0
	}
	P=""
	next
}
/ warning: already included source file /{
	W=W P "\n#"$0
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
	if(help)exit
	if(LIB)W=W"\n#Unused Library functions:"LIB
	if(HOOKS)W=W"\n#Unused hooks:"HOOKS
	if(X){
		print"not ok - "file" lint "(gawk?"g":"")"awk\n#Errors:"X
		if(W)print"#Warnings/Info:"W
		exit 1
	}
	print"ok - "file" lint "(gawk?"gawk":"awk")
	if(W)print"#Warnings/Info:"W
}
