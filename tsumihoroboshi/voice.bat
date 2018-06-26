@echo off

set version=v0.1.0

echo Downloading voice patch... (1 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/Tsumihoroboshi-Voices.7z

echo Downloading patch... (2 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/tsumihoroboshi/releases/download/%version%/Tsumihoroboshi.Voice.Patch.%version%.zip

echo Extracting files...
echo.
.\7za.exe x Tsumihoroboshi-Voices.7z -aoa
.\7za.exe x Tsumihoroboshi.Voice.Patch.%version%.zip

echo Moving folders...
echo.
echo D | xcopy /E /Y .\voice ..\StreamingAssets\SE
echo D | xcopy /E /Y .\StreamingAssets ..\StreamingAssets

echo Deleting useless files...
echo.
del .\*.7z
del .\*.zip
rmdir /S /Q .\voice
rmdir /S /Q .\StreamingAssets
del ..\StreamingAssets\CompiledUpdateScripts\*.mg
cd ..
rmdir /S /Q .\temp

echo All done, finishing in three seconds...

exit