DEFINT A-Z
dim shared testsrun%
PRINT "#TAP testing testcasesTAP.bas"
TAPnum% = 1
PRINT "1.."; LTRIM$(STR$(TAPnum%))
pass "TAP dummy pass"
IF TAPnum% <> testsrun% THEN PRINT "#Planned"; STR$(TAPnum%); " tests, but ran"; STR$(testsrun%); " tests"
system

SUB pass (name$)
testsrun%=testsrun%+1
?"ok - "name$
END SUB

