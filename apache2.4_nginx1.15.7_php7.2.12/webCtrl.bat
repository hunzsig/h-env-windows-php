====================================================
@echo off
rem 如出现问题请检查路径或尝试以管理员身份运行

echo ==================begin========================

cls 

SET XPATH=E:
SET NGINX_DIR=%XPATH%\Web\nginx-1.15.7\
SET APACHE_DIR=%XPATH%\Web\Apache24\bin\

color ff 
TITLE NAP控制面板

CLS 
ECHO.# Nginx+Apache+Php
ECHO.# by hunzsig 20181204

:MENU

ECHO.----------------------进程列表----------------------
tasklist|findstr /i "nginx.exe"
tasklist|findstr /i "httpd.exe"
ECHO.----------------------------------------------------
ECHO.[1] 启动/重启[NAP模式]
ECHO.[2] 启动/重启[AP模式]
ECHO.[9] 关闭
ECHO.[0] 退出 
ECHO.输入功能号:

set /p ID=
IF "%id%"=="1" GOTO startNAP
IF "%id%"=="2" GOTO startAP
IF "%id%"=="9" GOTO stop 
IF "%id%"=="0" EXIT
PAUSE 



:startNAP 
call :shutdown
call :startNginx
call :startApache
GOTO MENU

:startAP 
call :shutdown
call :startApache
GOTO MENU

:stop 
call :shutdown
GOTO MENU

:shutdown
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
%XPATH% 
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
%XPATH% 
cd "%APACHE_DIR%" 
RunHiddenConsole httpd.exe
ECHO.OK
ECHO.
goto :eof

