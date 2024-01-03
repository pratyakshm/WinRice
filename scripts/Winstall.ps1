# This file is a part of the WinRice software
# Copyright (c) 2020-2024 Pratyaksh Mehrotra <contact@pratyakshm.com>
# All rights reserved.

Function print($text) {
	Write-Host $text
}


if (!(Get-Command winget)) { 
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JurY1'))
}

# Try Winstall.txt
if (Test-Path Winstall.txt) {
    print "Starting Winstall..."
    # Get each line from the text file and use winget install command on it.
    Get-Content 'Winstall.txt' | ForEach-Object {
        $App = $_.Split('=')
        print "    Installing $App..."
        winget install "$App" --silent | Out-Null
    }
    print "Winstall has successfully installed the app(s)."
}

# Try winstall.txt
elseif (Test-Path winstall.txt) {
    print "Starting Winstall..."
    # Get each line from the text file and use winget install command on it.
    Get-Content 'winstall.txt' | ForEach-Object {
        $App = $_.Split('=')
        print "    Installing $App..."
        winget install "$App" --silent | Out-Null
    }
    print "Winstall has successfully installed the app(s)."
}
else {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    print "Select Winstall text file from File Picker UI"
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Filter = "Text file (*.txt)| *.txt"
    $OpenFileDialog.ShowDialog() | Out-Null
    if ($OpenFileDialog.FileName) {
        print "Starting Winstall..."
        Get-Content $OpenFileDialog.FileName | ForEach-Object {					
            $App = $_.Split('=')
            print "    Installing $App..."
            winget install "$App" --silent | Out-Null
        }
        print "Winstall has successfully installed the app(s)."
    }
    else {
        print "No text file was picked."
    }
}