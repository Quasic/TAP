@echo off
cd %~dp0
call startTests "%~nx0" 3
call bailout test
call endTests
