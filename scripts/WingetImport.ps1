# This file is a part of the WinRice software
# Copyright (c) 2020-2024 Pratyaksh Mehrotra <contact@pratyakshm.com>
# All rights reserved.

if (!(Get-Command winget)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JurY1'))
}

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
Write-Host "Select the exported JSON from File Picker UI"
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.InitialDirectory = $initialDirectory
$OpenFileDialog.Filter = "JSON (*.json)| *.json"
$OpenFileDialog.ShowDialog() | Out-Null
if ($OpenFileDialog.FileName) {
    Write-Host "Initializing JSON file..."
    Start-Sleep -Milliseconds 200
    winget import $OpenFileDialog.FileName
}
elseif (!($OpenFileDialog.FileName)) {
    Write-Host "No JSON selected."
}