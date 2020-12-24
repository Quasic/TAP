@echo off
call TAP\startTests "%~nx0" 3
call TAP\bailout test
call TAP\endTests
