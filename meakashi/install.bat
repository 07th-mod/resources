@echo off

set version=v4.1.1

echo Downloading graphics patch... (1 of 3)
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Meakashi-CG.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Meakashi-CGAlt.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Meakashi-UI.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Meakashi-Movie.7z

echo Downloading voice patch... (2 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Meakashi-Voices.7z

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
echo D | xcopy /E /Y .\Managed ..\Managed
echo D | xcopy /E /Y .\CGAlt ..\StreamingAssets\CGAlt
echo D | xcopy /E /Y .\CG ..\StreamingAssets\CG
echo D | xcopy /E /Y .\voice ..\StreamingAssets\voice
echo D | xcopy /E /Y .\StreamingAssets ..\StreamingAssets
echo F | xcopy /Y .\sharedassets0.assets ..\sharedassets0.assets
echo F | xcopy /Y .\sharedassets0.assets.resS ..\sharedassets0.assets.resS
mkdir ..\StreamingAssets\BGMAlt
mkdir ..\StreamingAssets\voiceAlt
mkdir ..\StreamingAssets\SEAlt

echo Deleting useless files...
echo.
rmdir /S /Q .\CG
rmdir /S /Q .\CGAlt
rmdir /S /Q .\StreamingAssets
rmdir /S /Q .\voice
rmdir /S /Q .\spectrum
rmdir /S /Q .\Managed
del .\*.7z
del .\*.zip
del .\sharedassets0.assets*
del ..\StreamingAssets\CompiledUpdateScripts\*.mg
cd ..
rmdir /S /Q .\temp

echo All done, finishing in three seconds...

exit