@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

set version=v4.1.0

call :colorEcho a0 "Downloading graphics patch... (1 of 3)"
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-CG.7z
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-CGAlt.7z

REM if exist ..\..\steam_api.dll (
    REM .\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-UI.7z
    REM goto :continue
REM ) else (
    REM .\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-UI_MG.7z
    REM goto :continue
REM )

:continue
call :colorEcho a0 "Downloading voice patch... (2 of 3)"
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-Voices.7z
timeout /t 1 > nul

call :colorEcho a0 "Downloading patch... (3 of 3)"
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/himatsubushi/releases/download/%version%/Himatsubushi.Voice.and.Graphics.Patch.%version%.zip
timeout /t 1 > nul

call :colorEcho a0 "Checking for incomplete downloads..."
echo.
timeout /t 1 > nul
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/himatsubushi/releases/download/%version%/Himatsubushi.Voice.and.Graphics.Patch.%version%.zip
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-Voices.7z
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-CG.7z
.\aria2c.exe --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-CGAlt.7z
timeout /t 1 > nul

call :colorEcho a0 "Extracting files..."
echo.
timeout /t 1 > nul
.\7za.exe x Himatsubushi-CG.7z -aoa
.\7za.exe x Himatsubushi-CGAlt.7z -aoa
.\7za.exe x Himatsubushi-Voices.7z -aoa
.\7za.exe x Himatsubushi.Voice.and.Graphics.Patch.*.zip -aoa
REM .\7za.exe x Himatsubushi-UI*.7z
rmdir /S /Q ..\StreamingAssets\CG > nul
rmdir /S /Q ..\StreamingAssets\CGAlt > nul
REM ren ..\sharedassets0.assets sharedassets0.assets.backup
REM ren ..\sharedassets0.assets.resS sharedassets0.assets.resS.backup
timeout /t 1 > nul

call :colorEcho a0 "Moving folders..."
echo.
echo D | xcopy /E /Y .\Managed ..\Managed > nul
echo D | xcopy /E /Y .\CGAlt ..\StreamingAssets\CGAlt > nul
echo D | xcopy /E /Y .\CG ..\StreamingAssets\CG > nul
echo D | xcopy /E /Y .\voice ..\StreamingAssets\voice > nul
echo D | xcopy /E /Y .\StreamingAssets ..\StreamingAssets > nul
REM echo F | xcopy /Y .\sharedassets0.assets ..\sharedassets0.assets > nul
REM echo F | xcopy /Y .\sharedassets0.assets.resS ..\sharedassets0.assets.resS > nul
mkdir ..\StreamingAssets\BGMAlt
mkdir ..\StreamingAssets\voiceAlt
mkdir ..\StreamingAssets\SEAlt

call :colorEcho a0 "Deleting useless files..."
echo.
timeout /t 1 > nul
rmdir /S /Q .\CG > nul
rmdir /S /Q .\CGAlt > nul
rmdir /S /Q .\StreamingAssets > nul
rmdir /S /Q .\voice > nul
rmdir /S /Q .\spectrum > nul
rmdir /S /Q .\Managed > nul
del .\*.7z > nul
del .\*.zip > nul
REM del .\sharedassets0.assets* > nul
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
