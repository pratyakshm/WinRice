# This file is a part of the WinRice software
# Copyright (c) 2020-2024 Pratyaksh Mehrotra <contact@pratyakshm.com>
# All rights reserved.

Write-Host "Installing Flow Launcher..."
winget install Flow-Launcher.Flow-Launcher | Out-Null

# Check if Flow Launcher is successfully installed.
$packageId = "Flow-Launcher.Flow-Launcher"
$installedPackages = winget list
if ($installedPackages -match $packageId) {
	Write-Host "Flow Launcher is installed."
} else {
	Write-Host "Failed to install Flow Launcher."
	return
}

Write-Host "Customizing Flow Launcher..."

# Stop Flow Launcher running processes and remove Settings backup to ensure no unintended overwrite
Stop-Process -Name "flow.launcher" -Force

# Declare settings files locations
$settingsFolderPath = "$env:APPDATA\FlowLauncher\Settings"
$settingsPath = Join-Path -Path $settingsFolderPath -ChildPath "Settings.json"
$backupPath = Join-Path -Path $settingsFolderPath -ChildPath "Settings.json.bak"

# Delete the backup file to avoid unintended overwrite
Remove-Item -Path $backupPath -Force -ErrorAction SilentlyContinue

# Download the onsetGlaze theme for Flow
$url = "https://raw.githubusercontent.com/abhidahal/onsetGlaze.flow/main/OnsetGlaze.xaml"
$outputPath = "$env:APPDATA\FlowLauncher\Themes\OnsetGlaze.xaml"
Invoke-WebRequest -Uri $url -OutFile $outputPath

# Update to OnsetGlaze Theme
$newThemeValue = "OnsetGlaze"
$jsonContent = Get-Content -Path $settingsPath | ConvertFrom-Json
$jsonContent.Theme = $newThemeValue
$jsonContent | ConvertTo-Json -Depth 100 | Set-Content -Path $settingsPath

# Disable unnecessary plugins
$pluginsToDisable = @(
    "CEA0FDFC6D3B4085823D60DC76F28855",
    "572be03c74c642baae319fc283e561a8",
    "6A122269676E40EB86EB543B945932B9",
    "9f8f9b14-2518-4907-b211-35ab6290dee7",
    "D409510CD0D2481F853690A07E6DC426",
    "0308FD86DE0A4DEE8D62B9B535370992",
    "565B73353DBF4806919830B9202EE3BF",
    "5043CETYU6A748679OPA02D27D99677A"
)
function DisablePlugins {
	param(
		[Parameter(Mandatory=$true)]
		[System.Management.Automation.PSObject]$Object
	)

	$Object.PSObject.Properties | ForEach-Object {
		if ($_.Value -is [System.Management.Automation.PSObject]) {
			DisablePlugins -Object $_.Value
		}
		elseif ($_.Name -eq "ID" -and $pluginsToDisable -contains $_.Value) {
			$Object.Disabled = $true
		}
	}
}

$jsonContent = Get-Content -Path $settingsPath | ConvertFrom-Json
DisablePlugins -Object $jsonContent.PluginSettings.Plugins
$jsonContent | ConvertTo-Json -Depth 100 | Set-Content -Path $settingsPath
Write-Host "Customization performed: "
Write-Host "    – Set Theme to OnsetGlaze."
Write-Host "    – Disabled the following plugins:"
Write-Host "    		– Browser Bookmarks"
Write-Host "    		– Calculator"
Write-Host "    		– Explorer"
Write-Host "    		– Plugin Indicator"
Write-Host "    		– Plugins Manager"
Write-Host "    		– Shell"
Write-Host "    		– URL"
Write-Host "    		– Web Searches"
Write-Host "    		– Windows Settings"
Write-Host "You may change these preferences later in Flow Launcher Settings."