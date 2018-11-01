#!/bin/sh

mv 0.utf 0_old.utf
mv Umineko1to4 Umineko1to4_old
mv saves saves_from_before_patching

aria2c --file-allocation=none --continue=true -x 8 https://07th-mod.com/Beato/Umineko1to4.app.zip

aria2c --file-allocation=none --continue=true --check-integrity=true --max-concurrent-downloads=1 --retry-wait 5 -x 8 --follow-metalink=mem https://github.com/07th-mod/resources/raw/master/umineko-question/umi_full.meta4

mv 0.utf 0.u
7z x Umineko-Graphics.zip.001 -aoa
7z x Umineko-Voices.7z
7z x Umineko-Update* -aoa
7z x Umineko1to4.app.zip -aoa

# if file is extracted, MacOSX quarantines it into a special read-only folder so it can't access the game files
# the below line _might_ fix the issue by disabling the quarantine.
# see http://lapcatsoftware.com/articles/app-translocation.html
# use sudo fs_usage -wb | grep umineko to diagnose this issue
xattr -d com.apple.quarantine Umineko1to4.app

cp -na "en\bmp\background\r_click" "en\bmp"

echo Please verify the game works correctly. If it works correctly, you can delete or move Umineko-Graphics.zip.00X, Umineko-Voices.7z, and Umineko-Update.zip
echo Regarding SAVES - Saves are not compatible with the stock game, BUT you can get your chapter progress back.
echo To do this, copy global.sav and envdata from saves_from_before_patching to the mysav folder.

# rm -rf ./Umineko-Graphics.zip*
# rm -rf ./Umineko-Voices.7z
# rm -rf ./Umineko-Update*
# rm -rf ./Umineko1to4.app.zip
# rm -rf ./Umineko1to4_for_LINUX.zip