#!/bin/sh

mv 0.utf 0_old.utf
mv Umineko1to4 Umineko1to4_old
mv saves mysav

aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Graphics.zip.001
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Graphics.zip.002
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Graphics.zip.003
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Voices.7z
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko1to4.app.zip
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/umineko-question/raw/master/InDevelopment/ManualUpdates/0.utf
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Update-v1.zip
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Update-v2.zip
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko-Update-v3.zip
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko1to4

mv 0.utf 0.u
7z x Umineko-Graphics.zip.001 -aoa
7z x Umineko-Voices.7z
7z x Umineko-Update-v1.zip -aoa
7z x Umineko-Update-v2.zip -aoa
7z x Umineko-Update-v3.zip -aoa
7z x Umineko1to4.app.zip -aoa

cp -na "en\bmp\background\r_click" "en\bmp"

rm -rf ./Umineko-Graphics.zip*
rm -rf ./Umineko-Voices.7z
rm -rf ./Umineko-Update-*.zip
rm -rf ./Umineko1to4.app.zip
rm -rf ./Umineko1to4_for_LINUX.zip