cls
echo.
timeout /t 2 /nobreak > NUL

set x64="%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe"
 
taskkill /f /im OneDrive.exe > NUL 2>&1
ping 127.0.0.1 -n 5 > NUL 2>&1
 
if exist %x64% (
%x64% /uninstall
) else (
echo "OneDriveSetup.exe installer not found, skipping."
)
ping 127.0.0.1 -n 8 > NUL 2>&1

rd "%USERPROFILE%\OneDrive" /Q /S > NUL 2>&1
rd "C:\OneDriveTemp" /Q /S > NUL 2>&1
rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S > NUL 2>&1
rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S > NUL 2>&1

echo.
echo Removing OneDrive from the Explorer Side Panel.
reg delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > NUL 2>&1
reg delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > NUL 2>&1
