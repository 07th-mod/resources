@echo off

rem set version=v3.1.0

cd ..

echo Downloading graphics patch... (1 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/rikachama/ConsoleArcs-CG.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/rikachama/Himatsubushi-UI.7z

echo Downloading voices and sounds... (2 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/rikachama/ConsoleArcs-BGM.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/rikachama/ConsoleArcs-Voices.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/rikachama/ConsoleArcs-SE.7z

echo Downloading patch... (3 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 http://07th-mod.com/latest.php?repository=higurashi-console-arcs

echo Preparing files...
echo.
del .\HigurashiEp04_Data\StreamingAssets\CompiledUpdateScripts\*.mg
ren .\HigurashiEp04_Data\sharedassets0.assets sharedassets0.assets.backup
ren .\HigurashiEp04_Data\sharedassets0.assets.resS sharedassets0.assets.resS.backup
rmdir /S /Q .\HigurashiEp04_Data\StreamingAssets\CG
rmdir /S /Q .\HigurashiEp04_Data\StreamingAssets\CGAlt

echo Extracting files...
echo.
rem .\temp\7za.exe x *-CGAlt.7z -aoa
.\temp\7za.exe x *-CG.7z -aoa
.\temp\7za.exe x *-BGM.7z -aoa
.\temp\7za.exe x *-SE.7z -aoa
.\temp\7za.exe x *-Voices.7z -aoa
.\temp\7za.exe x *.Voice.and.Graphics.Patch.*.zip -aoa
.\temp\7za.exe x *-UI.7z -aoa
rem .\temp\7za.exe x *-Movie.7z -aoa

echo All done, finishing in three seconds...

exit