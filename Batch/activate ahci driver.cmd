@echo off
cls
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Msahci" /v "Start" /t "REG_DWORD" /d 0 /f
echo done!
pause
