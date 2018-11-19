import os, shutil, platform, glob
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

def cleanOld():
    old_CG = "./HigurashiEp04_Data/StreamingAssets/CG"
    old_CGAlt = "./HigurashiEp04_Data/StreamingAssets/CGAlt"

    for mg in glob.glob('./HigurashiEp04_Data/StreamingAssets/CompiledUpdateScripts/*.mg'):
            os.remove(mg)
    
    if os.path.isdir(old_CG):
        shutil.rmtree(old_CG)
        
    if os.path.isdir(old_CGAlt):
        shutil.rmtree(old_CGAlt)

def download():
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
    for file in files:
        call([r'.\tmp\7za.exe', 'x', file, '-aoa'])

print("Downloading patch files...")
systemUI()
download()
print("Backing up UI...")
backupUI()
print("Removing unnecessary folders and files...")
cleanOld()
print("Installing patch...")
extractFiles()

print("All done, the patch was successfully installed.")