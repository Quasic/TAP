@echo off
if errorlevel 1 goto fail
call pass %1
goto EOF
:fail
call fail "%1, code %errorlevel%"
:EOF