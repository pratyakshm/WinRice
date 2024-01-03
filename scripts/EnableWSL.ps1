# This file is a part of the WinRice software
# Copyright (c) 2020-2024 Pratyaksh Mehrotra <contact@pratyakshm.com>
# All rights reserved.

if ($CurrentBuild -lt 22000) {
    Write-Host "Enabling Windows Subsystem for Linux..."
    Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart -WarningAction Ignore | Out-Null
    Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -Online -All -NoRestart -WarningAction Ignore | Out-Null
    if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) {
        Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -Online -All -NoRestart -WarningAction Ignore | Out-Null
    }
    else {
        $ProductName = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName
        Write-Host "Could not enable Hyper-V since $ProductName does not support it."
    }
    Write-Host "Enabled Windows Subsystem for Linux."
}
elseif ($CurrentBuild -ge 22000) {
    Write-Host "Enabling Windows Subsystem for Linux version 2 along with GUI App support..."
    wsl --install | Out-Null
    Write-Host "Enabled Windows Subsystem for Linux."
}