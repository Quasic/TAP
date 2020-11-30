@echo off
set TAPrun=0
set TAPfailed=0
set TAPskip=0
echo #TAP testing %1
if 1%2 EQU +1%2 goto num
echo 1..0 # Skipped: %2
set TAPnum=0
goto endif
:num
echo 1..%2
set TAPnum=%2
:endif
