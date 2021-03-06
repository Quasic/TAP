' TAP format testcase library for VBScript
' by Quasic
' released under Creative Commons Attribution (BY) 4.0 license
' Please report bugs at https://github.com/Quasic/TAP/issues
set TESTSTREAM=Nothing
TESTSRUN=0
TESTSFAILED=0
SKIPTESTS=0
NUMTESTS=0
SKIPTESTS=0
SKIPWHY=""
SKIPTYPE=""
sub startTests(stream,name,num)
	set TESTSTREAM=stream
	TESTSRUN=0
	TESTSFAILED=0
	SKIPTESTS=0
	testWrite "#TAP testing "&name&" (TAP.vbs 0.1)"
	if num="?" then
		NUMTESTS="?"
	elseif vartype(num)=8 then
		testWrite "1..0 # Skipped: "&num
		NUMTESTS=0
	else
		testWrite "1.."&num
		NUMTESTS=num
	end if
end sub
sub testWrite(s)
	TESTSTREAM.write s&chr(10)
end sub
sub doneTesting(num)
	if NUMTESTS<>"?" and NUMTESTS<>num then testWrite "#Planned "&NUMTESTS&" tests at start, but "&num&" tests at end"
	NUMTESTS=num
	endTests
end sub
sub endTests
	if TESTSFAILED then testWrite "#Failed "&TESTSFAILED&" tests"
	if NUMTESTS="?" then
		testWrite "1.."&TESTSRUN
	elseif TESTSRUN<>NUMTESTS then
		testWrite "#Planned "&NUMTESTS&" tests, but ran "&TESTSRUN&" tests"
		TESTSFAILED=TESTSFAILED+1
	end if
	if TESTSFAILED>254 then WScript.quit 255
	WScript.quit TESTSFAILED
end sub
sub bailOut(reason)
	testWrite "Bail out!  "&reason
	WScript.quit 255
end sub
sub pass(s)
	TESTSRUN=TESTSRUN+1
	if SKIPTESTS then
		SKIPTESTS=SKIPTESTS-1
		if SKIPTYPE="TODO" then
			testWrite "ok "&TESTSRUN&" - "&s&" # TODO "&SKIPWHY
		else
			testWrite "ok "&TESTSRUN&" # skip "&SKIPWHY
		end if
	else
		testWrite "ok - "&s
	end if
end sub
sub fail(s)
	TESTSRUN=TESTSRUN+1
	if SKIPTESTS then
		SKIPTESTS=SKIPTESTS-1
		if SKIPTYPE="TODO" then
			testWrite "not ok "&TESTSRUN&" - "&s&" # TODO "&SKIPWHY&"\n#   Failed (TODO) test '"&s&"'"
		else
			testWrite "ok "&TESTSRUN&" # skip "&SKIPWHY
		end if
	else
		TESTSFAILED=TESTSFAILED+1
		testWrite "not ok - "&s
		'if n then
		'	testWrite "#"&TESTSERIES&": "&n
		'end if
	end if
end sub
sub skip(why,n)
	if SKIPTESTS then diag "skip called during "&SKIPTYPE&", nesting unsupported"
	SKIPTESTS=n
	SKIPWHY=why
	SKIPTYPE="skip"
end sub
sub todo(why,n)
	if SKIPTESTS then diag "todo called during "&SKIPTYPE&", nesting unsupported"
	SKIPTESTS=n
	SKIPWHY=why
	SKIPTYPE="TODO"
end sub
sub diag(s)
	testWrite "#"&s
end sub
sub ok(t,s)
if t then
	pass s
else
	fail s
end if
end sub
sub iseq(a,b,s)
if a=b then
	pass s
else
	fail s&", got "&a
end if
end sub
sub isnt(a,b,s)
if a=b then
	fail s&", got "&a
else
	pass s
end if
end sub
'like, unlike, is_deeply, can
