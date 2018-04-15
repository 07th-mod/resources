@echo off
SETLOCAL EnableDelayedExpansion

::Check installer is run in the correct game directory. wrongFolderForceInstall label happens if user forces install anyway.
if not exist "arc.nsa" goto :wrongFolder
:wrongFolderForceInstall

ren Umineko1to4.exe Umineko1to4_old.exe > nul
ren 0.utf 0_old.utf > nul

echo "Downloading and verifying all files. You can close and reopen this at any time, your progress will be saved."
echo.

::aria2c won't retry if it gets a 403 code, so force it to retry continously
:downloadLoop
timeout /t 3 > nul
.\temp\aria2c --file-allocation=none --continue=true --check-integrity=true --max-concurrent-downloads=1 --retry-wait 5 -x 8 --follow-metalink=mem https://github.com/07th-mod/resources/raw/master/umineko-question/umi_full.meta4 || goto :downloadLoop

echo "Extracting files..."
echo.
timeout /t 1 > nul
ren 0.utf 0.u > nul
ren saves mysav > nul
.\temp\7za.exe x Umineko-Graphics.zip.001 -aoa
call :checkError "ERROR An error occured when extracting the graphics files. Please try to run the installer again, and check the game files are not in use"
.\temp\7za.exe x Umineko-Update-04_2018.zip -aoa
call :checkError "ERROR An error occured when extracting the graphics files. Please try to run the installer again, and check the game files are not in use"
.\temp\7za.exe x Umineko-Voices.7z -aoa
call :checkError "ERROR An error occured when extracting the voice files. Please try to run the installer again, and check the game files are not in use"
timeout /t 1 > nul

echo "Extraction Finished"
echo.

robocopy en\bmp\background\r_click en\bmp\r_click /E
echo "Character Bio Hotfix Finished"
echo.


:skipDelete
echo "All done. Press any key to exit..."
pause > nul
exit

:checkError
IF %ERRORLEVEL% NEQ 0 (
  echo %*
  pause
  exit
)
EXIT /B 0

::Actions to take if user selected the wrong folder
:wrongFolder
echo "WARNING - The selected install directory doesnt appear to contain the game files."
echo.
explorer .

:wrongFolderChoice
set /P c=An explorer window has been opened. Is this the Umineko Question Arcs game directory[Y/N]?
if /I "%c%" EQU "Y" goto :wrongFolderForceInstall
if /I "%c%" EQU "N" goto :wrongFolderExit
goto :wrongFolderChoice


:wrongFolderExit
echo "Installation has been aborted - wrong install folder"
echo.
echo "Please run the installer again with the correct game directory."
echo.
echo "You may wish to delete the temporary files which have been created."
echo.
pause
exit