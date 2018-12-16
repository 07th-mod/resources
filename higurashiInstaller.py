from __future__ import print_function, unicode_literals, with_statement
import sys, os, os.path as path, platform, shutil, glob, subprocess, json
try:
	from urllib.request import urlopen, Request
	from urllib.error import HTTPError
except ImportError:
	from urllib2 import urlopen, Request, HTTPError

try:
	import winreg
except ImportError:
	import _winreg
	winreg = _winreg

try:
	import tkinter
	from tkinter import filedialog
except ImportError:
	import Tkinter
	from tkinter import tkFileDialog
	tkinter = Tkinter
	filedialog = tkFileDialog

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

# Define constants used throughout the script. Use function calls to enforce variables as const
IS_WINDOWS = platform.system() == "Windows"
IS_LINUX = platform.system() == "Linux"
IS_MAC = platform.system() == "Darwin"

#query available executables. If any installation of executables is done in the python script, it must be done
#before this executes
ARIA_EXECUTABLE = "aria2c"
if path.exists("./aria2c"):
	ARIA_EXECUTABLE = "./aria2c"

SEVEN_ZIP_EXECUTABLE = "7za"
if path.exists("./7za"):
	SEVEN_ZIP_EXECUTABLE = "./7za"
elif path.exists("./7z"):
	SEVEN_ZIP_EXECUTABLE = "./7z"

#when calling this function, use named arguments to avoid confusion!
def aria(downloadDir=None, inputFile=None):
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
	]

	#Add an extra command line argument if the function argument has been provided
	if downloadDir:
		arguments.append('-d ' + downloadDir)

	if inputFile:
		arguments.append('--input-file=' + inputFile)

	subprocess.call(arguments)

def sevenZipExtract(archive_path):
	subprocess.call([SEVEN_ZIP_EXECUTABLE, "x", archive_path, "-aoa"])

def exitWithError():
	""" On Windows, prevent window closing immediately when exiting with error. Other plaforms just exit. """
	print("ERROR: The installer cannot continue. Press any key to exit...")
	if IS_WINDOWS:
		input()
	sys.exit(1)

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

def getModList():
	"""
	Gets the list of available mods from the 07th Mod server

	:return: A list of mod info objects
	:rtype: list[dict]
	"""
	try:
		file = urlopen(Request("http://07th-mod.com/installer/higurashi.json", headers={"User-Agent": ""}))
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

def promptChoice(choiceList, guiPrompt, textPrompt, canOther=False, textPromptWithOther=None):
	"""
	Prompts the user to choose from a list
	Currently supports using a choose GUI on mac OS and falls back to a CLI chooser on other OSes
	TODO: Find ways to display choose GUIs on other OSes
	:param list[str] choiceList: The list of choices
	:param str guiPrompt: The prompt to use in GUI mode
	:param str textPrompt: The prompt to use in CLI mode.  Note that the user will be directed to select from a list of integers representing options so please mention that.
	:param bool canOther: Whether or not to give the user an Other option, which will instruct them to give a path to an application
	:param str textPromptWithOther: The text prompt to use if there's both options and the `Other` option available.  If `canOther` is true, `textPrompt` will be used if there are only options (so it's just Other) and this will be used otherwise.  If `canOther` is false, this will be ignored.
	:return: The string that the user selected, or if canOther is true, possibly a path that was not in the option list
	:rtype: str
	"""
	choice = "Other"
	if IS_MAC:
		withOther = choiceList + ["Other"] if canOther else choiceList
		choiceList = ('"' + x.replace('"', '\\"') + '"' for x in withOther)
		if choiceList:
			choice = subprocess.check_output(["osascript", "-e", "choose from list {" + ",".join(choiceList) + "} with prompt \"" + guiPrompt + "\" default items \"Other\""]).strip().decode("utf-8")
			if choice == u"false": exitWithError()
		if choice == u"Other":
			choice = subprocess.check_output(["osascript", "-e", "POSIX path of (choose file of type {\"com.apple.application\"} with prompt \"" + guiPrompt + "\")"]).strip().decode("utf-8")
	else:
		if choiceList and canOther:
			print(textPromptWithOther)
		else:
			print(textPrompt)
		for index, game in enumerate(choiceList):
			print(str(index) + ": " + game)

		if canOther:
			print("Press Enter Key: Choose the folder manually")

		inputted = input()

		#Open a Folder Chooser prompt if user types 'm', and 'canOther' is enabled
		if canOther and inputted.strip() == '':
			return promptUserChooseFolder()

		try:
			choice = choiceList[int(inputted.strip())]
		except (ValueError, IndexError):
			if not canOther:
				print("You must choose one of the available items")
				exitWithError()
			choice = inputted.strip()
			if path.split(choice)[1].startswith("HigurashiEp"):
				choice = path.split(choice)[0]
	return decodeStr(choice)

def printSupportedGames(modList):
	"""
	Prints a list of games that have mods available for them
	:param list[dict] modList: The list of available mods
	"""
	print("Supported games:")
	for game in set(x["target"] for x in modList):
		print("  " + game)

def promptUserChooseFolder():
	"""
	Operating System Suppoprt: Should work on all platforms
	Opens a GUI which prompts the user to select a folder
	:return: The full path to the user selected folder is returned
	"""
	return filedialog.askdirectory()  # show an "Open" dialog box and return the path to the selected file

def main():
	top = tkinter.Tk()

	#IMPORTANT: remove this to show the main window
	top.withdraw()

	print("Getting latest mod info...")
	modList = getModList()
	foundGames = findInstalledGames(modList)

	#gameToUse is the path to the game install directory, for example "C:\games\Steam\steamapps\common\Higurashi 02 - Watanagashi"
	gameToUse = promptChoice(
		choiceList=foundGames,
		guiPrompt="Please choose a game to mod",
		textPrompt="Please input the path of the game you would like to mod.",
		textPromptWithOther="Please type the number of a game you would like to mod.  Alternatively, you can input the path to it manually.",
		canOther=True
	)

	#target name, for example 'Watanagashi', that the user has selected
	targetName = getGameNameFromGamePath(gameToUse, modList)
	if not targetName:
		print(gameToUse + " does not appear to be a supported higurashi game.")
		printSupportedGames(modList)
		exitWithError()

	# Using the targetName (eg. 'Watanagashi'), check which mods have a matching name
	# Multiple mods may be returned (eg the 'full' patch and 'voice only' patch may have the same 'target' name
	possibleMods = [x for x in modList if x["target"] == targetName]
	if len(possibleMods) > 1:
		modName = promptChoice(choiceList=[x["name"] for x in possibleMods],
							   guiPrompt="Please choose a mod to install",
							   textPrompt="Please type the number of the mod to install")
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

main()
