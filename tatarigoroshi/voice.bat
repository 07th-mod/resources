@echo off

set version=v0.5.2

echo Downloading voice patch... (1 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/nipah/Tatarigoroshi-Voices.zip
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/nipah/Tatarigoroshi-HD.zip

echo Downloading patch... (2 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/tatarigoroshi/releases/download/v0.5.2/Tatarigoroshi.Voice.Patch.v0.5.2.zip

echo Extracting files...
echo.
.\7za.exe x Tatarigoroshi-Voices.zip -aoa
.\7za.exe x Tatarigoroshi.Voice.Patch.v0.5.2.zip -aoa
.\7za.exe x Tatarigoroshi-HD.zip -aoa

echo Moving folders...
echo.
xcopy /E /I /Y .\voice ..\HigurashiEp0*_Data\StreamingAssets\SE
xcopy /E /I /Y .\SE ..\HigurashiEp0*_Data\StreamingAssets\SE
xcopy /E /I /Y .\Update ..\HigurashiEp0*_Data\StreamingAssets\Update
xcopy /E /I /Y .\HigurashiEp0*_Data\StreamingAssets ..\HigurashiEp0*_Data\StreamingAssets

del ..\HigurashiEp0*_Data\StreamingAssets\CompiledUpdateScripts\*.mg

echo All done, finishing in three seconds...

exit