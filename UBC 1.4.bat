@echo off
REM i put the new forgis on da jeep
REM Check if the script is running on Windows 7 or lower
ver | findstr /i "6\.1\." > nul
if %errorlevel% equ 0 (
    echo This script cannot run on Windows 7 or lower.
    pause
    exit
)

:menu
cls
type ascii.txt
echo.
echo.
echo.
echo -------- Bad Menu ---------
echo Hey %username%!
echo Enter 1 to Cleanup temp files.
echo Enter 2 to Display Info.
echo Enter 3 to Sing a PC song.
echo Enter 4 to BackUp.
echo Enter 5 to Check PC Specs.
echo Enter 6 to Exit.
choice /c 123456 /n /m "Enter an option:"
if %errorlevel% equ 1 goto option1
if %errorlevel% equ 2 goto option2
if %errorlevel% equ 3 goto option3
if %errorlevel% equ 4 goto option4
if %errorlevel% equ 5 goto option5
if %errorlevel% equ 6 goto exit

:option1
echo Please BackUp your files before deleting temporary files...
echo Deleting temporary files...
del /f /q /s %temp%\*.* %WinDir%\Temp\*.* %WinDir%\Prefetch\*.* %AppData%\Temp\*.* %HomePath%\AppData\LocalLow\Temp\*.* %SYSTEMDRIVE%\AMD\*.* %SYSTEMDRIVE%\NVIDIA\*.* %SYSTEMDRIVE%\INTEL\*.* C:\$Recycle.Bin\*.* C:\Users\%username%\AppData\Local\Microsoft\Windows\INetCache\IE\*.*
rd /s /q %WinDir%\Temp %WinDir%\Prefetch %temp% %AppData%\Temp %HomePath%\AppData\LocalLow\Temp %SYSTEMDRIVE%\AMD %SYSTEMDRIVE%\NVIDIA %SYSTEMDRIVE%\INTEL
md %WinDir%\Temp %WinDir%\Prefetch %temp% %AppData%\Temp %HomePath%\AppData\LocalLow\Temp
cleanmgr /sagerun:1
choice /m "Do you have CCleaner?"
if errorlevel 2 goto distempdelmes
"C:\Program Files\CCleaner\CCleaner.exe" /auto
echo Done!
pause
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
echo UBC v1.4
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
echo Backup completed.
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
    echo Storage is Outdated - wmic logicaldisk get size,freespace,caption
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

:exit
exit