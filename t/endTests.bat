@echo off
cd %~dp0/../TAP
call startTests "%~nx0" 10
call pass "TAP dummy pass"
call skip "TAP dummy" 2
call pass "TAP dummy skip pass"
call fail "TAP dummy skip fail"
call todo "TAP test" 4
call fail "TAP dummy todo fail"
call is 5 6 isfail
call isnt 5 5 isntfail
false
call wasok wasokfail
call is 5 5 ispass
call isnt 5 6 isntpass
true
call wasok wasokpass
call endTests
