@echo off
if '%TAPfailed%'=='0' goto allpassed
echo #Failed %TAPfailed% tests
:allpassed
if '%TAPnum%'=='%TAPrun%' goto numright
echo #Planned %TAPnum% tests, but ran %TAPrun% tests
exit 255
:numright
if '%TAPfailed%'=='0' goto nofails
exit %TAPfailed%
:nofails