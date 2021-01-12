set T=new TAP
T.startTests WScript.stdout,"TAPtestcasesVBSclass",4
T.pass "TAP dummy pass"
T.skip "TAP dummy",2
	T.pass "TAP dummy pass"
	T.fail "TAP dummy fail"
T.todo "TAP test",1
	T.fail "TAP dummy todo fail"
T.diag "TAP tests END"
T.endTests
