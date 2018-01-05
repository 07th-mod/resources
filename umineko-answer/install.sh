#!/bin/sh

mv 0.utf 0_old.utf

aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.001
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.002
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Graphics.7z.003
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-Voices.zip
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Bern/Umineko5to8.app.zip
aria2c --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/umineko-answer/blob/master/0.utf

7z x UminekoChiru-Graphics.zip.001 -aoa
7z x UminekoChiru-Voices.zip
7z x Umineko5to8.app.zip -aoa

rm -rf ./UminekoChiru-Graphics.zip*
rm -rf ./UminekoChiru-Voices.zip
rm -rf ./Umineko5to8.app.zip
