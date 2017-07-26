@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

call :colorEcho a0 "Downloading graphics patch..."
echo.
call :colorEcho 0a "Sometimes you won't get a download ETA or file size, but the download will be completed normally"
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true https://github.com/07th-mod/resources/releases/download/Nipah/Meakashi-CG.zip
timeout /t 1 > nul

call :colorEcho a0 "Downloading MangaGamer sprites patch..."
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true https://github.com/07th-mod/resources/releases/download/Nipah/Meakashi-CGAlt.zip
timeout /t 1 > nul

call :colorEcho a0 "Downloading voice patch..."
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true https://github.com/07th-mod/resources/releases/download/Nipah/Meakashi-Voices.zip
timeout /t 1 > nul

call :colorEcho a0 "Downloading patch..."
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true https://github.com/07th-mod/meakashi/releases/download/v1.5.2/Meakashi.Voice.and.Graphics.Patch.v1.5.2.zip
timeout /t 1 > nul

call :colorEcho a0 "Extracting files..."
echo.
timeout /t 1 > nul
.\7za.exe x Meakashi-Voices.zip
.\7za.exe x Meakashi-CG.zip
.\7za.exe x Meakashi-CGAlt.zip
echo A | .\7za.exe x Meakashi.Voice.and.Graphics.Patch.v1.5.2.zip
rmdir /S /Q ..\CG > nul
rmdir /S /Q ..\CGAlt > nul
timeout /t 1 > nul

call :colorEcho a0 "Moving folders..."
echo.
echo D | xcopy /E /Y .\CG ..\CG > nul
echo D | xcopy /E /Y .\CGAlt ..\CGAlt > nul
echo D | xcopy /E /Y .\SE ..\SE > nul
echo D | xcopy /E /Y .\Update ..\Update > nul

call :colorEcho a0 "Deleting useless files..."
echo.
timeout /t 1 > nul
rmdir /S /Q .\CG > nul
rmdir /S /Q .\CGAlt > nul
rmdir /S /Q .\Update > nul
rmdir /S /Q .\SE > nul
del .\*.zip > nul
del ..\CompiledUpdateScripts\*.mg > nul
timeout /t 1 > nul

call :colorEcho a0 "All done, finishing in three seconds..."
timeout /t 3 > nul

exit
:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i