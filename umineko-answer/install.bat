@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

ren Umineko5to8.exe Umineko5to8_old.exe > nul
ren 0.utf 0_old.utf > nul

call :colorEcho a0 "Downloading and verifying all files. You can close and reopen this at any time, your progress will be saved."
echo.

::aria2c won't retry if it gets a 403 code, so force it to retry continously
:downloadLoop
timeout /t 3 > nul
.\temp\aria2c --console-log-level=error --file-allocation=none --continue=true --check-integrity=true --max-concurrent-downloads=1 --retry-wait 5 -x 8 --follow-metalink=mem https://github.com/07th-mod/resources/raw/master/umineko-answer/chiru_full.meta4 || goto :downloadLoop

call :colorEcho a0 "Extracting files..."
echo.
timeout /t 1 > nul
ren 0.utf 0.u > nul
ren saves mysav > nul
.\temp\7za.exe x UminekoChiru-Graphics.7z.001 -aoa
call :checkError "ERROR An error occured when extracting the graphics files. Please try to run the installer again, and check the game files are not in use"
.\temp\7za.exe x UminekoChiru-Update-v1.zip -aoa
call :checkError "ERROR An error occured when extracting the updates files. Please try to run the installer again, and check the game files are not in use"
.\temp\7za.exe x UminekoChiru-Voices.7z -aoa
call :checkError "ERROR An error occured when extracting the voice files. Please try to run the installer again, and check the game files are not in use"
timeout /t 1 > nul

call :colorEcho a0 "Extraction Finished"
echo.

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
