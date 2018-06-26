@echo off

echo Backing up files
echo.
cd ..
mkdir Backup
echo D | xcopy /E /Y .\Managed .\Backup\Managed
echo D | xcopy /E /Y .\StreamingAssets\CGAlt ..\Backup\StreamingAssets\CGAlt
echo D | xcopy /E /Y .\StreamingAssets\CG ..\Backup\StreamingAssets\CG
echo Backup complete