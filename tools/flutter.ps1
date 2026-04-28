# Fix Windows SDK UCRT path for MSBuild
$env:UCRTContentRoot = "C:\Program Files (x86)\Windows Kits\10\"

# Forward all arguments to real flutter
& "D:\Android\flutter\bin\flutter.bat" @args
