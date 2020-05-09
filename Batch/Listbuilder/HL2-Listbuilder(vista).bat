REM  QBFC Project Options Begin
REM  HasVersionInfo: Yes
REM  Companyname: Quicl_Wango -=BatchCoding=-
REM  Productname: HL2-Listbuilder
REM  Filedescription: Das Tool dient zur Erstellung der für HL²-Gameserver benötigten Map- und Soundlisten.
REM  Copyrights: Copyright © 2008-2009 by Quick_Wango
REM  Trademarks: 
REM  Originalname: 
REM  Comments: Die Nutzung dieses Tools ist nur server-crew.com-Kunden gestattet.
REM  Productversion:  1. 0. 1. 0
REM  Fileversion:  1. 0. 1. 0
REM  Internalname: 
REM  Appicon: E:\Skripte und Texte\Icons\liste3.ico
REM  Embeddedfile: E:\Skripte und Texte\Skripte und Texte\readme.txt
REM  QBFC Project Options End

@echo off
cls
title HL2-Listbuilder - OS-Check
:://"readme.txt"
::checking OS
for /f "delims=.[ tokens=2" %%a in ('ver') do set osversion=%%a
if "%osversion%"=="Version 5" (echo Ihr Betriebssystem ist: Windows XP) else if "%osversion%"=="Version 6" (echo Ihr Betriebssystem ist: Windows Vista && goto :start) else (echo Ihr Windows-Version wurde nicht erkannt.)
echo Da ihr Betriebssystem nicht Windows Vista ist,kann es zu Problemen kommen.
echo.
echo Sie können diese Version nicht mit Ihrem aktuellem Betriebssystem verwenden!
echo Eventuell ist eine Version fuer Ihr System verfuegbar.
echo.
echo Bestaetigen Sie mit iner beliebigen Taste um das Programm zu beenden.
pause >nul
exit

::end of checking OS
:start
::prepering for FTP
set ftpip=%1
set ftpuser=%2
set ftppass=%3
set ftpdir=%4
set sounddir=%5
if exist "%userprofile%\ftpcoms-maps.txt" (del "%userprofile%\ftpcoms-maps.txt" 1>nul 2>nul)
if exist "%userprofile%\ftpcoms-sounds.txt" (del "%userprofile%\ftpcoms-sounds.txt" 1>nul 2>nul)
if exist "%userprofile%\tmp-list.txt" (del "%userprofile%\tmp-list.txt" 1>nul 2>nul)
if exist "%userprofile%\tmp-mp3-list.txt" (del "%userprofile%\tmp-mp3-list.txt" 1>nul 2>nul)
if exist "%userprofile%\tmp-wav-list.txt" (del "%userprofile%\tmp-wav-list.txt" 1>nul 2>nul)


::FTP-Daten
title HL2-Listbuilder - FTP-Daten
if not "%ftpip%"=="" (goto :ok-ip)
set /p ftpip="Gib hier die IP deines Gameservers an: "
:ok-ip
ping %ftpip% 1>nul 2>nul || goto :error
:ftpdata
cls
if not "%ftpuser%"=="" (goto :ok-user)
set /p ftpuser="Gib hier deinen FTP-Benutzernamen ein: "
:ok-user
if not "%ftppass%"=="" (goto :ok-pass)
set /p ftppass="Gib hier dein FTP-Password ein: "
:ok-pass
if not "%ftpdir%"=="" (goto :mainmenu)
echo Gib hier das Grundverzeichnis deines Servers an
set /p ftpdir="wie zum Beispiel srcds oder hlds_1 an: "
echo.
echo Ueberpruefe deine Eingaben noch einmal!
echo Korrekt? [J^|N]
"choice" /c jn >nul
if "%errorlevel%"=="1" (echo OK) else if "%errorlevel%"=="2" (goto :ftpdata)
ping 127.0.0.1 -n 3 1>nul 2>nul
::end of prepering for FTP


:mainmenu
cls
if exist "%userprofile%\temp-maplist.txt" (del "%userprofile%\temp-maplist.txt" 1>nul 2>nul)
if exist "%userprofile%\temp-maplist-f.txt" (del "%userprofile%\temp-maplist-f.txt" 1>nul 2>nul)
cls
:: mainmenu
title HL2-Listbuilder - Hauptmenue
color 0f
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo °                               ^*^*Hauptmenue^*^*                                °
echo °                                                                             °
echo ° WillKommen im HL2-Listbuilder!                                              °
echo ° Waehle aus den folgenden Punkten was du tun moechtest:                      °
echo °                                                                             °
echo ° --^>Bestehende Listen im Zielverzeichnis (Desktop) loeschen... [1]           °
echo °    (Noetig um neue Listen zu erstellen!)                                    °
echo °                                                                             °
echo ° --^>Liste(n) erstellen... [2]                                                °
echo °                                                                             °
echo ° --^>FTP-Daten neu eingeben... [3]                                            °
echo °                                                                             °
echo ° --^>Support... [4]                                                           °
echo °                                                                             °
echo ° --^>Beenden... [5]                                                           °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
:: end mainmenu
"choice" /c 12345 >nul
if "%errorlevel%"=="1" (goto :delmenu) else if "%errorlevel%"=="2" (goto :listmenu) else if "%errorlevel%"=="3" (goto :re-ftpdata) else if "%errorlevel%"=="4" (goto :support) else if "%errorlevel%"=="5" (del "%userprofile%\temp-list.txt" 1>nul 2>nul & exit)


:delmenu
:: deleting
title HL2-Listbuilder - Loeschmenue
cls
color 0f
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo °                              ^*^*Loeschmenue^*^*                                °
echo °                                                                             °
echo ° Waehle aus den folgenden Punkten was du tun moechtest:                      °
echo °                                                                             °
echo °                                                                             °
echo ° --^>NUR die mapcycle.txt loeschen... [1]                                     °
echo °                                                                             °
echo ° --^>NUR die maplist.txt loeschen... [2]                                      °
echo °                                                                             °
echo ° --^>NUR die votemaplist.txt loeschen... [3]                                  °
echo °                                                                             °
echo ° --^>ALLE existierenden Maplisten loeschen... [4]                             °
echo °                                                                             °
echo ° --^>Die Soundlisten loeschen... [5]                                          °
echo °                                                                             °
echo ° --^>zurueck zum Hauptmenue... [6]                                            °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
"choice" /c 123456 >nul
if %errorlevel%==1 (goto :delchoice1) else if %errorlevel%==2 (goto :delchoice2) else if %errorlevel%==5 (goto :delchoice5) else if %errorlevel%==6 (goto :mainmenu)
if exist "%userprofile%\Desktop\votemaplist.txt" (del "%userprofile%\Desktop\votemaplist.txt" 1>nul 2>nul)
if %errorlevel%==3 (goto :done)
:delchoice2
if exist "%userprofile%\Desktop\maplist.txt" (del "%userprofile%\Desktop\maplist.txt" 1>nul 2>nul)
if %errorlevel%==2 (goto :done)
:delchoice1
if exist "%userprofile%\Desktop\mapcycle.txt" (del "%userprofile%\Desktop\mapcycle.txt" 1>nul 2>nul)
goto :done
:delchoice5
if exist "%userprofile%\Desktop\soundlist.txt" (del "%userprofile%\Desktop\soundlist.txt" 1>nul 2>nul)
if exist "%userprofile%\Desktop\commandlist.txt" (del "%userprofile%\Desktop\commandlist.txt" 1>nul 2>nul)
goto :done
:: end deleting


:listmenu
title HL2-Listbuilder - Listenmenue
:: writing lists
cls
color 0f
set answer=
echo Willst du Maplisten [1] oder Soundlisten [2] erstellen?
"choice" /c 12 >nul
if %errorlevel%==1 (goto :maplists) else if %errorlevel%==2 (goto :soundlists)
:maplists
cls
title HL²-Listbuilder - Listenmenü - Maps
if exist "%userprofile%\ftpcoms-maps.txt" (del "%userprofile%\ftpcoms-maps.txt" 1>nul 2>nul)
echo %ftpuser%>>"%userprofile%\ftpcoms-maps.txt"
echo %ftppass%>>"%userprofile%\ftpcoms-maps.txt"
echo cd %ftpdir%/cstrike/maps>>"%userprofile%\ftpcoms-maps.txt"
echo dir ^*.bsp>>"%userprofile%\ftpcoms-maps.txt"
echo quit>>"%userprofile%\ftpcoms-maps.txt"
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo °                          ^*^*Maplistenmenue^*^*                                 °
echo °                                                                             °
echo ° Waehle aus den folgenden Punkten was du tun moechtest:                      °
echo °                                                                             °
echo °                                                                             °
echo ° --^>NUR die mapcycle.txt erstellen... [1]                                    °
echo °                                                                             °
echo ° --^>NUR die maplist.txt erstellen... [2]                                     °
echo °                                                                             °
echo ° --^>NUR die votemaplist.txt erstellen... [3]                                 °
echo °                                                                             °
echo ° --^>ALLE Listen erstellen... [4]                                             °
echo °                                                                             °
echo ° --^>NUR zB "gg_"-map in die Liste eintragen... [5]                           °
echo °                                                                             °
echo ° --^>zurueck zum Hauptmenue... [6]                                            °
echo °                                                                             °
echo ° Die Listen werden auf dem Desktop erstellt!                                 °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
"choice" /c 123456 >nul
for /f "skip=17 tokens=9" %%a in ('ftp -s:"%userprofile%\ftpcoms-maps.txt" %ftpip%') do echo %%a>>"%userprofile%\temp-maplist.txt"
if %errorlevel%==1 (goto :lischoice1) else if %errorlevel%==2 (goto :lischoice2) else if %errorlevel%==3 (goto :lischoice3) else if %errorlevel%==5 (goto :filteredlist) else if %errorlevel%==6 (goto :mainmenu)
if exist "%userprofile%\Desktop\mapcycle.txt" (goto :error)
if exist "%userprofile%\Desktop\maplist.txt" (goto :error)
if exist "%userprofile%\Desktop\votemaplist.txt" (goto :error)
for /f "skip=2 delims=.^  tokens=1" %%b in ('find /i ".bsp" "%userprofile%\temp-maplist.txt"') do echo %%b>>"%userprofile%\Desktop\mapcycle.txt"
for /f "skip=2 delims=.^  tokens=1" %%b in ('find /i ".bsp" "%userprofile%\temp-maplist.txt"') do echo %%b>>"%userprofile%\Desktop\maplist.txt"
for /f "skip=2 delims=.^  tokens=1" %%b in ('find /i ".bsp" "%userprofile%\temp-maplist.txt"') do echo %%b>>"%userprofile%\Desktop\votemaplist.txt"
(del "%userprofile%\temp-maplist.txt" 1>nul 2>nul)
goto :done
:lischoice1
if exist "%userprofile%\Desktop\mapcycle.txt" (goto :error)
for /f "skip=2 delims=.^  tokens=1" %%b in ('find /i ".bsp" "%userprofile%\temp-maplist.txt"') do echo %%b>>"%userprofile%\Desktop\mapcycle.txt"
(del "%userprofile%\temp-maplist.txt" 1>nul 2>nul)
goto :done
:lischoice2
if exist "%userprofile%\Desktop\maplist.txt" (goto :error)
for /f "skip=2 delims=.^  tokens=1" %%b in ('find /i ".bsp" "%userprofile%\temp-maplist.txt"') do echo %%b>>"%userprofile%\Desktop\maplist.txt"
(del "%userprofile%\temp-maplist.txt" 1>nul 2>nul)
goto :done
:lischoice3
if exist "%userprofile%\Desktop\votemaplist.txt" (goto :error)
for /f "skip=2 delims=.^  tokens=1" %%b in ('find /i ".bsp" "%userprofile%\temp-maplist.txt"') do echo %%b>>"%userprofile%\Desktop\votemaplist.txt"
(del "%userprofile%\temp-maplist.txt" 1>nul 2>nul)
goto :done


:filteredlist
title HL2-Listbuilder - Listenmenue + Filter
cls
color 0f
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo °                            ^*^*Filtermenue^*^*                                  °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo ° Hier kannst du das Prefix (=Vorsilbe) eingeben.                             °
echo ° Beispiele waeren:                                                           °
echo °                                                                             °
echo ° --^>"gg_" fuer GunGame-maps                                                  °
echo °                                                                             °
echo ° --^>"de_" fuer Demolition-maps                                               °
echo °                                                                             °
echo ° --^>"zm_" fuer Zombi-maps                                                    °
echo °                                                                             °
echo ° --^>"surf_" fuer Surf-maps                                                   °
echo °                                                                             °
echo ° Gib das Prefix ohne Anfuehrungszeichen ein, da es sonst nicht               °
echo ° funktioniert!                                                               °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
set /p filter="Gib hier das Prefix ein: - "

:listmenufiltered
title HL2-Listbuilder - Listenmenue + Filter
cls
color 0f
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo °                     ^*^*Listenmenue - Gefiltert^*^*                             °
echo °                                                                             °
echo ° Waehle aus den folgenden Punkten was du tun moechtest:                      °
echo °                                                                             °
echo °                                                                             °
echo ° --^>NUR die mapcycle.txt erstellen... [1]                                    °
echo °                                                                             °
echo ° --^>NUR die maplist.txt erstellen... [2]                                     °
echo °                                                                             °
echo ° --^>NUR die votemaplist.txt erstellen... [3]                                 °
echo °                                                                             °
echo ° --^>ALLE Listen erstellen... [4]                                             °
echo °                                                                             °
echo ° --^>zurueck zum Hauptmenue... [5]                                            °
echo °                                                                             °
echo ° Die Listen werden auf dem Desktop erstellt!                                 °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
"choice" /c 12345 >nul
for /f "skip=2" %%c in ('find /i "%filter%" "%userprofile%\temp-maplist.txt"') do echo %%c>>"%userprofile%\temp-maplist-f.txt"
if %errorlevel%==5 (goto :mainmenu) else if %errorlevel%==3 (goto :lmfchoice3) else if %errorlevel%==2 (goto :lmfchoice2) else if %errorlevel%==1 (goto :lmfchoice1)
if exist "%userprofile%\Desktop\mapcycle.txt" (goto :error)
if exist "%userprofile%\Desktop\maplist.txt" (goto :error)
if exist "%userprofile%\Desktop\votemaplist.txt" (goto :error)
for /f "skip=2 delims=.^  tokens=1" %%d in ('find /i ".bsp" "%userprofile%\temp-maplist-f.txt"') do echo %%d>>"%userprofile%\Desktop\mapcycle.txt"
for /f "skip=2 delims=.^  tokens=1" %%d in ('find /i ".bsp" "%userprofile%\temp-maplist-f.txt"') do echo %%d>>"%userprofile%\Desktop\maplist.txt"
for /f "skip=2 delims=.^  tokens=1" %%d in ('find /i ".bsp" "%userprofile%\temp-maplist-f.txt"') do echo %%d>>"%userprofile%\Desktop\votemaplist.txt"
(del "%userprofile%\temp-maplist1.txt" 1>nul 2>nul) & (del "%userprofile%\temp-maplist-f.txt" 1>nul 2>nul)
goto :done
:lmfchoice1
if exist "%userprofile%\Desktop\mapcycle.txt" (goto :error)
for /f "skip=2 delims=.^  tokens=1" %%d in ('find /i ".bsp" "%userprofile%\temp-maplist-f.txt"') do echo %%d>>"%userprofile%\Desktop\mapcycle.txt"
(del "%userprofile%\temp-maplist.txt" 1>nul 2>nul) & (del "%userprofile%\temp-maplist-f.txt" 1>nul 2>nul)
goto :done
:lmfchoice2
if exist "%userprofile%\Desktop\maplist.txt" (goto :error)
for /f "skip=2 delims=.^  tokens=1" %%d in ('find /i ".bsp" "%userprofile%\temp-maplist-f.txt"') do echo %%d>>"%userprofile%\Desktop\maplist.txt"
(del "%userprofile%\temp-maplist.txt" 1>nul 2>nul) & (del "%userprofile%\temp-maplist-f.txt" 1>nul 2>nul)
goto :done
:lmfchoice3
if exist "%userprofile%\Desktop\votemaplist.txt" (goto :error)
for /f "skip=2 delims=.^  tokens=1" %%d in ('find /i ".bsp" "%userprofile%\temp-maplist-f.txt"') do echo %%d>>"%userprofile%\Desktop\votemaplist.txt"
(del "%userprofile%\temp-maplist.txt" 1>nul 2>nul) & (del "%userprofile%\temp-maplist-f.txt" 1>nul 2>nul)
goto :done


:soundlists
title HL2-Listbuilder - Listenmenue - Sounds
cls
color 0f
if exist "%userprofile%\Desktop\soundlist.txt" (goto :error)
if exist "%userprofile%\Desktop\commandlist.txt" (goto :error)
if not "%sounddir%"=="" (goto :ok-dir)
set /p sounddir="Gib den Pfad deiner MP3s/WAVs im Soundsordner an (Bsp: admin_plugin/say_sounds):
:ok-dir
if exist "%userprofile%\ftpcoms-sounds.txt" (del "%userprofile%\ftpcoms-sounds.txt" 1>nul 2>nul)
echo %ftpuser%>>"%userprofile%\ftpcoms-sounds.txt"
echo %ftppass%>>"%userprofile%\ftpcoms-sounds.txt"
echo cd %ftpdir%/cstrike/sounds/%sounddir%>>"%userprofile%\ftpcoms-sounds.txt"
echo dir ^*.mp3>>"%userprofile%\ftpcoms-sounds.txt"
echo dir ^*.wav>>"%userprofile%\ftpcoms-sounds.txt"
echo quit>>"%userprofile%\ftpcoms-sounds.txt"
:soundlistmenu
cls
color 0f
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo °                        ^*^*Soundlistenmenue^*^*                                 °
echo °                                                                             °
echo ° Waehle aus den folgenden Punkten was du tun moechtest:                      °
echo °                                                                             °
echo °                                                                             °
echo ° --^>NUR die Soundlisten (soundlist.txt + commandlist.txt) erstellen... [1]   °
echo °                                                                             °
echo ° --^>zurueck zum Hauptmenue... [2]                                            °
echo °                                                                             °
echo ° ---^>Als Befehl zum Abspielen der Sounds wird deren Dateinamen verwendet!    °
echo °                                                                             °
echo ° ---^>Falls du bereits Befehle in deiner commandlist.txt hast, die nichts     °
echo °     mit sounds zu tun haben, oder sounds aus anderen verzeichnissen,        °
echo °     empfehle ich den inhalt der erstellten liste zu kopieren un  d in       °
echo °     deine alte liste einzufuegen.                                           °
echo °                                                                             °
echo ° ---^>Als say-Befehl werden die Dateinamen der Sounds benutzt.                °
echo °                                                                             °
echo ° Die Listen werden auf dem Desktop erstellt!                                 °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
"choice" /c 12 >nul
if %errorlevel%==1 (goto :sounds) else if %errorlevel%==2 (goto :mainmenu)
:sounds
for /f "tokens=9" %%a in ('ftp -s:"%userprofile%\ftpcoms-sounds.txt" %ftpip%') do echo %%a>>"%userprofile%\tmp-list.txt"
for /f "skip=2" %%b in ('find /i ".mp3" "%userprofile%\tmp-list.txt"') do echo %%b>>"%userprofile%\tmp-mp3-list.txt"
for /f "skip=2" %%c in ('find /i ".wav" "%userprofile%\tmp-list.txt"') do echo %%c>>"%userprofile%\tmp-wav-list.txt"
for /f "skip=2 delims=. tokens=1" %%d in ('find /i ".mp3" "%userprofile%\tmp-mp3-list.txt"') do echo "%%d" %sounddir%/%%d.mp3>>"%userprofile%\Desktop\soundlist.txt"
for /f "skip=2 delims=. tokens=1" %%e in ('find /i ".wav" "%userprofile%\tmp-wav-list.txt"') do echo "%%e" %sounddir%/%%e.wav>>"%userprofile%\Desktop\soundlist.txt"
for /f "skip=2 delims=. tokens=1" %%f in ('find /i ".mp3" "%userprofile%\tmp-mp3-list.txt"') do echo "%%f" C ma_play %%f>>"%userprofile%\Desktop\commandlist.txt"
for /f "skip=2 delims=. tokens=1" %%g in ('find /i ".wav" "%userprofile%\tmp-wav-list.txt"') do echo "%%g" C ma_play %%g>>"%userprofile%\Desktop\commandlist.txt"
del %userprofile%\tmp-list.txt" 1>nul 2>nul
del "%userprofile%\tmp-mp3-list.txt" 1>nul 2>nul
del "%userprofile%\tmp-wav-list.txt" 1>nul 2>nul
goto :done
:: end writing lists


:support
title HL2-Listbuilder - Support
:: support
cls
color 0f
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo °                            ^*^*Support^*^*                                      °
echo °                                                                             °
echo °                                                                             °
echo °   Copyright (C) 2008 by Quick_Wango                                         °
echo °                                                                             °
echo ° --^>Email: quick.wango@wmw.cc                                                °
echo °                                                                             °
echo ° --^>ICQ: 362816561                                                           °
echo °                                                                             °
echo ° --^>Skype: Quick_Wango                                                       °
echo °                                                                             °
echo ° --^>MSN: quick_wango@hotmail.de                                              °
echo °                                                                             °
echo °                                                                             °
echo ° Bestaetige mit einer beliebigen Taste um zurueckzukehren.                   °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
pause>nul
goto :mainmenu


:done
title HL2-Listbuilder - Fertig
:: done
if exist "%userprofile%\ftpcoms-maps.txt" (del "%userprofile%\ftpcoms-maps.txt")
if exist "%userprofile%\ftpcoms-sounds.txt" (del "%userprofile%\ftpcoms-sounds.txt")
if exist "%userprofile%\tmp-list.txt" (del "%userprofile%\tmp-list.txt")
cls
color 0a
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo °                            ^*^*FERTIG!!^*^*                                     °
echo °                                                                             °
echo ° Der Auftrag wurde erfolgreich ausgefuehrt!                                  °
echo °                                                                             °
echo °                                                                             °
echo ° --^> doch Probleme?? - Geh auf den Punkt "Support" fuer Hilfe                °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo ° In 3 Sekunden wird wieder das Hauptmenue angezeigt!                         °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ping 127.0.0.1 -n 3 1>nul 2>nul
goto :mainmenu


:error
title HL2-Listbuilder - Listenmenue - Fehler
cls
if exist "%userprofile%\temp-maplist.txt" (del "%userprofile%\Desktop\temp-maplist.txt" 1>nul 2>nul)
if exist "%userprofile%\temp-maplist-f.txt" (del "%userprofile%\Desktop\temp-maplist-f.txt" 1>nul 2>nul)
cls
color 0c
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo °                              ^*^*ERROR^*^*                                      °
echo °                                                                             °
echo °   Es gibt in der Regel nur 2 Gruende fuer einen Fehler:                     °
echo °                                                                             °
echo °                                                                             °
echo ° --^>1. Die von dir angegebene IP ist nicht erreichbar.                       °
echo °                                                                             °
echo ° --^>2. Es existiert bereits eine oder mehrere der Listen auf deinem          °
echo °       Desktop.                                                              °
echo ° ---^>Beide Probleme sollten ohne weiteres loesbar sein.                      °
echo °                                                                             °
echo ° ----^>Falls ein anderes Problem auftritt bitte ich um Kontaktaufnahme        °
echo °       ueber eins der im Punkt "Support" genannten Mittel                    °
echo °                                                                             °
echo ° Bestaetige mit einer beliebigen Taste um zurueckzukehren.                   °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °                                                                             °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
pause>nul
goto :mainmenu


:re-ftpdata
color 0f
cls
echo Aktuelle IP: "%ftpip%".
set /p ftpip="Gib jetzt die neue IP ein! --> "
echo.
echo Aktueller User: "%ftpuser%".
set /p ftpuser="Gib jetzt den neuen User ein!--> "
echo.
echo Akktuelles Passwort: "%ftppass%".
set /p ftppass="Gib jetzt das neue Passwort ein! --> "
echo.
echo Akktuelles Maps-Verzeizeichnis: "%ftpdir%".
set /p ftpdir="Gib jetzt das neue maps-Verzeichnis ein! --> "
echo.
echo Akktuelles Sounds-Verzeinis: "%soundsdir%".
set /p soundsdir="Gib jetzt das neue Sounds-Verzeichis ein!         -->"
echo.
echo Ueberpruefe deine Eingaben noch einmal!Korrekt? [J^|N]
"choice" /c jn >nul
if "%errorlevel%"=="1" (echo Erledigt!) else if "%errorlevel%"=="2" (goto :re-ftpdata)
ping 127.0.0.1 -n 3 1>nul 2>nul
goto :mainmenu


::End of File (won't be reached xD)

::Dieses Tool ist dazu gedacht, die für HL²-Server benötigten, "Maplisten"
::und "Soundlisten" zu erstellen. Es ist nicht gestattet das Programm unter
::einem anderen Namen zu vertreiben!