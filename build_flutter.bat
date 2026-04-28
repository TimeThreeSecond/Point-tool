@echo off
call "D:\Android\VSBuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1
cd /d D:\Point\pprogram
flutter clean
flutter build windows --verbose > D:\Point\build_log.txt 2>&1
echo Build completed with exit code %ERRORLEVEL% >> D:\Point\build_log.txt