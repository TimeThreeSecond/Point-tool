@echo off
call "D:\Android\VSBuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
cd /d D:\Point\pprogram
flutter run -d windows
pause