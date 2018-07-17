@echo off

set version=v3.1.0

echo Downloading graphics patch... (1 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 https://07th-mod.com/hanyuu/ConsoleArcs-CG.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 https://07th-mod.com/hanyuu/Himatsubushi-UI.7z

echo Downloading voices and sounds... (2 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 https://07th-mod.com/hanyuu/ConsoleArcs-BGM.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 https://07th-mod.com/hanyuu/ConsoleArcs-Voices.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 16 https://07th-mod.com/hanyuu/ConsoleArcs-SE.7z

echo Downloading patch... (3 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/higurashi-console-arcs/releases/download/%version%/ConsoleArcs.Voice.and.Graphics.Patch.%version%.zip

echo Extracting files...
echo.
.\7za.exe x ConsoleArcs-CG.7z -aoa
.\7za.exe x ConsoleArcs-BGM.7z -aoa
.\7za.exe x ConsoleArcs-SE.7z -aoa
.\7za.exe x ConsoleArcs-Voices.7z -aoa
.\7za.exe x ConsoleArcs.Voice.and.Graphics.Patch.*.zip -aoa
.\7za.exe x Himatsubushi-UI*.7z
rmdir /S /Q ..\StreamingAssets\CG
rmdir /S /Q ..\StreamingAssets\CGAlt
ren ..\sharedassets0.assets sharedassets0.assets.backup
ren ..\sharedassets0.assets.resS sharedassets0.assets.resS.backup

echo Moving folders...
echo.
xcopy /E /I /Y .\Managed ..\Managed
xcopy /E /I /Y .\SE ..\StreamingAssets\SE
xcopy /E /I /Y .\CG ..\StreamingAssets\CG
xcopy /E /I /Y .\voice ..\StreamingAssets\voice
xcopy /E /I /Y .\BGM ..\StreamingAssets\BGM
xcopy /E /I /Y .\StreamingAssets ..\StreamingAssets
move .\sharedassets0.assets ..\sharedassets0.assets
move .\sharedassets0.assets.resS ..\sharedassets0.assets.resS
mkdir ..\StreamingAssets\BGMAlt
mkdir ..\StreamingAssets\voiceAlt
mkdir ..\StreamingAssets\SEAlt
del ..\StreamingAssets\CompiledUpdateScripts\*.mg

echo All done, finishing in three seconds...

exit