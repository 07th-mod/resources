@echo off

set version=v4.2.0

echo Downloading graphics patch... (1 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-CG.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-CGAlt.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-UI.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-Movie.7z

echo Downloading voice patch... (2 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Himatsubushi-Voices.7z

echo Downloading patch... (3 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/himatsubushi/releases/download/%version%/Himatsubushi.Voice.and.Graphics.Patch.%version%.zip

echo Extracting files...
echo.
.\7za.exe x Himatsubushi-CG.7z -aoa
.\7za.exe x Himatsubushi-CGAlt.7z -aoa
.\7za.exe x Himatsubushi-Voices.7z -aoa
.\7za.exe x Himatsubushi.Voice.and.Graphics.Patch.*.zip -aoa
.\7za.exe x Himatsubushi-UI*.7z
.\7za.exe x Himatsubushi-Movie.7z
rmdir /S /Q ..\StreamingAssets\CG
rmdir /S /Q ..\StreamingAssets\CGAlt
mkdir ..\StreamingAssets\movies
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
move .\mv08.mp4 ..\StreamingAssets\movies\mv08.mp4
mkdir ..\StreamingAssets\BGMAlt
mkdir ..\StreamingAssets\voiceAlt
mkdir ..\StreamingAssets\SEAlt

echo Deleting useless files..."
echo.
rmdir /S /Q .\CG
rmdir /S /Q .\CGAlt
rmdir /S /Q .\StreamingAssets
rmdir /S /Q .\voice
rmdir /S /Q .\spectrum
rmdir /S /Q .\Managed
rmdir /S /Q .\Plugins
del .\*.mp4
del .\*.7z
del .\*.zip
del .\sharedassets0.assets*
del ..\StreamingAssets\CompiledUpdateScripts\*.mg
cd ..

echo All done, finishing in three seconds...
rmdir /S /Q .\temp

exit