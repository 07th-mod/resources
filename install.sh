#!/bin/sh

7z x *-CGAlt.zip
7z x *-CG.zip
7z x *-Voices.zip
7z x *.Voice.and.Graphics.Patch.*.zip -aoa
7z x *-Textboxes.zip -aoa
rm -rf ../CG
rm -rf ../CGAlt
rm -rf ../../Managed/Assembly-CSharp.dll

mv ./Managed/Assembly-CSharp.dll ../../Managed/Assembly-CSharp.dll
mv ./CGAlt ../CGAlt
mv ./CG ../CG
mv ./SE ../voice
mv ./StreamingAssets/Update/* ../Update
mkdir ../BGMAlt
mkdir ../voiceAlt
mkdir ../SEAlt

cd ..
rm -rf ./temp
rm -rf ./CompiledUpdateScripts/*.mg