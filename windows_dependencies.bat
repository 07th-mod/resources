@echo off

::Change to the same directory the batch file is in. Required because when
::running the batch file in administrator mode, the working directory gets reset!
@setlocal enableextensions
@cd /d "%~dp0"

::Check for administrator permissions https://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights
net session >nul 2>&1
if NOT %errorLevel% == 0 (
    echo Error: Installer Stopped - Not in Administator Mode. 
    echo ------------------------------------------------------------------------------
    echo To fix this, right click this program and click "Run as Administrator."
    echo ------------------------------------------------------------------------------
    pause
    exit /b 1
) 

::Print current directory for debugging
echo The Current Directory is [%cd%]
echo The Batch File is located at [%~f0]


::Check whether various tools are installed and install if necessary
choco --version >nul 2>&1 && (
    echo Chocolatey is installed
) || (
    echo Chocolatey is not installed
    echo installing Chocolatey
    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
)

python --version >nul 2>&1 && (
    echo Python is installed
) || (
    echo Python is not installed
    echo installing Python
    choco install python -y --force
    echo installed Python
)

7z -h >nul 2>&1 && (
    echo 7zip is installed
) || (
    echo 7zip is not installed
    echo installing 7zip
    choco install 7zip.portable -y --force
    echo installed 7zip
)

aria2c --version >nul 2>&1 && (
    echo aria2 is installed
) || (
    echo aria2 is not installed
    echo installing aria2
    choco install aria2 -y --force
    echo installed aria2c
)

::Refresh the environment variables so python is added to path immediately.
::NOTE: when calling another .cmd or .bat file, you must use 'call' to call it,
::or else the original batch file will terminate when the child batch file
::terminates. refreshenv is implmented in chocolatey as a .cmd file.
call refreshenv

::Try to run the python script.
::On failure, tell the user to run installer again to refresh environment variables
python --version >nul 2>&1 && (
    python "install.py"
) || (
    echo .
    echo .
    echo .
    echo .
    echo .
    echo .
    echo .
    echo .
    echo -----------------------------------------------------------------------
    echo WARNING: Installer Needs Restart
    echo -----------------------------------------------------------------------
    echo Please re-run this batch file.
    echo Right-click this program and click "Run as Administrator."
    echo .
    echo .
    echo If you have this warning more than once, your PATH variable is probably
    echo not set correctly. Please download and install python, MAKING SURE TO
    echo TICK THE BOX "Add Python 3 to PATH": https://www.python.org/downloads
    echo If still not working, contact us on our discord server.
    echo -----------------------------------------------------------------------
)

pause