

@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin

@echo off
echo Detect Microsoft Office 2021 installation directory
set OfficePath="C:\Program Files\Microsoft Office\Office16\"
if exist "C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs" set OfficePath="C:\Program Files (x86)\Microsoft Office\Office16\"
For /F "tokens=2 delims=[]" %%G in ('ver') Do (set _version=%%G) 
For /F "tokens=2 delims=. " %%G in ('echo %_version%') Do (set _major=%%G) 
if "%_major%"=="5" (echo Restart the KMS key management server
cscript %OfficePath%ospp.vbs /osppsvcrestart)
echo Setting up the KMS key management server
cscript %OfficePath%ospp.vbs /sethst:kms.kadirkozan.com.tr
cscript %OfficePath%ospp.vbs /setprt:1688
echo Start Microsoft Office 
cscript %OfficePath%ospp.vbs /act
echo Startup program execution completed
echo Please note: The top (about the first five lines) must have Product activation successful,
echo It means your Office is started successfully!


echo "Office installation complete"

pause