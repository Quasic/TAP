startTests WScript.stdout,"TAPtestcasesVBS",4
pass "TAP dummy pass"
skip "TAP dummy",2
	pass "TAP dummy pass"
	fail "TAP dummy fail"
todo "TAP test",1
	fail "TAP dummy todo fail"
diag "TAP tests END"
endTests
