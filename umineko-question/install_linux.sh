#!/bin/bash

# checks if the user provided any input for the directory, if not, uses default steam folder
if [ $# -gt 0 ]; then
	game="$1"
else
	game="$HOME/.local/share/Steam/steamapps/common/Umineko When They Cry - Question Arcs/"
fi

# checks if the game executable exists
if [ ! -e "$game/Umineko1to4" -a ! -e "$game/Umineko1to4.exe" ]; then
	printf "Please rerun the script with correct path for the game directory. e.g. ./$(basename $0) games/umineko"
	exit 1
fi

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
aria2c --console-log-level=error --dir=temp --file-allocation=none --continue=true --check-integrity=true --max-concurrent-downloads=1 --retry-wait 5 -x 8 --follow-metalink=mem https://github.com/07th-mod/resources/raw/master/umineko-question/umi_full.meta4 --save-session temp/out.txt
has_error=$(wc -l < temp/out.txt)
while [ $has_error -gt 0 ]
do
	aria2c --console-log-level=error --dir=temp --file-allocation=none --continue=true --check-integrity=true --max-concurrent-downloads=1 --retry-wait 5 -x 8 --follow-metalink=mem https://github.com/07th-mod/resources/raw/master/umineko-question/umi_full.meta4 --save-session temp/out.txt
	has_error=$(wc -l < temp/out.txt)
  	sleep 10
done
aria2c --console-log-level=error --dir=temp --file-allocation=none --continue=true -x 8 https://github.com/07th-mod/resources/releases/download/Beato/Umineko1to4

# backups the script and executable, if they exist
if [ -e 0.utf ]; then
    mv 0.utf 0.utf.old
fi
if [ -e Umineko1to4 ]; then
	mv Umineko1to4 Umineko1to4.old
fi

# extracts, creates, and moves the necessary files and folders
#ln -s saves mysav
printf '\n\nExtracting the archives...\n\n'
mkdir -p mysav
mv temp/0.utf 0.u
mv temp/Umineko1to4 Umineko1to4
7za x temp/Umineko-Graphics.zip.001 -aoa
7za x temp/Umineko-Voices.7z
7za x temp/Umineko-Update-04_2018.zip -aoa
cp -na "en/bmp/background/r_click" "en/bmp"

chmod +x Umineko1to4

# cleans everything
printf '\n\nTemporary installer files are listed below:\n '
ls -ogh temp | cut -d' ' -f3-
while true; do
	printf "\n"
    read -p 'Do you want to delete these temporary files? (Y/n)  ' yn
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