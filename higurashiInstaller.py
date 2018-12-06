from __future__ import print_function, unicode_literals
import sys, os, os.path as path, platform, shutil, glob, subprocess, json
try:
	from urllib.request import urlopen, Request
	from urllib.error import HTTPError
except ImportError:
	from urllib2 import urlopen, Request, HTTPError

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
def IS_WINDOWS(): return platform.system() == "Windows"
def IS_LINUX(): return platform.system() == "Linux"
def IS_MAC(): return platform.system() == "Darwin"

#query available executables. If any installation of executables is done in the python script, it must be done
#before this executes
if path.exists("./aria2c"):
	def ARIA_EXECUTABLE(): return "./aria2c"
else:
	def ARIA_EXECUTABLE(): return "aria2c"

#when calling this function, use named arguments to avoid confusion!
def aria(downloadDir=None, inputFile=None):
	"""
	Calls aria2c with some default arguments:
	TODO: list what each default argument does as comments next to arguments array?

	:param downloadDir: The directory to store the downloaded file(s)
	:param inputFile: The path to a file containing multiple URLS to download (see aria2c documentation)
	:return:
	"""
	arguments = [
		ARIA_EXECUTABLE(),
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

def exitWithError():
	# I think the windows command prompt immediately exits if you launched the program from a GUI
	# So make sure they can read any error messages by waiting for input
	if IS_WINDOWS():
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

		if IS_MAC():
			self.dataDirectory = path.join(self.directory, "Contents/Resources/Data")
		else:
			self.dataDirectory = path.join(self.directory, info["dataname"])

		self.assetsDir = path.join(self.dataDirectory, "StreamingAssets")

		if path.exists(path.join(self.directory, "steam_api.dll")):
			self.isSteam = True
		else:
			self.isSteam = False

		self.downloadDir = info["name"] + "Download"

		if path.exists("./7za"):
			self.unzip = "./7za"
		elif path.exists("./7z"):
			self.unzip = "./7z"
		else:
			self.unzip = "7za"



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
		Downloads the required files for the mod
		"""
		if IS_WINDOWS():
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
		except:
			pass
		fileList = open("downloadList.txt", "w")
		for file in files:
			fileList.write(file + "\n")
		fileList.close()

		aria(downloadDir=self.downloadDir, inputFile='downloadList.txt')

		os.remove("downloadList.txt")

	def extractFiles(self):
		"""
		Extracts downloaded files using 7zip
		"""
		for file in sorted(os.listdir(self.downloadDir)):
			subprocess.call([self.unzip, "x", path.join(self.downloadDir, file), "-aoa"])

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

		if IS_MAC():
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

def findPossibleGames():
	"""
	If supported, searches the computer for things that might be Higurashi games
	Currently only does things on Mac OS
	TODO: Find ways to search for games on other platforms

	:return: A list of things that might be Higurashi games
	:rtype: list[str]
	"""
	if IS_MAC():
		return sorted(x for x in subprocess.check_output(["mdfind", "kind:Application", "Higurashi"]).decode("utf-8").split("\n") if x)
	else:
		return []

def getGameInfo(game, modList):
	"""
	Gets the name of the given game, if there's a mod for it

	:param str game: The path to the game
	:param list[dict] modList: The list of available mods (used for finding game names)
	:return: The name of the game, or None if no game was matched
	:rtype: str or None
	"""
	if IS_MAC():
		try:
			info = subprocess.check_output(["plutil", "-convert", "json", "-o", "-", path.join(game, "Contents/Info.plist")])
			parsed = json.loads(info)
			name = parsed["CFBundleExecutable"] + "_Data"
		except (OSError, KeyError):
			return None
	else:
		for file in os.listdir(game):
			if file.startsWith("HigurashiEp"):
				name = file

	for game in modList:
		if game["dataname"] == name:
			return game["target"]
	return None

def findGames(modList):
	"""
	Find moddable games
	Uses findPossibleGames and therefore will support finding games on the same platforms it does
	:param list[dict] modList: The list of available mods
	:return: A list of games that were found and moddable
	:rtype: list[str]
	"""
	possibleGames = findPossibleGames()
	games = []
	for game in possibleGames:
		if getGameInfo(game, modList) is not None:
			games.append(game)
	return games

def promptChoice(choiceList, guiPrompt, textPrompt, canOther=True):
	"""
	Prompts the user to choose from a list
	Currently supports using a choose GUI on mac OS and falls back to a CLI chooser on other OSes
	TODO: Find ways to display choose GUIs on other OSes
	:param list[str] choiceList: The list of choices
	:param str guiPrompt: The prompt to use in GUI mode
	:param str textPrompt: The prompt to use in CLI mode.  Note that the user will be directed to select from a list of integers representing options so please mention that.
	:param bool canOther: Whether or not to give the user an Other option, which will instruct them to give a path to an application
	:return: The string that the user selected, or if canOther is true, possibly a path that was not in the option list
	:rtype: str
	"""
	choice = "Other"
	if IS_MAC():
		withOther = choiceList + ["Other"] if canOther else choiceList
		choiceList = ('"' + x.replace('"', '\\"') + '"' for x in withOther)
		if choiceList:
			choice = subprocess.check_output(["osascript", "-e", "choose from list {" + ",".join(choiceList) + "} with prompt \"" + guiPrompt + "\" default items \"Other\""]).strip().decode("utf-8")
		if choice == u"Other":
			choice = subprocess.check_output(["osascript", "-e", "POSIX path of (choose file of type {\"com.apple.application\"} with prompt \"" + guiPrompt + "\")"]).strip().decode("utf-8")
	else:
		if choiceList and canOther:
			textPrompt = textPrompt + "  Alternatively, you can input the path to it manually."
		print(textPrompt)
		for index, game in enumerate(choiceList):
			print(str(index) + ": " + game)
		inputted = input()
		try:
			choice = choiceList[int(inputted.strip())]
		except:
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

print("Getting latest mod info...")
modList = getModList()
foundGames = findGames(modList)
gameToUse = promptChoice(foundGames, "Please choose a game to mod", "Please type the number of a game you would like to mod.")
targetName = getGameInfo(gameToUse, modList)
if not targetName:
	print(gameToUse + " does not appear to be a supported higurashi game.")
	printSupportedGames(modList)
	exitWithError()
possibleMods = [x for x in modList if x["target"] == targetName]
if len(possibleMods) > 1:
	modName = promptChoice([x["name"] for x in possibleMods], "Please choose a mod to install", "Please type the number of the mod to install", canOther=False)
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
