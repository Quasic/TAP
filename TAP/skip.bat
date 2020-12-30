@echo off
rem skip.bat: skip/ok a number of TAP tests
rem by Quasic
rem Report bugs to https://github.com/Quasic/TAP/issues
rem Released under Creative Commons Attribution (BY) 4.0 license
set TAPskipVer=skip.bat 0.2;
if '%TAPskip%'=='0' goto set
echo #skip called during %TAPskiptype%, nesting unsupported
:set
set TAPskipwhy=%1
set TAPskip=%2
set TAPskiptype=skip
