@echo off

rem set version=v1.0.0

cd ..

echo Downloading graphics patch... (1 of 3)
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tsumihoroboshi-CG.7z
rem .\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tsumihoroboshi-CGAlt.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tsumihoroboshi-UI.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tsumihoroboshi-Movie.7z

echo Downloading voice patch... (2 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tsumihoroboshi-Voices.7z

echo Downloading patch... (3 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 http://07th-mod.com/latest.php?repository=tsumihoroboshi

echo Preparing files...
echo.
del .\HigurashiEp06\StreamingAssets\CompiledUpdateScripts\*.mg
ren .\HigurashiEp06_Data\sharedassets0.assets sharedassets0.assets.backup
ren .\HigurashiEp06_Data\sharedassets0.assets.resS sharedassets0.assets.resS.backup
rmdir /S /Q .\HigurashiEp06_Data\StreamingAssets\CG
rem rmdir /S /Q .\HigurashiEp06_Data\StreamingAssets\CGAlt

echo Extracting files...
echo.
rem .\temp\7za.exe x *-CGAlt.7z -aoa
.\temp\7za.exe x *-CG.7z -aoa
.\temp\7za.exe x *-Voices.7z -aoa
.\temp\7za.exe x *.Voice.and.Graphics.Patch.*.zip -aoa
.\temp\7za.exe x *-UI.7z -aoa
.\temp\7za.exe x *-Movie.7z -aoa

echo All done, finishing in three seconds...

exit