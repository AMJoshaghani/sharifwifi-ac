@ECHO off
:: By AMJoshaghani @ amjoshaghani.ir

:: main
SET SCRIPT_PATH=%~dp0
SET /p USERNAME=Enter you username: 
powershell -Command $pword = read-host "Your password " -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword) ; ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) > .tmp.txt 
SET /p PASS=<.tmp.txt & del .tmp.txt

SET "FP=%SCRIPT_PATH%\src\Sharif-WiFi.bat"
SET "TF=%temp%\Sharif-WiFi.bat"
COPY %FP% %temp%
POWERSHELL -Command "(gc %TF%) -replace 'USERNAME&PASSWORD', 'SET "USERNAME=%USERNAME%" && SET "PASS=%PASS%"' | Out-File -encoding ASCII %FP%"
DEL %TF%

ECHO Copying file to startup...
COPY %FP% "%USERPROFILE%\Start Menu\Programs\Startup"
ECHO Done
PAUSE
