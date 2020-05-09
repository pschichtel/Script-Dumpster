@echo off
title Firefoxkiller
taskkill /im firefox.exe /f 1>nul 2>nul
for /f "skip=5 tokens=1" %%a in ('tasklist') do if "%%a"=="firefox.exe" (echo Taskkill fehlgeschlagen! &&  pause>nul && exit)
echo Taskkill erfolgreich!
ping 127.0.0.1 -n 3 >nul
