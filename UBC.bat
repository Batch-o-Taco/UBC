@echo off
rem don't talk about number 1.1 and 1.2 😫
:: Check if the script is running on Windows 7 or lower
ver | findstr /i "6\.1\." > nul
if %errorlevel% == 0 (
    echo This script cannot run on Windows 7 or lower.
    pause
    exit
)

:: Menu
:menu
type ascii.txt
echo(
echo(
echo(
echo -------- Bad Menu ---------
echo Enter 1 to Cleanup temp files.
echo Enter 2 to Display Info.
echo Enter 3 to Sing a PC Cleaning song.
echo Enter 4 to BackUp.
echo Enter 5 to Exit.
set /p ans="Enter an option:"

if "%ans%"=="1" goto tempdel
if "%ans%"=="2" goto info
if "%ans%"=="3" goto song
if "%ans%"=="4" goto backup
if "%ans%"=="5" goto exit

:: Delete temporary files
:tempdel
echo Please BackUp your files as 
echo Deleting temporary files...
del /f /q %temp%\*.*
REM These lines delete files from various directories
del /s /f /q %WinDir%\Temp\*.*
del /s /f /q %WinDir%\Prefetch\*.*
del /s /f /q %Temp%\*.*
del /s /f /q %AppData%\Temp\*.*
del /s /f /q %HomePath%\AppData\LocalLow\Temp\*.*
del /s /f /q %SYSTEMDRIVE%\AMD\*.*
del /s /f /q %SYSTEMDRIVE%\NVIDIA\*.*
del /s /f /q %SYSTEMDRIVE%\INTEL\*.*
del /s /f /q C:\$Recycle.Bin\*.*
del /s /f /q C:\Users\%username%\AppData\Local\Microsoft\Windows\INetCache\IE\*.*

REM These lines remove directories
rd /s /q %WinDir%\Temp
rd /s /q %WinDir%\Prefetch
rd /s /q %Temp%
rd /s /q %AppData%\Temp
rd /s /q %HomePath%\AppData\LocalLow\Temp
rd /s /q %SYSTEMDRIVE%\AMD
rd /s /q %SYSTEMDRIVE%\NVIDIA
rd /s /q %SYSTEMDRIVE%\INTEL

REM These lines create directories
md %WinDir%\Temp
md %WinDir%\Prefetch
md %Temp%
md %AppData%\Temp
md %HomePath%\AppData\LocalLow\Temp
cleanmgr /sagerun:1
cls
set /P c=Do you have CCleaner[Y/N]?
if /I "%c%" EQU "Y" goto :auclean
if /I "%c%" EQU "N" goto :distempdelmes
echo Disk cleanup complete!
pause
cls
set /P c=Do you want to remove replicate files[Y/N]?
if /I "%c%" EQU "Y" goto :delrepfil
if /I "%c%" EQU "N" goto :distempdelmes

:distempdelmes
cls
echo Temporary files have been deleted successfully.
pause
cls
goto menu

:info
cls
echo This is still in very early development stages, Contribution would be appreciated.

echo WARNING! Don't trust random batch files, you never know whats inside! Always check the code of files.

echo Keep your operating system, antivirus, and other software up-to-date with the latest security patches.

echo Use a reputable antivirus software and keep it updated.

echo Be cautious when downloading and installing software from the internet, especially if it is from an untrusted source.

echo Use strong and unique passwords and enable two-factor authentication whenever possible.

echo Avoid clicking on suspicious links or opening email attachments from unknown senders.

echo Regularly backup your important files to a secure location.

echo Educate yourself about common types of malware and how to recognize them.

echo UBC v1.2

pause
cls
goto menu

:song
cls
echo Computer, Computer
echo The one that never gets cleaned :(
echo Computer, Computer
echo the one that never will get cleaned.
pause
cls
goto menu

:delrepfil
cls
rem Remove duplicate files
set "source=C:\Folder"
for /f "delims=" %%a in ('dir /b /a-d "%source%\*" ^| sort /r') do (
  if exist "%source%\%%~nxa" (
    del "%%~fa"
  ) else (
    move "%%~fa" "%source%\"
  )
)

:backup
cls
set /p src=Enter the source folder path: 
set /p dest=Enter the destination folder path: 
echo Backing up %src% to %dest%...
xcopy /s /e /h /i /c "%src%" "%dest%"
echo Backup completed.
pause
cls
goto menu

:auclean
"C:\Program Files\CCleaner\CCleaner.exe" /auto
echo Done!
pause
goto distempdelmes

:exit
exit
