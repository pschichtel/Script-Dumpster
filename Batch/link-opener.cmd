@echo off
:start
cls
set /p file="Geben Sie den Dateipfad der Liste an: "
if not exist "%file%" (goto error)
set /p browser="Geben Sie den Dateipfad des Browsers an: "
if not exist "%browser%" (goto error)

echo.
echo Die Links:
type "%file%"
echo.
echo.
echo Diese werden mit folgendem Browser geîffnet:
echo %browser%
echo.
pause
cls

echo ôffne neues Browser-Fenster...
start "" "%browser%"
ping localhost -n 3 >nul 2>nul

echo ôffne nun die Links...
for /f %%a in ('type "%file%"') do "%browser%" "%%a"

echo Alle Links wurden geîffnet!
pause
goto eof

:error
echo.
echo Es ist ein Fehler aufgetreten, prÅfen Sie den eingebenen Pfad und versuchen Sie es erneut.
pause
goto start

:eof