====================================================
@echo off
rem 如出现问题请检查路径或尝试以管理员身份运行

echo ==================begin========================

cls 

SET DISK=D:
SET DEP=%DISK%\Web\h-web-env-windows\dependent
SET NGINX_DIR=%DEP%\nginx-1.15.10\
SET REDIS_DIR=%DEP%\Redis-x64-3.2.100\
SET RunHiddenConsole=%DEP%\RunHiddenConsole

color ff 
TITLE PHP - 临时控制面板

CLS 
ECHO.# by hunzsig
ECHO %~0

:MENU

ECHO.----------------------进程列表----------------------
tasklist|findstr /i "nginx.exe"
tasklist|findstr /i "httpd.exe"
tasklist|findstr /i "redis-server.exe"
ECHO.----------------------------------------------------
ECHO.[1] 启动/重启
ECHO.[9] 关闭
ECHO.[0] 退出 
ECHO.输入操作号:
set /p ID=
IF "%id%"=="1" GOTO start
IF "%id%"=="9" GOTO stop 
IF "%id%"=="0" EXIT
PAUSE 

:start
ECHO.输入PHP版本号:
set /p VERSION=
SET APACHE_DIR=%DISK%\Web\h-web-env-windows\php_%version%\bin\
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO "Not support this php version！"
GOTO MENU
)
call :shutdown
call :startApache
call :startNginx
call :startRedis
GOTO MENU


:stop 
call :shutdown
GOTO MENU

:shutdown
call :shutdownRedis
call :shutdownNginx
call :shutdownApache
goto :eof

:shutdownNginx
ECHO.Stopping Nginx...... 
taskkill /F /IM nginx.exe > nul
ECHO.OK
ECHO. 
goto :eof

:startNginx
ECHO.Start Nginx...... 
IF NOT EXIST "%NGINX_DIR%nginx.exe" (
ECHO "%NGINX_DIR%nginx.exe" not exist
goto :eof
)
%XDISK% 
cd "%NGINX_DIR%" 
start nginx.exe
ECHO.OK
ECHO.
goto :eof


:shutdownApache
ECHO.Stopping Apache...... 
taskkill /F /IM httpd.exe > nul
ECHO.OK
ECHO. 
goto :eof

:startApache
ECHO.Start Apache...... 
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO "%APACHE_DIR%httpd.exe" not exist
goto :eof
)
%XDISK% 
cd "%APACHE_DIR%" 
%RunHiddenConsole% httpd.exe
ECHO.OK
ECHO.
goto :eof

:shutdownRedis
ECHO.Stopping Redis...... 
taskkill /F /IM redis-server.exe > nul
ECHO.OK
ECHO. 
goto :eof

:startRedis
ECHO.Start Redis...... 
IF NOT EXIST "%REDIS_DIR%redis-server.exe" (
ECHO "%REDIS_DIR%redis-server.exe" not exist
goto :eof
)
%XDISK% 
cd "%REDIS_DIR%" 
%RunHiddenConsole% redis-server.exe
ECHO.OK
ECHO.
goto :eof

