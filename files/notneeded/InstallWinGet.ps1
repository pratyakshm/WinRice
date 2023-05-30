$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

Function space {
	Write-Host " "
}

Function print($text) {
	Write-Host $text
}

space
if (Get-Command winget) {
	print "WinGet is already installed on this device."
	return 
}
# Create new folder and set location.
if (!(Test-Path WinRice)) {
	New-Item WinRice -ItemType Directory | Out-Null
	$currentdir = $(Get-Location).Path; $dir = "$currentdir/WinRice"; Set-Location $dir
}
else {
	Set-Location WinRice
}

# Credit: https://dev.to/kaiwalter/download-windows-store-apps-with-powershell-from-https-store-rg-adguard-net-155m.
Write-Host "Installing HEVC Video Extensions..."
$apiUrl = "https://store.rg-adguard.net/api/GetFiles"
$productUrl = "https://www.microsoft.com/en-us/p/9nblggh4nns1"
$downloadFolder = Join-Path (Get-Location).Path "WinRice"
if(!(Test-Path $downloadFolder -PathType Container)) {
	New-Item $downloadFolder -ItemType Directory -Force | Out-Null
}
$body = @{
	type = 'url'
	url  = $productUrl
	ring = 'Retail'
	lang = 'en-US'
}

$raw = Invoke-RestMethod -Method Post -Uri $apiUrl -ContentType 'application/x-www-form-urlencoded' -Body $body

$raw | Select-String '<tr style.*<a href=\"(?<url>.*)"\s.*>(?<text>.*)<\/a>' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { 
	$url = $_.Groups[1].Value
	$text = $_.Groups[2].Value
		if($text -match "_(x64|neutral).*appx(|bundle)$") {
			$downloadFile = Join-Path $downloadFolder $text
			Invoke-WebRequest -Uri $url -OutFile $downloadFile
		}
	}
	Set-Location WinRice
	Add-AppxPackage Microsoft.Desktop*
	Set-Location ../
	Remove-Item WinRice -Recurse -Force
	if (!(Get-Command winget))
	{
		print "Could not install WinGet. Falling back to legacy method."
		print "Warning: Legacy method will install an older version of winget, please update 'App Installer' from Microsoft later on."
		print "Preparing download..."
		# Create new folder and set location.
		if (!(Test-Path WinRice)) {
			New-Item WinRice -ItemType Directory | out-Null
			$currentdir = $(Get-Location).Path
			$dir = "$currentdir/WinRice"
			Set-Location $dir
		}
		else {
			Set-Location WinRice
		}

		# Download the packages.
		$WinGetURL = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
		print "Downloading WinGet installation packages..."
		Start-BitsTransfer $WinGetURL.assets.browser_download_url;

		if (!(Get-AppxPackage "Microsoft.VCLibs.*.UWPDesktop")) {
			$VCLibs = "Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.Appx"
			Start-BitsTransfer $VCLibs
			Add-AppxPackage Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.Appx
		}

		# Install WinGet.
		print "Installing WinGet..."
		Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
			
		# Cleanup installers.
		Set-Location ..
		Remove-Item WinRice -Recurse -Force

		# Get-Command winget, if it works then print success message.
		if (Get-Command winget) {
			print "Installed WinGet."
		}
		else {
			print "WinGet could not be installed."
			return
		}
	}

print "Installed WinGet."