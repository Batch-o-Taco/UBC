@echo off
REM This script displays a menu of options for performing various tasks.

:: Check if the script is running on Windows Vista or lower
ver | findstr /i "6\.[0-9]\." > nul
if "%errorlevel%" equ "0" (
    echo This script cannot run on Windows Vista or lower.
    pause
    exit
)

set version=UBC 1.6
set logFile=C:\UBCLog.txt
title %version%
setlocal EnableDelayedExpansion
if not exist %logFile% (
    echo Creating UBCLog.txt file...
    echo. > %logFile%
)

:menu
cls
type ascii.txt
echo.
echo.
echo.
echo -------- %version%'s Bad Menu ---------
echo Hey %username%!
echo Enter 1 to Cleanup temp files.
echo Enter 2 to Display Info.
echo Enter 3 to Sing a PC song.
echo Enter 4 to BackUp.
echo Enter 5 to Check PC Specs.
echo Enter 6 to Repair System Files.
echo Enter 7 to Install UBC-Moptions.
echo Enter 8 to See More Options.
echo Enter 9 to Exit.
set /p menuchoice=Enter an option number:

if "%menuchoice%" gtr "9" goto :invalidoption
if "%menuchoice%"=="0" goto :invalidoption
if "%menuchoice%"=="1" goto :option1
if "%menuchoice%"=="2" goto :option2
if "%menuchoice%"=="3" goto :option3
if "%menuchoice%"=="4" goto :option4
if "%menuchoice%"=="5" goto :option5
if "%menuchoice%"=="6" goto :option6
if "%menuchoice%"=="7" goto :minstall
if "%menuchoice%"=="8" goto :xyz
if "%menuchoice%"=="9" goto :exit

:invalidoption
echo Invalid option. Please enter a number from 1 to 9. >> %logFile%
pause
cls
goto :menu

:option1
cls
echo "Run as Admin" is the best way to go, you can still run it like usual.
pause
cls
echo Please BackUp your files before deleting temporary files...
echo Install the UPC Debloater in the More Options Menu for Best Performance...
pause
cls
echo Doing Boot Edits...
bcdedit /set useplatformclock No >> %logFile%
bcdedit /set useplatformtick No >> %logFile%
bcdedit /set disabledynamictick Yes >> %logFile%
bcdedit /set forcelegacyplatform No >> %logFile%
bcdedit /set tscsyncpolicy Enhanced >> %logFile%
bcdedit /set avoidlowmemory 0x8000000 >> %logFile%
bcdedit /set firstmegabytepolicy UseAll >> %logFile%
bcdedit /set nolowmem Yes >> %logFile%
bcdedit /set isolatedcontext No >> %logFile%
bcdedit /set x2apicpolicy Enable >> %logFile%
bcdedit /set usephysicaldestination No >> %logFile%
bcdedit /set linearaddress57 OptOut >> %logFile%
bcdedit /set noumex Yes >> %logFile%
bcdedit /set perfmem 0 >> %logFile%
bcdedit /set clustermodeaddressing 1 >> %logFile%
bcdedit /set configflags 0 >> %logFile%
bcdedit /set uselegacyapicmode No >> %logFile%
bcdedit /set disableelamdrivers Yes >> %logFile%
bcdedit /set vsmlaunchtype Off >> %logFile%
bcdedit /set ems No >> %logFile%
bcdedit /set extendedinput Yes >> %logFile%
bcdedit /set highestmode Yes >> %logFile%
bcdedit /set forcefipscrypto No >> %logFile%
bcdedit /set sos Yes >> %logFile%
bcdedit /set pae ForceEnable >> %logFile%
bcdedit /set debug No >> %logFile%
bcdedit /set hypervisorlaunchtype Off >> %logFile%
cls
echo Deleting Thumbnail Cache..
taskkill /f /im explorer.exe
timeout 2 /nobreak>nul
DEL /F /S /Q /A %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db
timeout 2 /nobreak>nul
start explorer.exe
timeout /t 1 /nobreak > NUL
cls
echo Doing Simple Registry Tweaks...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f 
del /f /q /s %temp%\*.* %WinDir%\Temp\*.* %WinDir%\Prefetch\*.* %AppData%\Temp\*.* %HomePath%\AppData\LocalLow\Temp\*.* %SYSTEMDRIVE%\AMD\*.* %SYSTEMDRIVE%\NVIDIA\*.* %SYSTEMDRIVE%\INTEL\*.* C:\$Recycle.Bin\*.*
rd /s /q %WinDir%\Temp %WinDir%\Prefetch %temp% %AppData%\Temp %HomePath%\AppData\LocalLow\Temp %SYSTEMDRIVE%\AMD %SYSTEMDRIVE%\NVIDIA %SYSTEMDRIVE%\INTEL
md %WinDir%\Temp %WinDir%\Prefetch %temp% %AppData%\Temp %HomePath%\AppData\LocalLow\Temp
cls
echo Running the Clean Utility...
cleanmgr /sagerun:1
start URT.reg
cls
echo Clearing all event logs...
for /f "tokens=1,2*" %%a in ('wevtutil el') do (
  wevtutil cl "%%b" || (
    echo Error clearing event log %%b.
    pause
    cls
    goto temp2
  )
)

echo Event logs cleared successfully.
pause
if "%winver%"=="7" goto win7
echo Invalid Windows version entered.
pause
cls
set /p winver=Enter your Windows version (11, 10, or 7): 
if "%winver%"=="11" goto win11
if "%winver%"=="10" goto win10
cls
goto menu

:option2
cls
echo This is still in very early development stages, Contribution would be appreciated.
echo WARNING! Don't trust random batch files, you never know whats inside! Always check the code of files.
echo.
echo Keep your operating system, antivirus, and other software up-to-date with the latest security patches.
echo.
echo Use a reputable antivirus software and keep it updated.
echo.
echo Be cautious when downloading and installing software from the internet, especially if it is from an untrusted source.
echo.
echo Use strong and unique passwords and enable two-factor authentication whenever possible.
echo.
echo Avoid clicking on suspicious links or opening email attachments from unknown senders.
echo.
echo Regularly backup your important files to a secure location.
echo.
echo You Need to Run as Admin to have LogFiles.
echo.
echo %version% 
echo.
pause
goto menu

:option3
cls
echo Computer, Computer
echo The one that never gets cleaned :(
echo Computer, Computer
echo the one that never will get cleaned.
pause
goto menu

:option4
cls
set /p "src=Enter the source folder path: "
set /p "dest=Enter the destination folder path: "
echo Backing up %src% to %dest%...
xcopy /s /e /h /i /c "%src%" "%dest%"
echo Backup completed.  >> %logFile%
pause
goto menu

:option5
cls
setlocal
REM Check RAM
wmic ComputerSystem get TotalPhysicalMemory | findstr /C:"4294967296" >nul
if %errorlevel% equ 0 (
    echo RAM Is Outdated - wmic ComputerSystem get TotalPhysicalMemory
) else (
    echo RAM Is Updated - wmic ComputerSystem get TotalPhysicalMemory
)

REM Check CPU
wmic cpu get NumberOfCores | findstr /C:"2" >nul
if %errorlevel% equ 0 (
    echo CPU Is Outdated - wmic cpu get NumberOfCores
) else (
    echo CPU Is Updated - wmic cpu get NumberOfCores
)

REM Check Storage
wmic diskdrive get size | findstr /C:"250000000000" >nul
if %errorlevel% equ 0 (
    echo Storage is Updated - wmic logicaldisk get size,freespace,caption
) else (
    echo Storage is Outdated - wmic logicaldisk get size,freespace,caption  >> %logFile%
)
endlocal
pause
goto menu2

:menu2
cls
echo Press 1 to go to the main menu.
echo Press 2 to go to advanced specs.
choice /c 12 /n /m "Enter an option:"
if %errorlevel% equ 1 goto menu
if %errorlevel% equ 2 goto advanced

:advanced
cls
echo RAM Size:
wmic ComputerSystem get TotalPhysicalMemory
echo.
echo Storage Size:
wmic logicaldisk get size,freespace,caption
echo.
echo CPU Cores:
wmic cpu get NumberOfCores
pause
goto menu2

:option6
cls
sfc /scannow
pause
goto menu3

:menu3
cls
SET choice=
SET /p choice=Did it fix it?: 
IF NOT '%choice%'=='' SET choice=%choice:~0,1%
IF '%choice%'=='Y' GOTO menu
IF '%choice%'=='y' GOTO menu
IF '%choice%'=='N' GOTO fix2  >> %logFile%
IF '%choice%'=='n' GOTO fix2  >> %logFile%
IF '%choice%'=='' GOTO fix2  >> %logFile%
ECHO "%choice%" is not valid.
ECHO.
pause
cls
GOTO menu

:fix2
cls
echo If you see that there are errors, Go to Fix3.
DISM /Online /Cleanup-Image /ScanHealth 
echo.
SET /p choice=Did you have any errors?: 
IF NOT '%choice%'=='' SET choice=%choice:~0,1%
IF '%choice%'=='Y' GOTO fix3
IF '%choice%'=='y' GOTO fix3
IF '%choice%'=='N' GOTO menu
IF '%choice%'=='n' GOTO menu
IF '%choice%'=='' GOTO menu
ECHO "%choice%" is not valid
ECHO.
pause
cls
GOTO menu

:fix3
echo Fixing...
DISM /Online /Cleanup-Image /RestoreHealth /Source:repairSource\install.wim
pause
echo Fixes Done!  >> %logFile%
pause
cls
goto menu

:option7
REM Get user input for setup file and arguments
set /p setup=Enter path to setup file: 
set /p arguments=Enter setup arguments (optional): 

REM Validate user input and install setup file
if not exist "%setup%" (
    echo Invalid setup file. Please try again.
    goto :install_setup
) else (
    echo Installing setup file...
    start /wait "" "%setup%" %arguments%
    echo Setup file installed successfully.  >> %logFile%
)

:optionR8
cls
setlocal

REM Get current date and time in a format suitable for a restore point name
for /f "tokens=1-5 delims=/:. " %%d in ("%date% %time%") do set "timestamp=%%d-%%e-%%f_%%g-%%h"

REM Create a restore point
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "MyRestorePoint_%timestamp%", 100, 12

REM Check the return code to see if the restore point was created successfully
if %errorlevel% equ 0 (
    echo System restore point created successfully.
pause
cls
goto menu
) else (
    echo Failed to create system restore point.
pause
cls
goto menu
)
endlocal

:option8A
cls
echo Scanning for malware...
powershell.exe -Command "Start-MpScan -ScanType QuickScan"
echo Malware scan completed.
pause
goto menu


:xyz
cls
echo %version% iMO Menu.
echo Enter 1 to Do a malware scan.
echo Enter 2 to Defragment the Disk.
echo Enter 3 to Install UPC Debloater.
echo Enter 4 to Desinstall Common Apps.
echo Enter 5 to Exit iMO.
set /p imomenu=Enter an Option:

if "%imomenu%"=="5" goto menu
if "%imomenu%"=="4" goto option8D
if "%imomenu%"=="3" goto option8C
if "%imomenu%"=="2" goto option8B
if "%imomenu%"=="1" goto option8A

:option8B
cls
echo Defragmenting system drive...  >> %logFile%
defrag.exe C: /U /V
echo System drive defragmentation completed.  >> %logFile%
pause
cls
goto menu

:minstall
git clone https://github.com/BatchProgrammerWhoSuckAtIt/UBCMOPTIONS-SourceCode-Github-Release.git  >> %logFile%
```

REM Change back to the original folder
cd ..

echo Folder, ASCII art text file, and batch script created successfully.  >> %logFile%
pause
cls
goto menu

:win7
sc config TabletInputService start=disabled
sc config ehstart start=disabled
sc config RemoteRegistry start=disabled
sc config WSearch start=disabled
cls
echo Windows 7 Tweaks Done!
pause
cls
goto temp2


:win10
sc config SessionEnv start=disabled
sc config WaaSMedicSvc start=disabled
cls
echo Windows 10 Tweaks Done!
pause
cls
goto temp2

:win11
sc config SessionEnv start=disabled
sc config WaaSMedicSvc start=disabled
cls
echo Windows 11 Tweaks Done!
pause
cls
goto temp2

:temp2
netsh interface ip set dns name="Local Area Connection" static 1.1.1.1 primary
netsh interface ip add dns name="Local Area Connection" addr=1.0.0.1 index=2
powercfg -h off
powercfg -setactive <power plan name>
set /p gamer=Are you a gamer? (Yes/No)
if /i "%gamer%"=="yes" (
    start GamerSettings.reg
) else (
set /p ccleanerexecuter=Execute CCleaner?
if "%ccleanerexecuter%"=="Y" goto ccleaner
if "%ccleanerexecuter%"=="N" goto menu

:ccleaner
"C:\Program Files\CCleaner\CCleaner.exe" /auto)
echo Done!  >> %logFile%
pause
cls
goto menu

:option8C

:option8D
echo Scanning for bundleware...

:: Define list of bundleware app names
set "bundleware=Avast,McAfee,Norton,AVG,Google Chrome,Opera,Firefox,Yahoo Search,Ask Toolbar,Adobe Reader,Microsoft Office Trial,WinZip,WinRAR,7-Zip,Dropbox,iCare Data Recovery,Driver Booster,Advanced SystemCare,CCleaner,IObit Uninstaller"

:: Split list into array
set i=0
for %%a in (%bundleware%) do (
    set /a i+=1
    set "app[!i!]=%%a"
)

:: Display list of bundleware apps
echo The following bundleware apps were found on your system:
for /l %%i in (1,1,%i%) do (
    echo %%i. !app[%%i]!
)

:: Prompt user to choose which apps to uninstall
set /p "uninstall=Enter the numbers of the apps you want to uninstall (comma-separated): "

:: Uninstall selected apps
echo Uninstalling selected apps...
for %%i in (%uninstall%) do (
    set "app=!app[%%i]!"
    echo Uninstalling !app!...
    wmic product where "name='!app!'" call uninstall /nointeractive
)

echo Done.
pause

:exit
exit  >> %logFile%