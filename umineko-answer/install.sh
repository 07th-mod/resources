#!/bin/sh

mv 0.utf 0_old.utf
mv Umineko5to8 Umineko5to8_old
mv saves saves_from_before_patching

aria2c --file-allocation=none --continue=true -x 8 https://07th-mod.com/Bern/Umineko5to8.app.zip

aria2c --file-allocation=none --continue=true --check-integrity=true --max-concurrent-downloads=1 --retry-wait 5 -x 8 --follow-metalink=mem https://github.com/07th-mod/resources/raw/master/umineko-answer/chiru_full.meta4

mv 0.utf 0.u
7z x UminekoChiru-Graphics.7z.001 -aoa
7z x UminekoChiru-Update* -aoa
7z x UminekoChiru-Voices.7z
7z x Umineko5to8.app.zip -aoa

echo Please verify the game works correctly. If it works correctly, you can delete or move UminekoChiru-Graphics.zip.00X, UminekoChiru-Voices.7z, and UminekoChiru-Update.zip
echo Regarding SAVES - Saves are not compatible with the stock game, BUT you can get your chapter progress back.
echo To do this, copy [global.sav] and [envdata] from [saves_from_before_patching] to the [mysav] folder.

# rm -rf ./UminekoChiru-Graphics.7z*
# rm -rf ./UminekoChiru-Voices.7z
# rm -rf ./Umineko5to8.app.zip
# rm -rf ./UminekoChiru-Update*