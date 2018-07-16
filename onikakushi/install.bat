@echo off

set version=v5.7.0

echo Downloading graphics patch... (1 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 http://07th.nijino-yu.me/current/Onikakushi-CG.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 http://07th.nijino-yu.me/current/Onikakushi-CGAlt.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 http://07th.nijino-yu.me/current/Onikakushi-UI.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 http://07th.nijino-yu.me/current/Onikakushi-Movie.7z

echo Downloading voice patch... (2 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 http://07th.nijino-yu.me/current/Onikakushi-Voices.7z

echo Downloading patch... (3 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/onikakushi/releases/download/%version%/Onikakushi.Voice.and.Graphics.Patch.%version%.zip

echo Extracting files...
echo.
.\7za.exe x Onikakushi-CGAlt.7z -aoa
.\7za.exe x Onikakushi-CG.7z -aoa
.\7za.exe x Onikakushi-Voices.7z -aoa
.\7za.exe x Onikakushi.Voice.and.Graphics.Patch.*.zip -aoa
.\7za.exe x Onikakushi-UI.7z -aoa
.\7za.exe x Onikakushi-Movie.7z -aoa
rmdir /S /Q ..\StreamingAssets\CG
rmdir /S /Q ..\StreamingAssets\CGAlt
ren ..\sharedassets0.assets sharedassets0.assets.backup

echo Moving folders...
echo.
xcopy /E /I /Y .\Managed ..\Managed
xcopy /E /I /Y .\Plugins ..\Plugins
xcopy /E /I /Y .\CGAlt ..\StreamingAssets\CGAlt
xcopy /E /I /Y .\CG ..\StreamingAssets\CG
xcopy /E /I /Y .\voice ..\StreamingAssets\voice
xcopy /E /I /Y .\spectrum ..\StreamingAssets\spectrum
xcopy /E /I /Y .\movies ..\StreamingAssets\movies
xcopy /E /I /Y .\StreamingAssets ..\StreamingAssets
move .\sharedassets0.assets ..\sharedassets0.assets
mkdir ..\StreamingAssets\BGMAlt
mkdir ..\StreamingAssets\voiceAlt
mkdir ..\StreamingAssets\SEAlt
del ..\StreamingAssets\CompiledUpdateScripts\*.mg

echo All done, finishing in three seconds...

exit
