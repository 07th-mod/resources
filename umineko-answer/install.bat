@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

::Check installer is run in the correct game directory. wrongFolderForceInstall label happens if user forces install anyway.
if not exist "arc.nsa" goto :wrongFolder
:wrongFolderForceInstall

ren Umineko5to8.exe Umineko5to8_old.exe > nul
ren 0.utf 0_old.utf > nul

call :colorEcho a0 "Downloading all files. You can close and reopen this at any time, your progress will be saved."
echo.
timeout /t 1 > nul
.\temp\aria2c --file-allocation=none --continue=true --max-resume-failure-tries=5 --check-integrity=true --max-concurrent-downloads=1 -x 8 chiru_patch_1.0.meta4
timeout /t 1 > nul

call :colorEcho a0 "Checking for incomplete downloads..."
echo.
timeout /t 1 > nul
.\temp\aria2c --file-allocation=none --continue=true --max-resume-failure-tries=5 --check-integrity=true --max-concurrent-downloads=1 -x 8 chiru_patch_1.0.meta4
call :checkError "ERROR - An error occured during the download process. Please try to run the installer again."
timeout /t 1 > nul

call :colorEcho a0 "Extracting files..."
echo.
timeout /t 1 > nul
.\temp\7za.exe x UminekoChiru-Graphics.7z.001 -aoa
call :checkError "ERROR - An error occured when extracting the graphics files. Please try to run the installer again, and check the game files are not in use."
.\temp\7za.exe x UminekoChiru-Voices.zip
call :checkError "ERROR - An error occured when extracting the voice files. Please try to run the installer again, and check the game files are not in use."
timeout /t 1 > nul

:choice
set /P c=Do you want to delete the temporary install files[Y/N]?
if /I "%c%" EQU "Y" goto :doDelete
if /I "%c%" EQU "N" goto :skipDelete
goto :choice

:doDelete
call :colorEcho a0 "Deleting useless files..."
echo.
timeout /t 1 > nul
rmdir /S /Q .\temp > nul
del .\UminekoChiru-Graphics.7z.00* > nul
del .\UminekoChiru-Voices.zip > nul
timeout /t 1 > nul

:skipDelete
call :colorEcho a0 "All done"
pause
exit

:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i
EXIT /B 0

:checkError
IF %ERRORLEVEL% NEQ 0 (
  echo %*
  pause
  exit
)
EXIT /B 0

::Actions to take if user selected the wrong folder
:wrongFolder
call :colorEcho c0 "WARNING - The selected install directory doesnt appear to contain the game files."
echo.
explorer .

:wrongFolderChoice
set /P c=An explorer window has been opened. Is this the Umineko Chiru game directory[Y/N]?
if /I "%c%" EQU "Y" goto :wrongFolderForceInstall
if /I "%c%" EQU "N" goto :wrongFolderExit
goto :wrongFolderChoice


:wrongFolderExit
call :colorEcho c0 "Installation has been aborted - wrong install folder"
echo.
call :colorEcho 0f "Please run the installer again with the correct game directory."
echo.
call :colorEcho 0f "You may wish to delete the temporary files which have been created."
echo.
pause
exit
