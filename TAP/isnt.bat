@echo off
if '%1'=='%2' goto f
call "%~dp0/pass" %3
goto EOF
:f
call "%~dp0/fail" "%3, got %1"
:EOF
