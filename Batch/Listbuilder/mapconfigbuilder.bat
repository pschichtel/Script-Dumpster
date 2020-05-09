@echo off

set /p config="Gib hier die Config an: "

set /p prefix="Und hier das Mapprefix: "

md "%userprofile%\Desktop\mapconfigs" 1>nul 2>nul

cd "%userprofile%\Desktop\mapconfigs" 1>nul 2>nul

for /f "skip=2" %%a in ('find "%prefix%_" "%userprofile%\Desktop\maplist.txt"') do (echo exec "%config%.cfg">%%a.cfg)
