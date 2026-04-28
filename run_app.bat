@echo off
call "D:\Android\VSBuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1
cd /d D:\Point\pprogram

REM Create data directory and copy Flutter assets
if not exist build\windows\x64\runner\data mkdir build\windows\x64\runner\data
xcopy /Y /I /S "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\icudtl.dat" "build\windows\x64\runner\" 2>nul

REM Build flutter assets
cd build\windows\x64\runner
if not exist data\flutter_assets mkdir data\flutter_assets

REM Run the app
cd D:\Point\pprogram
build\windows\x64\runner\pprogram.exe

pause