@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

set /p addon=Which addon would you like to link? 
set "gamePath=C:\Games\World of Warcraft\"

IF NOT EXIST "%gamePath%" set "gamePath=D:\Games\World of Warcraft\"

:MakeLink
mklink /D "%gamePath%_classic_\Interface\AddOns\%addon%" "%CD%\%addon%"

set /p addon=Anything else? 
goto MakeLink
