@echo off

set version=v5.2.1

echo Downloading graphics patch... (1 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Tatarigoroshi-CG.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Tatarigoroshi-CGAlt.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Wata_Tata-Movie.7z

if exist ..\..\steam_api.dll (
    .\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Tatarigoroshi-UI.7z
) else (
    .\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Tatarigoroshi-UI_MG.7z
)

echo Downloading voice patch... (2 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Tatarigoroshi-Voices.7z

echo Downloading patch... (3 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/tatarigoroshi/releases/download/%version%/Tatarigoroshi.Voice.and.Graphics.Patch.%version%.zip

echo Extracting files...
echo.
.\7za.exe x Tatarigoroshi-CGAlt.7z -aoa
.\7za.exe x Tatarigoroshi-Voices.7z -aoa
.\7za.exe x Tatarigoroshi-CG.7z -aoa
.\7za.exe x Tatarigoroshi.Voice.and.Graphics.Patch.*.zip -aoa
.\7za.exe x Tatarigoroshi-UI*.7z -aoa
.\7za.exe x Wata_Tata-Movie.7z -aoa
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
xcopy /E /I /Y .\spectrum ..\StreamingAssets\spectrum
xcopy /E /I /Y .\StreamingAssets ..\StreamingAssets
move .\sharedassets0.assets ..\sharedassets0.assets
move .\sharedassets0.assets.resS ..\sharedassets0.assets.resS
move .\mv07.mp4 ..\StreamingAssets\movies\mv07.mp4
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