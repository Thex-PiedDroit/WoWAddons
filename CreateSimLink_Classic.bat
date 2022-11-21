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

:MakeLink
set /p addon=Which addon would you like to link? 
set "addonPath=%CD%\..\WoW\%addon%"

IF NOT EXIST "%addonPath%" (
	echo The addon doesn't exist.
	goto MakeLink
)

set "linkPath=%gamePath%_classic_\Interface\AddOns\%addon%"

IF NOT EXIST "%linkPath%" (
	mklink /D "%linkPath%" "%addonPath%"
) ELSE echo A link for this addon already exists.

goto MakeLink
