# This file is a part of the WinRice software
# Copyright (c) 2020-2024 Pratyaksh Mehrotra <contact@pratyakshm.com>
# All rights reserved.

Write-Host "Enabling Virtualization-based security..."
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "HyperVVirtualizationBasedSecurityOptOut"
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Type DWord -Value 1
Write-Host "Enabled Virtualization-based security."