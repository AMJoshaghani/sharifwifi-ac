@echo off
:: by AMJoshaghani @ amjoshaghani.ir
:: declarations
SET "SADDR=net2.sharif.edu"
USERNAME&PASSWORD

:: main
timeout /t 10 /nobreak > NUL
:PING
PING sharif.edu -n 1 -w 5000 > NUL
IF ERRORLEVEL 1 (GOTO PING)
ECHO Authenticating...
CURL -X POST -d "username=%USERNAME%&password=%PASS%" --ssl-no-revoke "https://%SADDR%/login" > NUL
IF ERRORLEVEL 1 (CALL :ERR) ELSE (CALL :SUC)
GOTO :EOF

:: sub workers
:ERR
ECHO Failed.
CALL :NOTIF "Sharif-WiFi" "Auth failed." "Error"
EXIT /B 1

:SUC
ECHO Succeed.
CALL :NOTIF "Sharif-WiFi" "Auth succeed." "Information"
EXIT /B 0

:NOTIF
SET type=%~3
SET "$Titre=%~1"
SET "$Message=%~2"
SET "$Icon=%~3"
FOR /f "delims=" %%a IN ('powershell -c "[reflection.assembly]::loadwithpartialname('System.Windows.Forms');[reflection.assembly]::loadwithpartialname('System.Drawing');$notify = new-object system.windows.forms.notifyicon;$notify.icon = [System.Drawing.SystemIcons]::%$Icon%;$notify.visible = $true;$notify.showballoontip(10,'%$Titre%','%$Message%',[system.windows.forms.tooltipicon]::None)"') DO (SET $=)

GOTO :EOF
