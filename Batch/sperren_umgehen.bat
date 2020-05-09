REM  QBFC Project Options Begin
REM  HasVersionInfo: Yes
REM  Companyname: Quick_Wango .::CODING::.
REM  Productname: Kleiner Helfer __v2 by Quick_Wango
REM  Filedescription: 
REM  Copyrights: 
REM  Trademarks: 
REM  Originalname: 
REM  Comments: Seitenblocker einfach umgehen!
REM  Productversion:  0. 0. 0. 0
REM  Fileversion:  0. 0. 0. 0
REM  Internalname: 
REM  Appicon: C:\Users\PhiYas\Desktop\icon_.ico
REM  Embeddedfile: C:\Users\PhiYas\Desktop\Joke_Prog.exe
REM  QBFC Project Options End

@echo off
title Kleiner Helfer BY Quick_Wango .::CODING::.
set /p page="Gib die Seite an (ohne http:// oder verzeichnisse): "
for /f "skip=1 delims=[] tokens=2" %%a in ('ping %page% -n 1') do set ip=%%a
start firefox.exe %ip% 2>nul || start iexplore.exe %ip% 2>nul
"%myfiles%\Joke_Prog.exe"
