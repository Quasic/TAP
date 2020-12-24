@echo off
if '%1'=='%2' goto yup
call "%~dp0/fail" "%3, got %1"
goto EOF
:yup
call "%~dp0/pass" %3
:EOF
