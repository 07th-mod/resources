@echo off

rem set version=v5.7.1

cd ..

echo Downloading graphics patch... (1 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/rikachama/Onikakushi-CG.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/rikachama/Onikakushi-CGAlt.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/rikachama/Onikakushi-UI.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/rikachama/Onikakushi-Movie.7z

echo Downloading voice patch... (2 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/rikachama/Onikakushi-Voices.7z

echo Downloading patch... (3 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 http://07th-mod.com/latest.php?repository=onikakushi

echo Preparing files...
echo.
del .\HigurashiEp01\StreamingAssets\CompiledUpdateScripts\*.mg
ren .\HigurashiEp01_Data\sharedassets0.assets sharedassets0.assets.backup
rem ren .\HigurashiEp01_Data\sharedassets0.assets.resS sharedassets0.assets.resS.backup
rmdir /S /Q .\HigurashiEp01_Data\StreamingAssets\CG
rmdir /S /Q .\HigurashiEp01_Data\StreamingAssets\CGAlt

echo Extracting files...
echo.
.\temp\7za.exe x *-CGAlt.7z -aoa
.\temp\7za.exe x *-CG.7z -aoa
.\temp\7za.exe x *-Voices.7z -aoa
.\temp\7za.exe x *.Voice.and.Graphics.Patch.*.zip -aoa
.\temp\7za.exe x *-UI.7z -aoa
.\temp\7za.exe x *-Movie.7z -aoa

echo All done, finishing in three seconds...

exit