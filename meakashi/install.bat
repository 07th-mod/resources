@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

call :colorEcho a0 "Downloading graphics patch...  (1 of 3)"
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true -x 16 https://github.com/07th-mod/resources/releases/download/Nipah/Meakashi-CG.zip
.\aria2c.exe --file-allocation=none --continue=true -x 16 https://github.com/07th-mod/resources/releases/download/Nipah/Meakashi-CGAlt.zip
timeout /t 1 > nul

call :colorEcho a0 "Downloading voice patch...  (2 of 3)"
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true -x 16 https://github.com/07th-mod/resources/releases/download/Nipah/Meakashi-Voices.zip
timeout /t 1 > nul

call :colorEcho a0 "Downloading patch...  (3 of 3)"
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true -x 16 https://github.com/07th-mod/meakashi/releases/download/v3.0.0/Meakashi.Voice.and.Graphics.Patch.v3.0.1.zip
.\aria2c.exe --file-allocation=none --continue=true -x 16 https://github.com/07th-mod/resources/releases/download/Nipah/HigurashiKai-Textboxes.zip
timeout /t 1 > nul

call :colorEcho a0 "Extracting files..."
echo.
timeout /t 1 > nul
.\7za.exe x Meakashi-Voices.zip
.\7za.exe x Meakashi-CG.zip
.\7za.exe x Meakashi-CGAlt.zip
echo A | .\7za.exe x Meakashi.Voice.and.Graphics.Patch.*.zip
echo A | .\7za.exe x HigurashiKai-Textboxes.zip
rmdir /S /Q ..\StreamingAssets\CG > nul
rmdir /S /Q ..\StreamingAssets\CGAlt > nul
timeout /t 1 > nul

call :colorEcho a0 "Moving folders..."
echo.
echo D | xcopy /E /Y .\Managed ..\Managed > nul
echo D | xcopy /E /Y .\CGAlt ..\StreamingAssets\CGAlt > nul
echo D | xcopy /E /Y .\CG ..\StreamingAssets\CG > nul
echo D | xcopy /E /Y .\SE ..\StreamingAssets\voice > nul
echo D | xcopy /E /Y .\StreamingAssets ..\StreamingAssets > nul
mkdir ..\StreamingAssets\BGMAlt
mkdir ..\StreamingAssets\voiceAlt
mkdir ..\StreamingAssets\SEAlt

call :colorEcho a0 "Deleting useless files..."
echo.
timeout /t 1 > nul
rmdir /S /Q .\CG > nul
rmdir /S /Q .\CGAlt > nul
rmdir /S /Q .\Update > nul
rmdir /S /Q .\SE > nul
rmdir /S /Q .\Managed > nul
del .\*.zip > nul
del ..\StreamingAssets\CompiledUpdateScripts\*.mg > nul
timeout /t 1 > nul

call :colorEcho a0 "All done, finishing in three seconds..."
timeout /t 3 > nul

exit
:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i