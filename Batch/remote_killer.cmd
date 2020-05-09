@echo off

set /p domain="Gib die Domain ein: "
set /p pcID="Und jetzt die Zahl des PC's: "
set /p prozess="Zum Schluss noch den Prozess-Namen: "
set /p force="Soll das Beenden erzwungen werden?[0^|1]: "
set /p sub="Sollen alle Unterprozesse auch beendet werden?[0^|1]: "
if "%force%"=="1" (set force=/f) else (set force=)
if "%sub%"=="1" (set sub=/t) else (set sub=)
taskkill /S %domain% /im %prozess% /U %domain%\PC%pcID% %force% %sub% >nul
echo.
echo.
pause