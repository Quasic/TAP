@echo off
cd %~dp0/../TAP
call startTests "%~nx0" 21
call pass "TAP dummy pass"
call skip "TAP dummy" 2
	call pass "TAP dummy skip pass"
	call fail "TAP dummy skip fail"
call todo "TAP test" 10
	call fail fail
	call fail "TAP dummy todo fail"
	call is 5 6 isfail
	call is 5 6 "is fail with quotes"
	call isnt 5 5 isntfail
	call isnt 5 5 "isnt fail with quotes"
	false
	call wasok wasokfail
	false
	call wasok "wasok fail w/quotes"
	call pathexist dummy pathexistfail
	call pathexist dummy "pathexist fail w/quotes"
call is 5 5 ispass
call is 5 5 "is pass w/quotes"
call isnt 5 6 isntpass
call isnt 5 6 "isnt pass w/quotes"
true
call wasok wasokpass
true
call wasok "wasok pass w/quotes"
call pathexist . pathexistpass
call pathexist . "pathexist pass w/quotes"
call endTests
