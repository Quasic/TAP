@echo off
if errorlevel 1 goto fail
call "%~dp0/pass" %1
goto EOF
:fail
call "%~dp0/fail" "%1, code %errorlevel%"
:EOF
