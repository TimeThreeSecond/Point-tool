@echo off
call "D:\Android\VSBuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1
cd /d D:\Point\pprogram
flutter clean
flutter run -d windows