# This file is a part of the WinRice software
# Copyright (c) 2020-2023 Pratyaksh Mehrotra <contact@pratyakshm.com>
# All rights reserved.

Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse
Write-Host "Windows Update settings have been reset."