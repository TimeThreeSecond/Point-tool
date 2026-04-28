@echo off
call "D:\Android\VSBuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1
cd /d D:\Point\pprogram

REM Clean build directory
if exist build\windows rmdir /s /q build\windows

REM Configure with Ninja
cmake -S windows -B build\windows\x64 -G Ninja -DCMAKE_BUILD_TYPE=Debug -DFLUTTER_TARGET_PLATFORM=windows-x64

if %ERRORLEVEL% NEQ 0 (
    echo CMake configuration failed
    pause
    exit /b 1
)

REM Build
ninja -C build\windows\x64

if %ERRORLEVEL% NEQ 0 (
    echo Build failed
    pause
    exit /b 1
)

echo Build succeeded!
pause