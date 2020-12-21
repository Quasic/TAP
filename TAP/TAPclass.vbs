class TAP
private TESTSTREAM,TESTSRUN,TESTSFAILED,SKIPTESTS,NUMTESTS,SKIPTYPE,SKIPWHY
public sub startTests(stream,name,num)
	set TESTSTREAM=stream
	TESTSRUN=0
	TESTSFAILED=0
	SKIPTESTS=0
	testWrite "#TAP testing "&name
	if vartype(num)=8 then
		testWrite "1..0 # Skipped: "&num
		NUMTESTS=0
	else
		testWrite "1.."&num
		NUMTESTS=num
	end if
end sub
public sub testWrite(s)
	TESTSTREAM.write s&chr(10)
end sub
public sub endTests
	if TESTSFAILED then testWrite "#Failed "&TESTSFAILED&" tests"
	if TESTSRUN<>NUMTESTS then
		testWrite "#Planned "&NUMTESTS&" tests, but ran "&TESTSRUN&" tests"
		TESTSFAILED=TESTSFAILED+1
	end if
	if TESTSFAILED>254 then WScript.quit 255
	WScript.quit TESTSFAILED
end sub
public sub bailOut(reason)
	testWrite "Bail out!  "&reason
	WScript.quit 255
end sub
public sub pass(s)
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
public sub fail(s)
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
public sub skip(why,n)
	if SKIPTESTS then diag "skip called during "&SKIPTYPE&", nesting unsupported"
	SKIPTESTS=n
	SKIPWHY=why
	SKIPTYPE="skip"
end sub
public sub todo(why,n)
	if SKIPTESTS then diag "todo called during "&SKIPTYPE&", nesting unsupported"
	SKIPTESTS=n
	SKIPWHY=why
	SKIPTYPE="TODO"
end sub
public sub diag(s)
	testWrite "#"&s
end sub
public sub ok(t,s)
if t then
	pass s
else
	fail s
end if
end sub
public sub iseq(a,b,s)
if a=b then
	pass s
else
	fail s&", got "&a
end if
end sub
public sub isnt(a,b,s)
if a=b then
	fail s&", got "&a
else
	pass s
end if
end sub
'like, unlike, is_deeply, can
end class