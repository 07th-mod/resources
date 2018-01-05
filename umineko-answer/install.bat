@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

call :colorEcho a0 "Downloading graphics patch... (1 of 3)"
echo.
timeout /t 1 > nul
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.001
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.002
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.003
timeout /t 1 > nul

call :colorEcho a0 "Downloading voice patch... (2 of 3)"
echo.
timeout /t 1 > nul
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Voices.zip
timeout /t 1 > nul

call :colorEcho a0 "Downloading patch... (3 of 3)"
echo.
timeout /t 1 > nul
ren Umineko5to8.exe Umineko5to8_old.exe > nul
ren 0.utf 0_old.utf > nul
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/Umineko5to8.exe
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/umineko-answer/blob/master/0.utf
timeout /t 1 > nul

call :colorEcho a0 "Checking for incomplete downloads..."
echo.
timeout /t 1 > nul
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/Umineko5to8.exe
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/umineko-answer/blob/master/0.utf
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Voices.zip
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.001
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.002
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.003
timeout /t 1 > nul

call :colorEcho a0 "Extracting files..."
echo.
timeout /t 1 > nul
.\temp\7za.exe x UminekoChiru-Graphics.7z.001 -aoa
.\temp\7za.exe x UminekoChiru-Voices.zip
timeout /t 1 > nul

call :colorEcho a0 "Deleting useless files..."
echo.
timeout /t 1 > nul
rmdir /S /Q .\temp > nul
del .\UminekoChiru-Graphics.7z.00* > nul
del .\UminekoChiru-Voices.zip > nul
timeout /t 1 > nul

call :colorEcho a0 "All done, finishing in three seconds..."
timeout /t 3 > nul

exit
:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i