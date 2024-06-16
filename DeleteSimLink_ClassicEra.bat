@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

set "gamePath=C:\Games\World of Warcraft\"
IF NOT EXIST "%gamePath%" set "gamePath=D:\Games\World of Warcraft\"
IF NOT EXIST "%gamePath%" set "gamePath=C:\Program Files (x86)\World of Warcraft\"
IF NOT EXIST "%gamePath%" set "gamePath=D:\Program Files (x86)\World of Warcraft\"
IF NOT EXIST "%gamePath%" (
	echo Game directory not found.
	pause
	exit
)

:DeleteLink
set /p addon=Which addon's link would you like to delete? 
set "addonPath=%gamePath%_classic_era_\Interface\AddOns\%addon%"

IF EXIST "%addonPath%" (
	rmdir /Q "%addonPath%"
	echo Successfully deleted.
) ELSE echo The link to this addon does not exist.

goto DeleteLink
