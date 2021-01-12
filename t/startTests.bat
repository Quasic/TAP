@echo off
cd %~dp0\..\TAP
call startTests "%~nx0" "skip test test"
call endTests
