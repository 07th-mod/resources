@echo off

set version=v0.5.0

echo Downloading voice patch... (1 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/nipah/Meakashi-Voices.zip
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/nipah/Meakashi-HD.zip

echo Downloading patch... (2 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/meakashi/releases/download/v0.5.0/Meakashi.Voice.Patch.v0.5.0.zip

echo Extracting files...
echo.
.\7za.exe x Meakashi-Voices.zip -aoa
.\7za.exe x Meakashi.Voice.Patch.v0.5.0.zip -aoa
.\7za.exe x Meakashi-HD.zip -aoa

echo Moving folders...
echo.
xcopy /E /I /Y .\voice ..\HigurashiEp05_Data\StreamingAssets\SE
xcopy /E /I /Y .\SE ..\HigurashiEp05_Data\StreamingAssets\SE
xcopy /E /I /Y .\Update ..\HigurashiEp05_Data\StreamingAssets\Update
xcopy /E /I /Y .\HigurashiEp05_Data\StreamingAssets ..\HigurashiEp05_Data\StreamingAssets

del ..\HigurashiEp05_Data\StreamingAssets\CompiledUpdateScripts\*.mg

echo All done, finishing in three seconds...

exit