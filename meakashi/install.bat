@echo off

set version=v4.1.2

echo Downloading graphics patch... (1 of 3)
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/hanyuu/Meakashi-CG.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/hanyuu/Meakashi-CGAlt.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/hanyuu/Meakashi-UI.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/hanyuu/Meakashi-Movie.7z

echo Downloading voice patch... (2 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/hanyuu/Meakashi-Voices.7z

echo Downloading patch... (3 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/Meakashi/releases/download/%version%/Meakashi.Voice.and.Graphics.Patch.%version%.zip

echo Extracting files...
echo.
.\7za.exe x Meakashi-CG.7z -aoa
.\7za.exe x Meakashi-CGAlt.7z -aoa
.\7za.exe x Meakashi-Voices.7z -aoa
.\7za.exe x Meakashi.Voice.and.Graphics.Patch.*.zip -aoa
.\7za.exe x Meakashi-UI.7z -aoa
.\7za.exe x Meakashi-Movie.7z -aoa
rmdir /S /Q ..\StreamingAssets\CG
rmdir /S /Q ..\StreamingAssets\CGAlt
ren ..\sharedassets0.assets sharedassets0.assets.backup
ren ..\sharedassets0.assets.resS sharedassets0.assets.resS.backup

echo Moving folders...
echo.
xcopy /E /I /Y .\Managed ..\Managed
xcopy /E /I /Y .\Plugins ..\Plugins
xcopy /E /I /Y .\CGAlt ..\StreamingAssets\CGAlt
xcopy /E /I /Y .\CG ..\StreamingAssets\CG
xcopy /E /I /Y .\voice ..\StreamingAssets\voice
xcopy /E /I /Y .\StreamingAssets ..\StreamingAssets
move .\sharedassets0.assets ..\sharedassets0.assets
move .\sharedassets0.assets.resS ..\sharedassets0.assets.resS
mkdir ..\StreamingAssets\BGMAlt
mkdir ..\StreamingAssets\voiceAlt
mkdir ..\StreamingAssets\SEAlt
del ..\StreamingAssets\CompiledUpdateScripts\*.mg

echo All done, finishing in three seconds...

exit