====================================================
@echo off
rem 如出现问题请检查路径或尝试以管理员身份运行

echo ==================begin========================

cls 

SET DISK=D:
SET DEP=%DISK%\Web\h-web-env-windows\dependent
SET NGINX_DIR=%DEP%\nginx-1.15.10\
SET REDIS_DIR=%DEP%\Redis-x64-3.2.100\

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
ECHO.----------------------------------------------------
ECHO.输入PHP版本号:
set /p VERSION=
SET APACHE_DIR=%DISK%\Web\h-web-env-windows\php_%version%\bin\
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
IF "%id%"=="1" GOTO start
IF "%id%"=="2" GOTO stop
IF "%id%"=="3" GOTO register
IF "%id%"=="9" GOTO remove 
IF "%id%"=="0" EXIT
PAUSE 

:start
call :startX
GOTO MENU
:stop
call :stopX
GOTO MENU
:register 
call :registerX
GOTO MENU
:remove
call :removeX
GOTO MENU

:startX
ECHO.Start Nginx...... 
IF NOT EXIST "%NGINX_DIR%nginx.exe" (
ECHO "%NGINX_DIR%nginx.exe" not exist
goto :eof
)
%DISK% 
cd "%NGINX_DIR%" 
winsw.exe start
ECHO.
ECHO.Start Apache...... 
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO "%APACHE_DIR%httpd.exe" not exist
goto :eof
)
%DISK% 
cd "%APACHE_DIR%" 
httpd.exe -k start
ECHO.
ECHO.Start Redis...... 
IF NOT EXIST "%REDIS_DIR%redis-server.exe" (
ECHO "%REDIS_DIR%redis-server.exe" not exist
goto :eof
)
%DISK% 
cd "%REDIS_DIR%" 
redis-server --service-start
ECHO.
goto :eof

:stopX
ECHO.Stop Nginx...... 
IF NOT EXIST "%NGINX_DIR%nginx.exe" (
ECHO "%NGINX_DIR%nginx.exe" not exist
goto :eof
)
%DISK% 
cd "%NGINX_DIR%" 
winsw.exe stop
taskkill /F /IM nginx.exe > nul
ECHO.
ECHO.Stop Apache...... 
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO "%APACHE_DIR%httpd.exe" not exist
goto :eof
)
%DISK% 
cd "%APACHE_DIR%" 
httpd.exe -k stop
ECHO.
ECHO.Stop Redis...... 
IF NOT EXIST "%REDIS_DIR%redis-server.exe" (
ECHO "%REDIS_DIR%redis-server.exe" not exist
goto :eof
)
%DISK% 
cd "%REDIS_DIR%" 
redis-server --service-stop
ECHO.
goto :eof

:registerX
ECHO.Register Nginx...... 
IF NOT EXIST "%NGINX_DIR%nginx.exe" (
ECHO "%NGINX_DIR%nginx.exe" not exist
goto :eof
)
%DISK% 
cd "%NGINX_DIR%" 
winsw.exe install
ECHO.
ECHO.Register Apache...... 
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO "%APACHE_DIR%httpd.exe" not exist
goto :eof
)
%DISK% 
cd "%APACHE_DIR%"
httpd.exe -k install
ECHO.
ECHO.Register Redis...... 
IF NOT EXIST "%REDIS_DIR%redis-server.exe" (
ECHO "%%REDIS_DIR%redis-server.exe" not exist
goto :eof
)
%DISK% 
cd "%REDIS_DIR%"
redis-server.exe --service-install redis.windows.conf --loglevel verbose
ECHO.
goto :eof



:removeX
ECHO.Remove Nginx...... 
IF NOT EXIST "%NGINX_DIR%nginx.exe" (
ECHO "%NGINX_DIR%nginx.exe" not exist
goto :eof
)
%DISK% 
cd "%NGINX_DIR%"
winsw.exe uninstall
ECHO.
ECHO.Remove Apache...... 
IF NOT EXIST "%APACHE_DIR%httpd.exe" (
ECHO "%APACHE_DIR%httpd.exe" not exist
goto :eof
)
%DISK% 
cd "%APACHE_DIR%"
httpd.exe -k uninstall
ECHO.
ECHO.Remove Redis...... 
IF NOT EXIST "%REDIS_DIR%redis-server.exe" (
ECHO "%REDIS_DIR%redis-server.exe" not exist
goto :eof
)
%DISK% 
cd "%REDIS_DIR%"
redis-server --service-uninstall
ECHO.
goto :eof