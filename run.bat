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
SET TOOL_EXE=%TOP%\tool.exe

SET VENDOR=%TOP%\vendor
SET PHP_CGI_SPAWNER=%VENDOR%\php-cgi-spawner.exe
SET RunHiddenConsole=%VENDOR%\RunHiddenConsole.exe
SET NGINX=%VENDOR%\nginx-1.21.6\

color ff 
TITLE PHP - ��ʱ�������

CLS 
ECHO.# by hunzsig
ECHO %~0

:MENU

ECHO.----------------------�����б�----------------------
tasklist|findstr /i "php-cgi-spawner.exe"
tasklist|findstr /i "php-cgi.exe"
tasklist|findstr /i "nginx.exe"
ECHO.----------------------------------------------------
ECHO.[1] ����/����
ECHO.[9] �ر�
ECHO.[0] �˳� 
ECHO.���������:
set /p ID=
IF "%id%"=="1" ( GOTO start ) ^
ELSE IF "%id%"=="9" ( GOTO stop ) ^
ELSE IF "%id%"=="0" ( EXIT ) ^
ELSE ( GOTO error )
PAUSE

:error
ECHO.Not support this opreation��
GOTO MENU

:start
%TOOL_EXE%
cd "%VENDOR%"
call :shutdown
call :startPHP
call :startNginx
GOTO MENU


:stop 
call :shutdown
GOTO MENU

:shutdown
taskkill /F /IM php-cgi-spawner.exe > nul
taskkill /F /IM php-cgi.exe > nul
taskkill /F /IM nginx.exe > nul
ECHO.[All][stoped]
goto :eof


:startPHP
start %VENDOR%php-cgi-spawner.exe php_56/php-cgi.exe 9056 4+16
start %VENDOR%php-cgi-spawner.exe php_70/php-cgi.exe 9070 4+16
start %VENDOR%php-cgi-spawner.exe php_71/php-cgi.exe 9071 4+16
start %VENDOR%php-cgi-spawner.exe php_72/php-cgi.exe 9072 4+16
start %VENDOR%php-cgi-spawner.exe php_73/php-cgi.exe 9073 4+16
start %VENDOR%php-cgi-spawner.exe php_74/php-cgi.exe 9074 4+16
start %VENDOR%php-cgi-spawner.exe php_80/php-cgi.exe 9080 4+16
start %VENDOR%php-cgi-spawner.exe php_81/php-cgi.exe 9081 4+16
ECHO.[Default][PHP][E]
goto :eof


:startNginx
IF NOT EXIST "%NGINX%nginx.exe" (
ECHO.[Dependent][Nginx][hasn't been decompressed yet]
goto :eof
)
%XDISK% 
cd "%NGINX%" 
start nginx.exe
ECHO.[Dependent][Nginx][E]
goto :eof