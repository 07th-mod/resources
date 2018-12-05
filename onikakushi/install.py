import os, shutil, platform, glob
from subprocess import call

def systemUI():
    if platform.system() == 'Windows':
        call([r'aria2c', '--file-allocation=none', '--continue=true', '--retry-wait=5', '-m 0', '-x 8', '-s 8', 'https://07th-mod.com/rikachama/Onikakushi-UI.7z'])
    else:
        call([r'aria2c', '--file-allocation=none', '--continue=true', '--retry-wait=5', '-m 0', '-x 8', '-s 8', 'https://07th-mod.com/rikachama/Onikakushi-UI_UNIX.7z'])       

def backupUI():
    try:
        os.rename('./HigurashiEp01_Data/sharedassets0.assets','./HigurashiEp01_Data/sharedassets0.assets.backup')
    #    os.rename('./HigurashiEp01_Data/sharedassets0.assets.resS', './HigurashiEp01_Data/sharedassets0.assets.resS.backup')
    except FileExistsError:
        pass

def cleanOld():
    base_path = "./HigurashiEp01_Data"

    if platform.system() == 'Darwin':
        base_path = "./Data"

    old_CG = os.path.join(base_path, "StreamingAssets/CG")
    old_CGAlt = os.path.join(base_path, "StreamingAssets/CGAlt")
    compiled_scripts_pattern = os.path.join(base_path, "StreamingAssets/CompiledUpdateScripts/*.mg") 

    for mg in glob.glob(compiled_scripts_pattern):
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
        '--input-file=onikakushi.zip',
    ]
    
    call(arguments)
    os.remove("./onikakushi.zip")

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

def macSync()
    if platform.system() == 'Windows' or platform.system() == 'Linux':
        pass
    else:
        sync = [
            r'rsync',
            '-avP',
            '/Higurashi*/*',
            './Contents/Resources/Data/',
        ]
    
        leftovers = "./HigurashiEp01_Data"
        if os.path.isdir(leftovers):
            shutil.rmtree(leftovers)


print("Downloading patch files...")
systemUI()
download()
print("Backing up UI...")
backupUI()
print("Removing unnecessary folders and files...")
cleanOld()
print("Installing patch...")
extractFiles()
macSync()

print("All done, the patch was successfully installed.")