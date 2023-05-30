# This file is a part of the WinRice software
# Copyright (c) 2020-2023 Pratyaksh Mehrotra <contact@pratyakshm.com>
# All rights reserved.

Function print($text) {
	Write-Host $text
}

if (!(Get-Command winget)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JurY1'))
}
space
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
print "Select the exported JSON from File Picker UI"
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.InitialDirectory = $initialDirectory
$OpenFileDialog.Filter = "JSON (*.json)| *.json"
$OpenFileDialog.ShowDialog() | Out-Null
if ($OpenFileDialog.FileName) {
    print "Initializing JSON file..."
    Start-Sleep -Milliseconds 200
    winget import $OpenFileDialog.FileName
}
elseif (!($OpenFileDialog.FileName)) {
    print "No JSON selected."
}