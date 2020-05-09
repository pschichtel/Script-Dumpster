@echo off
cls
set /p page="Gib die Domain ein, die gesperrt werden soll: "
ping %page% -n 1 >nul 2>nul || goto error
echo 127.0.0.1 %page% >> %windir%\System32\drivers\etc\hosts
cls
echo Erledigt!
pause
goto eof
:error
echo Die Domain ist nicht erreichbar.
pause
:eof
