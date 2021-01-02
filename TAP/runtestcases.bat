@echo off
echo # runtestcases.bat 0.1a
:while
cd
if exist testcases.sh goto test
cd ..
if errorlevel goto notfound
goto while
:notfound
echo Reached root directory without finding testcases.sh.
pause
exit 1
:test
git-bash testcases.sh
