@echo off

rem set version=v5.2.1

cd ..

echo Downloading graphics patch... (1 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tatarigoroshi-CG.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tatarigoroshi-CGAlt.7z
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tatarigoroshi-Movie.7z

if exist .\steam_api.dll (
    .\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tatarigoroshi-UI.7z
) else (
    if exist .\gog.ico (
        .\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tatarigoroshi-UI.7z
    ) else (
        .\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tatarigoroshi-UI_MG.7z
    )
)

echo Downloading voice patch... (2 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 -s 8 https://07th-mod.com/rikachama/Tatarigoroshi-Voices.7z

echo Downloading patch... (3 of 3)
echo.
.\temp\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 http://07th-mod.com/latest.php?repository=tatarigoroshi

echo Preparing files...
echo.
del .\HigurashiEp03_Data\StreamingAssets\CompiledUpdateScripts\*.mg

if exist .\HigurashiEp03_Data\sharedassets0.assets.backup (
    goto skip
) else (
    ren .\HigurashiEp03_Data\sharedassets0.assets sharedassets0.assets.backup
    ren .\HigurashiEp03_Data\sharedassets0.assets.resS sharedassets0.assets.resS.backup
)

:skip
rmdir /S /Q .\HigurashiEp03_Data\StreamingAssets\CG
rmdir /S /Q .\HigurashiEp03_Data\StreamingAssets\CGAlt

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
