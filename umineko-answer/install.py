import os
from time import sleep
from subprocess import call
import platform


def checkError(return_value, help_text):
    if return_value != 0:
        print(help_text)
        input("")

def userSaidYes(message):
    input(message + " [y/n]").lower() in ('y','yes')

def systemIsWindows():
    return platform.system() == 'Windows'


def SCRIPT_FolderCheck():
    #Check installer is run in the correct game directory. wrongFolderForceInstall label happens if user forces install anyway.
    if os.path.exists("arc.nsa"):
        return

    print("WARNING - The selected install directory [{}] doesnt appear to contain the game files.".format(os.path.abspath('.')))

    #only on windows, open the explorer to show the install directory
    if systemIsWindows():
        print('The folder has been opened - please check it contains the game files')
        call(['explorer', '.'])

    if userSaidYes("Do you want to continue the install anyway?"):
       return

    print('You may wish to delete the installer files located at: ')
    print("{}".format(os.path.abspath('.')))
    input("Press enter to quit")
    exit(-1)


def SCRIPT_BackupExeAndScript():
    try:
        os.rename('Umineko5to8.exe','Umineko5to8_old.exe')
        os.rename('0.utf', '0_old.utf')
    except FileExistsError:
        pass

def SCRIPT_Download():
    print("Downloading and verifying all files. You can close and reopen this at any time, your progress will be saved.")

    #aria2c won't retry if it gets a 403 code, so force it to retry continously
    aria2c_return_value = -1
    while aria2c_return_value != 0:
        aria2c_return_value = call([
              r'.\temp\aria2c',
              '--file-allocation=none',
              '--continue=true',
              '--check-integrity=true',
              '--max-concurrent-downloads=1',
              '--retry-wait=5',
              '--max-connection-per-server=8',
              '--follow-metalink=mem',
              'https://github.com/07th-mod/resources/raw/master/umineko-answer/chiru_full.meta4'
        ])

    sleep(1)

def SCRIPT_ExtractFiles():
    print("Extracting files...")
    checkError(
        call([r'.\temp\7za.exe','x','UminekoChiru-Graphics.7z.001', '-aoa']),
        "ERROR An error occured when extracting the graphics files. Please try to run the installer again, and check the game files are not in use"
    )
    sleep(1)

    checkError(
        call([r'.\temp\7za.exe', 'x', 'UminekoChiru-Voices.zip', '-aoa']),
        "ERROR An error occured when extracting the voice files. Please try to run the installer again, and check the game files are not in use"
    )
    sleep(1)

    print("Extraction Finished")

def SCRIPT_Cleanup():
    if userSaidYes("Do you want to delete the temporary install files?"):
        os.remove(r'.\UminekoChiru-Graphics.7z.001')
        os.remove(r'.\UminekoChiru-Graphics.7z.002')
        os.remove(r'.\UminekoChiru-Graphics.7z.003')
        os.remove(r'.\UminekoChiru-Voices.zip')
        print('remove goes here')
        sleep(1)

# ------------------ Script Execution Begins Here -------------------
SCRIPT_FolderCheck()

SCRIPT_BackupExeAndScript()

SCRIPT_Download()

SCRIPT_ExtractFiles()

SCRIPT_Cleanup()

print("All done. Press enter to quit the installer...")
input("")


