@echo off

::Hier der Pfad zum Kompiler hinter das = :
set gpp_dir=C:\Dev-Cpp\bin\g++.exe

set PATH=%PATH%;%gpp_dir%

if exist "log.txt" (del "log.txt")
for /f "delims=. tokens=1" %%a in ("%1") do set outputname=%%a
if exist "%1.exe" (del "%1.exe")
g++ -o "%outputname%.exe" "%1" 2>log.txt || start notepad "log.txt"
ping 127.0.0.1 -n 2 1>nul 2>nul
if exist "log.txt" (del "log.txt")
