# This file is a part of the WinRice software
# Copyright (c) 2020-2023 Pratyaksh Mehrotra <contact@pratyakshm.com>
# All rights reserved.

Function space {
	Write-Host " "
}

Function print($text) {
	Write-Host $text
}

if ($CurrentBuild -lt 22000) {
    print "Enabling Windows Subsystem for Linux..."
    Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart -WarningAction Ignore | Out-Null
    Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -Online -All -NoRestart -WarningAction Ignore | Out-Null
    if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) {
        Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -Online -All -NoRestart -WarningAction Ignore | Out-Null
    }
    else {
        $ProductName = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName
        print "Could not enable Hyper-V since $ProductName does not support it."
    }
    print "Enabled Windows Subsystem for Linux."
}
elseif ($CurrentBuild -ge 22000) {
    print "Enabling Windows Subsystem for Linux version 2 along with GUI App support..."
    wsl --install | Out-Null
    print "Enabled Windows Subsystem for Linux."
}