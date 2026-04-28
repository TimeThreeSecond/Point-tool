@echo off
call "D:\Android\VSBuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1
cd /d D:\Point\pprogram

REM Clean build directory
if exist build\windows rmdir /s /q build\windows

REM Create flutter ephemeral directory
if not exist windows\flutter\ephemeral mkdir windows\flutter\ephemeral

REM Copy Flutter Windows artifacts
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_windows.dll.lib" "windows\flutter\ephemeral\" >nul 2>&1
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_windows.dll" "windows\flutter\ephemeral\" >nul 2>&1
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_windows.dll.pdb" "windows\flutter\ephemeral\" >nul 2>&1
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_export.h" "windows\flutter\ephemeral\" >nul 2>&1
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_messenger.h" "windows\flutter\ephemeral\" >nul 2>&1
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_plugin_registrar.h" "windows\flutter\ephemeral\" >nul 2>&1
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_texture_registrar.h" "windows\flutter\ephemeral\" >nul 2>&1
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_windows.h" "windows\flutter\ephemeral\" >nul 2>&1
xcopy /Y /I /S "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\cpp_client_wrapper\*" "windows\flutter\ephemeral\cpp_client_wrapper\" >nul 2>&1

echo === Step 1: CMake configure ===
cmake -S windows -B build\windows\x64 -G Ninja -DCMAKE_BUILD_TYPE=Debug -DFLUTTER_TARGET_PLATFORM=windows-x64 -DFLUTTER_MANAGED_DIR="D:/Point/pprogram/windows/flutter" 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo CMake configuration failed
    exit /b 1
)

echo === Step 2: Ninja build ===
ninja -C build\windows\x64 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo Build failed
    exit /b 1
)

echo === Step 3: Copy runtime files ===
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\flutter_windows.dll" "build\windows\x64\runner\" >nul 2>&1
xcopy /Y /I "D:\Android\flutter\bin\cache\artifacts\engine\windows-x64\icudtl.dat" "build\windows\x64\runner\" >nul 2>&1
if not exist build\windows\x64\runner\data\flutter_assets mkdir build\windows\x64\runner\data\flutter_assets

echo === Step 4: Build Flutter bundle ===
cd /d D:\Point\pprogram
flutter build bundle --target-platform=windows-x64 --verbose 2>&1

echo === Step 5: Copy assets ===
xcopy /Y /I /S "build\flutter_assets\*" "build\windows\x64\runner\data\flutter_assets\" >nul 2>&1

echo === Step 6: Run app ===
build\windows\x64\runner\pprogram.exe 2>&1

echo Exit code: %ERRORLEVEL%