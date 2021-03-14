# This file is a part of the CleanWin software
# Copyright (c) 2021 PratyakshM <pratyakshm@protonmail.com>
# All rights reserved.

# Import BitsTransfer module and download NetTestFile
Import-Module BitsTransfer 
Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/NetTestFile
# If the file exists, proceed with installing WSL, else inform user about no internet connection.
If (Test-Path NetTestFile) {
    Remove-Item NetTestFile
    Write-Host "Enabling Windows Subsystem for Linux..."
    Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart -WarningAction Ignore | Out-Null
    Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -Online -All -NoRestart -WarningAction Ignore | Out-Null
    Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -Online -All -NoRestart -WarningAction Ignore | Out-Null
} 
else {
    Write-Host "Windows Subsystem for Linux can't be installed. Are you sure you're connected to the internet?"
}