# This file is a part of the WinRice software
# Copyright (c) 2021 Pratyaksh Mehrotra <pratyakshm@protonmail.com>
# All rights reserved.

# Default preset
$tasks = @(
### Maintenance Tasks ###
	"WinRice",
	"OSBuildInfo",
	"CreateSystemRestore",
	"Activity",

### Apps & Features ###
	"AppsFeatures",
	"InstallFrameworks",
	# "UninstallFrameworks",
	"InstallWinGet",
	"EnableExperimentsWinGet",
	# "DisableExperimentsWinGet",
	"MicrosoftStore",
	"Install7zip", 
	# "Uninstall7zip",
	"WinGetImport",
	"Winstall", 
	"InstallHEVC", 
	# "UninstallHEVC",
	"Widgets",
	"InstallFonts", 
	# "UninstallFonts",
	"UninstallApps", "Activity", 
	"WebApps",
	"UninstallConnect",
	"UnpinStartTiles", "Activity", 
	"UnpinAppsFromTaskbar", 
	"UninstallOneDrive", "Activity",
	# "InstallOneDrive",
	"UninstallFeatures", "Activity", 
	# "InstallFeatures", "Activity", 
	"EnableWSL", "Activity", 
	# "DisableWSL",
	"EnabledotNET3.5", "Activity", 
	# "DisabledotNET3.5",
	"EnableSandbox",
	# "DisableSandbox",
	"SetPhotoViewerAssociation",
	# "UnsetPhotoViewerAssociation",
	"ChangesDone",

### Privacy & Security ###
	"PrivacySecurity",
	"DisableActivityHistory",	
	# "EnableActivityHistory",
	"DisableAdvertisingID",			
	# "EnableAdvertisingID",
	"DisableBackgroundApps",        
	# "EnableBackgroundApps",
	"DisableFeedback",		       
	# "EnableFeedback",
	"DisableInkHarvesting",			
	# "EnableInkHarvesting",
	"DisableLangAccess",  		    
	# "EnableLangAccess",
	"DisableLocationTracking",      
	# "EnableLocationTracking",
	"DisableMapUpdates",			
	# "EnableMapsUpdates",
	"DisableSpeechRecognition",		
	# "EnableSpeechRecognition",
	"DisableSilentInstallApps",
	# "EnableSilentInstallApps",
	"HideSuggestedContentInSettings",
	# "ShowSuggestedContentInSettings",
	"HideSuggestedContentInStart",
	# "ShowSuggestedContentInStart",
	"DisableTailoredExperiences",	
	# "EnableTailoredExperiences",
	"DisableTelemetry",				
	# "EnableTelemetry",
	"EnableClipboard",				
	# "DisableClipboard",
	"AutoLoginPostUpdate", 		    
	# "StayOnLockscreenPostUpdate",
	"ChangesDone",

### Tasks & Services ###
	"TasksServices",
	"DisableStorageSense",		   
	# "EnableStorageSense",
	"DisableReservedStorage",	   
	# "EnableReservedStorage",
	"DisableAutoplay",             
	# "EnableAutoplay",
	"DisableAutorun",              
	# "EnableAutorun",
	"DisableHibernation",
	# "EnableHibernation",
	"SetBIOSTimeUTC",              
	# "SetBIOSTimeLocal",
	"EnableNumLock",			   
	# "DisableNumLock",
	"DisableServices",			   
	# "EnableServices",
	"DisableTasks",				   
	# "EnableTasks",
	"SetupWindowsUpdate",		   
	# "ResetWindowsUpdate",
	# "EnablePowerdownAfterShutdown",
	# "DisablePowerdownAfterShutdown",
	"ChangesDone",

### Windows Explorer ###
	"PrintExplorerChanges",
	"EnablePrtScrToSnip",		   
	# "DisablePrtScrSnip",
	"ShowExtensions",
	# "HideExtensions",
	"HideRecentFilesInQuickAccess",
	# "ShowRecentFilesInQuickAccess",
	"EnableExtensions",
	# "DisableExtensions",
	"DisableStickyKeys",           
	# "EnableStickyKeys",
	"SetExplorerThisPC",           
	# "SetExplorerQuickAccess",
    "Hide3DObjects",      		   
	# "Restore3DObjects",
	"HideSearchBar",			   
	# "RestoreSearchBar"
	"HideTaskView",                
	# "RestoreTaskView",
	"HideCortana",			       
	# "RestoreCortana",
	"HideMeetNow",				   
	# "RestoreMeetNow",
	"DisableTaskbarFeed",		   
	# "EnableTaskbarFeed",  (News and Interests)
	"DisableWidgetsItem",
	# "EnableWidgetsItem",
	"DisableChatItem",
	# "EnableChatItem",
	"ChangesDone",

###  Tasks after successful run ###
	"Activity",
	"Success"
)

# Reverting changes: https://github.com/pratyakshm/WinRice/wiki/Reverting-changes.

# Core functions +++
Function Log($text) {
	Start-Sleep -Milliseconds 200
    Write-Host $text
}

Function check($test) {
    if ($test -like "y" -or $test -like "yeah" -or $test -like "yes" -or $test -like "yep" -or $test -like "yea" -or $test -like "yah") { 
		return $true
	}
	elseif ($test -like "n" -or $test -like "nope" -or $test -like "no" -or $test -like "nada" -or $test -like "nah" -or $test -like "naw") {
		return $false
	}
}

Function cwexit {
	Write-Host "WinRice will now exit."
	Start-Sleep -Seconds 2
	exit
}

Function ask($question) {
	Read-Host $question
}

Function space {
	Write-Host " "
}

Function print($text) {
	Write-Host $text
}

function RunWithProgress {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Text,
        [Parameter(Mandatory = $true)]
        [ScriptBlock]
        $Task,
		[Parameter(Mandatory = $false)]
        [Boolean]
		$Exit = $false
    )
    $spinner = '\', '|', '/', '-', '\', '|', '/', '-'
	$endtext = $text
    # Run given scriptblock in bg
    $job = Start-Job -ScriptBlock $Task
    # Spin while job is running
    do {
        foreach ($s in $spinner) {
            Write-Host -NoNewline "`r  [$s] $text"
            Start-Sleep -Milliseconds 150
        }
    }
    while($job.State -eq "Running")
    # Get output
    $result = Receive-Job -Job $job
    # Filter result
    if ($result -eq $false -or $null -eq $result) {
        # Failure indicator
        $ind = '-'
        $color = "DarkRed"
		$fail = $true
    }
    else {
        # Success indicator
        $ind = '+'
        $color = "DarkGreen"
    }
    Write-Host -NoNewline -ForegroundColor $color "`r  [$ind] "; Write-Host "$endtext"
	# Exit on failure
	if ($Exit -and $fail) { cwexit }
    return $result
}


# Did you read the docs? (Funny stuff).
$hasReadDoc = ask "Have you read the documentation? [y/n]"
if (!(check($hasReadDoc))) {
	log "I didn't write the documentation for nothing."
	log "Go ahead, read it."
	log "Ctrl + left click https://github.com/pratyakshm/WinRice/blob/main/README.md"
	log "You're welcome."
	exit
}

# Core functions ---
if (!(Test-Path C:\WinRice)) {
	New-Item C:\WinRice -ItemType Directory | Out-Null 
}
Start-Transcript -OutputDirectory "C:\WinRice" | Out-Null 
$CurrentVersionPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$CurrentBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild
$DisplayVersion = Get-ItemPropertyValue $CurrentVersionPath -Name DisplayVersion -ErrorAction SilentlyContinue
$ProductNameCore = (Get-WmiObject -class Win32_OperatingSystem).Caption
$ProductName = $ProductNameCore.TrimStart("Microsoft ")
$ProductNameCore = $null
$OSBuildCore = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Update\TargetingInfo\Installed\Client.OS.rs2.amd64" -Name Version 
$OSBuild = $OSBuildCore.TrimStart("10.0")
$BuildBranch = Get-ItemPropertyValue $CurrentVersionPath -Name BuildBranch
# Source: https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%207/Module/Sophia.psm1#L825.
$hkeyuser = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID

### Pre-execution tasks ###

Clear-Host
print "WinRice pre-execution environment"
Start-Sleep -Milliseconds 20
space
print "Copyright (c) Pratyaksh Mehrotra and contributors"
Start-Sleep -Milliseconds 20
print "https://github.com/pratyakshm/WinRice"
space
Start-Sleep -Milliseconds 100
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'


####### BEGIN CHECKS #########

# Check if supported OS build.
$oscheck = {
	$CurrentBuild = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentBuild
	if ($CurrentBuild -lt 19043) {
		return $false
	}
	elseif ($CurrentBuild -ge 19043) {
		return $true
	}
}
RunWithProgress -Text "Supported Windows version" -Task $oscheck -Exit $true | Out-Null


# Check if session is elevated.
$isadmin = {
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	$admin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
	return $admin
}

RunWithProgress -Text "Elevated PowerShell session" -Task $isadmin -Exit $true | Out-Null

# Exit WinRice if PC is not connected.
$isonline = {
	Import-Module BitsTransfer
	Start-BitsTransfer https://raw.githubusercontent.com/WinRice/Files/main/File.txt
	if (Test-Path File.txt) {
		Remove-Item File.txt
		return $true
	}
	elseif (!(Test-Path File.txt)) {
		return $false | Out-Null
	}
}

RunWithProgress -Text "Device connection" -Task $isonline -Exit $true | Out-Null

# Check if laptop (https://devblogs.microsoft.com/scripting/hey-scripting-guy-weekend-scripter-how-can-i-use-wmi-to-detect-laptops/).
Param(
[string]$computer = “localhost”
)
$isLaptop = $false | Out-Null
if(Get-WmiObject -Class Win32_SystemEnclosure -ComputerName $computer | Where-Object {$_.ChassisTypes -eq 9 -or $_.ChassisTypes -eq 10 -or $_.ChassisTypes -eq 14}) { 
	$isLaptop = $true | Out-Null
	}
if(Get-WmiObject -Class Win32_Battery -ComputerName $computer) { 
	$isLaptop = $true | Out-Null
	}
$isLaptop

# Check for pending restart (part of code used here was picked from https://thesysadminchannel.com/remotely-check-pending-reboot-status-powershell).
$isrestartpending = {
	param (
		[Parameter(
		Mandatory = $false,
		ValueFromPipeline=$true,
		ValueFromPipelineByPropertyName=$true,
		Position=0
		)]
		[string[]]  $ComputerName = $env:COMPUTERNAME
		)
	ForEach ($Computer in $ComputerName) {
		$PendingReboot = $false
		$HKLM = [UInt32] "0x80000002"
		$WMI_Reg = [WMIClass] "\\$Computer\root\default:StdRegProv"
		if ($WMI_Reg) {
			if (($WMI_Reg.EnumKey($HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\")).sNames -contains 'RebootPending') {$PendingReboot = $true}
			if (($WMI_Reg.EnumKey($HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\")).sNames -contains 'RebootRequired') {$PendingReboot = $true}
		
			# Check for SCCM namespace.
			$SCCM_Namespace = Get-WmiObject -Namespace ROOT\CCM\ClientSDK -List -ComputerName $Computer -ErrorAction Ignore
			if ($SCCM_Namespace) {
				if (([WmiClass]"\\$Computer\ROOT\CCM\ClientSDK:CCM_ClientUtilities").DetermineIfRebootPending().RebootPending -eq $true) {$PendingReboot = $true}
			}
		
			if ($PendingReboot -eq $true) {
				return $false
			}
			else {
				return $true
			}
		}   
	}
}

RunWithProgress -Text "No restarts needed" -Task $isrestartpending -Exit $true | Out-Null

# Clear variables.
$WMI_Reg        = $null
$SCCM_Namespace = $null

# Check PowerShell version and import required modules.
$pwshver = {
	if ((($PSVersionTable).PSVersion).Major -eq "5") { 
		return $true 
	}
	Import-Module -Name Appx, Microsoft.PowerShell.Management, PackageManagement -UseWindowsPowerShell -WarningAction "SilentlyContinue" | Out-Null
	return $true
}

RunWithProgress -Text "Setting up PowerShell" -Task $pwshver -Exit $true | Out-Null

Start-Sleep -Milliseconds 800

# Take user configs.
space
print "Please take your time to answer the questions below in order to save user config."
print "Press Enter to proceed after answering a question."
space
$systemrestore = ask "Create a system restore point? [y/N]"
$uninstallapps = ask "Uninstall inbox apps?"
if ($uninstallapps -like "y") {
	$uninstallmethod = ask "Use App Uninstaller CLI, GUI or List? [CLI/GUI/List]"
}
if ($CurrentBuild -ge 22000) {
	$widgets = ask "Remove Widgets?"
}
$uninstallfeatures = ask "Uninstall unnecessary features?"
$netfx3 = ask "Enable dotNET 3.5?"
$wsl = ask "Enable Windows Subsystem for Linux?"
$sandbox = ask "Enable Windows Sandbox?"
$enableexperimentswinget = ask "winget: enable experimental features?"
$wingetimport = ask "winget: use winget import?"
$winstall = ask "winget: use Winstall?"

space 

Start-Sleep -Milliseconds 100
print "Starting WinRice..."
Start-Sleep -Milliseconds 600

# Intro.
Function WinRice {
	Clear-Host
	space
	print "pratyakshm's WinRice"
	Start-Sleep -Milliseconds 100
	space
	print "Copyright (c) Pratyaksh Mehrotra (a.k.a. pratyakshm) and contributors"
	Start-Sleep -Milliseconds 100
	print "https://github.com/pratyakshm/WinRice"
	Start-Sleep 1
}

# OS Build.
Function OSBuildInfo {
	space
	print "$ProductName $DisplayVersion "
	if ($CurrentBuild -ge 22000)
	{
		print "Build $OSBuild, $BuildBranch branch"
	}
	elseif ($CurrentBuild -lt 22000)
	{
		print "Build $OSBuildCore, $BuildBranch branch"
	}
	
	Start-Sleep -Milliseconds 200
	space
	space
	Start-Sleep 1
}

# Changes performed.
Function ChangesDone {
	space
	print "---------------------------"
	print "     CHANGES PERFORMED     "
	print "---------------------------"
	space
	Start-Sleep 1
}

# Create a system restore point with type MODIFY_SETTINGS.
Function CreateSystemRestore {
$ProgressPreference = 'SilentlyContinue'
	if ($systemrestore -like "y") {
		space
		print "Creating a system restore point with type MODIFY_SETTINGS..."
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -Type DWord -Value 0 -Force
		Enable-ComputerRestore -Drive $env:SystemDrive
		Checkpoint-Computer -Description "WinRice" -RestorePointType "MODIFY_SETTINGS" -WarningAction SilentlyContinue
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -Type DWord -Value 1440 -Force
		Disable-ComputerRestore -Drive $env:SystemDrive
		print "Created system restore point."
	}
}

# Prevent the console output from freezing by emulating backspace key. (https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%205.1/Module/Sophia.psm1#L728-L767)
Function Activity {
	# Sleep for 500ms.
	Start-Sleep -Milliseconds 500

	Add-Type -AssemblyName System.Windows.Forms

	$SetForegroundWindow = @{
		Namespace = "WinAPI"
		Name = "ForegroundWindow"
		Language = "CSharp"
		MemberDefinition = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
	}

	if (-not ("WinAPI.ForegroundWindow" -as [type]))
	{
		Add-Type @SetForegroundWindow
	}

	Get-Process | Where-Object -FilterScript {$_.MainWindowTitle -like "*PowerShell*" -or $_.MainWindowTitle -like "*Windows PowerShell*" -or $_.MainWindowTitle -like "*pwsh*"} | ForEach-Object -Process {
		# Show window if minimized.
		[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10) | Out-Null 

		Start-Sleep -Milliseconds 10

		# Move the console window to the foreground.
		[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle) | Out-Null

		Start-Sleep -Milliseconds 10

		# Emulate Backspace key.
		[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
	}
}



###################################
######### APPS & FEATURES #########
###################################

# Update status
Function AppsFeatures {
	space
	print "-------------------------"
	print "     APPS & FEATURES     "
	print "-------------------------"
	space
}

# Install runtime packages .
Function InstallFrameworks {
$ProgressPreference = 'SilentlyContinue'
	# Create new folder and set location.
	if (!(Test-Path WinRice)) {
		New-Item WinRice -ItemType Directory | out-Null
		$currentdir = $(Get-Location).Path; $dir = "$currentdir/WinRice"; Set-Location $dir
	}
	else {
		Set-Location WinRice
	}
	# Download frameworks.
	print "Installing app frameworks..."
	$VCLibs1 = "https://github.com/WinRice/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.Appx"
	$VCLibs2 = "https://github.com/WinRice/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x86__8wekyb3d8bbwe.Appx"
	$VCLibs3 = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
	$VCLibs4 = "https://aka.ms/Microsoft.VCLibs.x86.14.00.Desktop.appx"
	Start-BitsTransfer $VCLibs1; Start-BitsTransfer $VCLibs2; Start-BitsTransfer $VCLibs3; Start-BitsTransfer $VCLibs4

	# Install frameworks.
	$VCLibs1 = "Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.Appx"
	$VCLibs2 = "Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x86__8wekyb3d8bbwe.Appx"
	$VCLibs3 = "Microsoft.VCLibs.x64.14.00.Desktop.appx"
	$VCLibs4 = "Microsoft.VCLibs.x86.14.00.Desktop.appx"
	Add-AppxPackage $VCLibs1; Add-AppxPackage $VCLibs2; Add-AppxPackage $VCLibs3; Add-AppxPackage $VCLibs4

	# Cleanup installers.
	Set-Location ..
	Remove-Item WinRice -Recurse -Force
		
	# Get-Command VCLibs, if it works then print success message.
	if (Get-AppxPackage *VCLibs*) 
	{
		print "Installed app frameworks."
	}
	else
	{
		print "Could not install app frameworks."
	}
}

Function UninstallFrameworks {
	space
	if (!(Get-AppxPackage "Microsoft.VCLibs.140.00.UWPDesktop" -or Get-AppxPackage "Microsoft.VCLibs.x64.14.00.Desktop")) {
		print "Frameworks are not present on this device."
		return
	}
	print "Uninstalling frameworks..."
	$Apps = @(
		"Microsoft.VCLibs.*.UWPDesktop"
		"Microsoft.VCLibs.*.Desktop"
	)
	ForEach ($App in $Apps) {
		print "     Uninstalling $App."
		Get-AppxPackage $App | Remove-AppxPackage
	}
	if ((Get-AppxPackage "Microsoft.VCLibs.140.00.UWPDesktop") -or (Get-AppxPackage "Microsoft.VCLibs.*.Desktop")) {
		print "Could not uninstall one or more frameworks."
		return
	}
	print "Uninstalled frameworks."
}

# Install WinGet (Windows Package Manager).
Function InstallWinGet {
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
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

	# Download the packages.
	print "Installing WinGet..."
	$WinGetURL = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
	Start-BitsTransfer $WinGetURL.assets.browser_download_url

	# Install WinGet.
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
	}
}

# Enable all experimental features in WinGet.
Function EnableExperimentsWinGet {
$ProgressPreference = 'SilentlyContinue'
	if (!(check($enableexperimentswinget))) { 
		return 
	}
	elseif (!(Get-Command winget)) {
		print "WinGet is not installed."
		return
	}
	space
	print "Turning on experimental features in WinGet..."
	$currentdir = $(Get-Location).Path
	Set-Location "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\"
	Rename-Item settings.json settings.json.backup
	Start-BitsTransfer "https://raw.githubusercontent.com/WinRice/Files/main/settings.json"
	Set-Location $currentdir
	print "Turned on experimental features in WinGet."
}

# Disable all experimental features in winget
Function DisableExperimentsWinGet {
	if (!(Get-Command winget)) {
		print "WinGet is not installed, couldn't turn off its experimental features."
		return
	}
	print "Turning off experimental features in WinGet."
	$currentdir = $(Get-Location).Path
	Set-Location "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\"
	Remove-Item settings.json
	if (!(Test-Path settings.json))
	{
		print "Could not find winget settings backup. Could not turn off experimental features."
		return
	}
	Rename-Item settings.json.backup settings.json
	Set-Location $currentdir
	print "Turned off experimental features in WinGet."
}

# Update Microsoft Store if older version - helpful for users clean installing Windows 11 from ISOs.
function MicrosoftStore {
$ProgressPreference = 'SilentlyContinue'
		if ($CurrentBuild -lt 22000) 
		{
			return
		}
		if ((Get-AppxPackage "Microsoft.WindowsStore").Version -ge "22107.1401.4.0")
		{
			return
		}
		space
		print "Updating Microsoft Store..."
		Get-AppxPackage "Microsoft.WindowsStore" | Remove-AppxPackage 
		Start-BitsTransfer https://github.com/WinRice/Files/raw/main/Microsoft.WindowsStore_22107.1401.4.0_neutral.Msixbundle
		Add-AppPackage "Microsoft.WindowsStore_22107.1401.4.0_neutral.Msixbundle"
		Remove-Item "Microsoft.WindowsStore_22107.1401.4.0_neutral.Msixbundle"
		if ((Get-AppxPackage "Microsoft.WindowsStore").Version -eq "22107.1401.4.0")
		{
			print "Updated Microsoft Store."
			return
		}
		print "Could not update Microsoft Store."
	}
	
# Install 7zip.
Function Install7zip {
	space
	if (!(Get-Command winget)) {
		print "WinGet is not installed. Couldn't install 7-zip."
		return 
	}
	$7zip = "HKLM:\SOFTWARE\7-Zip"
	if (!(Test-Path $7zip)) {
		print "Installing 7-zip..."
		winget install 7zip --silent | Out-Null
		print "Installed 7-zip."
	}
	else {
		print "7-zip is already installed on this device."
	}
}

# Uninstall 7zip
Function Uninstall7zip {
	space
	$7zip = "HKLM:\SOFTWARE\7-Zip"
	if (!(Test-Path $7zip)) {
		print "7-zip is not present on this device."
		return
	}
	print "Uninstalling 7-zip..."
	winget uninstall 7zip.7zip | Out-Null
	if (Test-Path $7zip) {
		print "Could not uninstall 7-zip."
		return
	}
	print "Uninstalled 7-zip."
}

# Use winget import (optional) (part of code used here was picked from https://devblogs.microsoft.com/scripting/hey-scripting-guy-can-i-open-a-file-dialog-box-with-windows-powershell/)
Function WinGetImport {
	if ($wingetimport -like "n" ) {
		return
	}
	if (!(Get-Command winget)) {
		print "WinGet is not installed. Please install WinGet first before using winget import."
		return
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
}

# Install apps from Winstall file (the Winstall.txt file must be on the same directory as WinRice).
Function Winstall {
$ErrorActionPreference = 'Continue'
	# Check if WinGet installed - otherwise return.
	if (!(check($winstall))) { 
		return 
	}
	space
	if (!(Get-Command winget)) { 
		print "WinGet is not installed. Please install WinGet first before using Winstall."
		Start-Process "https://bit.ly/Winstall" 
		return
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
			Get-Content $OpenFileDialog.FileName | ForEach-Object {					$App = $_.Split('=')
				print "    Installing $App..."
				winget install "$App" --silent | Out-Null
			}
			print "Winstall has successfully installed the app(s)."
		}
		else {
			print "No text file was picked."
		}
	}
}

# Install HEVC.
Function InstallHEVC {
$ProgressPreference = 'SilentlyContinue'
	space
	if (Get-AppxPackage -Name Microsoft.HEVCVideoExtension) {
		print "HEVC Video Extensions are already installed on this device."
		return
	}
	print "Installing HEVC Video Extensions..."
	Start-BitsTransfer https://github.com/WinRice/Files/raw/main/Microsoft.HEVCVideoExtension_1.0.42042.0_x64__8wekyb3d8bbwe.Appx
	Add-AppxPackage Microsoft.HEVCVideoExtension_1.0.42042.0_x64__8wekyb3d8bbwe.Appx
	Remove-Item Microsoft.HEVCVideoExtension_1.0.42042.0_x64__8wekyb3d8bbwe.Appx
	if (!(Get-AppxPackage "Microsoft.HEVCVideoExtension"))
	{
		print "Could not install HEVC Video Extensions."
		return 
	}

	print "Installed HEVC Video Extensions."
}

# Uninstall HEVC 
Function UninstallHEVC {
$ProgressPreference = 'SilentlyContinue'
	space
	if (!(Get-AppxPackage "Microsoft.HEVCVideoExtension")) {
		print "HEVC Video Extensions may have already been uninstalled."
		return
	}
	print "Uninstalling HEVC Video Extensions..."
	Get-AppxPackage "Microsoft.HEVCVideoExtension" | Remove-AppxPackage
	if (!(Get-AppxPackage "Microsoft.HEVCVideoExtension")) {
		print "Uninstalled HEVC Video Extensions."
	}
	else {
		print "Could not uninstall HEVC Video Extensions."
	}
}

# Update Widgets
function UpdateWidgets {
	space
	print "Checking if Widgets are updated..."
	$version = (Get-AppxPackage "MicrosoftWindows.Client.WebExperience").Version
	if ($version -ge 421.17400.0.0)
	{	
		print "Widgets are up to date."
		return
	}
	print "Updating Widgets..."
	Start-BitsTransfer https://github.com/WinRice/Files/raw/main/MicrosoftWindows.Client.WebExperience_421.19701.0.0_neutral_cw5n1h2txyewy.AppxBundle
	Add-AppxPackage MicrosoftWindows.Client.WebExperience_421.19701.0.0_neutral_cw5n1h2txyewy.AppxBundle
	$version = (Get-AppxPackage "MicrosoftWindows.Client.WebExperience").Version
	Remove-Item MicrosoftWindows.Client.WebExperience_421.19701.0.0_neutral_cw5n1h2txyewy.AppxBundle
	if ($version -ge 421.19701.0.0) {
		print "Updated Widgets."
	}
	else {
		print "Could not update Widgets."
	}
}

# Remove Widgets
function RemoveWidgets {
	space
	if (!(Get-AppxPackage "MicrosoftWindows.Client.WebExperience")) {
		print "Widgets may have already been removed."
		return
	}
	print "Removing Widgets..."
	Get-AppxPackage "MicrosoftWindows.Client.WebExperience" | Remove-AppxPackage
	if (Get-AppxPackage "MicrosoftWindows.Client.WebExperience"){
		print "Could not remove Widgets."
	}
	else {
		print "Removed Widgets."
	}
}

# Unfinished function.
Function Widgets {
$ProgressPreference = 'SilentlyContinue'
	if ($widgets -like "n") {
		UpdateWidgets
	}
	elseif ($widgets -like "y") {
		RemoveWidgets
	}
}

# Install fonts (part of code here was picked from https://github.com/code-rgb/WinRice).
Function InstallFonts {
$ProgressPreference = 'SilentlyContinue'
	space
	# Check if Cascadia Code is installed and inform user.
	$installed = "C:\Windows\Fonts\CascadiaCodePL.ttf"
	if (Test-Path -Path $installed) {
		print "Cascadia Code is already installed on this device."
		return
	}
	# Install Cascadia Code if not already installed.
	print "Installing Cascadia Code..."
	$response = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/cascadia-code/releases/latest"
	Start-BitsTransfer -Source $response.assets.browser_download_url -Destination "CascadiaCode.zip"
	Expand-Archive CascadiaCode.zip
	$font = $(Get-ChildItem "CascadiaCode\ttf\CascadiaCodePL.ttf").FullName
	$installed = "C:\Windows\Fonts\CascadiaCodePL.ttf"
	Move-Item $font $installed
	Remove-Item CascadiaCode.zip
	Remove-Item CascadiaCode -Recurse -Force
	print "Installed Cascadia Code."
}

Function UninstallFonts {
	$fontfile = "C:\Windows\Fonts\CascadiaCodePL.ttf"
	if (!($fontfile)) {
		print "Fonts may have already been uninstalled."
		return
	}
	space
	print "Uninstalling fonts..."
	Remove-Item $fontfile
	if (!($fontfile)) {
		print "Uninstalled fonts."
	}
	else {
		print "Could not uninstall fonts."
	}
}


# Uninstaller GUI.
Function UninstallerGUI {
	
    Add-Type -AssemblyName PresentationCore, PresentationFramework

    #region Variables.
    # ArrayList containing the UWP apps to remove.
    $AppxPackages = New-Object -TypeName System.Collections.ArrayList($null)

    # List of UWP apps that won't be checked for removal.
    $UncheckedAppxPackages = @(

        # Calculator.
        "Microsoft.WindowsCalculator",
    
        # Microsoft Office.
        "Microsoft.Office.Desktop.OneNote",
        "Microsoft.Office.Desktop.Word",
        "Microsoft.Office.Desktop",
        "Microsoft.Office.Desktop.Outlook",
        "Microsoft.Office.Desktop.Excel",
        "Microsoft.Office.Desktop.Access",
        "Microsoft.Office.Desktop.PowerPoint",
    
        # Microsoft Store.
        "Microsoft.WindowsStore",
    
        # Photos (and Video Editor).
        "Microsoft.Windows.Photos",
        "Microsoft.Photos.MediaEngineDLC",

        # Snip & Sketch.
        "Microsoft.ScreenSketch"

    )

    # UWP apps that won't be shown in the form
    $ExcludedAppxPackages = @(
		# HEVC Video Extensions from Device Manufacturer.
		"Microsoft.HEVCVideoExtension",

		# Microsoft Store and appx dependencies.
		"Microsoft.StorePurchaseApp",
        "Microsoft.DesktopAppInstaller",
    
        # Web Media Extensions.
        "Microsoft.WebMediaExtensions"

        # Media Engine DLC
        "Microsoft.Photos.MediaEngineDLC"

        # Windows Terminal.
        "Microsoft.WindowsTerminal"

        # Web Experience (used for Widgets).
        "MicrosoftWindows.Client.WebExperience"
            
        # Xbox apps.
		"Microsoft.GamingServices",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxGameOverlay"
    )
    #endregion Variables.

    #region XAML Markup.
    [xml]$XAML = '
    <Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Name="Window"
    MinHeight="450" MinWidth="400"
    SizeToContent="Width" WindowStartupLocation="CenterScreen"
    TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
    FontFamily="Segoe UI" FontSize="12" ShowInTaskbar="False">
    <Window.Resources>
    <Style TargetType="StackPanel">
                <Setter Property="Orientation" Value="Horizontal"/>
            </Style>
            <Style TargetType="CheckBox">
                <Setter Property="Margin" Value="10, 10, 5, 10"/>
                <Setter Property="IsChecked" Value="True"/>
            </Style>
            <Style TargetType="TextBlock">
                <Setter Property="Margin" Value="5, 10, 10, 10"/>
            </Style>
            <Style TargetType="Button">
                <Setter Property="Margin" Value="20"/>
                <Setter Property="Padding" Value="10"/>
            </Style>
        </Window.Resources>
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <StackPanel Grid.Column="1" Orientation="Horizontal">
                    <CheckBox Name="CheckboxRemoveAll" IsChecked="False"/>
                    <TextBlock Name="TextblockRemoveAll"/>
                </StackPanel>
            </Grid>
            <ScrollViewer Name="Scroll" Grid.Row="1"
                HorizontalScrollBarVisibility="Disabled"
                VerticalScrollBarVisibility="Auto">
                <StackPanel Name="PanelContainer" Orientation="Vertical"/>
            </ScrollViewer>
            <Button Name="Button" Grid.Row="2"/>
        </Grid>
</Window>
    '
    #endregion XAML Markup.

    $Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
    $Form = [Windows.Markup.XamlReader]::Load($Reader)
    $XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
        Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name) -Scope Global
    }


    #region Functions.
    function Get-CheckboxClicked
    {
        [CmdletBinding()]
        param
        (
            [Parameter(
                Mandatory = $true,
                ValueFromPipeline = $true
            )]
            [ValidateNotNull()]
            $CheckBox
        )

        $AppxName = $CheckBox.Parent.Children[1].Text
        if ($CheckBox.IsChecked)
        {
            [void]$AppxPackages.Add($AppxName)
        }
        else
        {
            [void]$AppxPackages.Remove($AppxName)
        }
        if ($AppxPackages.Count -gt 0)
        {
            $Button.IsEnabled = $true
        }
        else
        {
            $Button.IsEnabled = $false
        }
    }

    function DeleteButton
    {
        [void]$Window.Close()
        $OFS = "|"
        if ($CheckboxRemoveAll.IsChecked) {   
            print "Uninstalling $AppxPackages..."
            Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cmatch $AppxPackages} | Remove-AppxPackage -AllUsers
            print "Done."
        }
        else {  
            print "Uninstalling $AppxPackages..."
            Get-AppxPackage -PackageTypeFilter Bundle | Where-Object -FilterScript {$_.Name -cmatch $AppxPackages} | Remove-AppxPackage
            print "Done."
        }
        $OFS = " "
    }

    function Add-AppxControl
    {
        [CmdletBinding()]
        param
        (
            [Parameter(
                Mandatory = $true,
                ValueFromPipeline = $true
            )]
            [ValidateNotNull()]
            [string]
            $AppxName
        )

        $CheckBox = New-Object -TypeName System.Windows.Controls.CheckBox
        $CheckBox.Add_Click({Get-CheckboxClicked -CheckBox $_.Source})

        $TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock
        $TextBlock.Text = $AppxName

        $StackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
        [void]$StackPanel.Children.Add($CheckBox)
        [void]$StackPanel.Children.Add($TextBlock)

        [void]$PanelContainer.Children.Add($StackPanel)

        if ($UncheckedAppxPackages.Contains($AppxName))
        {
            $CheckBox.IsChecked = $false
            # Exit function, item is not checked.
            return
        }

        # If package checked, add to the array list to uninstall.
        [void]$AppxPackages.Add($AppxName)
    }
    #endregion Functions.

    #region Events Handlers.

    # Window Loaded Event.
    $Window.Add_Loaded({
        $OFS = "|"
        (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cnotmatch $ExcludedAppxPackages}).Name | ForEach-Object -Process {
            Add-AppxControl -AppxName $_
        }
        $OFS = " "

        $TextblockRemoveAll.Text = "All users"
        $Window.Title = "Select apps"
        $Button.Content = "Uninstall"
    })

    preventfreeze

    # Button Click Event.
    $Button.Add_Click({DeleteButton})
    #endregion Events Handlers.

    if (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cnotmatch ($ExcludedAppxPackages -join "|")})
    {
        # Display the dialog box.
        $Form.ShowDialog() | Out-Null
    }
    else
    {
        print "Nothing to display."
    }
}

# Uninstaller CLI.
Function UninstallerCLI {
	print "Uninstalling inbox apps..." # Remove inbox apps.
	$InboxApps = @(
		"Microsoft.549981C3F5F10"
		"Microsoft.BingNews"
		"Microsoft.BingWeather"
		"Microsoft.GamingApp"
		"Microsoft.GetHelp" 
		"Microsoft.Getstarted" 
		"Microsoft.Messaging"
		"Microsoft.Microsoft3DViewer" 
		"Microsoft.MicrosoftStickyNotes"  
		"Microsoft.MSPaint" # Paint 3D app
		"Microsoft.Paint"  # Paint app (MSIX)
		"Microsoft.MicrosoftOfficeHub"
		"Microsoft.Office.OneNote"
		"Microsoft.MixedReality.Portal"
		"Microsoft.MicrosoftSolitaireCollection" 
		"Microsoft.NetworkSpeedTest" 
		"Microsoft.News" 
		"Microsoft.Office.Sway" 
		"Microsoft.OneConnect"
		"Microsoft.People" 
		"Microsoft.PowerAutomateDesktop"
		"Microsoft.Print3D" 
		"Microsoft.SkypeApp"
		"Microsoft.Todos"
		"Microsoft.WindowsAlarms"
		"Microsoft.WindowsCommunicationsApps" 
		"Microsoft.WindowsFeedbackHub" 
		"Microsoft.WindowsMaps" 
		"Microsoft.WindowsSoundRecorder"
		"Microsoft.XboxApp"
		"Microsoft.YourPhone"
		"Microsoft.ZuneMusic"
		"Microsoft.ZuneVideo"
	)
	ForEach ($InboxApp in $InboxApps) {
		if (Get-AppxPackage $InboxApp) {
			print "     Uninstalling $InboxApp..."
			Get-AppxPackage -Name $InboxApp| Remove-AppxPackage 
			Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $InboxApp | Remove-AppxProvisionedPackage -Online | Out-Null
		}
	}

	if (!(Get-CimInstance -ClassName Win32_PnPEntity | Where-Object -FilterScript {($_.PNPClass -eq "Camera") -or ($_.PNPClass -eq "Image")})) {
		print "     Uninstalling Microsoft.WindowsCamera..."
		if (Get-AppxPackage "Microsoft.WindowsCamera")
		{
			Get-AppxPackage "Microsoft.WindowsCamera" | Remove-AppxPackage
			Get-AppxProvisionedPackage -Online "Microsoft.WindowsCamera" | Remove-AppxProvisionedPackage 
		}
	}

	$SponsoredApps = @(					# Remove Sponsored apps.
		"*AdobePhotoshopExpress*"
		"*CandyCrush*"
		"*BubbleWitch3Saga*"
		"*Twitter*"
		"*Facebook*"
		"*Spotify*"
		"*Minecraft*"
		"*Dolby*"
	)
	ForEach ($SponsoredApp in $SponsoredApps) {
		if (Get-AppxPackage $SponsoredApp) {
			print "     Uninstalling $SponsoredApp.."
			Get-AppxPackage -Name $SponsoredApp| Remove-AppxPackage 
			Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $SponsoredApp | Remove-AppxProvisionedPackage -Online | Out-Null
		}
	}
	print "Uninstalled inbox apps."
}

# Get apps and uninstall from text file
function UninstallerList {
	if (Test-Path uninstallapps.txt) {
		print "Uninstalling listed inbox apps..."
		# Get each line from the text file and use winget install command on it.
		Get-Content 'Winstall.txt' | ForEach-Object {
			if (Get-AppxPackage $App) 
			{
				print "     Uninstalling $App"
				Get-AppxPackage "$App" | Remove-AppxPackage
			}
			elseif (!(Get-AppxPackage $App))
			{
				print "     Couldn't find: $App"
			}
		}
		print "Uninstalled listed inbox apps."
	}
	else
	{
		[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
		print "App Uninstaller Lists"
		print "Select a text file"
		$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
		$OpenFileDialog.InitialDirectory = $initialDirectory
		$OpenFileDialog.Filter = "Text file (*.txt)| *.txt"
		$OpenFileDialog.ShowDialog() | Out-Null
		if ($OpenFileDialog.FileName) {
			print "Uninstalling listed inbox apps..."
			Get-Content $OpenFileDialog.FileName | ForEach-Object {	
				$App = $_.Split('=')
				print "     Uninstalling $App"
				Get-AppxPackage "$App" | Remove-AppxPackage
			}
			print "Uninstalled listed inbox apps."
		}
		else {
			print "No text file was picked."
		}
	}
}

# Main Uninstall function.
Function UninstallApps {
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
	if (!(check($uninstallapps))) { 
		return 
	}
	space
	if ($uninstallmethod -like "CLI") 
	{
		UninstallerCLI
	}
	elseif ($uninstallmethod -like "GUI") 
	{
		UninstallerGUI
	}
	elseif ($uninstallmethod -like "List" -or $uninstallmethod -like "Lists")
	{
		UninstallerList
	}
}

# Remove Office webapps.
function WebApps {
	if (!(Test-Path "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk")) {
		return
	}
	print "Removing Office web-apps..."
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Outlook.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Word.lnk"
	print "Removed Office web-apps."
}
	
# Uninstall Connect app.
Function UninstallConnect {
	if (!(Get-AppxPackage Microsoft-PPIProjection-Package))  {
		return
	}
	Start-BitsTransfer https://github.com/WinRice/Files/raw/main/install_wim_tweak.exe
	Start-BitsTransfer https://raw.githubusercontent.com/WinRice/Files/main/connect.cmd
	./connect.cmd | Out-Null
	Remove-Item install_wim_tweak.exe
	Remove-Item connect.cmd
	Remove-Item Packages.txt
}

# Unpin all start menu tiles.
Function UnpinStartTiles {
	if ($CurrentBuild -ge 22000) {
		return
	}
	space
	print "Unpinning all tiles from Start Menu..."
	Set-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -Value '<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '  <LayoutOptions StartTileGroupCellWidth="6" />'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '  <DefaultLayoutOverride>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    <StartLayoutCollection>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '      <defaultlayout:StartLayout GroupCellWidth="6" />'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    </StartLayoutCollection>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '  </DefaultLayoutOverride>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    <CustomTaskbarLayoutCollection>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '      <defaultlayout:TaskbarLayout>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '        <taskbar:TaskbarPinList>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '          <taskbar:UWA AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" />'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '          <taskbar:DesktopApp DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '        </taskbar:TaskbarPinList>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '      </defaultlayout:TaskbarLayout>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    </CustomTaskbarLayoutCollection>'
	Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '</LayoutModificationTemplate>'
	$START_MENU_LAYOUT = @"
	<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
		<LayoutOptions StartTileGroupCellWidth="6" />
		<DefaultLayoutOverride>
			<StartLayoutCollection>
				<defaultlayout:StartLayout GroupCellWidth="6" />
			</StartLayoutCollection>
		</DefaultLayoutOverride>
	</LayoutModificationTemplate>
"@
	$layoutFile="C:\Windows\StartMenuLayout.xml"
	# Delete layout file if it already exists.
	if(Test-Path $layoutFile)
	{
		Remove-Item $layoutFile
	}
	# Creates a blank layout file.
	$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
	$regAliases = @("HKLM", "HKCU")
	# Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level.
	foreach ($regAlias in $regAliases){
		$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
		$keyPath = $basePath + "\Explorer" 
		if(!(Test-Path -Path $keyPath)) { 
			New-Item -Path $basePath -Name "Explorer" | Out-Null
		}
		Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
		Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
		}
	# Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process.
	Stop-Process -name explorer -Force
	Start-Sleep -s 5
	$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
	Start-Sleep -s 5
	# Enable the ability to pin items again by disabling "LockedStartLayout".
	foreach ($regAlias in $regAliases){
		$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
		$keyPath = $basePath + "\Explorer" 
		Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
	}
	# Restart Explorer and delete the layout file.
	Stop-Process -name explorer -Force
	# Uncomment the next line to make clean start menu default for all new users.
	Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
	Remove-Item $layoutFile
	print "Unpinned all tiles from Start Menu."
}

# Unpin Apps from taskbar (https://docs.microsoft.com/en-us/answers/questions/214599/unpin-icons-from-taskbar-in-windows-10-20h2.html).
Function UnpinAppsFromTaskbar {
	space
	print "Unpinning apps from taskbar..."
	$AppNames = @(
		"Mail"
		"Microsoft Edge"
		"Microsoft Store"
		"Microsoft Teams"
		"Office"
		"Xbox"
	)
	ForEach ($AppName in $AppNames) {
		if ( $App = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object { $_.Name -eq $AppName })) {
			$App.Verbs() | Where-Object { $_.Name.replace('&', '') -match 'Unpin from taskbar' } | ForEach-Object {$_.DoIt()} -ErrorAction SilentlyContinue | Out-Null
		}	
	}
	print "Unpinned apps from taskbar."
	Start-Sleep -Milliseconds 100
}

# Uninstall Microsoft OneDrive (supports 64-bit versions).
Function UninstallOneDrive {
$ErrorActionPreference = 'SilentlyContinue'
	if (!(check($uninstallapps))) { 
		return 
	}
	space
	if (!(Get-Command winget)) {
		print "WinGet is not installed. Microsoft OneDrive could not be uninstalled."
		return
	}
	print "Uninstalling Microsoft OneDrive..."

	# Uninstall using WinGet.
	winget uninstall Microsoft.OneDrive --silent | Out-Null

	# Cleanup leftover folders.
	Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force
	Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -Force
	Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force
	Remove-Item "$env:LOCALAPPDATA\OneDrive" -Recurse -Force

	print "Uninstalled Microsoft OneDrive."
}


# Install Microsoft OneDrive 
Function InstallOneDrive {
	if (!(Get-Command winget)) {
		print "WinGet is not installed. Could not install Microsoft OneDrive."
		return
	}
	print "Installing Microsoft OneDrive."
	winget install Microsoft.OneDrive --silent | Out-Null
	$check = winget list Microsoft.OneDrive
	if ($check -like "No installed package found matching input criteria.") {
		print "Could not install Microsoft OneDrive."
		return
	}
	print "Installed Microsoft OneDrive."
}


# Uninstall Windows Optional Features and Windows Capabilities.
Function UninstallFeatures {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
	if (!(check($uninstallfeatures))) { 
		return 
	}
	space
	print "Removing capabilites and features..."

	# Capablities 
	if ($CurrentBuild -lt 22000) 
	{
		$Capabilities = @(
			"App.StepsRecorder*"
			"MathRecognizer*"
			"Media.WindowsMediaPlayer*"
			"Microsoft-Windows-SnippingTool*"
			"Microsoft.Windows.MSPaint*" 
			"Microsoft.Windows.PowerShell.ISE*"
			"Microsoft.Windows.WordPad*"
			"Print.Fax.Scan*"
			"Print.Management.Console*"
			"XPS.Viewer*"
		)
	}
	elseif ($CurrentBuild -ge 22000)
	{
		$Capabilities = @(
			"App.StepsRecorder*"
			"MathRecognizer*"
			"Media.WindowsMediaPlayer*"
			"Microsoft.Windows.PowerShell.ISE*"
			"Microsoft.Windows.WordPad*"
			"Print.Fax.Scan*"
			"Print.Management.Console*"
			"XPS.Viewer*"
		)
	}

	ForEach ($Capability in $Capabilities) {
		Get-WindowsCapability -Online | Where-Object {$_.Name -like $Capability} | Remove-WindowsCapability -Online | Out-Null
	}
	
	if (!(Get-CimInstance -ClassName Win32_PnPEntity | Where-Object -FilterScript {($_.PNPClass -eq "Camera") -or ($_.PNPClass -eq "Image")})) 
	{
		Get-WindowsCapability -Online "*Hello.Face*" | Remove-WindowsCapability -Online | Out-Null
		print "    - Uninstalled Windows Hello Face"
	}

	# Print list of capabilities
	if ($CurrentBuild -lt 22000)
	{
		$CapLists =@(
			"Math Recognizer"
			"Microsoft Paint"
			"Steps Recorder"
			"Snipping Tool" 
			"Windows Fax & Scan"
			"Windows Media Player"
			"Windows Hello Face"
			"Windows PowerShell ISE"
			"Windows XPS Features"
			"WordPad"
		)
		ForEach ($CapList in $CapLists) {
			Start-Sleep -Milliseconds 20
			print "    - Uninstalled $CapList"
		}
	}

	elseif ($CurrentBuild -ge 22000)
	{
		$CapLists =@(
			"Math Recognizer"
			"Steps Recorder"
			"Windows Fax & Scan"
			"Windows Media Player"
			"Windows Hello Face"
			"Windows PowerShell ISE"
			"Windows XPS Features"
			"WordPad"
		)
		ForEach ($CapList in $CapLists) {
			Start-Sleep -Milliseconds 20
			print "    - Uninstalled $CapList"
		}
	}

	$OptionalFeatures = @(
		"LegacyComponents"
		"Printing-XPSServices-Feature*"
		"SmbDirect"
		"SMB1Protocol"
		"SMB1Protocol-Deprecation"
		"SMB1Protocol-Client"
		"SMB1Protocol-Server"
		"MicrosoftWindowsPowerShellV2"
		"MicrosoftWindowsPowerShellV2Root"
		"WorkFolders-Client*"
	)
	ForEach ($OptionalFeature in $OptionalFeatures) {
		Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like $OptionalFeature} | Disable-WindowsOptionalFeature -Online -NoRestart | Out-Null
	}

	# Print user friendly list of features uninstalled.
	$Features =@(
		"DirectPlay"
		"PowerShell v2 (root)"
		"SMB1 protocol"
		"SMB Direct"
		"Work Folders Client"
		"XPS Document Writer"
	)
	ForEach ($Feature in $Features) {
		Start-Sleep -Milliseconds 20
		print "    - Disabled $Feature"
	}
	
	print "Removed capabilities and features."
}

# Install Windows Optional Features and Windows Capabilities.
Function InstallFeatures {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Adding capabilites and features..."
	# Install capabilities.
	$Capabilities = @(
		"App.StepsRecorder*"
		"Hello.Face*"
		"MathRecognizer*"
		"Media.WindowsMediaPlayer*"
		"Microsoft-Windows-SnippingTool*"
		"Microsoft.Windows.MSPaint*" 
		"Microsoft.Windows.PowerShell.ISE*"
		"Microsoft.Windows.WordPad*"
		"Print.Fax.Scan*"
		"XPS.Viewer*"
	)
	ForEach ($Capability in $Capabilities) {
		Get-WindowsCapability -Online | Where-Object {$_.Name -like $Capability} | Add-WindowsCapability -Online | Out-Null
	}
	# Print user friendly list of capabilities installed.
	$CapLists =@(
		"Math Recognizer"
		"Microsoft Paint"
		"Snipping Tool"
		"Steps Recorder"
		"Windows Fax & Scan"
		"Windows Media Player"
		"Windows Hello Face"
		"Windows PowerShell ISE"
		"Windows XPS Features"
		"WordPad"
	)
	ForEach ($CapList in $CapLists) {
		Start-Sleep -Milliseconds 70
		print "    - Installed $CapList"
	}

	$OptionalFeatures = @(
		"WorkFolders-Client*"
		"Printing-XPSServices-Feature*"
	)
	ForEach ($OptionalFeature in $OptionalFeatures) {
		Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like $OptionalFeature} | Enable-WindowsOptionalFeature -Online -NoRestart | Out-Null
	}
	# Print user friendly list of features uninstalled.
	print "    - Enabled Work Folders Client."
	
	print "Added capabilities and features."
}

# Install WSL on Windows 11
function installwslwin11 {
	print "Installing Windows Subsystem for Linux..."
	wsl --install | Out-Null
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State -like "Disabled") {
		print "Could not install Windows Subsystem for Linux."
		return
	}
	print "Installed Windows Subsystem for Linux."
}

# Install WSL on Windows 10
function installwslwin10 {
	# Check if KB5004296 is installed.
	# https://support.microsoft.com/en-us/topic/july-29-2021-kb5004296-os-builds-19041-1151-19042-1151-and-19043-1151-preview-6aba536a-6ed2-41cb-bc3d-3980e8693cc4
	# If yes, then use wsl --install, or else fallback to legacy deployment method.

	$updated = Get-HotFix -ID KB5004296

	print "Installing Windows Subsystem for Linux..."

	if ($updated) {
		wsl --install | Out-Null
	}

	elseif (!($updated)) {
		print "Hotfix KB5004296 is not applied to this device, falling back to classic WSL deployment method..."
		print "Please manually install Linux kernel updates and switch to WSL2 after device restart."
		Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All -NoRestart | Out-Null
	}
	
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State -like "Disabled") {
		print "Could not install Windows Subsystem for Linux."
		return
	}
	print "Installed Windows Subsystem for Linux."
}

# Enable Windows Subsystem for Linux.
Function EnableWSL {
$ProgressPreference = 'SilentlyContinue'
	if (!(check($wsl))) { 
		return 
	}

	space 
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State -like "Enabled") {
		print "Windows Subsystem for Linux is already enabled."
		return
	}

	if ($CurrentBuild -ge 22000) {
		# Call installwslwin11 function
		installwslwin11
	}
	elseif ($CurrentBuild -lt 22000) {
		# Call installwslwin10 function
		installwslwin10
	}

}

# Disable Windows Subsystem for Linux.
Function DisableWSL {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
	space
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State -like "Disabled") {
		print "Windows Subsystem for Linux is already disabled."
		return
	}

	print "Disabling Windows Subsystem for Linux..."
	Disable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart | Out-Null

	if ((Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State -like "Enabled") {
		print "Could not disable Windows Subsystem for Linux."
		return
	}
	print "Disabled Windows Subsystem for Linux."
}

# Enable Sandbox.
Function EnableSandbox {
$ProgressPreference = 'SilentlyContinue'
	if ($sandbox -like "n") {
		return
	}
	space
	if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"})) {
		print "Could not enable Windows Sandbox since $ProductName does not support it."
		return
	}
	print "Enabling Windows Sandbox..."
	Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart -WarningAction Ignore | Out-Null
	print "Enabled Windows Sandbox."
}

# Disable Sandbox
Function DisableSandbox {
$ProgressPreference = 'SilentlyContinue'
	space
	if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"})) {
		print "Windows Sandbox can't be toggled in $ProductName."
		return
	}
	print "Disabling Windows Sandbox..."
	Disable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart -WarningAction Ignore | Out-Null
	print "Disabled Windows Sandbox."
}

# Enable dotNET 3.5.
Function EnabledotNET3.5 {
$ProgressPreference = 'SilentlyContinue'
	if (!(check($netfx3))) { 
		return 
	}
	$netfx3state = (Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State
	if ($netfx3state -like "Enabled"){
		print "dotNET 3.5 is already enabled."
		return
	}
	space
	print "Enabling dotNET 3.5..."
	Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -NoRestart | Out-Null
	print "Enabled dotNET 3.5."
}

# Disable dotNET 3.5
Function DisabledotNET3.5 {
$ProgressPreference = 'SilentlyContinue'
	space
	$netfx3state = (Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State
	if ($netfx3state -like "Disabled"){
		print "dotNET 3.5 is already disabled."
		return
	}
	print "Disabling dotNET 3.5..."
	Disable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -NoRestart | Out-Null
	print "Disabled dotNET 3.5."
}


# Set Windows Photo Viewer association for bmp, gif, jpg, png and tif.
Function SetPhotoViewerAssociation {
	space
	print "Adding Windows Photo Viewer (classic) to the 'Open with' menu..."
	if (!(Test-Path "HKCR:")) {
		New-PSDrive -Name "HKCR" -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" | Out-Null
	}
	ForEach ($type in @("Paint.Picture", "giffile", "jpegfile", "pngfile")) {
		New-Item -Path $("HKCR:\$type\shell\open") -Force | Out-Null
		New-Item -Path $("HKCR:\$type\shell\open\command") | Out-Null
		Set-ItemProperty -Path $("HKCR:\$type\shell\open") -Name "MuiVerb" -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
		Set-ItemProperty -Path $("HKCR:\$type\shell\open\command") -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
	}
	print "Added Windows Photo Viewer (classic) to the 'Open with' menu."

}

# Unset Windows Photo Viewer association for bmp, gif, jpg, png and tif.
Function UnsetPhotoViewerAssociation {
	print "Removing Windows Photo Viewer (classic) from the 'Open with' menu..."
	if (!(Test-Path "HKCR:")) {
		New-PSDrive -Name "HKCR" -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" | Out-Null
	}
	Remove-Item -Path "HKCR:\Paint.Picture\shell\open" -Recurse -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "MuiVerb" -ErrorAction SilentlyContinue
	Set-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "CommandId" -Type String -Value "IE.File"
	Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "(Default)" -Type String -Value "`"$env:SystemDrive\Program Files\Internet Explorer\iexplore.exe`" %1"
	Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "DelegateExecute" -Type String -Value "{17FE9752-0B5A-4665-84CD-569794602F5C}"
	Remove-Item -Path "HKCR:\jpegfile\shell\open" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\pngfile\shell\open" -Recurse -ErrorAction SilentlyContinue
	print "Removed Windows Photo Viewer association."
}



######################################
######### PRIVACY & SECURITY #########
######################################

# Update status
Function PrivacySecurity {
	space
	print "-------------------------"
	print "    PRIVACY & SECURITY   "
	print "-------------------------"
	space
}


# Disable Activity History.
Function DisableActivityHistory {
	space
	print "Turning off Activity History..."
	$ActivityFeed = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityFeed -Name "EnableActivityFeed" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "PublishUserActivities" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "UploadUserActivities" -Type DWord -Value 0	
	print "Turned off Activity History."
}

# Enable Activity History.
Function EnableActivityHistory {
	print "Turning on Activity History..."
	$ActivityHistory = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityHistory -Name "EnableActivityFeed" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "PublishUserActivities" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "UploadUserActivities" -Type DWord -Value 1
	print "Turned on Activity History."
}

# Disable Advertising ID.
Function DisableAdvertisingID {
	space
	print "Turning off Advertising ID..."
	$AdvertisingID = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	if (!(Test-Path $AdvertisingID)) {
		New-Item -Path $AdvertisingID | Out-Null
	}
	Set-ItemProperty -Path $AdvertisingID -Name "DisabledByGroupPolicy" -Type DWord -Value 1
	print "Turned off Advertising ID."
}

# Enable Advertising ID.
Function EnableAdvertisingID {
	print "Turning on Advertising ID..."
	$Advertising = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	Remove-ItemProperty -Path $Advertising -Name "DisabledByGroupPolicy" -ErrorAction SilentlyContinue
	print "Turned on Advertising ID."
}

# Disable Background apps (https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%205.1/Sophia.psm1#L8988-L9033).
Function DisableBackgroundApps {
	space
	print "Turning off Background apps..."
	Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
		Remove-ItemProperty -Path $_.PsPath -Name * -Force
	}
	$ExcludedApps = @(
		"Microsoft.LockApp",
		"Microsoft.Windows.ContentDeliveryManager",
		"Microsoft.549981C3F5F10",
		"Microsoft.Windows.Search",
		"Microsoft.Windows.SecHealthUI",
		"Microsoft.Windows.ShellExperienceHost",
		"Microsoft.Windows.StartMenuExperienceHost",
		"Microsoft.WindowsStore"
		)
		$OFS = "|"
		Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | Where-Object -FilterScript {$_.PSChildName -notmatch "^$($ExcludedApps.ForEach({[regex]::Escape($_)}))"} | ForEach-Object -Process {
			New-ItemProperty -Path $_.PsPath -Name Disabled -PropertyType DWord -Value 1 -Force | Out-Null
			New-ItemProperty -Path $_.PsPath -Name DisabledByUser -PropertyType DWord -Value 1 -Force | Out-Null
		}
		$OFS = " "
	print "Turned off Background apps."
}

# Enable Background apps.
Function EnableBackgroundApps {
	print "Turning on Background apps..."
	Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
		Remove-ItemProperty -Path $_.PsPath -Name * -Force
	}
	print "Turned on Background apps."
}

# Disable Feedback.
Function DisableFeedback {
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Turning off Feedback notifications..."
	$Feedback1 = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	$Feedback2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	$Feedback3 = "Microsoft\Windows\Feedback\Siuf\DmClient"
	$Feedback4 = "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
	if (!(Test-Path $Feedback1)) {
		New-Item -Path $Feedback1 -Force | Out-Null
	}
	Set-ItemProperty -Path $Feedback1 -Name "NumberOfSIUFInPeriod" -Type DWord -Value 1
	if (!(Test-Path $Feedback2)) {
		New-Item -Path $Feedback2 -Force | Out-Null
	}
	Set-ItemProperty -Path $Feedback2 -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName $Feedback3 | Out-Null
	Disable-ScheduledTask -TaskName $Feedback4 | Out-Null
	print "Turned off Feedback notifications."
}

# Enable Feedback.
Function EnableFeedback {
	print "Turning on Feedback notifications..."
	$Feedback1 = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	$Feedback2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	$Feedback3 = "Microsoft\Windows\Feedback\Siuf\DmClient"
	$Feedback4 = "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
	if (!(Test-Path $Feedback1 )) {
		New-Item $Feedback1 -Force | Out-Null
	}
	Remove-ItemProperty -Path $Feedback1 -Name "NumberOfSIUFInPeriod"
	Remove-ItemProperty -Path $Feedback2 -Name "DoNotShowFeedbackNotifications"
	Enable-ScheduledTask -TaskName $Feedback3 | Out-Null
	Enable-ScheduledTask` -TaskName $Feedback4 | Out-Null
	print "Turned on Feedback notifications."
}

# Disable inking personalization.
Function DisableInkHarvesting {
	space
	print "Turning off Inking & typing personalization..."
	$Ink1 = "HKCU:\Software\Microsoft\InputPersonalization"
	$Ink2 = "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore"
	$Ink3 = "HKCU:\Software\Microsoft\Personalization\Settings"
	if (!(Test-Path $Ink1)) {
		New-Item -Path $Ink1 -Force | Out-Null
	}
	New-ItemProperty -Path $Ink1 -Name "RestrictImplicitInkCollection" -Type DWord -Value 1 -Force | Out-Null 
	Set-ItemProperty -Path $Ink2 -Name "HarvestContacts" -Type DWord -Value 0
	Set-ItemProperty -Path $Ink3 -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
	print "Turned off Inking & typing personalization."
}

# Enable inking personalization. 
Function EnableInkHarvesting {
	space
	print "Turning on Inking & typing personalization..."
	$Ink1 = "HKCU:\Software\Microsoft\InputPersonalization"
	$Ink2 = "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore"
	$Ink3 = "HKCU:\Software\Microsoft\Personalization\Settings"
	if (!(Test-Path $Ink1)) {
		New-Item -Path $Ink1 -Force | Out-Null
	}
	New-ItemProperty -Path $Ink1 -Name "RestrictImplicitInkCollection" -Type DWord -Value 0 -Force | Out-Null 
	Set-ItemProperty -Path $Ink2 -Name "HarvestContacts" -Type DWord -Value 1
	Set-ItemProperty -Path $Ink3 -Name "AcceptedPrivacyPolicy" -Type DWord -Value 1
	print "Turned on Inking & typing personalization."
}

# Disable "Let websites provide locally relevant content by accessing my language list".
Function DisableLangAccess {
	space
	print "Turning off websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Remove-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 1 | Out-Null
	print "Turned off websites' ability to provide you with locally relevant content by accessing your language list."
}

# Enable "Let websites provide locally relevant content by accessing my language list".
Function EnableLangAccess {
	print "Turning on websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Set-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 0
	print "Turned on websites' ability to provide you with locally relevant content by accessing your language list."
}

# Disable Location Tracking.
Function DisableLocationTracking {
	space
	print "Turning off location tracking..."
	$Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	$Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
	if (!(Test-Path $Location1)) {
		New-Item -Path $Location1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Deny"
	Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 0
	print "Turned off Location tracking."
}

# Enable location tracking.
Function EnableLocationTracking {
	space
	print "Turning on Location tracking..."
	$Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	$Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
	if (!(Test-Path )) {
		New-Item -Path $Location1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Allow"
	Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 1
	print "Turned on Location tracking."
}

# Disable automatic Maps updates.
Function DisableMapUpdates {
	space
	print "Turning off automatic Maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
	print "Turned off automatic Maps updates."
}

# Enable maps updates.
Function EnableMapsUpdates {
	space
	print "Turning on automatic Maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 1
	print "Turned on automatic Maps updates."
}

# Disable Speech Recognition.
Function DisableSpeechRecognition {
	space
	print "Turning off Online Speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	if (!(Test-Path $Speech)) {
		New-Item -Path $Speech -ErrorAction SilentlyContinue | Out-Null
	}
	Remove-ItemProperty -Path $Speech -Name "HasAccepted" -ErrorAction SilentlyContinue
	New-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 0 -ErrorAction SilentlyContinue | Out-Null
	print "Turned off Online Speech recognition."
}

# Enable speech recognition. 
Function EnableSpeechRecognition {
	space
	print "Turning on Speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	if (!(Test-Path )) {
		New-Item -Path $Speech | Out-Null
		}
	Set-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 1
	print "Turned on Online Speech recognition"
}

# Disable silent installation of recommended apps.
Function DisableSilentInstallApps {
	space
	print "Turning off silent installation of suggested apps..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -Type DWord -Value 1
	print "Turned off silent installation of suggested apps."
}

# Enable silent installation of recommended apps.
Function EnableSilentInstallApps {
	space
	print "Turning on silent installation of suggested apps..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -Type DWord -Value 1
	print "Turned on silent installation of suggested apps."
}

# Disable "Show suggested content in Settings app"
Function HideSuggestedContentInSettings {
	space
	print "Turning off suggested content in Settings app..."
	$CDN = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353694Enabled -Type DWord -Value 0
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353696Enabled -Type DWord -Value 0
	Set-ItemProperty -Path $CDN -Name SubscribedContent-338393Enabled -Type DWord -Value 0
	print "Turned off suggested content in Settings app."
}

# Enable "Show suggested content in Settings app"
Function ShowSuggestedContentInSettings {
	space
	print "Turning on suggested content in Settings app..."
	$CDN = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353694Enabled -Type DWord -Value 1
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353696Enabled -Type DWord -Value 1
	Set-ItemProperty -Path $CDN -Name SubscribedContent-338393Enabled -Type DWord -Value 1
	print "Turned on suggested content in Settings app."
}

# Disable "Show me suggested content in Start menu".
Function HideSuggestedContentInStart {
	if ($CurrentBuild -ge 22000) {
		return
	}
	space 
	print "Turning off suggested content in Start menu..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -Type DWord -Value 0
	print "Turned off suggested content in Start menu."
}

# Enable "Show me suggested content in Start menu".
Function ShowSuggestedContentInStart {
	if ($CurrentBuild -ge 22000) {
		return
	}
	space 
	print "Turning on Suggested content in Start menu..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -Type DWord -Value 1
	print "Turned on Suggested content in Start menu."
}

# Disable Tailored experiences.
Function DisableTailoredExperiences {
	space
	print "Turning off Tailored experiences..."
	$TailoredExp1 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	$TailoredExp2 = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
	if (!(Test-Path $CloudContent )) {
		New-Item $CloudContent -Force | Out-Null
	}
	Set-ItemProperty -Path 
	Set-ItemProperty -Path $TailoredExp1 -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
	Set-ItemProperty -Path $TailoredExp2 -Name "Disabled" -Type DWord -Value 1
	print "Turned off Tailored experiences."
}

# Enable Tailored experiences.
Function EnableTailoredExperiences {
	space
	print "Turning on Tailored experiences..."
	$TailoredExp1 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	$TailoredExp2 = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
	Remove-ItemProperty -Path $TailoredExp1 -Name "DisableTailoredExperiencesWithDiagnosticData" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $TailoredExp2 -Name "Disabled" -ErrorAction SilentlyContinue
	print "Turned on Tailed experiences."
}

# Disable Telemetry. 
Function DisableTelemetry {
	space
	print "Turning off telemetry..."
	$Telemetry1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Set-ItemProperty -Path $Telemetry1 -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path $Telemetry2 -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path $Telemetry3 -Name "AllowTelemetry" -Type DWord -Value 0
	print "Turned off telemetry."
}

# Enable Telemetry.
Function EnableTelemetry {
	space
	print "Turning on Telemetry..."
	$Telemetry1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Set-ItemProperty -Path $Telemetry1  -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry2 -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry3 -Name "AllowTelemetry" -Type DWord -Value 3
	print "Turned off telemetry."
}

# Enable Clipboard History.
Function EnableClipboard {
	space
	print "Turning on Clipboard History..."
	$Clipboard = "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Value 1 -ErrorAction SilentlyContinue
	print "Turned on Clipboard History."
    Start-Sleep 1
    Set-Clipboard "Demo text by WinRice."
	print "You can now copy multiple items to your clipboard."
    print "Access your clipboard now using Windows key + V."
}

# Disable Clipboard History.
Function DisableClipboard {
	space
	print "Turning off Clipboard History..."
	$Clipboard = "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Value 0 -ErrorAction SilentlyContinue
	print "Turned off Clipboard History."
}

Function AutoLoginPostUpdate {
	space
	print "Turning on automatic login post updates..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent" -Type DWord -Value 1
	print "Turned on Automatic login applying updates"
} 

Function StayOnLockscreenPostUpdate {
	space
	print "Turning off automatic login post updates..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent"
	print "Turned off Automatic login after applying updates."
}



####################################
######### TASKS & SERVICES #########
####################################

# Update status.
Function TasksServices {
	space
	print "---------------------------"
	print "      TASKS & SERVICES     "   
	print "---------------------------"
	space
}

# Disable Autoplay.
Function DisableAutoplay {
	space
	print "Turning off AutoPlay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
	print "Turned off AutoPlay."
}

# Enable Autoplay.
Function EnableAutoplay {
	space
	print "Turning on Autoplay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
	print "Turned on AutoPlay."
}

# Disable Autorun for all drives.
Function DisableAutorun {
	space
	print "Turning off Autorun for all drives..."
	$Autorun = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	if (!(Test-Path $Autorun)) {
		New-Item -Path $Autorun | Out-Null
		}
	Set-ItemProperty -Path $Autorun -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
	print "Turned off Autorun for all drives."
}

# Enable Autorun for removable drives.
Function EnableAutorun {
	space
	print "Turning on Autorun for all drives..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
	print "Turned on Autorun for all drives."
}

# Disable Hiberfile.sys
Function DisableHibernation {
	if ($isLaptop) {
		return
	}
	space 
	print "Turning off hibernation..."
	powercfg.exe -h off
	print "Turned off hibernation."
}

# Enable Hiberfile.sys
Function EnableHibernation {
	if ($isLaptop) {
		return
	}
	space 
	print "Turning on hibernation..."
	powercfg.exe -h on
	print "Turned on hibernation."
}

# Set BIOS time to UTC.
Function SetBIOSTimeUTC {
	space
	print "Setting BIOS time to UTC..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
	print "BIOS Time is set to UTC."
}

# Set BIOS time to local time.
Function SetBIOSTimeLocal {
	space
	print "Setting BIOS time to Local time..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -ErrorAction SilentlyContinue
	print "BIOS Time is set to Local time."
}

# Enable Num lock on startup.
Function EnableNumLock {
	space
	print "Setting Num lock to turn on autoamtically on Startup..."
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force | Out-Null
	print "Num lock will turn on automatically on Startup."
}

# Disable Num lock on startup.
Function DisableNumLock {
	space
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483648 -Force | Out-Null
	print "Num lock will no longer turn on automatically on Startup."
}

# Enable Storage Sense. 
Function EnableStorageSense {
	space
	print "Turning on Storage Sense..."
	$EnableStorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $EnableStorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $EnableStorageSense -Name 01 -PropertyType DWord -Value 1 -Force | Out-Null
	print "Turned on Storage Sense."
}

# Disable Storage Sense.
Function DisableStorageSense {
	space
	print "Turning off Storage Sense..."
	$DisableStorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $DisableStorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $DisableStorageSense -Name 01 -PropertyType DWord -Value 0 -Force | Out-Null
	print "Turned off Storage Sense."
}

# Disable Reserved Storage. 
Function DisableReservedStorage {
	space
	print "Turning off Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 0
	print "Turned off Reserved Storage."
}

# Enable Reserved Storage. 
Function EnableReservedStorage {
	space
	print "Turning on Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 1
	print "Turned on Reserved Storage."
}

# Disable unnecessary services.
Function DisableServices {
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Turning off unnecessary services..."
    	$Services = @(
		"DiagTrack"
		"SysMain"
    )
    ForEach ($Service in $Services) {
		Stop-Service $Service | Out-Null
		Set-Service $Service -StartupType Disabled
		print "    Stopped service: $Service."
	}
	print "Turned off unnecesarry services."
}

# Enable unnecessary services.
Function EnableServices {
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Turning on unnecessary services..."
    	$Services = @(
		"DiagTrack"
		"SysMain"
    )
    ForEach ($Service in $Services) {
		Start-Service $Service | Out-Null
		Set-Service $Service -StartupType Automatic
		print "    Started service: $Service."
	}
	print "Turned on redundant services."
}

# Disable unnecessary scheduled tasks.
Function DisableTasks {
	space
	print "Turning off unnecessary tasks..."
	$Tasks = @(
		"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
		"Microsoft\Windows\Application Experience\ProgramDataUpdater"
        "Microsoft\Windows\Application Experience\PcaPatchDbTask"
		"Microsoft\Windows\Autochk\Proxy"
        "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
		"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
		"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 
		"Microsoft\Windows\Windows Error Reporting\QueueReporting" 
		"Microsoft\Windows\Feedback\Siuf\DmClient"
		"Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
    )
    ForEach ($Task in $Tasks) {
		Disable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		print "    Turned off task: $Task."
	}
    print "Turned off unnecessary tasks."
}

# Enable unnecessary scheduled tasks.
Function EnableTasks {
	$Tasks = @(
		"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
		"Microsoft\Windows\Application Experience\ProgramDataUpdater"
		"Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
		"Microsoft\Windows\Autochk\Proxy"
		"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
		"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 
		"Microsoft\Windows\Windows Error Reporting\QueueReporting" 
		"Microsoft\Windows\Feedback\Siuf\DmClient"
		"Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
    )
    ForEach ($Task in $Tasks) {
		Enable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		print "    Turned on task: $Task."
	}
    print "Turned on redundant tasks."
}

# Intelligently setup Windows Update policies.
Function SetupWindowsUpdate {
	space
	# Get Windows Edition, if its Professional, Education, or Enterprise.
    if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"})) {
		print "$ProductName does not support setting up Windows Update policies."
		return
	}
	print "Setting up Windows Update policies..."

    # Declare registry keys locations.
	$Update1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
	$Update2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
	$DeliveryOptimization = "Registry::HKEY_USERS\$hkeyuser\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings"
	
	if (!(Test-Path $Update1)) 
    {
		New-Item -Path $Update1 | Out-Null
		New-Item -Path $Update2 | Out-Null
	}
	
	if (!(Test-Path $DeliveryOptimization))
    {
        New-Item -Path $DeliveryOptimization | Out-Null
    }

	# Write registry values.
	Set-ItemProperty -Path $Update1 -Name DeferQualityUpdates -Type DWord -Value 1
	Set-ItemProperty -Path $Update1 -Name DeferQualityUpdatesPeriodInDays -Type DWord -Value 4
	Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdates -Type DWord -Value 1
	Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 20
	Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
	Set-ItemProperty -Path $Update2 -Name NoAutoRebootWithLoggedOnUsers -Type Dword -Value 1
    New-ItemProperty -Path $DeliveryOptimization -Name DownloadMode -Type DWord -Value 0 -Force

	# Print user message; policies applied.
	$WinUpdatePolicies =@(
		"Turned off automatic updates"
		"Turn off Delivery optimization"
		"Device will no longer auto restart if users are signed in"
		"Turned off re-installation of apps after Windows Updates"
		"Delayed quality updates by 4 days"
		"Delayed feature updates by 20 days"
	)
	ForEach ($WinUpdatePolicy in $WinUpdatePolicies) {
		print "    - $WinUpdatePolicy"
	}

	print "Set up Windows Update policies."
}

# Reset all Windows Update policies
Function ResetWindowsUpdate {
    space
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse
    print "All Windows Update policies were reset."
}

# A simple registry edit that fixes an issue where a small batch of devices turn back on after powering down.
Function EnablePowerdownAfterShutdown {
	space
	print "Enabling full powerdown on shut down..."
	print "This is known to fix issues where some PCs might boot up without user input after shutdown."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 1
	print "Enabled full power down on shut down."
}

# Revert the EnablePowerdownAfterShutdown edit.
Function DisablePowerdownAfterShutdown {
	space
	print "Disabling full powerdown on shut down..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 0
	print "Disabled full powerdown on shut down."
}



####################################
######### WINDOWS EXPLORER #########
####################################

# Update status: Explorer Changes.
Function PrintExplorerChanges {	
	space
	print "----------------------------------"
	print "          WINDOWS EXPLORER        "
	print "----------------------------------"
	space
}

# Use Print screen button to open screen skipping.
Function EnablePrtScrToSnip {
	space
	print "Binding Print Screen key to launch Snip overlay..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 1
	print "Bound Print Screen key to launch Snip overlay."
	Start-Sleep -Milliseconds 200
}
	
# Don't use Print screen button to open screen skipping.
Function DisablePrtScrSnip {
	space
	print "Unbinding Snip overlay launch from Print screen key...."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 0
	print "Unbound Snip overlay launch from Print screen key."
}

# Show extensions.
Function ShowExtensions {
	space
	print "Showing extensions in file names..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
	print "Showed extensions in file names."
}

# Hide extensions.
function HideExtensions {
	space
	print "Hiding extensions from file names..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 1
	print "Hidden extensions in file names."
}

# Hide Recent files in Quick Access.
function HideRecentFilesInQuickAccess {
	space
	print "Hiding recent files from Quick Access..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowRecent -Type DWord -Value 0
	print "Hidden recent files from Quick Access."
}

# Show Recent files in Quick Access.
function ShowRecentFilesInQuickAccess {
	space 
	print "Showing Recent files in Quick Access..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowRecent -Type DWord -Value 1
	print "Shown Recent files in Quick Access."
}

# Disable Sticky keys.
Function DisableStickyKeys {
	space
	print "Turning off Sticky keys..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
	print "Turned off Sticky keys."
	Start-Sleep -Milliseconds 200
}

# Enable Sticky keys.
Function EnableStickyKeys {
	space
	print "Turning on Sticky keys..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
	print "Turned on Sticky keys."
}

# Change default File Explorer view to This PC.
Function SetExplorerThisPC {
	space
	print "Setting default File Explorer view to This PC..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
	print "Set default File Explorer view to This PC."
	Start-Sleep -Milliseconds 200
}

# Change default File Explorer view to Quick Access.
Function SetExplorerQuickAccess {
	space
	print "Setting default File Explorer view to Quick Access..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -ErrorAction SilentlyContinue
	print "Set default File Explorer view to Quick Access."
}

# Hide 3D Objects.
Function Hide3DObjects {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Turning off 3D Objects..."
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
	$Hide3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	$Hide3DObjects2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	if (!(Test-Path $Hide3DObjects1)) {
		New-Item -Path $Hide3DObjects1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Hide3DObjects1 -Name "ThisPCPolicy" -Type String -Value "Hide"
	if (!(Test-Path $Hide3DObjects2)) {
		New-Item -Path $Hide3DObjects2 -Force | Out-Null
		}
	Set-ItemProperty -Path $Hide3DObjects2 -Name "ThisPCPolicy" -Type String -Value "Hide"
	print "Turned off 3D Objects."
	Start-Sleep -Milliseconds 200
}

# Restore 3D Objects.
Function Restore3DObjects {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Turning on 3D Objects..."
	$Restore3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	$Restore3DObjects2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	$Restore3DObjects3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	if (!(Test-Path $Restore3DObjects1)) {
		New-Item -Path $Restore3DObjects1 | Out-Null
	}
	Remove-ItemProperty -Path $Restore3DObjects2 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $Restore3DObjects3 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	print "Turned on 3D Objects."
}

# Hide Search bar from taskbar.
Function HideSearchBar {
	if ($CurrentBuild -lt 22000) {
		space
		print "Turning off Search bar..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
		print "Turned off Search bar."
	}
	elseif ($CurrentBuild -ge 22000) {
		space
		print "Turning off Search icon..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
		print "Turned off Search icon."
	}
	Start-Sleep -Milliseconds 200

}

# Restore Search bar to taskbar.
Function RestoreSearchBar {
	if ($CurrentBuild -lt 22000) {
		space
		print "Turning on Search bar..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 2
		print "Turned on Search bar."
	}
	elseif ($CurrentBuild -ge 22000) {
		space
		print "Turning off Search icon..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 1
		print "Turned off Search icon."
	}
	Start-Sleep -Milliseconds 200
}

# Hide Task View.
Function HideTaskView {
	space
	print "Turning off Task view icon..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
	print "Turned off Task view icon."
	Start-Sleep -Milliseconds 200
}

# Restore Task View button.
Function RestoreTaskView {
	space
	print "Turning on Task view icon..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
	print "Turned on Task view icon."
	Start-Sleep -Milliseconds 200
}

# Hide Cortana icon from taskbar.
Function HideCortana {
	if ($CurrentBuild -ge 22000) {
		return
	}
	space
	print "Turning off Cortana icon..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
	print "Turned off Cortana icon."
	Start-Sleep -Milliseconds 200
}

# Restore Cortana button in taskbar.
Function RestoreCortana {
	if ($CurrentBuild -ge 22000) {
		return
	}
	print "Turning on Cortana icon..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1
	print "Turned on Cortana icon."
	Start-Sleep -Milliseconds 200
}

# Hide Meet Now icon from tray.
Function HideMeetNow {
	if ($CurrentBuild -ge 22000) {
		return
	}
	space
	print "Turning off Meet now..."
    $Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    $Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 1
    Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
	print "Turned off Meet now."
	Start-Sleep -Milliseconds 200
}

# Restore Meet Now icon on tray.
Function RestoreMeetNow {
	if ($CurrentBuild -ge 22000) {
		return
	}
	space
	print "Turning on Meet now..."
    $Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    $Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 0
    Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
	print "Turned on Meet now."
	Start-Sleep -Milliseconds 200
}

# Turn off News and interests feed.
Function DisableTaskbarFeed {
	if ($CurrentBuild -ge 22000) {
		return
	}
	space
	print "Turning off News and interests..."
	$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
	$Feed2 = "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Feeds"
	Set-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 2 | Out-Null
	Set-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 2 | Out-Null
	print "Turned off News and interests."
	Start-Sleep -Milliseconds 200
}

# Turn on News and interests feed.
Function EnableTaskbarFeed {
	if ($CurrentBuild -ge 22000) {
		return
	}
	print "Turning on News and interests..."
	$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
	$Feed2 = "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Feeds"
	Set-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 0 | Out-Null
	Set-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 0 | Out-Null
	print "Turned on News and interests."
	Start-Sleep -Milliseconds 200
}

# Disable widgets item - Windows 11 only.
function DisableWidgetsItem {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Turning off Widgets Item..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Type DWord -Value 0
	print "Turned off Widgets Item."
	Start-Sleep -Milliseconds 200
}

# Enable Widgets item - Windows 11 only

function EnableWidgetsItem {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Turning on Widgets Item..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Type DWord -Value 1
	print "Turned on Widgets Item."
	Start-Sleep -Milliseconds 200
}

# Disable chat item - Windows 11 only
function DisableChatItem {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Turning off Chat Item..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Type DWord -Value 0
	print "Turned off Chat Item."
	Start-Sleep -Milliseconds 200
}

# Enable Chat item - Windows 11 only
function EnableChatItem {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Turning on Chat Item..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Type DWord -Value 1
	print "Turned on Chat Item."
	Start-Sleep -Milliseconds 200
}


Start-Sleep -Seconds 2

######### Tasks after successful run #########

# Tasks after run
Remove-PSDrive -Name HKCR
$ProgressPreference = 'Continue'

# Update status: WinRice execution successful.
Function Success {
	Stop-Process -Name explorer -Force
	Start-Sleep 3
	print "Thank you for using WinRice."
	Stop-Transcript
	Write-Host "Restarting this device in 10 seconds."
	for ($time = 10; $time -ge 0 ; $time--)
	{   
		Start-Sleep 1
		Write-Progress -Activity "Device restart" -Status "Restarting in $time seconds."
	}
	Restart-Computer

}

# Call the desired functions.
$tasks | ForEach-Object { Invoke-Expression $_ }
