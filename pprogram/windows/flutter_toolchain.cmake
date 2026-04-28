set(CMAKE_C_COMPILER "D:/Android/VSBuildTools/VC/Tools/MSVC/14.44.35207/bin/Hostx64/x64/cl.exe")
set(CMAKE_CXX_COMPILER "D:/Android/VSBuildTools/VC/Tools/MSVC/14.44.35207/bin/Hostx64/x64/cl.exe")
set(CMAKE_RC_COMPILER "C:/Program Files (x86)/Windows Kits/10/bin/10.0.26100.0/x64/rc.exe")

set(CMAKE_C_STANDARD_LIBRARIES "kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib")
set(CMAKE_CXX_STANDARD_LIBRARIES "kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib")

link_directories(
  "C:/Program Files (x86)/Windows Kits/10/Lib/10.0.26100.0/ucrt/x64"
  "C:/Program Files (x86)/Windows Kits/10/Lib/10.0.26100.0/um/x64"
  "D:/Android/VSBuildTools/VC/Tools/MSVC/14.44.35207/lib/x64"
)

include_directories(
  "D:/Android/VSBuildTools/VC/Tools/MSVC/14.44.35207/include"
  "D:/Android/VSBuildTools/VC/Auxiliary/VS/include"
  "C:/Program Files (x86)/Windows Kits/10/include/10.0.26100.0/ucrt"
  "C:/Program Files (x86)/Windows Kits/10/include/10.0.26100.0/um"
  "C:/Program Files (x86)/Windows Kits/10/include/10.0.26100.0/shared"
  "C:/Program Files (x86)/Windows Kits/10/include/10.0.26100.0/winrt"
  "C:/Program Files (x86)/Windows Kits/10/include/10.0.26100.0/cppwinrt"
)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")

# Force MSBuild to use correct environment
set(ENV{LIB} "D:/Android/VSBuildTools/VC/Tools/MSVC/14.44.35207/lib/x64;C:/Program Files (x86)/Windows Kits/10/Lib/10.0.26100.0/ucrt/x64;C:/Program Files (x86)/Windows Kits/10/Lib/10.0.26100.0/um/x64")
set(ENV{INCLUDE} "D:/Android/VSBuildTools/VC/Tools/MSVC/14.44.35207/include;D:/Android/VSBuildTools/VC/Auxiliary/VS/include;C:/Program Files (x86)/Windows Kits/10/include/10.0.26100.0/ucrt;C:/Program Files (x86)/Windows Kits/10/include/10.0.26100.0/um;C:/Program Files (x86)/Windows Kits/10/include/10.0.26100.0/shared;C:/Program Files (x86)/Windows Kits/10/include/10.0.26100.0/winrt;C:/Program Files (x86)/Windows Kits/10/include/10.0.26100.0/cppwinrt")
set(ENV{LIBPATH} "D:/Android/VSBuildTools/VC/Tools/MSVC/14.44.35207/lib/x64;D:/Android/VSBuildTools/VC/Tools/MSVC/14.44.35207/lib/x86/store/references;C:/Program Files (x86)/Windows Kits/10/UnionMetadata/10.0.26100.0;C:/Program Files (x86)/Windows Kits/10/References/10.0.26100.0;C:/Windows/Microsoft.NET/Framework64/v4.0.30319")