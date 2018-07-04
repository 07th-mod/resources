@echo off

set version=v0.5.1

echo Downloading voice patch... (1 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Nipah/Himatsubushi-Voices.zip

echo Downloading patch... (2 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/himatsubushi/releases/download/v0.5.1/Himatsubushi.Voice.Patch.v0.5.1.zip

echo Extracting files...
echo.
.\7za.exe x Himatsubushi-Voices.zip -aoa
.\7za.exe x Himatsubushi.Voice.Patch.v0.5.1.zip -aoa

echo Moving folders...
echo.
xcopy /E /I /Y .\voice ..\StreamingAssets\SE
xcopy /E /I /Y .\SE ..\StreamingAssets\SE
xcopy /E /I /Y .\Update ..\StreamingAssets\Update

echo Deleting useless files...
echo.
del .\*.zip
rmdir /S /Q .\SE
rmdir /S /Q .\Update
del ..\StreamingAssets\CompiledUpdateScripts\*.mg
cd ..

echo All done, finishing in three seconds...
rmdir /S /Q .\temp

exit