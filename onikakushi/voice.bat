@echo off

set version=v0.9.0

echo Downloading voice patch... (1 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/nipah/Onikakushi-Voices.zip
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/nipah/Onikakushi-HD.zip

echo Downloading patch... (2 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/onikakushi/releases/download/v0.9.0/Onikakushi.Voice.Patch.v0.9.0.zip

echo Extracting files...
echo.
.\7za.exe x Onikakushi-Voices.zip -aoa
.\7za.exe x Onikakushi.Voice.Patch.v0.9.0.zip -aoa
.\7za.exe x Onikakushi-HD.zip -aoa

echo Moving folders...
echo.
xcopy /E /I /Y .\voice ..\StreamingAssets\SE
xcopy /E /I /Y .\SE ..\StreamingAssets\SE
xcopy /E /I /Y .\Update ..\StreamingAssets\Update
xcopy /E /I /Y .\HigurashiEp0*_Data\StreamingAssets ..\StreamingAssets

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