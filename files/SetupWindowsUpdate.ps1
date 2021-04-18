# This file is a part of the CleanWin software
# Copyright (c) 2021 PratyakshM <pratyakshm@protonmail.com>
# All rights reserved.

Write-Host "Applying recommended settings for Windows Update..."
$DeliveryOptimization = "HKLM:\SYSTEM\CurrentControlSet\Services\DoSvc"
$Update1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$Update2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    If (!(Test-Path $Update1)) {
      New-Item -Path $Update1 | Out-Null
      New-Item -Path $Update2 | Out-Null
      }
Set-ItemProperty -Path $DeliveryOptimization -Name Start -Type DWord -Value 4
Set-ItemProperty -Path $Update1 -Name DeferQualityUpdates -Type DWord -Value 1
Set-ItemProperty -Path $Update1 -Name DeferQualityUpdatesPeriodInDays -Type DWord -Value 4
Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdates -Type DWord -Value 1
Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 20
Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
Stop-Service DoSvc | Out-Null
Set-Service DoSvc -StartupType Disabled  | Out-Null
Write-Host "Done."
Write-Host "Done."