@echo off
cd %~dp0
call startTests "%~nx0" "skip test test"
call endTests
