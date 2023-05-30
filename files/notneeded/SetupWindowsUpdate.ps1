# This file is a part of the WinRice software
# Copyright (c) 2020-2023 Pratyaksh Mehrotra <contact@pratyakshm.com>
# All rights reserved.
Function space {
	Write-Host " "
}

Function print($text) {
	Write-Host $text
}

$CurrentVersionPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$CurrentBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild
$ProductName = Get-ItemPropertyValue $CurrentVersionPath -Name ProductName

if ($CurrentBuild -ge 22000) {
	print "WinRice currently cannot set up Windows Update policies on Windows 11."
	exit 
}

# Get Windows Edition, if its Professional, Education, or Enterprise.
if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"})) {
	print "$ProductName does not support setting up Windows Update policies."
	return
}
print "Setting up Windows Update policies..."

# Declare registry keys locations.
$Update1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$Update2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
if (!(Test-Path $Update1)) {
	New-Item -Path $Update1 | Out-Null
	New-Item -Path $Update2 | Out-Null
}

# Write registry values.
Set-ItemProperty -Path $Update1 -Name DeferQualityUpdates -Type DWord -Value 1
Set-ItemProperty -Path $Update1 -Name DeferQualityUpdatesPeriodInDays -Type DWord -Value 4
Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdates -Type DWord -Value 1
Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 20
Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
Set-ItemProperty -Path $Update2 -Name NoAutoRebootWithLoggedOnUsers -Type Dword -Value 1

# print user message; policies applied.
$WinUpdatePolicies =@(
	"Turned off automatic updates"
	"Device will no longer auto restart if users are signed in"
	"Turned off re-installation of apps after Windows Updates"
	"Delayed quality updates by 4 days"
	"Delayed feature updates by 20 days"
)
ForEach ($WinUpdatePolicy in $WinUpdatePolicies) {
	print "    - $WinUpdatePolicy"
}

print "Set up Windows Update policies."