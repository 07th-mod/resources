@echo off

set version=v0.1.0

echo Downloading voice patch... (1 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/nipah/Tsumihoroboshi-Voices.zip
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://07th-mod.com/nipah/Tsumihoroboshi-HD.zip

echo Downloading patch... (2 of 2)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/tsumihoroboshi/releases/download/%version%/Tsumihoroboshi.Voice.Patch.%version%.zip

echo Extracting files...
echo.
.\7za.exe x Tsumihoroboshi-Voices.7z -aoa
.\7za.exe x Tsumihoroboshi.Voice.Patch.%version%.zip
.\7za.exe x Tsumihoroboshi-HD.7z -aoa

echo Moving folders...
echo.
xcopy /E /I /Y .\voice ..\HigurashiEp06_Data\StreamingAssets\SE
xcopy /E /I /Y .\SE ..\HigurashiEp06_Data\StreamingAssets\SE
xcopy /E /I /Y .\StreamingAssets ..\HigurashiEp06_Data\StreamingAssets
xcopy /E /I /Y .\HigurashiEp06_Data\StreamingAssets ..\HigurashiEp06_Data\StreamingAssets

del ..\HigurashiEp06_DataStreamingAssets\CompiledUpdateScripts\*.mg

echo All done, finishing in three seconds...

exit