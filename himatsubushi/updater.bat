@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

:start
call :colorEcho a0 "Comparing local version to remote version..." && echo:
timeout /t 3 > nul 
if exist local.txt (
    goto :compare
) else (
    echo No information about the local version found. Downloading the newest remote version available...
    goto :update
)

:compare
call :colorEcho a0 "Downloading remote information for comparison"
timeout /t 3 > nul
powershell -command "(convertfrom-json (invoke-webrequest https://api.github.com/repos/07th-mod/himatsubushi/releases/latest).content).assets.browser_download_url | set-content remote.txt"
fc remote.txt local.txt > nul
if errorlevel 1 goto :newver

:samever
echo Looks like you have the latest version already installed, nothing to do here...
del remote.txt
exit

:newver
echo New version found, redirecting to download and installation...
goto :download

:update
call :colorEcho a0 "Downloading latest patch..." && echo:
powershell -command "(convertfrom-json (invoke-webrequest https://api.github.com/repos/07th-mod/himatsubushi/releases/latest).content).assets.browser_download_url | set-content remote.txt"
goto :download

:download
.\aria2c.exe --file-allocation=none --continue=true -x 8 -i remote.txt
del local.txt
ren remote.txt local.txt
goto :install

:install
call :colorEcho a0 "Extracting files..."
echo.
timeout /t 1 > nul
.\7za.exe x *.Voice.and.Graphics.Patch.*.zip

call :colorEcho a0 "Moving folders..."
echo.
echo D | xcopy /E /Y .\Managed ..\Managed > nul
echo D | xcopy /E /Y .\StreamingAssets ..\StreamingAssets > nul

call :colorEcho a0 "Deleting leftovers..."
echo.
rmdir /S /Q .\StreamingAssets > nul
rmdir /S /Q .\Managed > nul
del ..\StreamingAssets\CompiledUpdateScripts\*.mg > nul
del *.zip

exit
:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i
