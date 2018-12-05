from __future__ import print_function, unicode_literals
import sys, os, os.path as path, platform, shutil, glob, subprocess, json
try:
	from urllib.request import urlopen, Request
except:
	from urllib2 import urlopen, Request

try: input = raw_input
except NameError: pass

def exitWithError():
	if platform.system() == "Windows":
		input()
	sys.exit(1)

class Installer:
	def __init__(self, directory, info):
		self.directory = directory
		if platform.system() == "Darwin":
			self.dataDirectory = path.join(self.directory, "Contents/Resources/Data")
		else:
			self.dataDirectory = path.join(self.directory, info["dataname"])
		self.assetsDir = path.join(self.dataDirectory, "StreamingAssets")
		self.info = info
		if path.exists(path.join(self.directory, "steam_api.dll")):
			self.isSteam = True
		else:
			self.isSteam = False

		if path.exists("./7za"):
			self.unzip = "./7za"
		elif path.exists("./7z"):
			self.unzip = "./7z"
		else:
			self.unzip = "7za"

		if path.exists("./aria2c"):
			self.aria = "./aria2c"
		else:
			self.aria = "aria2c"

	def backupUI(self):
		uiPath = path.join(self.dataDirectory, "sharedassets0.assets")
		backupPath = path.join(self.dataDirectory, "sharedassets0.assets.backup")
		if not path.exists(backupPath):
			os.rename(uiPath, backupPath)

	def cleanOld(self):
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
		if platform.system() == "Windows":
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
			os.mkdir("Download")
		except:
			pass
		fileList = open("downloadList.txt", "w")
		for file in files:
			fileList.write(file + "\n")
		fileList.close()
		arguments = [
			self.aria,
			"--file-allocation=none",
			'--file-allocation=none',
			'--continue=true',
			'--retry-wait=5',
			'-m 0',
			'-x 8',
			'-s 8',
			'-j 1',
			'-d Download',
			'--input-file=downloadList.txt'
		]
		subprocess.call(arguments)

		os.remove("downloadList.txt")

	def extractFiles(self):
		for file in sorted(os.listdir("Download")):
			subprocess.call([self.unzip, "x", path.join("Download", file), "-aoa"])

	def moveFilesIntoPlace(self, fromDir=None, toDir=None):
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
		shutil.rmtree("Download")

def getGameList():
	file = urlopen(Request("http://07th-mod.com/installer/higurashi.json", headers={'User-Agent': 'Mozilla'}))
	info = json.load(file)
	file.close()
	return info

def findPossibleGames():
	if platform.system() == "Darwin":
		return sorted(x for x in subprocess.check_output(["mdfind", "kind:Application", "Higurashi"]).decode("utf-8").split("\n") if x)
	else:
		return []

def getGameInfo(game, gameList):
	if platform.system() == "Darwin":
		info = subprocess.check_output(["plutil", "-convert", "json", "-o", "-", path.join(game, "Contents/Info.plist")])
		parsed = json.loads(info)
		name = parsed["CFBundleExecutable"] + "_Data"
	else:
		for file in os.listdir(game):
			if file.startsWith("HigurashiEp"):
				name = file

	for game in gameList:
		if game["dataname"] == name:
			return game["target"]
	return None

def findGames(gameList):
	possibleGames = findPossibleGames()
	games = []
	for game in possibleGames:
		if getGameInfo(game, gameList) is not None:
			games.append(game)
	return games

def promptChoice(choiceList, guiPrompt, textPrompt, canOther=True):
	choice = "Other"
	if platform.system() == "Darwin":
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
	return choice.decode("utf-8")

def printSupportedGames(gameList):
	print("Supported games:")
	for game in set(x["target"] for x in gameList):
		print("  " + game)

print("Getting latest mod info...")
gameList = getGameList()
foundGames = findGames(gameList)
gameToUse = promptChoice(foundGames, "Please choose a game to mod", "Please type the number of a game you would like to mod.")
targetName = getGameInfo(gameToUse, gameList)
if not targetName:
	print(gameToUse + " does not appear to be a supported higurashi game.")
	printSupportedGames(gameList)
	exitWithError()
possibleMods = [x for x in gameList if x["target"] == targetName]
if len(possibleMods) > 1:
	modName = promptChoice([x["name"] for x in possibleMods], "Please choose a mod to install", "Please type the number of the mod to install", canOther=False)
	mod = [x for x in possibleMods if x["name"] == modName][0]
else:
	mod = possibleMods[0]

installer = Installer(gameToUse, mod)
print("Downloading...")
installer.download()
print("Extracting...")
installer.cleanOld()
installer.extractFiles()
print("Moving files into place...")
installer.moveFilesIntoPlace()
print("Done!")
installer.cleanup()
