# This file is a part of the CleanWin software
# Copyright (c) 2021 PratyakshM <pratyakshm@protonmail.com>
# All rights reserved.

if ($CurrentBuild -lt 22000) {
	# Get Windows Edition, if its Professional, Education, or Enterprise.
    if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) {
			Write-Host "Setting up Windows Update policies..."

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

			# Print user message; policies applied.
			$WinUpdatePolicies =@(
				"Turned off automatic updates"
				"Device will no longer auto restart if users are signed in"
				"Turned off re-installation of apps after Windows Updates"
				"Delayed quality updates by 4 days"
				"Delayed feature updates by 20 days"
			)
			ForEach ($WinUpdatePolicy in $WinUpdatePolicies) {
				Write-Host "    - $WinUpdatePolicy"
			}

			Write-Host "Set up Windows Update policies."

		}

		# Print user message if unsupported edition.
		else {
			$ProductName = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName
			Write-Host "$ProductName does not support setting up Windows Update policies."
		}
	}
	
elseif ($CurrentBuild -ge 22000) {
	Write-Host "CleanWin currently cannot set up Windows Update policies on Windows 11."
}

else {
    # Do nothing.
}