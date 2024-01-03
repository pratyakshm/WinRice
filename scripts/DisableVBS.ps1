# This file is a part of the WinRice software
# Copyright (c) 2020-2024 Pratyaksh Mehrotra <contact@pratyakshm.com>
# All rights reserved.

Write-Host "Disabling Virtualization-based security..."
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "HyperVVirtualizationBasedSecurityOptOut" -Type DWord -Value 1 | Out-Null # Undocumented reg to opt out from Hyper-V based VBS
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -Type DWord -Value 0 | Out-Null # Disables VBS
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Type DWord -Value 0 | Out-Null # Core isolation switch
Write-Host "Disabled Virtualization-based security."