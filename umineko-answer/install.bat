@echo off

::installer may execute batch file from temporary directory - if this is the case, move one folder higher to install into game directory
if exist "..\arc.nsa" (
    if not exist "arc.nsa" (
        echo INFO: Batch file was run from temp directory - changing directory to game directory root...
        echo.
        cd ..
    )
)

if not exist ".\temp\aria2c.exe" (
    echo ERROR: aria2c not found in temp folder - installation cancelled
    EXIT /B 0
)

if not exist ".\temp\7za.exe" (
    echo ERROR: 7za not found in temp folder - installation cancelled
    EXIT /B 0
)

::add a readme to the temp directory
echo Writing readme to temp folder...
echo.
echo "Files in this folder can be deleted after install. You can also back them up incase you need to re-install later. Try playing the game first before deleting anything!" > "temp/README - Temp folder can be deleted or backed up after install.txt"

echo Backing up exe and script files...
echo.
move /Y Umineko5to8.exe Umineko5to8_backup.exe || echo INFO - Couldn't backup exe - continuing install anyway
echo.
move /Y 0.utf 0_backup.utf || echo INFO - Couldn't backup script file - continuing install anyway
echo.

echo Downloading and verifying all files. You can close and reopen this at any time, your progress will be saved.
echo Please ignore any Checksum Warnings - they always occur when a file is first downloaded or the download is resumed.
echo.

::aria2c won't retry if it gets a 403 code, so force it to retry continously
:downloadLoop    
.\temp\aria2c --console-log-level=error --file-allocation=none --continue=true --check-integrity=true --max-concurrent-downloads=1 --retry-wait 5 -x 8 --follow-metalink=mem https://github.com/07th-mod/resources/raw/master/umineko-answer/chiru_full.meta4 --dir=temp || (timeout /t 3 && goto :downloadLoop)

::Begin copying, extraction, and renaming
echo Copying umineko5to8.exe and script file...
copy /Y temp\Umineko5to8.exe .
copy /Y temp\0.utf 0.u
echo.

echo Renaming saves folder...
ren saves mysav || echo INFO - Couldn't rename saves folder - continuing install anyway
echo.

echo Extracting Graphics...
.\temp\7za.exe x temp\UminekoChiru-Graphics.7z.001 -aoa || echo ERROR during graphics extraction. Check the game files are not in use. && goto :installFailed

echo Extracting Voices...
.\temp\7za.exe x temp\UminekoChiru-Voices.7z -aoa || echo ERROR during voices extraction. Check the game files are not in use. && goto :installFailed

echo Extracting Updates...
.\temp\7za.exe x temp\UminekoChiru-Update* -aoa || echo ERROR during updates extraction. Check the game files are not in use. && goto :installFailed

::open the temp folder so users can delete/backup any temp install files
echo Opening temp folder for user to clean-up manually...
explorer temp

echo All done, finishing in three seconds
timeout /t 3

exit /B %ERRORLEVEL%

:installFailed    
echo ERROR - An installation step failed! Installation cancelled!
exit /B %ERRORLEVEL%
