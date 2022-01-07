# This file is a part of the WinRice software
# Copyright (c) 2021 PratyakshM <pratyakshm@protonmail.com>
# All rights reserved.

Write-Host "Enabling Virtualization-based security..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Type DWord -Value 1
bcdedit.exe /set hypervisorlaunchtype auto | Out-Null
Write-Host "Enabled Virtualization-based security."