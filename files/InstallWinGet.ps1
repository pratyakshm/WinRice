# This file is a part of the CleanWin software
# Copyright (c) 2021 PratyakshM <pratyakshm@protonmail.com>
# All rights reserved.

# Import BitsTransfer module and download NetTestFile
Import-Module BitsTransfer 
Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/NetTestFile
# If the file exists, proceed with downloading WinGet files, else inform user about no internet connection.
If (Test-Path NetTestFile) {
    Remove-Item NetTestFile
    Write-Host "Downloading required files..."
    Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle
    Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
    Write-Host "Installing Windows Package Manager (WinGet)..."
    Add-AppxPackage -Path .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -DependencyPath .\Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
    Remove-Item Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle
    Remove-Item Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
    Write-Host "Done."
	} 
	else {
	  Write-Host "We can't connect to GitHub to download the installation files. Are you sure that your internet connection is working?"
    }