@echo off
::-----------------------------
:: Inis:         Smiles.exe
:: SchulFilter:  difsvc.exe
set inis=Smiles.exe
set schulfilter=difsvc.exe
::-----------------------------

echo Soll ich das Schutz-System jetzt killen? [beliebige Taste]
echo (Schliesse die Konsole falls nicht!)
pause>nul
echo Pruefe Internetverbindung....
ping google.de 1>nul 2>nul || (echo Es ist noch kein Internet verfuegbar, trotzdem? [beliebige Taste] && pause>nul)
echo Kille Inis....
taskkill /im "%inis%" /f 1>nul 2>nul || goto error
for /f "skip=5 tokens=1" %%a in ('tasklist') do if "%%a"=="%inis%" (echo Konnte Inis nicht killen && goto error)
echo Kille SchulFilter....
taskkill /im "%schulfilter%" /f 1>nul 2>nul || goto error
for /f "skip=5 tokens=1" %%a in ('tasklist') do if "%%a"=="%schulfilter%" (echo Konnte SchulFilter nicht killen && goto error)
echo Der Weg ist jetzt frei :)
echo.
pause
goto eof

:error
echo.
echo Der Vorgang hat nicht sicher funktioniert....
echo Pruefe ob folgende Prozesse noch laufen:
echo -^> %inis%
echo -^> %schulfilter%
echo.
echo Druecke eine beliebige Taste um den Taskmanager zu oeffnen
pause>nul
start taskmgr

:eof