@echo off
set /A TAPrun=TAPrun+1
if '%TAPskip%'=='0' goto noskip
set /A TAPskip=TAPskip-1
if '%TAPskiptype%'=='TODO' goto todo
echo ok %TAPrun% - %1 # skip %TAPskipwhy%
goto EOF
:todo
echo not ok %TAPrun% - %1 # TODO %TAPskipwhy%
echo #   Failed (TODO) test %1
goto EOF
:noskip
echo not ok - %1
:EOF
