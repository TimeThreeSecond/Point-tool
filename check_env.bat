@echo off
call "D:\Android\VSBuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1
echo LIB=%LIB% > D:\Point\env.txt
echo INCLUDE=%INCLUDE% >> D:\Point\env.txt
echo PATH=%PATH% >> D:\Point\env.txt