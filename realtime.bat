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

SET RunHiddenConsole=%DEP%\RunHiddenConsole
SET NGINX_DIR=%DEP%\nginx-1.15.10\
SET REDIS_DIR=%DEP%\Redis-x64-3.2.100\
SET RABBITMQ_DIR=%DEP%\rabbitmq_server-3.7.15\sbin\
SET ELASTICSEARCH_DIR=%DEP%\elasticsearch-7.0.1\bin\
SET KIBANA_DIR=%DEP%\kibana-7.0.1\bin\
SET APM_DIR=%DEP%\apm-server-7.0.1\
SET PHPINI_EXE=%DEP%\dependent.exe

color ff 
TITLE PHP - 临时控制面板

CLS 
ECHO.# by hunzsig
ECHO %~0

:MENU

ECHO.----------------------进程列表----------------------
tasklist|findstr /i "httpd.exe"
tasklist|findstr /i "nginx.exe"
tasklist|findstr /i "redis-server.exe"
tasklist|findstr /i "erl.exe"
tasklist|findstr /i "java.exe"
tasklist|findstr /i "node.exe"
tasklist|findstr /i "apm-server.exe"
ECHO.----------------------------------------------------
ECHO.[1] 启动/重启
ECHO.[9] 关闭
ECHO.[0] 退出 
ECHO.输入操作号:
set /p ID=
IF "%id%"=="1" ( GOTO start ) ^
ELSE IF "%id%"=="9" ( GOTO stop ) ^
ELSE IF "%id%"=="0" ( EXIT ) ^
ELSE ( GOTO error )
PAUSE

:error
ECHO.Not support this opreation！
GOTO MENU

:start
ECHO.输入PHP版本号(5.6-7.3 or latest):
set /p VERSION=
cd "%DEP%"
%PHPINI_EXE% %version%
SET APACHE_DIR=%TOP%\php_%version%\bin\
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO.Not support this php version！
GOTO MENU
)
call :shutdown
call :startApache
call :startNginx
call :startRedis
call :startRabbitmq
call :startElasticsearch
call :startKibana
call :startApm
GOTO MENU


:stop 
call :shutdown
GOTO MENU

:shutdown
taskkill /F /IM httpd.exe > nul
taskkill /F /IM nginx.exe > nul
taskkill /F /IM redis-server.exe > nul
taskkill /F /IM apm-server.exe > nul
set n=0
for /f "tokens=5" %%i in ('netstat -aon ^| findstr ":5601"') do (
    set n=%%i
)
if %n% gtr 0 (
taskkill /F /PID %n%
)
set n=0
for /f "tokens=5" %%i in ('netstat -aon ^| findstr ":5672"') do (
    set n=%%i
)
if %n% gtr 0 (
taskkill /F /PID %n%
)
set n=0
for /f "tokens=5" %%i in ('netstat -aon ^| findstr ":9200"') do (
    set n=%%i
)
if %n% gtr 0 (
taskkill /F /PID %n%
)
ECHO.[All][stoped]
goto :eof


:startApache
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO.[Default][Apache][not exist]
goto :eof
)
%XDISK% 
cd "%APACHE_DIR%" 
%RunHiddenConsole% httpd.exe
ECHO.[Default][PHP][OK]
ECHO.[Default][Apache][OK]
goto :eof


:startNginx
IF NOT EXIST "%NGINX_DIR%nginx.exe" (
ECHO.[Dependent][Nginx][hasn't been decompressed yet]
goto :eof
)
%XDISK% 
cd "%NGINX_DIR%" 
start nginx.exe
ECHO.[Dependent][Nginx][OK]
goto :eof


:startRedis
IF NOT EXIST "%REDIS_DIR%redis-server.exe" (
ECHO.[Dependent][Redis][hasn't been decompressed yet]
goto :eof
)
%XDISK% 
cd "%REDIS_DIR%" 
%RunHiddenConsole% redis-server.exe
ECHO.[Dependent][Redis][OK]
goto :eof


:startElasticsearch
IF NOT EXIST "%ELASTICSEARCH_DIR%elasticsearch.bat" (
ECHO.[Dependent][Elasticsearch][hasn't been decompressed yet]
goto :eof
)
%XDISK% 
cd "%ELASTICSEARCH_DIR%" 
%RunHiddenConsole% elasticsearch.bat
ECHO.[Dependent][Elasticsearch][OK]
goto :eof


:startKibana
IF NOT EXIST "%KIBANA_DIR%kibana.bat" (
ECHO.[Dependent][Kibana][hasn't been decompressed yet]
goto :eof
)
%XDISK% 
cd "%KIBANA_DIR%" 
%RunHiddenConsole% kibana.bat
ECHO.[Dependent][Kibana][OK]
goto :eof


:startApm
IF NOT EXIST "%APM_DIR%apm-server.exe" (
ECHO.[Dependent][Apm][hasn't been decompressed yet]
goto :eof
)
%XDISK% 
cd "%APM_DIR%" 
%RunHiddenConsole% apm-server.exe
ECHO.[Dependent][Apm][OK]
goto :eof


:startRabbitmq
IF NOT EXIST "%RABBITMQ_DIR%rabbitmq-server.bat" (
ECHO.[Dependent][Rabbitmq][hasn't been decompressed yet]
goto :eof
)
%XDISK%
cd "%RABBITMQ_DIR%"
%RunHiddenConsole% rabbitmq-server.bat
ECHO.[Dependent][Rabbitmq][OK]
goto :eof
