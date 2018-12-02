import os, shutil, platform, glob
from subprocess import call

def systemUI():
    if platform.system() == 'Windows':
        call([r'aria2c', '--file-allocation=none', '--continue=true', '--retry-wait=5', '-m 0', '-x 8', '-s 8', 'https://07th-mod.com/rikachama/Watanagashi-UI.7z'])
    else:
        call([r'aria2c', '--file-allocation=none', '--continue=true', '--retry-wait=5', '-m 0', '-x 8', '-s 8', 'https://07th-mod.com/rikachama/Watanagashi-UI_UNIX.7z'])       

def backupUI():
    try:
        os.rename('./HigurashiEp02_Data/sharedassets0.assets','./HigurashiEp02_Data/sharedassets0.assets.backup')
    #    os.rename('./HigurashiEp02_Data/sharedassets0.assets.resS', './HigurashiEp02_Data/sharedassets0.assets.resS.backup')
    except FileExistsError:
        pass

def cleanOld():
    old_CG = "./HigurashiEp02_Data/StreamingAssets/CG"
    old_CGAlt = "./HigurashiEp02_Data/StreamingAssets/CGAlt"

    for mg in glob.glob('./HigurashiEp02_Data/StreamingAssets/CompiledUpdateScripts/*.mg'):
            os.remove(mg)
    
    if os.path.isdir(old_CG):
        shutil.rmtree(old_CG)
        
    if os.path.isdir(old_CGAlt):
        shutil.rmtree(old_CGAlt)

def download():
    arguments = [
        r'aria2c',
        '--file-allocation=none',
        '--continue=true',
        '--retry-wait=5',
        '-m 0',
        '-x 8',
        '-s 8',
        '-j 1',
        '--input-file=watanagashi.zip',
    ]
    
    call(arguments)
    os.remove("./watanagashi.zip")

def extractFiles():
    files = [
        "*-CGAlt.7z",
        "*-CG.7z",
        "*-Voices.7z",
        "*.Voice.and.Graphics.Patch.*.zip",
        "*-UI.7z",
        "*-Movie.7z",
    ]
    for file in files:
        call([r'7z', 'x', file, '-aoa'])

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