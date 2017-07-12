:Auto Build and Deploy Web
:Author Gmoz 2017/07

ECHO OFF

:the war filename
SET WAR_NAME=LayaWeb.war

:the path of the project you want to build by ant
SET PROJECT_FLODER="D:\Projects\LayaWeb"

:notice the asadmin.bat location
SET GLASSFISH_PATH="D:\Program Files (x86)\glassfish-4.1.2\glassfish"

:the war file you want to deploy
SET WAR_PATH=%PROJECT_FLODER%\dist\%WAR_NAME%

:your domain name
SET DOMAIN_NAME=domain1

:no need to change
SET GLASSFISH_BIN_PATH=%GLASSFISH_PATH%\bin
SET GLASSFISH_AUTODEPLOY_PATH=%GLASSFISH_PATH%\domains\%DOMAIN_NAME%\autodeploy


ECHO "[Clean and Build...Start]"
call ant -f %PROJECT_FLODER% -Dnb.internal.action.name=rebuild -DforceRedeploy=false -Dbrowser.context=%PROJECT_FLODER% clean dist
ECHO.

ECHO "[Stop Glassfish...]"
call %GLASSFISH_BIN_PATH%\asadmin stop-domain %DOMAIN_NAME%
ECHO.

ECHO "[Delete old war file from autodeploy floder...]"
DEL %GLASSFISH_AUTODEPLOY_PATH%\%WAR_NAME%_deployed
DEL %GLASSFISH_AUTODEPLOY_PATH%\%WAR_NAME%
DEL %GLASSFISH_AUTODEPLOY_PATH%\".autodeploystatus"\%WAR_NAME%
ECHO.

ECHO "[Copy war file to autodeploy floder...]"
XCOPY /y %WAR_PATH% %GLASSFISH_AUTODEPLOY_PATH%\
ECHO.

ECHO "[Start Glassfish...]"
call %GLASSFISH_BIN_PATH%\asadmin start-domain %DOMAIN_NAME%
ECHO.

set /p="Waiting autodeploy..."<nul
:CheckForFile
:Deploy completed while the file existed
IF EXIST %GLASSFISH_AUTODEPLOY_PATH%\%WAR_NAME%_deployed GOTO FoundIt
timeout /t 1 > nul
set /p="."<nul
GOTO CheckForFile

:FoundIt
ECHO.
ECHO.
ECHO.
ECHO.
ECHO "[Build & Deploy finshed]"

PAUSE
