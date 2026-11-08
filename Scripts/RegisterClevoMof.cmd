@echo off

rem Written by DeviceIoControl - Register CLEVOMOF.dll to the system (3-Zone keyboards only)

net session > nul 2>&1
if not %errorlevel%==0 goto OnAccessError
if not exist %cd%\RegisterClevoKbOnBoot.cmd goto OnCurrDirError
if not exist %cd%\..\CLEVOMOF.dll goto OnMissingFileError
if exist C:\Windows\SysWOW64\CLEVOMOF.dll goto OnAlreadyRegistered

color 0c

echo !!!!!!!!!!!!!!READ CAREFULLY!!!!!!!!!!!!!!
echo.
echo Before continuing, please ensure this is a CLEVO/Tongfang based device.
echo This script is designed specifically for CLEVO/Tongfang based laptops with an 'Aptio Setup Utility' / 'American Megatrends Inc.' BIOS.
echo.
echo ----- Running this script on an incompatible device could result in an UNBOOTABLE system! -----
echo.
echo If you already have any variation of the CLEVO Control Center installed, YOU DO NOT NEED TO RUN THIS SCRIPT. (Please close this now, if this is the case)
echo. 
echo If NOT, please TRIPLE CHECK, this is the correct device - You can request for help using the following link if you are unsure: https://github.com/DeviceIoControl/CppKeyboardColour/issues/new/choose
echo.
pause

color 07

echo.
echo Checking BIOS version information...
systeminfo | find /i "BIOS Version:" > nul
if not %errorlevel%==0 goto OnBiosCheckError

systeminfo | find /i "American Megatrends" > nul
if not %errorlevel%==0 goto OnBiosCheckError

color 0c

echo.
echo BIOS version information was verified successfully.
echo.
echo WARNING: This script can result in an UNBOOTABLE SYSTEM, if this script is executed on an incompatible device!
echo.
echo Would you still like to proceed? (Close the script NOW to cancel).
echo.
pause

echo Copying CLEVOMOF.dll... (Please wait)
copy ..\CLEVOMOF.dll C:\Windows\SysWOW64\

echo Registering CLEVOMOF.dll... (Please wait)
reg add HKLM\SYSTEM\CurrentControlSet\Services\WmiAcpi /v MofImagePath /t REG_SZ /d "C:\Windows\SysWOW64\CLEVOMOF.dll"
if not %errorlevel%==0 goto OnFatalScriptError

color 0a

echo.
echo CLEVOMOF.dll registration completed successfully.
echo Your system needs to restart for this change to take effect.
echo.
set /p userConfirm=Would you like to restart now? (Y/N)
if /i %userConfirm%==y goto OnSuccessRestartMachine
if /i %userConfirm%==n goto OnSuccessCloseScript

:OnSuccessRestartMachine
echo.
echo Restarting Windows in 10 seconds...
waitfor ClevoMofRegisterComplete /T 10 > nul
shutdown /r /t 0
exit

:OnSuccessCloseScript
echo Exiting...
exit

:OnFatalScriptError
echo.
echo CLEVOMOF.dll registration failed - Please create an issue https://github.com/DeviceIoControl/CppKeyboardColour/issues/new/choose and contact @DeviceIoControl for assistance.
pause
exit

:OnAlreadyRegistered
echo.
echo CLEVOMOF.dll is already registered. Script is not required.
pause
exit

:OnMissingFileError
echo.
echo CLEVOMOF.dll is missing (or in an incorrect directory) - Please ensure the DLL is in the parent directory and try again.
pause
exit

:OnBiosCheckError
echo.
echo Cannot verify the BIOS Version for this device - Please run this script again on a compatible device.
pause
exit

:OnCurrDirError
echo.
echo Please change current directory (using the cd command) to the "Scripts\" directory before running this command.
pause
exit

:OnAccessError
echo.
echo Insufficient privileges - Please run this script as Administrator!
pause
exit
