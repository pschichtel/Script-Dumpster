@echo off
for /f %%a in ('dir /b *.wdseml') do (
    move "%%a" "%%~dpna.eml"
)