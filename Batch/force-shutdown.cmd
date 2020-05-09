@echo off
echo Starting Force-Shutdown ...
echo Killing ... explorer.exe and sub's
taskkill /im explorer.exe /f /t
echo Shutting down ...
shutdown /s /f /t 10 /c "Force shutdown will be executed in 10 seconds ..."
set /p quit="Cancel Shutdown? [yes^|no] - "
if "%quit%"=="yes" (shutdown /a)
exit