@echo off
:: BatchGotAdmin
:-------------------------------------
REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"


cls 

SET TOP=%cd%
SET DEP=%TOP%\dependent
SET PHPINI_EXE=%DEP%\dependent.exe

color ff 
TITLE PHP - iniÂ·¾¶ÐÞÕý

CLS 
ECHO.# by hunzsig
ECHO %~0

cd "%DEP%"
%PHPINI_EXE% 5.6
%PHPINI_EXE% 7.0
%PHPINI_EXE% 7.1
%PHPINI_EXE% 7.2
%PHPINI_EXE% 7.3
%PHPINI_EXE% 7.4
%PHPINI_EXE% 8.0
%PHPINI_EXE% 8.1

PAUSE