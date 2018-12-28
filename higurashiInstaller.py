#!/usr/bin/python
from __future__ import print_function, unicode_literals, with_statement
import sys, os, os.path as path, platform, shutil, glob, subprocess, json
import pprint
pp = pprint.PrettyPrinter(indent=4)
try:
	from urllib.request import urlopen, Request
	from urllib.error import HTTPError
except ImportError:
	from urllib2 import urlopen, Request, HTTPError

try:
	import tkinter
	from tkinter import filedialog
	from tkinter import Listbox
	from tkinter import messagebox
except ImportError:
	import Tkinter as tkinter
	from Tkinter import tkFileDialog as filedialog
	from Tkinter import tkMessageBox as messagebox
	from Tkinter import Listbox

# Python 2 Compatibility
try: input = raw_input
except NameError: pass

try:
	"".decode("utf-8")
	def decodeStr(string):
		return string.decode("utf-8")
except AttributeError:
	def decodeStr(string):
		return string

def exitWithError():
	""" On Windows, prevent window closing immediately when exiting with error. Other plaforms just exit. """
	print("ERROR: The installer cannot continue. Press any key to exit...")
	if IS_WINDOWS:
		input()
	sys.exit(1)

def findWorkingExecutablePath(executable_paths, flags):
	"""
	Try to execute each path in executable_paths to see which one can be called and returns exit code 0
	The 'flags' argument is any extra flags required to make the executable return 0 exit code
	:param executable_paths: a list [] of possible executable paths (eg. "./7za", "7z")
	:param flags: any extra flags like "-h" required to make the executable have a 0 exit code
	:return: the path of the valid executable, or None if no valid executables found
	"""
	with open(os.devnull, 'w') as os_devnull:
		for path in executable_paths:
			try:
				if subprocess.call([path, flags], stdout=os_devnull) == 0:
					print("Found valid executable:", path)
					return path
			except:
				pass

	return None

###################################### Executable detection and Installation ###########################################

# If you double-click on the file in Finder on macOS, it will not open with a path that is near the .py file
# Since we want to properly find things like `./aria2c`, we should move to that path first.
dirname = os.path.dirname(sys.argv[0])
if dirname.strip():
	os.chdir(dirname)

# Define constants used throughout the script. Use function calls to enforce variables as const
IS_WINDOWS = platform.system() == "Windows"
IS_LINUX = platform.system() == "Linux"
IS_MAC = platform.system() == "Darwin"

#query available executables. If any installation of executables is done in the python script, it must be done
#before this executes
ARIA_EXECUTABLE = findWorkingExecutablePath(["./aria2c", "aria2c"], '-h')
if ARIA_EXECUTABLE is None:
	# TODO: automatically download and install dependencies
	print("ERROR: aria2c executable not found (aria2c). Please install the dependencies for your platform.")
	exitWithError()

SEVEN_ZIP_EXECUTABLE = findWorkingExecutablePath(["./7za", "7za", "./7z", "7z"], '-h')
if SEVEN_ZIP_EXECUTABLE is None:
	# TODO: automatically download and install dependencies
	print("ERROR: 7-zip executable not found (7za or 7z). Please install the dependencies for your platform.")
	exitWithError()

#when calling this function, use named arguments to avoid confusion!
def aria(downloadDir=None, inputFile=None, url=None):
	"""
	Calls aria2c with some default arguments:
	TODO: list what each default argument does as comments next to arguments array?

	:param downloadDir: The directory to store the downloaded file(s)
	:param inputFile: The path to a file containing multiple URLS to download (see aria2c documentation)
	"""
	arguments = [
		ARIA_EXECUTABLE,
		"--file-allocation=none",
		'--continue=true',
		'--retry-wait=5',
		'-m 0',
		'-x 8',
		'-s 8',
		'-j 1',
		'--follow-metalink=mem',  #always follow metalinks, for now
		'--check-integrity=true', #check integrity when using metalink
	]

	#Add an extra command line argument if the function argument has been provided
	if downloadDir:
		arguments.append('-d ' + downloadDir)

	if inputFile:
		arguments.append('--input-file=' + inputFile)

	if url:
		arguments.append(url)

	subprocess.call(arguments)

def sevenZipExtract(archive_path, outputDir=None):
	arguments = [SEVEN_ZIP_EXECUTABLE, "x", archive_path, "-aoa"]
	if outputDir:
		arguments.append('-o' + outputDir)
	subprocess.call(arguments)

####################################### TKINTER Functions and Classes ##################################################
# see http://effbot.org/tkinterbook/tkinter-dialog-windows.htm
class ListChooserDialog:

	def __init__(self, parent, listEntries, guiPrompt, allowManualFolderSelection):
		"""
		NOTE: do not call this constructor directly. Use the ListChooserDialog.showDialog function instead.
		"""
		self.top = tkinter.Toplevel(parent)
		defaultPadding = {"padx":20, "pady":10}

		# Set a description for this dialog (eg "Please choose a game to mod"
		tkinter.Label(self.top, text=guiPrompt).pack()

		# Define the main listbox to hold the choices given by the 'listEntries' parameter
		listboxFrame = tkinter.Frame(self.top)

		# Define a scrollbar and a listbox. The yscrollcommand is so that the listbox can control the scrollbar
		scrollbar = tkinter.Scrollbar(listboxFrame, orient=tkinter.VERTICAL)
		self.listbox = Listbox(listboxFrame, selectmode=tkinter.BROWSE, yscrollcommand=scrollbar.set)

		# Also configure the scrollbar to control the listbox, and pack it
		scrollbar.config(command=self.listbox.yview)
		scrollbar.pack(side=tkinter.RIGHT, fill=tkinter.Y)

		# Setting width to 0 forces auto-resize of listbox see: https://stackoverflow.com/a/26504193/848627
		for item in listEntries:
			self.listbox.insert(tkinter.END, item)
		self.listbox.config(width=0)
		self.listbox.pack(side=tkinter.LEFT, fill=tkinter.BOTH, expand=1)

		# Finally, pack the Frame so its contents are displayed on the dialog
		listboxFrame.pack(**defaultPadding)

		# If the user is allowed to choose a directory manually, add directory chooser button
		if allowManualFolderSelection:
			b2 = tkinter.Button(self.top, text="Choose Folder Manually", command=self.showDirectoryChooser)
			b2.pack(**defaultPadding)

		# Add an 'OK' button. When pressed, the dialog is closed
		b = tkinter.Button(self.top, text="OK", command=self.ok)
		b.pack(**defaultPadding)

		# This variable stores the returned value from the dialog
		self.result = None

	def showDirectoryChooser(self):
		if IS_MAC:
			self.result = filedialog.askopenfilename(filetypes=[(None, "com.apple.application")])
		else:
			self.result = filedialog.askdirectory()
		self.top.destroy()

	def ok(self):
		"""
		This function is called when the 'OK' button is pressed. It retrieves the value of the currently selected item,
		then closes the dialog
		:return:
		"""
		selected_value = None

		if len(self.listbox.curselection()) > 0:
			selected_index = self.listbox.curselection()[0]
			selected_value = self.listbox.get(selected_index)

		self.result = selected_value

		self.top.destroy()

	@staticmethod
	def showDialog(rootGUIWindow, choiceList, guiPrompt, allowManualFolderSelection):
		"""
		Static helper function to show dialog and get a return value. Arguments are the same as constructor
		:param rootGUIWindow: the parent tkinter object of the dialog (can be root window)
		:param choiceList: a list of strings that the user is to choose from
		:param guiPrompt: the description that will be shown on the dialog
		:param allowManualFolderSelection: if true, user is allowed to select a folder manually.
		:return: returns the value the user selected (string), or None if none available
		"""
		d = ListChooserDialog(rootGUIWindow, choiceList, guiPrompt, allowManualFolderSelection)
		rootGUIWindow.wait_window(d.top)
		return d.result

########################################## Installer Functions  and Classes ############################################
class Installer:
	def __init__(self, directory, info):
		"""
		Installer Init

		:param str directory: The directory of the game
		:param dict info: The info dictionary from server JSON file for the requested target
		"""
		self.directory = directory
		self.info = info

		if IS_MAC:
			self.dataDirectory = path.join(self.directory, "Contents/Resources/Data")
		else:
			self.dataDirectory = path.join(self.directory, info["dataname"])

		self.assetsDir = path.join(self.dataDirectory, "StreamingAssets")

		if path.exists(path.join(self.directory, "steam_api.dll")):
			self.isSteam = True
		else:
			self.isSteam = False

		self.downloadDir = info["name"] + "Download"

	def backupUI(self):
		"""
		Backs up the `sharedassets0.assets` file
		"""
		uiPath = path.join(self.dataDirectory, "sharedassets0.assets")
		backupPath = path.join(self.dataDirectory, "sharedassets0.assets.backup")
		if path.exists(uiPath) and not path.exists(backupPath):
			os.rename(uiPath, backupPath)

	def cleanOld(self):
		"""
		Removes folders that shouldn't persist through the install
		(CompiledUpdateScripts, CG, and CGAlt)
		"""
		oldCG = path.join(self.assetsDir, "CG")
		oldCGAlt = path.join(self.assetsDir, "CGAlt")
		compiledScriptsPattern = path.join(self.assetsDir, "CompiledUpdateScripts/*.mg")

		for mg in glob.glob(compiledScriptsPattern):
			os.remove(mg)

		if path.isdir(oldCG):
			shutil.rmtree(oldCG)

		if path.isdir(oldCGAlt):
			shutil.rmtree(oldCGAlt)

	def download(self):
		"""
		Downloads the required files for the mod.
		- The JSON file contains the list of files for each platform to download (see the constructor of this class).
		- This function first selects the appropriate section of the JSON file, depending on the current platform
		- Then, the URLs listed in the JSON file are written out to a file called 'downloadList.txt'
		- Finally, aria2c is called to download the files listed in 'downloadList.txt'
		"""
		if IS_WINDOWS:
			try:
				files = self.info["files"]["win"]
			except KeyError:
				if self.isSteam:
					files = self.info["files"]["win-steam"]
				else:
					files = self.info["files"]["win-mg"]
		else:
			try:
				files = self.info["files"]["unix"]
			except KeyError:
				if self.isSteam:
					files = self.info["files"]["unix-steam"]
				else:
					files = self.info["files"]["unix-mg"]
		try:
			os.mkdir(self.downloadDir)
		except OSError:
			pass
		fileList = open("downloadList.txt", "w")
		for file in files:
			fileList.write(file + "\n")
		fileList.close()

		aria(downloadDir=self.downloadDir, inputFile='downloadList.txt')

		os.remove("downloadList.txt")

	def extractFiles(self):
		"""
		Extracts downloaded files using 7zip: "Overwrite All existing files without prompt."
		"""
		for file in sorted(os.listdir(self.downloadDir)):
			sevenZipExtract(path.join(self.downloadDir, file))

	def moveFilesIntoPlace(self, fromDir=None, toDir=None):
		"""
		Moves files from the directory they were extracted to
		to the game data folder

		fromDir and toDir are for recursion, leave them at their defaults to start the process
		"""
		if fromDir is None: fromDir = self.info["dataname"]
		if toDir is None: toDir = self.dataDirectory

		for file in os.listdir(fromDir):
			src = path.join(fromDir, file)
			target = path.join(toDir, file)
			if path.isdir(src):
				if not path.exists(target):
					os.mkdir(target)
				self.moveFilesIntoPlace(fromDir=src, toDir=target)
			else:
				if path.exists(target):
					os.remove(target)
				shutil.move(src, target)
		os.rmdir(fromDir)

	def cleanup(self):
		"""
		General cleanup and other post-install things

		Removes downloaded 7z files
		On mac, modifies the application Info.plist with new values if available
		"""
		try:
			shutil.rmtree(self.downloadDir)
		except OSError:
			pass

		if IS_MAC:
			# Allows fixing up application Info.plist file so that the titlebar doesn't show `Higurashi01` as the name of the application
			# Can also add a custom CFBundleIdentifier to change the save directory (e.g. for Console Arcs)
			infoPlist = path.join(self.directory, "Contents/Info.plist")
			infoPlistJSON = subprocess.check_output(["plutil", "-convert", "json", "-o", "-", infoPlist])
			parsed = json.loads(infoPlistJSON)
			if "CFBundleName" in self.info and parsed["CFBundleName"] != self.info["CFBundleName"]:
				subprocess.call(["plutil", "-replace", "CFBundleName", "-string", self.info["CFBundleName"], infoPlist])
			if "CFBundleIdentifier" in self.info and parsed["CFBundleIdentifier"] != self.info["CFBundleIdentifier"]:
				subprocess.call(["plutil", "-replace", "CFBundleIdentifier", "-string", self.info["CFBundleIdentifier"], infoPlist])

def getModList(jsonURL):
	"""
	Gets the list of available mods from the 07th Mod server

	:return: A list of mod info objects
	:rtype: list[dict]
	"""
	try:
		file = urlopen(Request(jsonURL, headers={"User-Agent": ""}))
	except HTTPError as error:
		print(error)
		print("Couldn't reach 07th Mod Server to download patch info")
		print("Note that we have blocked Japan from downloading (VPNs are compatible with this installer, however)")
		exitWithError()
	info = json.load(file)
	file.close()
	return info

def findPossibleGamePathsWindows():
	"""
	Blindly retrieve all game folders in the `Steam\steamappps\common` folder (no filtering is performed)
	TODO: scan other locations than just the steamapps folder
	:return: a list of absolute paths, which are the folders in the `Steam\steamappps\common` folder
	:rtype: list[str]
	"""
	try:
		import winreg
	except ImportError:
		import _winreg as winreg

	registrySteamPath = None
	try:
		registryKey = winreg.OpenKey(winreg.HKEY_CURRENT_USER, r'Software\Valve\Steam')
		registrySteamPath, _regType = winreg.QueryValueEx(registryKey, 'SteamPath')
		winreg.CloseKey(registryKey)
	except WindowsError:
		print("findPossibleGamePaths: Couldn't read Steam registry key - Steam not installed?")
		return []

	# normpath added so returned paths have consistent slash directions (registry key has forward slashes on Win...)
	try:
		for root, dirs, _files in os.walk(os.path.join(registrySteamPath, r'steamapps\common')):
			return [os.path.normpath(os.path.join(root, x)) for x in dirs]
	except:
		print("findPossibleGamePaths: Couldn't open registry key folder - Steam folder deleted?")
		return []


def findPossibleGamePaths():
	"""
	If supported, searches the computer for things that might be Higurashi games
	Currently only does things on Mac OS
	TODO: Find ways to search for games on other platforms

	:return: A list of game paths that might be Higurashi games
	:rtype: list[str]
	"""
	allPossibleGamePaths = []

	if IS_WINDOWS:
		allPossibleGamePaths.extend(findPossibleGamePathsWindows())

	if IS_MAC:
		allPossibleGamePaths.extend(
			x for x in subprocess
				.check_output(["mdfind", "kind:Application", "Higurashi"])
				.decode("utf-8")
				.split("\n") if x
		)

	#if all methods fail, return empty list
	return sorted(allPossibleGamePaths)

def getGameNameFromGamePath(gamePath, modList):
	"""
	Given the path to a game folder, gets the name of the game in the folder, ONLY if a mod exists for that game
	The returned name will match the 'dataname' field in the JSON file, or be None type if no name could be determined.

	:param str gamePath: The path to the game folder
	:param list[dict] modList: The list of available mods (used for finding game names)
	:return: The name of the game , or None if no game was matched
	:rtype: str or None
	"""
	name = None

	if IS_MAC:
		try:
			info = subprocess.check_output(["plutil", "-convert", "json", "-o", "-", path.join(gamePath, "Contents/Info.plist")])
			parsed = json.loads(info)
			name = parsed["CFBundleExecutable"] + "_Data"
		except (OSError, KeyError):
			return None
	else:
		#create a set data structure, containing all the mod data folder names
		allModDataFolders = set([mod["dataname"] for mod in modList])
		try:
			for file in os.listdir(gamePath):
				if file in allModDataFolders:
					name = file
					break
		except:
			print("getGameNameFromGamePath failed on path [{}]".format(gamePath))

	if name is None:
		return None

	for mod in modList:
		if mod["dataname"] == name:
			return mod["target"]
	return None

def findInstalledGames(modList):
	"""
	Find moddable games
	Uses findPossibleGames and therefore will support finding games on the same platforms it does
	TODO: consider removal of this function, since it's only called in one place.
	:param list[dict] modList: The list of available mods
	:return: A list of games that were found and moddable
	:rtype: list[str]
	"""
	return [path for path in findPossibleGamePaths() if getGameNameFromGamePath(path, modList) is not None]

def promptChoice(rootGUIWindow, choiceList, guiPrompt, canOther=False):
	"""
	Prompts the user to choose from a list
	:param list[str] choiceList: The list of choices
	:param str guiPrompt: The prompt to use in GUI mode
	:param str textPrompt: The prompt to use in CLI mode.  Note that the user will be directed to select from a list of integers representing options so please mention that.
	:param bool canOther: Whether or not to give the user an Other option, which will instruct them to give a path to an application
	:param str textPromptWithOther: The text prompt to use if there's both options and the `Other` option available.  If `canOther` is true, `textPrompt` will be used if there are only options (so it's just Other) and this will be used otherwise.  If `canOther` is false, this will be ignored.
	:return: The string that the user selected, or if canOther is true, possibly a path that was not in the option list
	:rtype: str
	"""
	result = ListChooserDialog.showDialog(rootGUIWindow, choiceList, guiPrompt, allowManualFolderSelection=canOther)
	if not result:
		exitWithError()

	return decodeStr(result)

def printSupportedGames(modList):
	"""
	Prints a list of games that have mods available for them
	:param list[dict] modList: The list of available mods
	"""
	print("Supported games:")
	for game in set(x["target"] for x in modList):
		print("  " + game)


def main():
	print("Getting latest mod info...")
	modList = getModList("http://07th-mod.com/installer/higurashi.json")
	foundGames = findInstalledGames(modList)

	#gameToUse is the path to the game install directory, for example "C:\games\Steam\steamapps\common\Higurashi 02 - Watanagashi"
	gameToUse = promptChoice(
		rootGUIWindow = rootWindow,
		choiceList=foundGames,
		guiPrompt="Please choose a game to mod",
		canOther=True
	)

	#target name, for example 'Watanagashi', that the user has selected
	targetName = getGameNameFromGamePath(gameToUse, modList)
	if not targetName:
		print(gameToUse + " does not appear to be a supported higurashi game.")
		printSupportedGames(modList)
		exitWithError()

	print("targetName", targetName)

	# Using the targetName (eg. 'Watanagashi'), check which mods have a matching name
	# Multiple mods may be returned (eg the 'full' patch and 'voice only' patch may have the same 'target' name
	possibleMods = [x for x in modList if x["target"] == targetName]
	if len(possibleMods) > 1:
		modName = promptChoice(
			rootGUIWindow = rootWindow,
			choiceList=[x["name"] for x in possibleMods],
			guiPrompt="Please choose a mod to install")
		mod = [x for x in possibleMods if x["name"] == modName][0]
	else:
		mod = possibleMods[0]

	installer = Installer(gameToUse, mod)
	print("Downloading...")
	installer.download()
	print("Extracting...")
	installer.backupUI()
	installer.cleanOld()
	installer.extractFiles()
	print("Moving files into place...")
	installer.moveFilesIntoPlace()
	print("Done!")
	installer.cleanup()

################################################## UMINEKO INSTALL #####################################################

UMINEKO_ANSWER_MODS = ["mod_voice_only", "mod_full_patch", "mod_adv_mode"]
UMINEKO_QUESTION_MODS = ["mod_voice_only", "mod_full_patch", "mod_1080p_beta"]
umi_debug_mode = False

# You can use the 'exist_ok' of python3 to do this already, but not in python 2
def makeDirsExistOK(directoryToMake):
	try:
		os.makedirs(directoryToMake)
	except OSError:
		pass

def uminekoDownload(downloadTempDir, url_list):
	print("Downloading:{} to {}".format(url_list, downloadTempDir))
	makeDirsExistOK(downloadTempDir)

	for url in url_list:
		print("will try to download {} into {} ".format(url, downloadTempDir))
		if not umi_debug_mode:
			aria(downloadTempDir, url=url)

#NOTE: this function makes some assumptions about the archive files:
# - all archive files have either the extension .7z, .zip (or both)
# - the archives are intended to be extracted in the order: 'graphics' 'voices' 'update', then any other type of archive
def uminekoExtract(fromDir, toDir):
	def sortingFunction(filenameAnyCase):
		filename = filenameAnyCase.lower()
		if 'graphics' in filename:
			return 0
		elif 'voices' in filename:
			return 1
		elif 'update' in filename:
			return 2
		else:
			return 3

	print("extracting from {} to {}".format(fromDir, toDir))

	archives = []
	otherFiles = []

	for filename in os.listdir(fromDir):
		if '.7z' in filename.lower() or '.zip' in filename.lower():
			archives.append(filename)
		else:
			otherFiles.append(filename)

	#sort the archive files so they are extracted in the correct order
	archives.sort(key=sortingFunction)

	for archive_name in archives:
		archive_path = path.join(fromDir, archive_name)
		print("Trying to extract file {} to {}".format(archive_path, toDir))
		if not umi_debug_mode:
			sevenZipExtract(archive_path, outputDir=toDir)

	#copy all non-archive files to the game folder. If a .utf file is found, rename it depending on the OS
	for sourceFilename in otherFiles:
		fileNameNoExt, extension = os.path.splitext(sourceFilename)

		destFilename = sourceFilename

		#on any OS besides MAC, rename 0.utf files to 0.u files. On mac, leave filenames unchanged.
		if not IS_MAC and extension.lower() == '.utf':
			destFilename = fileNameNoExt + '.u'

		sourceFullPath = os.path.join(fromDir, sourceFilename)
		destFullPath = os.path.join(toDir, destFilename)

		print("Trying to copy", sourceFullPath, "to", destFullPath)
		shutil.copy(sourceFullPath, destFullPath)

def deleteAllInPathExceptSpecified(paths, extensions, searchStrings):
	for path in paths:
		if not os.path.isdir(path):
			print("removeFilesWithExtensions: {} is not a dir or doesn't exist - skipping".format(path))
			continue

		for fileAnyCase in os.listdir(path):
			filename, extension = os.path.splitext(fileAnyCase.lower())

			hasCorrectExtension = extension in extensions

			hasCorrectSearchString = False
			for searchString in searchStrings:
				if searchString in filename:
					hasCorrectSearchString = True

			fullDeletePath = os.path.join(path, fileAnyCase)

			if hasCorrectExtension and hasCorrectSearchString:
				print("Keeping file:", fullDeletePath)
			else:
				print("Deleting file:", fullDeletePath)
				if not umi_debug_mode:
					os.remove(fullDeletePath)

#backs up files for both question and answer arcs
#if a backup already exists, the file is instead removed
def backupOrRemoveFiles(folderToBackup):
	pathsToBackup = ['Umineko5to8.exe', 'Umineko5to8', 'Umineko5to8.app',
					 'Umineko1to4.exe', 'Umineko1to4', 'Umineko1to4.app',
					 '0.utf', '0.u']

	for pathToBackup in pathsToBackup:
		fullFilePath = os.path.join(folderToBackup, pathToBackup)
		backupPath = fullFilePath + '.backup'

		#only process the file if it exists on disk
		if not os.path.isfile(fullFilePath) and not os.path.isdir(fullFilePath):
			continue

		# backup the file if no backup has been performed previously - otherwise delete the file
		if os.path.isfile(backupPath) or os.path.isdir(backupPath):
			print("backupOrRemoveFiles: removing", fullFilePath, "as backup already exists")
			if os.path.isfile(backupPath):
				os.remove(fullFilePath)
			else:
				shutil.rmtree(fullFilePath)
		else:
			print("backupOrRemoveFiles: backing up", fullFilePath)
			shutil.move(fullFilePath, backupPath)

def installUminekoAnswer(gameInfo, modToInstall, gamePath):
	print("User wants to install", modToInstall)
	print("game info:", gameInfo)
	print("game path:", gamePath)

	if modToInstall not in UMINEKO_ANSWER_MODS:
		print("Unknown Umineko Mod [{}]".format(modToInstall))
		exitWithError()

	#do a quick verification that the directory is correct before starting installer
	if not os.path.isfile(os.path.join(gamePath, "arc.nsa")):
		print("There is no 'arc.nsa' in the game folder. Are you sure the correct game folder was selected?")
		print("ERROR - wrong game path. Installation Stopped.")
		exitWithError()

	#Create aliases for the temp directories, and ensure they exist beforehand
	downloadTempDir = path.join(gamePath, "temp")
	advDownloadTempDir = path.join(gamePath, "temp_adv")
	makeDirsExistOK(downloadTempDir)
	makeDirsExistOK(advDownloadTempDir)

	############################# Wipe non-checksummed install files in the temp folder ################################
	#deleteAllInPathExceptSpecified([downloadTempDir, advDownloadTempDir], ['.aria2', '.utf', '.u', '.exe'])
	deleteAllInPathExceptSpecified([downloadTempDir, advDownloadTempDir],
								   extensions=['.7z', '.zip'],
								   searchStrings=['graphic', 'voice'])

	if os.listdir(downloadTempDir) or os.listdir(advDownloadTempDir):
		print("Information: Temp directories are not empty - continued or overwritten install")

	# Backup/clear the .exe and script files
	backupOrRemoveFiles(gamePath)

	if modToInstall == "mod_voice_only":
		uminekoDownload(downloadTempDir, url_list=gameInfo["files"]["voice_only"])
		uminekoExtract(fromDir=downloadTempDir, toDir=gamePath)
	elif modToInstall == "mod_full_patch" or modToInstall == "mod_adv_mode":
		uminekoDownload(downloadTempDir, url_list=gameInfo["files"]["full"])
		uminekoExtract(fromDir=downloadTempDir, toDir=gamePath)

		# Perform extra steps for adv mode
		if modToInstall == "mod_adv_mode":
			uminekoDownload(advDownloadTempDir, url_list=gameInfo["files"]["adv"])
			uminekoExtract(fromDir=advDownloadTempDir, toDir=gamePath)

	# write batch file to let users launch game in debug mode and enable steam sync
	with open(os.path.join(gamePath, "Umineko5to8_DebugMode.bat"), 'w') as f:
		f.writelines(["Umineko5to8.exe --debug", "pause"])

	with open(os.path.join(gamePath, "EnableSteamSync.bat"), 'w') as f:
		f.writelines(["mklink saves mysav /J", "pause"])

	# For now, don't copy save data

	# Open the temp folder so users can delete/backup any temp install files
	if IS_WINDOWS:
		subprocess.call(["explorer", os.path.join(gamePath, "temp")])
		subprocess.call(["explorer", os.path.join(gamePath, "temp_adv")])

def mainUmineko():

	# Given a game path, returns the corresponding game install information for that path
	# In the JSON, this is one of the elements of the top level array
	# It will return 'None' if the game path is invalid (not an Umineko game). Use this feature to scan for valid game paths.
	def getUminekoGameInformationFromGamePath(modList, gamePath):
		for uminekoGameInfo in modList:
			try:
				for filename in os.listdir(gamePath):
					if uminekoGameInfo['dataname'].lower() in filename.lower():
						return uminekoGameInfo
			except:
				print("getGameNameFromGamePath failed on path [{}]".format(gamePath))

		return None

	print("Getting latest mod info (Umineko)...")
	modList = getModListDUMMY()

	gamePathList = [gamePath for gamePath in findPossibleGamePaths() if getUminekoGameInformationFromGamePath(modList, gamePath) is not None]
	print("Detected {} game folders: {}".format(len(gamePathList), gamePathList))

	userSelectedGamePath = promptChoice(
		rootGUIWindow=rootWindow,
		choiceList= gamePathList,
		guiPrompt="Please choose a game to mod",
		canOther=True
	)

	print("Selected game folder: [{}]".format(userSelectedGamePath))
	gameInfo = getUminekoGameInformationFromGamePath(modList, userSelectedGamePath)
	print("Selected Game Information:")
	pp.pprint(gameInfo)

	if gameInfo['name'] == 'UminekoAnswer':
		userSelectedMod = promptChoice(
			rootGUIWindow=rootWindow,
			choiceList=UMINEKO_ANSWER_MODS,
			guiPrompt="Please choose which Answer Arc mod to apply",
			canOther=False
		)
		installUminekoAnswer(gameInfo, userSelectedMod, userSelectedGamePath)
	elif gameInfo['name'] == 'UminekoQuestion':
		userSelectedMod = promptChoice(
			rootGUIWindow=rootWindow,
			choiceList=UMINEKO_QUESTION_MODS,
			guiPrompt="Please choose which Question Arc mod to apply",
			canOther=False
		)
		installUminekoQuestion(gameInfo, userSelectedMod, userSelectedGamePath)
	else:
		print("Unknown Umineko game [{}]".format(gameInfo['name']))
		exitWithError()

rootWindow = tkinter.Tk()

def closeAndStartHigurashi():
	rootWindow.withdraw()
	main()
	rootWindow.destroy()

def closeAndStartUmineko():
	rootWindow.withdraw()
	mainUmineko()
	messagebox.showinfo("Install Completed", "Install Finished. Temporary install files have been displayed - please "
											 "delete the temporary files after checking the mod has installed correctly.")
	rootWindow.destroy()

# Add an 'OK' button. When pressed, the dialog is closed
defaultPadding = {"padx": 20, "pady": 10}
b = tkinter.Button(rootWindow, text="Install Higurashi Mods", command=closeAndStartHigurashi)
b.pack(**defaultPadding)
b = tkinter.Button(rootWindow, text="Install Umineko Mods", command=closeAndStartUmineko)
b.pack(**defaultPadding)

rootWindow.mainloop()
