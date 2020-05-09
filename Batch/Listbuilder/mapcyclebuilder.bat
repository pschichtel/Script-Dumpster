:: Copyright by Quick_Wango
@echo off
cls
if not exist "%~dp0*.bsp" (goto :nofiles)
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo ° Wenn du bereits eine mapcycle.txt/maplist.txt und/oder °
echo ° votemaplist.txt auf dem Desktop hast werden diese      °
echo ° gelöscht. Sicher diese vor dem start!                  °                       °
echo ° Bestätige wenn du bereit bist!                         °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
pause>nul
if exist "%userprofile%\Desktop\mapcycle.txt" (del "%userprofile%\Desktop\mapcycle.txt")
if exist "%userprofile%\Desktop\maplist.txt" (del "%userprofile%\Desktop\maplist.txt")
if exist "%userprofile%\Desktop\votemaplist.txt" (del "%userprofile%\Desktop\votemaplist.txt")
cls
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo ° Das Tool wird nun die mapcycle.txt auf deinen Desktop  °
echo ° schreiben!                                             °
echo ° Bestätige zum Starten!                                 °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
pause>nul
cls
for /f "eol=p skip=5 tokens=4" %%a in ('dir "%~dp0\*.bsp"') do echo %%a>>%userprofile%\Desktop\tmp-mapcycle.txt
for /f "skip=2" %%b in ('find /i ".bsp" "%userprofile%\Desktop\tmp-mapcycle.txt"') do echo %%b>>%userprofile%\Desktop\tmp2-mapcycle.txt
for /f " delims=. tokens=1" %%c in (%userprofile%\Desktop\tmp2-mapcycle.txt) do echo %%c>>%userprofile%\Desktop\mapcycle.txt
del %userprofile%\Desktop\tmp-mapcycle.txt && del %userprofile%\Desktop\tmp2-mapcycle.txt
:wrong1
cls
set /p answer="Willst du auch die maplist.txt schreiben?(y|n) - "
if "%answer%"=="y" (for /f "tokens=1" %%d in (%userprofile%\Desktop\mapcycle.txt) do echo %%d>>%userprofile%\Desktop\maplist.txt) else if "%answer%"=="n" (goto :wrong2) else if "%answer%"=="" (goto :wrong1) else goto :wrong1
:wrong2
set /p answer="Willst du auch die votemaplist.txt schreiben?(y|n) - "
if "%answer%"=="y" (for /f "tokens=1" %%d in (%userprofile%\Desktop\mapcycle.txt) do echo %%d>>%userprofile%\Desktop\votemaplist.txt) else if "%answer%"=="n" (goto :done) else if "%answer%"=="" (goto :wrong2) else goto :wrong2
goto :done
:nofiles
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo ° Du musst das Tool im Verzeinis der Maps starten!       °
echo ° Zum Beispiel in C:\HLServer\cstrike\maps               °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ping 127.0.0.1 -n 5 >nul
:done
cls
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo ° DONE!                                                  °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ping 127.0.0.1 -n 2 >nul
cls
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
echo ° Copyright by Quick_Wango                               °
echo ° Support: Quick.Wango@wmw.cc                            °
echo °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ping 127.0.0.1 -n 5 >nul
:: End of File