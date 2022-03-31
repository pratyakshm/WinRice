# This file is a part of the WinRice software
# Copyright (c) 2022 Pratyaksh Mehrotra <pratyakshm@protonmail.com>
# All rights reserved.

Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse
Write-Host "Windows Update settings have been reset."