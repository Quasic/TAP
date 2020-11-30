@echo off
if '%1'=='%2' goto yup
call fail "%3, got %1"
goto EOF
:yup
call pass %3
:EOF
