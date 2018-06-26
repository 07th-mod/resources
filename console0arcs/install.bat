@echo off

set version=v3.1.0

echo Downloading graphics patch... (1 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/ConsoleArcs-CG.7z

echo Downloading voices and sounds... (2 of 3)
echo.
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/ConsoleArcs-BGM.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/ConsoleArcs-Voices.7z
.\aria2c.exe --file-allocation=none --continue=true --retry-wait 5 -m 0 -x 8 https://github.com/07th-mod/resources/releases/download/Hanyuu/ConsoleArcs-SE.7z

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
rmdir /S /Q ..\StreamingAssets\CG
rmdir /S /Q ..\StreamingAssets\CGAlt

echo Moving folders...
echo.
echo D | xcopy /E /Y .\Managed ..\Managed
echo D | xcopy /E /Y .\SE ..\StreamingAssets\SE
echo D | xcopy /E /Y .\CG ..\StreamingAssets\CG
echo D | xcopy /E /Y .\voice ..\StreamingAssets\voice
echo D | xcopy /E /Y .\BGM ..\StreamingAssets\BGM
echo D | xcopy /E /Y .\StreamingAssets ..\StreamingAssets
mkdir ..\StreamingAssets\BGMAlt
mkdir ..\StreamingAssets\voiceAlt
mkdir ..\StreamingAssets\SEAlt

echo Deleting useless files...
echo.
rmdir /S /Q .\CG
rmdir /S /Q .\StreamingAssets
rmdir /S /Q .\voice
rmdir /S /Q .\Managed
rmdir /S /Q .\SE
rmdir /S /Q .\BGM
del .\*.zip
del .\*.7z
del ..\StreamingAssets\CompiledUpdateScripts\*.mg
cd ..

echo All done, finishing in three seconds...
rmdir /S /Q .\temp

exit