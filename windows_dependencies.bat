@echo off

::Change to the same directory the batch file is in. Required because when
::running the batch file in administrator mode, the working directory gets reset!
@setlocal enableextensions
@cd /d "%~dp0"

::Print current directory for debugging
echo current directory is
cd

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
    choco install python -y
    echo installed Python
)

7z -h >nul 2>&1 && (
    echo 7zip is installed
) || (
    echo 7zip is not installed
    echo installing 7zip
    choco install 7zip.portable -y
    echo installed 7zip
)

aria2c --version >nul 2>&1 && (
    echo aria2 is installed
) || (
    echo aria2 is not installed
    echo installing aria2
    choco install aria2 -y
    echo installed aria2c
)

::run the python script
python "install.py"

pause