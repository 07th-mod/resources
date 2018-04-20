@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

set version=v2.1.0

call :colorEcho a0 "Downloading graphics patch... (1 of 4)"
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Nipah/ConsoleArcs-CG.zip
timeout /t 1 > nul

call :colorEcho a0 "Downloading voices and sounds... (2 of 4)"
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Nipah/ConsoleArcs-BGM.zip
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Nipah/ConsoleArcs-voice.zip
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Nipah/ConsoleArcs-SE.zip
timeout /t 1 > nul

call :colorEcho a0 "Downloading patch... (3 of 4)"
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/higurashi-console-arcs/releases/download/%version%/ConsoleArcs.Voice.and.Graphics.Patch.%version%.zip
timeout /t 1 > nul

call :colorEcho a0 "Checking for incomplete downloads... (4 of 4)"
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/higurashi-console-arcs/releases/download/%version%/ConsoleArcs.Voice.and.Graphics.Patch.%version%.zip
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Nipah/ConsoleArcs-BGM.zip
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Nipah/ConsoleArcs-voice.zip
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Nipah/ConsoleArcs-SE.zip
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Nipah/ConsoleArcs-CG.zip


call :colorEcho a0 "Extracting files..."
echo.
timeout /t 1 > nul
.\7za.exe x ConsoleArcs-CG.zip
.\7za.exe x ConsoleArcs-BGM.zip
.\7za.exe x ConsoleArcs-SE.zip
.\7za.exe x ConsoleArcs-voice.zip
.\7za.exe x ConsoleArcs.Voice.and.Graphics.Patch.*.zip
rmdir /S /Q ..\StreamingAssets\CG > nul
rmdir /S /Q ..\StreamingAssets\CGAlt > nul
timeout /t 1 > nul

call :colorEcho a0 "Moving folders..."
echo.
echo D | xcopy /E /Y .\Managed ..\Managed > nul
echo D | xcopy /E /Y .\SE ..\StreamingAssets\SE > nul
echo D | xcopy /E /Y .\CG ..\StreamingAssets\CG > nul
echo D | xcopy /E /Y .\voice ..\StreamingAssets\voice > nul
echo D | xcopy /E /Y .\BGM ..\StreamingAssets\BGM > nul
echo D | xcopy /E /Y .\StreamingAssets ..\StreamingAssets > nul
mkdir ..\StreamingAssets\BGMAlt
mkdir ..\StreamingAssets\voiceAlt
mkdir ..\StreamingAssets\SEAlt

call :colorEcho a0 "Deleting useless files..."
echo.
timeout /t 1 > nul
rmdir /S /Q .\CG > nul
rmdir /S /Q .\StreamingAssets > nul
rmdir /S /Q .\voice > nul
rmdir /S /Q .\Managed > nul
rmdir /S /Q .\SE > nul
rmdir /S /Q .\BGM > nul
del .\*.zip > nul
del ..\StreamingAssets\CompiledUpdateScripts\*.mg > nul
timeout /t 1 > nul

call :colorEcho a0 "All done, finishing in three seconds..."
timeout /t 3 > nul
cd ..
rmdir /S /Q .\temp > nul

exit
:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i
