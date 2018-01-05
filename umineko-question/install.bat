@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

call :colorEcho a0 "Downloading graphics patch... (1 of 3)"
echo.
timeout /t 1 > nul
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Graphics.zip.001
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Graphics.zip.002
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Graphics.zip.003
timeout /t 1 > nul

call :colorEcho a0 "Downloading voice patch... (2 of 3)"
echo.
timeout /t 1 > nul
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Voices.zip
timeout /t 1 > nul

call :colorEcho a0 "Downloading patch... (3 of 3)"
echo.
timeout /t 1 > nul
ren Umineko1to4.exe Umineko1to4_old.exe > nul
ren 0.utf 0_old.utf > nul
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko1to4.exe
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/umineko-question/raw/master/InDevelopment/ManualUpdates/0.utf
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Update-v1.zip
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Update-v2.zip
timeout /t 1 > nul

call :colorEcho a0 "Checking for incomplete downloads..."
echo.
timeout /t 1 > nul
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko1to4.exe
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/umineko-question/raw/master/InDevelopment/ManualUpdates/0.utf
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Update-v1.zip
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Update-v2.zip
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Voices.zip
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Graphics.zip.001
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Graphics.zip.002
.\temp\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Graphics.zip.003
timeout /t 1 > nul

call :colorEcho a0 "Extracting files..."
echo.
timeout /t 1 > nul
.\temp\7za.exe x Umineko-Graphics.zip.001 -aoa
.\temp\7za.exe x Umineko-Update-v1.zip -aoa
.\temp\7za.exe x Umineko-Update-v2.zip -aoa
.\temp\7za.exe x Umineko-Voices.zip
timeout /t 1 > nul

call :colorEcho a0 "Deleting useless files..."
echo.
timeout /t 1 > nul
rmdir /S /Q .\temp > nul
del .\Umineko-Graphics.zip.00* > nul
del .\Umineko-Voices.zip > nul
del .\Umineko-Update-*.zip > nul
timeout /t 1 > nul

call :colorEcho a0 "All done, finishing in three seconds..."
timeout /t 3 > nul

exit
:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i