#!/bin/sh

mv 0.utf 0_old.utf
mv Umineko5to8 Umineko5to8_old
mv saves mysav

aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.001
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.002
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.003
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Update-v1.zip
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Voices.7z
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/Umineko5to8.app.zip
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/umineko-answer/blob/master/0.utf
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/Umineko5to8

mv 0.utf 0.u
7z x UminekoChiru-Graphics.7z.001 -aoa
7z x UminekoChiru-Update-* -aoa
7z x UminekoChiru-Voices.7z
7z x Umineko5to8.app.zip -aoa

rm -rf ./UminekoChiru-Graphics.7z*
rm -rf ./UminekoChiru-Voices.7z
rm -rf ./Umineko5to8.app.zip
rm -rf ./UminekoChiru-Update-*.zip