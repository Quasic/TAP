@echo off
rem todo.bat: mark TAP tests that need fixing
rem by Quasic
rem Report bugs to https://github.com/Quasic/TAP/issues
rem Released under Creative Commons Attribution (BY) 4.0 license
set TAPtodoVer=todo.bat 0.1;
if '%TAPskip%'=='0' goto set
echo #todo called during %TAPskiptype%, nesting unsupported
:set
set TAPskipwhy=%1
set TAPskip=%2
set TAPskiptype=TODO
