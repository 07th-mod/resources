#!/bin/bash

# checks if the user provided any input for the directory, if not, uses default steam folder
if [ $# -gt 0 ]; then
	game="$1"
else
	game="$HOME/.local/share/Steam/steamapps/common/Umineko Chiru/"
fi

# checks if the game executable exists
if [ ! -e "$game/Umineko5to8" -a ! -e "$game/Umineko5to8.exe" ]; then
	printf "Please rerun the script with correct path for the game directory. e.g. ./$(basename $0) games/umineko\ chiru"
	exit 1
fi

# asks if the user wants to install adv mode
printf "\n"
while true; do
	read -p "Do you wish to install the ADV Mode (textbox at bottom of screen like in the PS3 Game)? It's still in beta. (Y/n) " yn
	case $yn in
    	[Nn]* ) adv=1; break;;
   		[Yy]* ) adv=0; break;;
    	'' ) adv=0; break;;
	esac
done
printf "\n\n"

cd "$game"
mkdir -p temp 		# creates a temporary folder for the archives and binaries

# checks if the user has aria2 or p7zip installed, if not, downloads the binaries and assigns them to functions
if [ ! $(command -v aria2c 2>/dev/null) ]; then
	printf 'Downloading aria2...\n\n'
	curl -L 'https://github.com/q3aql/aria2-static-builds/releases/download/v1.33.1/aria2-1.33.1-linux-gnu-32bit-build1.tar.bz2' > temp/aria2-1.33.1-linux-gnu-32bit-build1.tar.bz2
	tar -C temp -xf temp/aria2-1.33.1-linux-gnu-32bit-build1.tar.bz2 aria2-1.33.1-linux-gnu-32bit-build1/aria2c 
	function aria2c { 
		./temp/aria2-1.33.1-linux-gnu-32bit-build1/aria2c "$@"
	}
fi
if [ ! $(command -v 7za 2>/dev/null) ]; then
	printf 'Downloading 7zip...\n\n'
	curl -L 'https://sourceforge.net/projects/p7zip/files/p7zip/16.02/p7zip_16.02_x86_linux_bin.tar.bz2/download' > temp/p7zip_16.02_x86_linux_bin.tar.bz2
	tar -C temp -xf temp/p7zip_16.02_x86_linux_bin.tar.bz2 p7zip_16.02/bin/7za 
	function 7za { 
		./temp/p7zip_16.02/bin/7za "$@" 
	}
fi

# downloads the patch files
printf 'Downloading patch archives...\n\n'
aria2c --console-log-level=error --dir=temp --file-allocation=none --continue=true --check-integrity=true --max-concurrent-downloads=1 --retry-wait 5 -x 8 --follow-metalink=mem https://github.com/07th-mod/resources/raw/master/umineko-answer/chiru_full.meta4 --save-session temp/out.txt
has_error=$(wc -l < temp/out.txt)
while [ $has_error -gt 0 ]
do
	aria2c --console-log-level=error --dir=temp --file-allocation=none --continue=true --check-integrity=true --max-concurrent-downloads=1 --retry-wait 5 -x 8 --follow-metalink=mem https://github.com/07th-mod/resources/raw/master/umineko-answer/chiru_full.meta4 --save-session temp/out.txt
	has_error=$(wc -l < temp/out.txt)
  	sleep 10
done

if [ $adv -eq 0 ]; then
	aria2c --console-log-level=error --dir=temp --file-allocation=none --continue=true -x 8 --retry-wait 5 https://github.com/07th-mod/umineko-answer/raw/adv_mode/0.utf -o 0_adv.utf
	aria2c --console-log-level=error --dir=temp --file-allocation=none --continue=true -x 8 --retry-wait 5 https://github.com/07th-mod/resources/releases/download/Bern/UminekoChiru-ADV_Mode.7z
fi

aria2c --console-log-level=error --dir=temp --file-allocation=none --continue=true -x 8 --retry-wait 5 https://github.com/07th-mod/resources/releases/download/Bern/Umineko5to8

# backups the script and executable, if they exist
if [ -e 0.utf ]; then
    mv 0.utf 0.utf.old
fi
if [ -e Umineko5to8 ]; then
	mv Umineko5to8 Umineko5to8.old
fi

# moves the files from the temp folder, also checks for adv mode
#ln -s saves mysav
mkdir -p mysav
mv temp/Umineko5to8 Umineko5to8
if [ $adv -eq 0 ]; then
	mv temp/0_adv.utf 0.u
	mv temp/0.utf 0_nvl.utf
	cp -n fonts fontsbackup
else
	mv temp/0.utf 0.u
fi

# extracts archives
printf '\n\nExtracting the archives...\n\n'
7za x temp/UminekoChiru-Graphics.7z.001 -aoa
7za x temp/UminekoChiru-Voices.7z
7za x temp/UminekoChiru-Update-v1.zip -aoa	
if [ $adv -eq 0 ]; then
	7za x temp/UminekoChiru-ADV_Mode.7z -aoa
fi

chmod +x Umineko5to8

# cleans everything
printf '\n\nTemporary installer files are listed below:\n '
ls -ogh temp | cut -d' ' -f3-
printf "\n"
while true; do
    read -p 'Do you want to delete these temporary files? (Y/n) ' yn
    case $yn in
        [Nn]* ) break;;
        [Yy]* ) rm -rf temp; break;;
        '' ) rm -rf temp; break;;
    esac
done

# opens the game directory if 'xdg-open' exists
if [ $(command -v xdg-open 2>/dev/null) ]; then
	printf '\nOpening the game folder...'
	sleep 1
	xdg-open .
fi