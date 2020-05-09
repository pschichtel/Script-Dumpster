@echo off
cls
echo Welcome to Instant BSOD by Quick_Wango!
echo Press any key to dump your activ processes...
pause>nul
if exist processes.txt (del processes.txt /f >nul 2>nul)
for /f "skip=5 tokens=1" %%a in ('tasklist') do (echo %%a>>processes.txt)
echo Done!
echo.
echo Press any key to initiate the instant BSOD...
pause>nul
echo Just again to be sure...
pause>nul
if exist killed.txt (del killed.txt /f >nul 2>nul)
echo Bye bye!
echo 3
ping 127.0.0.1 -n 2 >nul 2>nul
echo 2
ping 127.0.0.1 -n 2 >nul 2>nul
echo 1
ping 127.0.0.1 -n 2 >nul 2>nul
echo BOOM
for /f "skip=5 tokens=1" %%a in ('tasklist') do (taskkill /im %%a /f >nul 2>nul && echo %%a>>killed.txt)
