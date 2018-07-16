@echo off

set version=v0.5.1

echo Downloading graphics patch... (1 of 3)
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 http://07th.nijino-yu.me/current/Tsumihoroboshi-CG.7z
rem .\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 http://07th.nijino-yu.me/current/Tsumihoroboshi-CGAlt.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 http://07th.nijino-yu.me/current/Tsumihoroboshi-UI.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 http://07th.nijino-yu.me/current/Tsumihoroboshi-Movie.7z

echo Downloading voice patch... (2 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 http://07th.nijino-yu.me/current/Tsumihoroboshi-Voices.7z

echo Downloading patch... (3 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/Tsumihoroboshi/releases/download/%version%/Tsumihoroboshi.Voice.and.Graphics.Patch.%version%.zip

echo Extracting files...
echo.
.\7za.exe x Tsumihoroboshi-CG.7z -aoa
rem .\7za.exe x Tsumihoroboshi-CGAlt.7z -aoa
.\7za.exe x Tsumihoroboshi-Voices.7z -aoa
.\7za.exe x Tsumihoroboshi.Voice.and.Graphics.Patch.*.zip -aoa
.\7za.exe x Tsumihoroboshi-UI.7z -aoa
.\7za.exe x Tsumihoroboshi-Movie.7z -aoa
rmdir /S /Q ..\StreamingAssets\CG
rmdir /S /Q ..\StreamingAssets\CGAlt
ren ..\sharedassets0.assets sharedassets0.assets.backup
ren ..\sharedassets0.assets.resS sharedassets0.assets.resS.backup

echo Moving folders...
echo.
xcopy /E /I /Y .\Managed ..\Managed
xcopy /E /I /Y .\Plugins ..\Plugins
rem xcopy /E /I /Y .\CGAlt ..\StreamingAssets\CGAlt
xcopy /E /I /Y .\CG ..\StreamingAssets\CG
xcopy /E /I /Y .\voice ..\StreamingAssets\voice
xcopy /E /I /Y .\spectrum ..\StreamingAssets\spectrum
xcopy /E /I /Y .\StreamingAssets ..\StreamingAssets
move .\TsumiUI-Windows\sharedassets0.assets ..\sharedassets0.assets
move .\TsumiUI-Windows\sharedassets0.assets.resS ..\sharedassets0.assets.resS
mkdir ..\StreamingAssets\BGMAlt
mkdir ..\StreamingAssets\voiceAlt
mkdir ..\StreamingAssets\SEAlt
del ..\StreamingAssets\CompiledUpdateScripts\*.mg

echo All done, finishing in three seconds...

exit