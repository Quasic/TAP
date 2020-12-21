@echo off
if '%1'=='%2' goto f
call pass %3
goto EOF
:f
call fail "%3, got %1"
:EOF
