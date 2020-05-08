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

SET NGINX_DIR=%DEP%\nginx-1.15.10\
SET REDIS_DIR=%DEP%\Redis-x64-3.2.100\
SET RABBITMQ_DIR=%DEP%\rabbitmq_server-3.7.15\sbin\
SET ELASTICSEARCH_DIR=%DEP%\elasticsearch-7.0.1\bin\
SET KIBANA_DIR=%DEP%\kibana-7.0.1\bin\
SET APM_DIR=%DEP%\apm-server-7.0.1\
SET PHPINI_EXE=%DEP%\dependent.exe

color ff 
TITLE PHP - 服务面板

CLS 
ECHO.# by hunzsig
ECHO %~0

:MENU

ECHO.----------------------进程列表----------------------
tasklist|findstr /i "nginx.exe"
tasklist|findstr /i "httpd.exe"
tasklist|findstr /i "redis-server.exe"
tasklist|findstr /i "erl.exe"
tasklist|findstr /i "java.exe"
tasklist|findstr /i "node.exe"
tasklist|findstr /i "apm-server.exe"
ECHO.----------------------------------------------------
ECHO.输入PHP版本号(5.6-7.4 or latest):
set /p VERSION=
cd "%DEP%"
%PHPINI_EXE% %version%
SET APACHE_DIR=%TOP%\php_%version%\bin\
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO "Not support this php version！"
GOTO MENU
)
ECHO.----------------------------------------------------
ECHO.[1] 启动服务
ECHO.[2] 停止服务
ECHO.[3] 注册服务
ECHO.[9] 删除服务
ECHO.[0] 退出 
ECHO.输入功能号:

set /p ID=
IF "%id%"=="1" ( GOTO start ) ^
ELSE IF "%id%"=="2" ( GOTO stop ) ^
ELSE IF "%id%"=="3" ( GOTO register ) ^
ELSE IF "%id%"=="9" ( GOTO remove ) ^
ELSE IF "%id%"=="0" ( EXIT ) ^
ELSE ( GOTO error )
PAUSE 

:error
ECHO.Not support this opreation！
GOTO MENU

:start
call :startApache
call :startNginx
call :startRedis
call :startRabbitmq
call :startElasticsearch
call :startKibana
call :startApm
GOTO MENU
:stop
call :stopApache
call :stopNginx
call :stopRedis
call :stopRabbitmq
call :stopElasticsearch
call :stopKibana
call :stopApm
GOTO MENU
:register
call :registerApache
call :registerNginx
call :registerRedis
call :registerRabbitmq
call :registerElasticsearch
call :registerKibana
call :registerApm
GOTO MENU
:remove
call :removeApache
call :removeNginx
call :removeRedis
call :removeRabbitmq
call :removeElasticsearch
call :removeKibana
call :removeApm
GOTO MENU






:startApache
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO.[Default][Apache][not exist]
goto :eof
)
%DISK%
cd "%APACHE_DIR%"
httpd.exe -k start
ECHO.[Default][PHP][START]
ECHO.[Default][Apache][START]
goto :eof

:startNginx
IF NOT EXIST "%NGINX_DIR%nginx.exe" (
ECHO.[Dependent][Nginx][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%NGINX_DIR%"
winsw.exe start
ECHO.[Dependent][Nginx][START]
goto :eof

:startRedis
IF NOT EXIST "%REDIS_DIR%redis-server.exe" (
ECHO.[Dependent][Redis][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%REDIS_DIR%"
redis-server --service-start
ECHO.[Dependent][Redis][START]
goto :eof

:startRabbitmq
IF NOT EXIST "%RABBITMQ_DIR%rabbitmq-service.bat" (
ECHO.[Dependent][Rabbitmq][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%RABBITMQ_DIR%"
call rabbitmq-service.bat start
ECHO.[Dependent][Rabbitmq][START]
goto :eof

:startElasticsearch
IF NOT EXIST "%ELASTICSEARCH_DIR%elasticsearch-service.bat" (
ECHO.[Dependent][Elasticsearch][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%ELASTICSEARCH_DIR%"
call elasticsearch-service.bat start
ECHO.[Dependent][Elasticsearch][START]
goto :eof

:startKibana
IF NOT EXIST "%KIBANA_DIR%kibana.bat" (
ECHO.[Dependent][Kibana][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%KIBANA_DIR%"
winsw.exe start
ECHO.[Dependent][Kibana][START]
goto :eof

:startApm
net start "apm-server"
goto :eof






:stopApache
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO.[Default][Apache][not exist]
goto :eof
)
%DISK%
cd "%APACHE_DIR%"
httpd.exe -k stop
ECHO.[Default][Apache][STOP]
ECHO.[Default][PHP][STOP]
goto :eof

:stopNginx
IF NOT EXIST "%NGINX_DIR%nginx.exe" (
ECHO.[Dependent][Nginx][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%NGINX_DIR%"
winsw.exe stop
taskkill /F /IM nginx.exe > nul
ECHO.[Dependent][Nginx][STOP]
goto :eof

:stopRedis
IF NOT EXIST "%REDIS_DIR%redis-server.exe" (
ECHO.[Dependent][Redis][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%REDIS_DIR%"
redis-server --service-stop
ECHO.[Dependent][Redis][STOP]
goto :eof

:stopRabbitmq
IF NOT EXIST "%RABBITMQ_DIR%rabbitmq-service.bat" (
ECHO.[Dependent][Rabbitmq][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%RABBITMQ_DIR%"
call rabbitmq-service.bat stop
ECHO.[Dependent][Rabbitmq][STOP]
goto :eof

:stopElasticsearch
IF NOT EXIST "%ELASTICSEARCH_DIR%elasticsearch-service.bat" (
ECHO.[Dependent][Elasticsearch][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%ELASTICSEARCH_DIR%"
call elasticsearch-service.bat stop
ECHO.[Dependent][Elasticsearch][STOP]
goto :eof

:stopKibana
IF NOT EXIST "%KIBANA_DIR%kibana.bat" (
ECHO.[Dependent][Kibana][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%KIBANA_DIR%"
winsw.exe stop
ECHO.[Dependent][Kibana][STOP]
goto :eof

:stopApm
net stop "apm-server"
goto :eof



:registerApache
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO.[Default][Apache][not exist]
goto :eof
)
%DISK%
cd "%APACHE_DIR%"
httpd.exe -k install
ECHO.[Default][PHP][REG]
ECHO.[Default][Apache][REG]
goto :eof

:registerNginx
IF NOT EXIST "%NGINX_DIR%nginx.exe" (
ECHO.[Dependent][Nginx][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%NGINX_DIR%"
winsw.exe install
ECHO.[Dependent][Nginx][REG]
goto :eof

:registerRedis
IF NOT EXIST "%REDIS_DIR%redis-server.exe" (
ECHO.[Dependent][Redis][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%REDIS_DIR%"
redis-server.exe --service-install redis.windows.conf --loglevel verbose
ECHO.[Dependent][Redis][REG]
goto :eof

:registerRabbitmq
IF NOT EXIST "%RABBITMQ_DIR%rabbitmq-service.bat" (
ECHO.[Dependent][Rabbitmq][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%RABBITMQ_DIR%"
call rabbitmq-service.bat install
ECHO.[Dependent][Rabbitmq][REG]
goto :eof

:registerElasticsearch
IF NOT EXIST "%ELASTICSEARCH_DIR%elasticsearch-service.bat" (
ECHO.[Dependent][Elasticsearch][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%ELASTICSEARCH_DIR%"
call elasticsearch-service.bat install
ECHO.[Dependent][Elasticsearch][REG]
goto :eof

:registerKibana
IF NOT EXIST "%KIBANA_DIR%kibana.bat" (
ECHO.[Dependent][Kibana][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%KIBANA_DIR%"
winsw.exe install
ECHO.[Dependent][Kibana][REG]
goto :eof

:registerApm
IF NOT EXIST "%APM_DIR%install-service-apm-server.ps1" (
ECHO.[Dependent][APM][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%APM_DIR%"
PowerShell.exe -ExecutionPolicy UnRestricted -File .\install-service-apm-server.ps1
ECHO.[Dependent][APM][REG]
goto :eof






:removeApache
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO.[Default][Apache][not exist]
goto :eof
)
%DISK%
cd "%APACHE_DIR%"
httpd.exe -k uninstall
ECHO.[Default][PHP][DEL]
ECHO.[Default][Apache][DEL]
goto :eof

:removeNginx
IF NOT EXIST "%NGINX_DIR%nginx.exe" (
ECHO.[Dependent][Nginx][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%NGINX_DIR%"
winsw.exe uninstall
ECHO.[Dependent][Nginx][DEL]
goto :eof

:removeRedis
IF NOT EXIST "%REDIS_DIR%redis-server.exe" (
ECHO.[Dependent][Redis][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%REDIS_DIR%"
redis-server --service-uninstall
ECHO.[Dependent][Redis][DEL]
goto :eof

:removeRabbitmq
IF NOT EXIST "%RABBITMQ_DIR%rabbitmq-service.bat" (
ECHO.[Dependent][Rabbitmq][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%RABBITMQ_DIR%"
call rabbitmq-service.bat remove
ECHO.[Dependent][Rabbitmq][DEL]
goto :eof


:removeElasticsearch
IF NOT EXIST "%ELASTICSEARCH_DIR%elasticsearch-service.bat" (
ECHO.[Dependent][Elasticsearch][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%ELASTICSEARCH_DIR%"
call elasticsearch-service.bat remove
ECHO.[Dependent][Elasticsearch][DEL]
goto :eo


:removeKibana
IF NOT EXIST "%KIBANA_DIR%kibana.bat" (
ECHO.[Dependent][Kibana][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%KIBANA_DIR%"
winsw.exe uninstall
ECHO.[Dependent][Kibana][DEL]
goto :eof

:removeApm
IF NOT EXIST "%APM_DIR%install-service-apm-server.ps1" (
ECHO.[Dependent][APM][hasn't been decompressed yet]
goto :eof
)
%DISK%
cd "%APM_DIR%"
PowerShell.exe -ExecutionPolicy UnRestricted -File .\uninstall-service-apm-server.ps1
ECHO.[Dependent][APM][DEL]
goto :eof

