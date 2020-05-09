@echo off
echo Adobe connection breaker v0.1 © by GamerSource
echo 15 activation domains will be blocked...
echo.
echo. 
echo ATTENTION: Run this Programm in the Admin Mode 
echo (Rightclick "Run as Admin" or "Als Administator ausfuehren") !!!
echo Without admin rights the programm cannot access the hosts-file in the Windows directory...
echo.
echo.
echo Click RETURN/Ok if the programm runs in the "Admin Mode"
pause >nul
echo 127.0.0.1 adobe.activate.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 activate.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 practivate.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 ereg.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 activate.wip3.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 wip3.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 3dns-3.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 3dns-2.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 adobe-dns.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 adobe-dns-2.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 adobe-dns-3.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 ereg.wip3.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 activate-sea.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 wwis-dubc1-vip60.adobe.com >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 activate-sjc0.adobe.com >> %windir%\System32\drivers\etc\hosts
echo.
echo.
echo Maybe your Antivir asks you to allow or deny the access to the file. Finished.
echo look at %windir%\System32\drivers\etc\ the file hosts and search a text in it like this
echo 127.0.0.1 adobe.activate.com
echo Finished...
pause >nul