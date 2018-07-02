@echo off

set version=v0.1.0

echo Downloading voice patch... (1 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Nipah/Tsumihoroboshi-Voices.zip

echo Downloading patch... (2 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/tsumihoroboshi/releases/download/%version%/Tsumihoroboshi.Voice.Patch.%version%.zip

echo Extracting files...
echo.
.\7za.exe x Tsumihoroboshi-Voices.7z -aoa
.\7za.exe x Tsumihoroboshi.Voice.Patch.%version%.zip

echo Moving folders...
echo.
xcopy /E /I /Y .\SE ..\StreamingAssets\SE
xcopy /E /I /Y .\StreamingAssets ..\StreamingAssets

echo Deleting useless files...
echo.
del .\*.zip
rmdir /S /Q .\SE
rmdir /S /Q .\StreamingAssets
del ..\StreamingAssets\CompiledUpdateScripts\*.mg
cd ..

echo All done, finishing in three seconds...
rmdir /S /Q .\temp

exit