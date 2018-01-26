@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

call :colorEcho 0f "Please wait while pre-install files are downloaded...."
echo.
.\temp\aria2c --file-allocation=none --continue=true -x 8 https://github.com/drojf/PortablePython/releases/download/v0.1/python.7z
.\temp\aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/raw/master/umineko-answer/install.py

call :colorEcho 0f "Extracting pre-install files...."
echo.
.\temp\7za.exe x python.7z -aoa -o.\temp
.\temp\python\python.exe install.py
exit

:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i
EXIT /B 0
