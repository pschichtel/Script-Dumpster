@echo off
:loop
cls
netstat /p tcp /a /n /b
echo.
echo Push any key!
pause>nul
goto loop