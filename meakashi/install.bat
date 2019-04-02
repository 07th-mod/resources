@echo off

rem set version=v4.1.2

cd ..

echo Downloading graphics patch... (1 of 3)
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Meakashi-CG.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Meakashi-CGAlt.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Meakashi-UI.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Meakashi-Movie.7z

echo Downloading voice patch... (2 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Meakashi-Voices.7z

echo Downloading patch... (3 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 http://07th-mod.com/latest.php?repository=meakashi

echo Preparing files...
echo.
del .\HigurashiEp05_Data\StreamingAssets\CompiledUpdateScripts\*.mg

if exist .\HigurashiEp05_Data\sharedassets0.assets.backup (
    goto skip
) else (
    ren .\HigurashiEp05_Data\sharedassets0.assets sharedassets0.assets.backup
    ren .\HigurashiEp05_Data\sharedassets0.assets.resS sharedassets0.assets.resS.backup
)

:skip
rmdir /S /Q .\HigurashiEp05_Data\StreamingAssets\CG
rmdir /S /Q .\HigurashiEp05_Data\StreamingAssets\CGAlt

echo Extracting files...
echo.
.\temp\7za.exe x *-CGAlt.7z -aoa
.\temp\7za.exe x *-CG.7z -aoa
.\temp\7za.exe x *-Voices.7z -aoa
.\temp\7za.exe x *.Voice.and.Graphics.Patch.*.zip -aoa
REM .\temp\7za.exe x *-UI.7z -aoa
.\temp\7za.exe x *-Movie.7z -aoa

echo All done, finishing in three seconds...

exit
