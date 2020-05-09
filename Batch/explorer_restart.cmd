@echo off
cls
echo Killing explorer.exe ...
taskkill /im explorer.exe /f
echo done!
pause
echo Starting explorer.exe ...
start explorer
echo done!