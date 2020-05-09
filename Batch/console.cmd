@echo off
cls
set title=Code Infection CMD Wrapper
title %title%
ver
echo Copyright (c) 2009 Microsoft Corporation. Alle Rechte vorbehalten.
echo.
:enter
set /p com="%cd%>"
%com%
title %title% - Last: %com%
goto enter
:eof