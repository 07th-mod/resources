import os, shutil, platform
from subprocess import call

def systemUI():
    if platform.system() == 'Windows':
        call([r'.\temp\aria2c', '--file-allocation=none', '--continue=true', '--retry-wait=5', '-m 0', '-x 8', '-s 8', 'https://07th-mod.com/rikachama/Himatsubushi-UI.7z'])
    else:
        call([r'.\temp\aria2c', '--file-allocation=none', '--continue=true', '--retry-wait=5', '-m 0', '-x 8', '-s 8', 'https://07th-mod.com/rikachama/Himatsubushi-UI_UNIX.7z'])       

def backupUI():
    try:
        os.rename('./HigurashiEp04_Data/sharedassets0.assets','./HigurashiEp04_Data/sharedassets0.assets.backup')
        os.rename('./HigurashiEp04_Data/sharedassets0.assets.resS', './HigurashiEp04_Data/sharedassets0.assets.resS.backup')
    except FileExistsError:
        pass

def cleanCG():
    old_CG = "./HigurashiEp04_Data/StreamingAssets/CG"
    old_CGAlt = "./HigurashiEp04_Data/StreamingAssets/CGAlt"
    old_CompiledUpdate = "./HigurashiEp04_Data/StreamingAssets/CompiledUpdateScripts"
    
    if os.path.isdir(old_CG) and os.path.isdir(old_CGAlt):
        shutil.rmtree(old_CG)
        shutil.rmtree(old_CGAlt)

    for file in os.listdir("./HigurashiEp04_Data/StreamingAssets/CompiledUpdateScripts"):
        file_path = os.path.join(old_CompiledUpdate, file)
        if os.path.isfile(file_path):
            os.remove(file_path)

def aria2c():
    arguments = [
        r'./temp/aria2c',
        '--file-allocation=none',
        '--continue=true',
        '--retry-wait=5',
        '-m 0',
        '-x 8',
        '-s 8',
        '-j 1',
        '--input-file=console.zip',
    ]
    
    call(arguments)
    os.remove("./console.zip")

def extractFiles():
    files = [
        "*-SE.7z",
        "*-CG.7z",
        "*-Voices.7z",
        "*.Voice.and.Graphics.Patch.*.zip",
        "*-UI.7z",
        "*-BGM.7z",
    ]
    for x in range(0,6):
        call([r'.\temp\7za.exe','x', files[x], '-aoa'])

print("Downloading patch files...")
systemUI()
aria2c()
print("Backing up UI...")
backupUI()
print("Removing unnecessary folders and files...")
cleanCG()
print("Installing patch...")
extractFiles()

print("All done, the patch was successfully installed.")