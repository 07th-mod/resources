@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

echo "Files in this folder can be deleted after install. You can also back them up incase you need to re-install later." > "temp/README - Temp folder can be deleted or backed up after install.txt"

ren Umineko1to4.exe Umineko1to4_old.exe > nul
ren 0.utf 0_old.utf > nul

call :colorEcho a0 "Downloading and verifying all files. You can close and reopen this at any time, your progress will be saved."
echo.

::aria2c won't retry if it gets a 403 code, so force it to retry continously
:downloadLoop
timeout /t 3 > nul
.\temp\aria2c --console-log-level=error --file-allocation=none --continue=true --check-integrity=true --max-concurrent-downloads=1 --retry-wait 5 -x 8 --follow-metalink=mem https://github.com/07th-mod/resources/raw/master/umineko-question/umi_full.meta4 --dir=temp || goto :downloadLoop

call :colorEcho a0 "Copying files..."
copy /Y temp\Umineko1to4.exe .
copy /Y temp\0.utf .

call :colorEcho a0 "Extracting files..."
echo.
timeout /t 1 > nul
ren 0.utf 0.u > nul
ren saves mysav > nul
.\temp\7za.exe x temp\Umineko-Graphics.zip.001 -aoa
call :checkError "ERROR An error occured when extracting the graphics files. Please try to run the installer again, and check the game files are not in use"
.\temp\7za.exe x temp\Umineko-Update-04_2018.zip -aoa
call :checkError "ERROR An error occured when extracting the update files. Please try to run the installer again, and check the game files are not in use"
.\temp\7za.exe x temp\Umineko-Voices.7z -aoa
call :checkError "ERROR An error occured when extracting the voice files. Please try to run the installer again, and check the game files are not in use"
timeout /t 1 > nul

call :colorEcho a0 "Extraction Finished"
echo.

robocopy en\bmp\background\r_click en\bmp\r_click /E
call :colorEcho a0 "Character Bio Hotfix Finished"
echo.

::open the temp folder so users can delete/backup any temp install files
call :colorEcho a0 "Temporary install files are shown - please delete or back them up if you wish to re-install"
explorer temp
call :colorEcho a0 "All done, finishing in three seconds..."
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
