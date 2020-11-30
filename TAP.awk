function startTests(name,num){
print "#TAP testing "(TESTSERIES=name)
if(+num>0){
	print "1.."(NUMTESTS=num)
}else{
	print "1..0 # Skipped: "num
	NUMTESTS=0
}
}
BEGIN{
TESTSRUN=0
TESTSFAILED=0
SKIPTESTS=0
}
function endTests(){
exit
}
function bailout(reason){
print "Bail out!  "reason
TESTSFAILED="Bailed out!"
exit 255
}
END{
if(TESTSFAILED=="Bailed out!"){
	exit 255
}
if(TESTSFAILED){
	print "#Failed "TESTSFAILED" tests"
}
if(TESTSRUN!=NUMTESTS){
	print "#Planned "NUMTESTS" tests, but ran "TESTSRUN" tests"
	exit 255
}
if(TESTSFAILED>254){
	exit 254
}
exit TESTSFAILED
}
function pass(s){
	TESTSRUN++
	if(SKIPTESTS){
		SKIPTESTS--
		if(SKIPTYPE=="TODO"){
			print "ok "TESTSRUN" - "s" # TODO "SKIPWHY
		}else{
			print "ok "TESTSRUN" # skip "SKIPWHY
		}
	}else{
		print "ok - "s
	}
}
function fail(s,n){
	TESTSRUN++
	if(SKIPTESTS){
		SKIPTESTS--
		if(SKIPTYPE=="TODO"){
			print "not ok "TESTSRUN" - "s" # TODO "SKIPWHY"\n#   Failed (TODO) test '"s"'"
		}else{
			print "ok "TESTSRUN" # skip "SKIPWHY
		}
	}else{
		TESTSFAILED++
		print "not ok - "s
		if(n){
			print "#"TESTSERIES": "n
		}
	}
}
function skip(why,n){
	if(SKIPTESTS){
		diag("skip called during "SKIPTYPE", nesting unsupported")
	}
	SKIPTESTS=n
	SKIPWHY=why
	SKIPTYPE="skip"
}
function todo(why,n){
	if(SKIPTESTS){
		diag("todo called during "SKIPTYPE", nesting unsupported")
	}
	SKIPTESTS=n
	SKIPWHY=why
	SKIPTYPE="TODO"
}
function diag(s){
	print "#"s
}
function ok(t,s){
if(t){
	pass(s)
}else{
	fail(s)
}
}
function is(a,b,s){
if(a==b){
	pass(s)
}else{
	fail(s", got "a)
}
}
function isnt(a,b,s){
if(a==b){
	fail(s", got "a)
}else{
	pass(s)
}
}
