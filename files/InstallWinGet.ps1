$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
if (!(Get-Command winget)) {
	Write-Host "Preparing download..."
	# Create new folder and set location.
	if (!(Test-Path CleanWin)) {
		New-Item CleanWin -ItemType Directory | out-Null
		$currentdir = $(Get-Location).Path
		$dir = "$currentdir/CleanWin"
		Set-Location $dir
	}
	else {
		Set-Location CleanWin
	}

	# Download the packages.
	$WinGetURL = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
	Write-Host "Downloading WinGet installation packages..."
	Start-BitsTransfer $WinGetURL.assets.browser_download_url
	$VCLibsURL = "https://github.com/CleanWin/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.Appx"
	
	if (!(Get-AppxPackage "Microsoft.VCLibs.*.UWPDesktop")) {
		Start-BitsTransfer $VCLibsURL
		Add-AppxPackage Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.Appx
		if (Get-AppxPackage "Microsoft.VCLibs.*.UWPDesktop") {
		}
		elseif (!(Get-AppxPackage "Microsoft.VCLibs.*.UWPDesktop")) {
			Write-Host "Failed to install required frameworks. Couldn't install WinGet."
			Start-Sleep 1
			Exit-PSSession
		}
	}

	# Install WinGet.
	Write-Host "Installing WinGet..."
	Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
		
	# Cleanup installers.
	Set-Location ..
	Remove-Item CleanWin -Recurse -Force

	# Get-Command winget, if it works then print success message.
	if (Get-Command winget) {
		Write-Host "Installed WinGet."
	}
	else {
		Write-Host "WinGet could not be installed."
	}

}
else {
	Write-Host "WinGet is already installed on this device."
}