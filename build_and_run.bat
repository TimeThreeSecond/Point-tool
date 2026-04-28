@echo off
call "D:\Android\VSBuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1
cd /d D:\Point\pprogram

REM Clean build directory
if exist build\windows rmdir /s /q build\windows

REM Create flutter ephemeral directory
if not exist windows\flutter\ephemeral mkdir windows\flutter\ephemeral

REM Copy Flutter Windows artifacts
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_windows.dll.lib" "windows\flutter\ephemeral\" 2>nul
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_windows.dll" "windows\flutter\ephemeral\" 2>nul
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_windows.dll.pdb" "windows\flutter\ephemeral\" 2>nul
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_export.h" "windows\flutter\ephemeral\" 2>nul
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_messenger.h" "windows\flutter\ephemeral\" 2>nul
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_plugin_registrar.h" "windows\flutter\ephemeral\" 2>nul
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_texture_registrar.h" "windows\flutter\ephemeral\" 2>nul
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_windows.h" "windows\flutter\ephemeral\" 2>nul
xcopy /Y /I /S "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\cpp_client_wrapper\*" "windows\flutter\ephemeral\cpp_client_wrapper\" 2>nul

REM Configure with Ninja
cmake -S windows -B build\windows\x64 -G Ninja -DCMAKE_BUILD_TYPE=Debug -DFLUTTER_TARGET_PLATFORM=windows-x64 -DFLUTTER_MANAGED_DIR="D:/Point/pprogram/windows/flutter"

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

REM Copy runtime files
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_windows.dll" "build\windows\x64\runner\" 2>nul
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\icudtl.dat" "build\windows\x64\runner\" 2>nul
if not exist build\windows\x64\runner\data\flutter_assets mkdir build\windows\x64\runner\data\flutter_assets

REM Build flutter assets using flutter tool
cd /d D:\Point\pprogram
flutter build bundle --target-platform=windows-x64

REM Copy assets
xcopy /Y /I /S "build\flutter_assets\*" "build\windows\x64\runner\data\flutter_assets\" 2>nul

echo Build complete! Running app...
build\windows\x64\runner\pprogram.exe