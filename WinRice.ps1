# This file is a part of the WinRice software
# Copyright (c) 2022 Pratyaksh Mehrotra <pratyakshm@protonmail.com>
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
	# "InstallVCLibs",
	# "UninstallVCLibs",
	"InstallWinGet",
	"InstallNanaZip", 
	# "UninstallNanaZip",
	"WinGetImport",
	"Winstall",
	# "Winuninstall"
	"InstallHEVC", 
	# "UninstallHEVC"
	"InstallWSL", "Activity", 
	# "UninstallWSL",
	"InstalldotNET3.5", "Activity", 
	# "UninstalldotNET3.5",
	"InstallSandbox",
	# "UninstallSandbox",
	"UninstallApps", "Activity", 
	"WebApps",
	"UnpinStartTiles", "Activity", 
	"UnpinAppsFromTaskbar", 
	"UninstallOneDrive", "Activity",
	# "InstallOneDrive",
	"UninstallFeatures", "Activity", 
	# "InstallFeatures", "Activity", 
	"ChangesDone",

### Privacy ###
	"PrivacySecurity",
	# "DisableActivityHistory",	
	# "EnableActivityHistory",
	"DisableAdvertisingID",			
	# "EnableAdvertisingID",
	# "DisableBackgroundApps",        
	# "EnableBackgroundApps",
	"DisableErrorReporting",
	# "EnableErrorReporting",
	"DisableFeedback",		       
	# "EnableFeedback",
	"DisableInkHarvesting",			
	# "EnableInkHarvesting",
	"DisableLangAccess",  		    
	# "EnableLangAccess",
	# "DisableLocationTracking",      
	# "EnableLocationTracking",
	# "DisableMapUpdates",			
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
	# "EnableTailoredExperiences",s
	"TelemetryRequired",				
	"TelemetryOptional",
	"EnableClipboard",				
	# "DisableClipboard",

### Security ###
	# "AutoLoginPostUpdate", 		    
	"StayOnLockscreenPostUpdate",
	# "DisableVBS",
	# "EnableVBS",
	"DisableLogonCredential",
	# "EnableLogonCredential",
	"DisableLLMNR",
	# "EnableLLMNR",
	"EnableSEHOP",
	# "DisableSEHOP",
	"DisableWPAD",
	# "EnableWPAD",
	"EnableLSAProtection"
	# "DisableLSAProtection"
	"DisableScriptHost"
	# "EnableScriptHost"
	"DisableOfficeOLE",
	# "EnableOfficeOLE",
	"ChangesDone",

### OS ###
	"OS",
	# "DisableStorageSense",		   
	# "EnableStorageSense",
	# "DisableReserves",	   
	# "EnableReserves",
	"RestorePowerOptions",
	"DisableAutoplay",             
	# "EnableAutoplay",
	"DisableAutorun",              
	# "EnableAutorun",
	"DisableHibernation",
	# "EnableHibernation",
	"BIOSTimeUTC",              
	# "BIOSTimeLocal",
	"EnableNumLock",			   
	# "DisableNumLock",
	# "DisableServices",			   
	# "EnableServices",
	"DisableTasks",				   
	# "DisableTasks",
	"DisableAMDTasks",
	# "EnableAMDTasks",
	"SetupWindowsUpdate",		   
	# "ResetWindowsUpdate",
	"DisableDeviceInstallation",
	# "EnableDeviceInstallation",
	# "EnablePowerdownAfterShutdown",
	# "DisablePowerdownAfterShutdown",
	"DisableWindowsTipsNotifications",
	# "EnableWindowsTipsNotifications",
	"DisableWindowsWelcomeExperience",
	# "EnableWindowsWelcomeExperience",
	"ChangesDone",

### Windows Explorer ###
	"WindowsExplorer",
	"EnablePrtScrToSnip",		   
	# "DisablePrtScrSnip",
	# "EnableExtensions",
	# "DisableExtensions",
	"DisableRecentFilesInQuickAccess",
	# "ShowRecentFilesInQuickAccess",
	"DisableStickyKeys",           
	# "EnableStickyKeys",
	"SetExplorerThisPC",           
	# "SetExplorerQuickAccess",
	"FixAppHoverPreviewThreshold",
	# "RevertAppHoverPreviewThreshold",
    "Disable3DObjects",      		   
	# "Enable3DObjects",
	"DisableSearch",			   
	# "EnableSearch"
	"DisableSearchView",                
	# "EnableTaskView",
	"DisableCortana",			       
	# "EnableCortana",
	"DisableMeetNow",				   
	# "EnableMeetNow",
	"DisableNI",		   
	# "EnableNI",  (News and Interests)
	"DisableWidgets",
	# "EnableWidgets",
	"DisableChat",
	# "EnableChat",
	"ChangesDone",

###  Tasks after successful run ###
	"Activity",
	"Success"
)

# Reverting changes: https://github.com/pratyakshm/WinRice/wiki/Reverting-changes.

# Core functions +++
function Log($text) {
	Start-Sleep -Milliseconds 200
    Write-Host $text
}

function check($test) {
    if ($test -like "y" -or $test -like "yeah" -or $test -like "yes" -or $test -like "yep" -or $test -like "yea" -or $test -like "yah") { 
		return $true
	}
	elseif ($test -like "n" -or $test -like "nope" -or $test -like "no" -or $test -like "nada" -or $test -like "nah" -or $test -like "naw") {
		return $false
	}
}

function wrexit {
	Write-Host "WinRice will now exit."
	Start-Sleep -Seconds 2
	exit
}

function ask($question) {
	Read-Host $question
	Start-Sleep -Milliseconds 100
}

function space {
	Write-Host " "
}

function print($text) {
	Write-Host $text
	Start-Sleep -Milliseconds 150
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
	if ($Exit -and $fail) { wrexit }
    return $result
}


# Did you read the docs? (Funny stuff).
$hasReadDoc = ask "By proceeding ahead, you acknowledge that you have read and understood the program documentation. [y/n]"
if (!(check($hasReadDoc))) {
	log "You (the user) have not read the program documentation. WinRice will now exit."
	exit
}

# Core functions ---
if (!(Test-Path C:\WinRice)) {
	New-Item C:\WinRice -ItemType Directory | Out-Null 
}
# Start logging
Start-Transcript -OutputDirectory "C:\WinRice" | Out-Null 

# Store OS details
$CurrentVersionPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$CurrentBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild
$DisplayVersion = Get-ItemPropertyValue $CurrentVersionPath -Name DisplayVersion -ErrorAction SilentlyContinue
$ProductNameCore = (Get-WmiObject -class Win32_OperatingSystem).Caption
$ProductName = $ProductNameCore.TrimStart("Microsoft ")
$ProductNameCore = $null
$OSBuildCore = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Update\TargetingInfo\Installed\Client.OS.rs2.amd64" -Name Version 
$OSBuild = $OSBuildCore.TrimStart("10.0")
$BuildBranch = Get-ItemPropertyValue $CurrentVersionPath -Name BuildBranch
$hkeyuser = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID
$Insider = (Get-Item -Path "HKLM:\SOFTWARE\Microsoft\WindowsSelfHost\Applicability").Property -contains "IsBuildFlightingEnabled" -or (Get-Item -Path "HKLM:\SOFTWARE\Microsoft\WindowsSelfHost\Applicability").Property -contains "BranchName"

# Change window title
$host.UI.RawUI.WindowTitle = "pratyakshm's WinRice"

# Display Information
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


# Begin checks
Write-Host "Beginning checks..."

# Check 1: If supported OS build.
$oscheck = {
	$CurrentBuild = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentBuild
	if ($CurrentBuild -lt 19042) {
		return $false
	}
	elseif ($CurrentBuild -ge 19042) {
		return $true
	}
}
RunWithProgress -Text "[1/5] Windows version is supported" -Task $oscheck -Exit $true | Out-Null


# Check 2: If session is elevated.
$isadmin = {
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	$admin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
	return $admin
}
RunWithProgress -Text "[2/5] Session is elevated" -Task $isadmin -Exit $true | Out-Null

# Check 3: Internet Connection.
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
RunWithProgress -Text "[3/5] Device is connected to the Internet" -Task $isonline -Exit $true | Out-Null

# Check 4: Device form-factor (https://devblogs.microsoft.com/scripting/hey-scripting-guy-weekend-scripter-how-can-i-use-wmi-to-detect-laptops/).
if(Get-WmiObject -Class Win32_SystemEnclosure | Where-Object {$_.ChassisTypes -eq 9 -or $_.ChassisTypes -eq 10 -or $_.ChassisTypes -eq 14}) 
{ 
	$isLaptop = $true
}

# Task 1: Import Appx Module to PowerShell if necessary.
$pwshver = {
	Import-Module -Name Appx -UseWindowsPowerShell -WarningAction "SilentlyContinue" | Out-Null
	return $true
}
RunWithProgress -Text "[4/5] Setting up PowerShell" -Task $pwshver -Exit $true | Out-Null

# Check 5: Check for pending restarts (part of code used here was picked from https://thesysadminchannel.com/remotely-check-pending-reboot-status-powershell).
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
# Clear variables.
$WMI_Reg        = $null
$SCCM_Namespace = $null
RunWithProgress -Text "[5/5] Device session is fresh" -Task $isrestartpending -Exit $true | Out-Null

# Conclude checks.
Start-Sleep -Milliseconds 100
Write-Host "Completed checks." -ForegroundColor green 
space

# Declare Express Settings.
$uninstallapps = "y"
if ((Test-Path uninstallapps.txt) -or (Test-Path UninstallApps.txt) -or (Test-Path Uninstallapps.txt))
{
	$uninstallmethod = "list"
}
$uninstallfeatures = "y"
$systemrestore = "y"
$systemwidepolicies = "y"

# Print Express Settings.
print "Express Settings:"
$settings = @(	
	"A set of non-essential apps will be uninstalled."	
	"A set of non-essential features will be uninstalled."
	"Configure specific changes that apply to all users in this device."
)
ForEach ($setting in $settings) 
{
	print "  $setting"
}
if ($CurrentBuild -ge 22000)
{
	Write-Host "  Widgets will not be removed."
}
if (!($Insider) -and (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}))
{
	$dwu = "y"
	$au = "y"
	print "  Windows automatic updates will be disabled."
	print "  Windows quality updates will be delayed by 4 days and feature updates will be delayed by 20 days."
}
elseif ($Insider)
{
	print "  Windows Update policies are left unchanged in Windows pre-release software."
}
space
print "To learn more, visit https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md."
space

$customize = ask "Do you want to proceed with Express Settings? [Y/n]"

if (!(check($customize)))
{
	space
	print "Please take your time to answer the questions below in order to save user config."
	print "Press Enter to proceed after answering a question."
	space
	space

	# App Deployment
	print "APP DEPLOYMENT"
	$installapps = ask "Do you want to install apps using WinGet? [y/N]"
	if (check($installapps))
	{
		$installusing = ask "Okay, do you want to use (1) winget import or (2) Winstall? [1/2]"
	}
	elseif ((!($installapps))) 
	{
		print "  No apps will be installed."
	}
	if ($installusing -eq "1")
	{
		print "  Apps WILL be installed using: winget import."
	}
	elseif ($installusing -eq "2")
	{
		print "  Apps WILL be installed using: Winstall."
	}
	
	$uninstallapps = ask "Do you want to uninstall non-essential apps? [Y/n]"
	if (!($uninstallapps))
	{
		$uninstallapps = "y"
		print "No input detected, non-essential apps WILL be uninstalled."
	}
	elseif (check($uninstallapps))
	{
		if ((Test-Path uninstallapps.txt) -or (Test-Path UninstallApps.txt) -or (Test-Path Uninstallapps.txt))
		{
			$uninstallmethod = "list"
		}
		elseif (!(Test-Path uninstallapps.txt) -or (!(Test-Path UninstallApps.txt)) -or (!(Test-Path Uninstallapps.txt)))
		{
			$uninstallmethod = ask "Do you want to select which apps to uninstall? [y/N]"
		}
		$uninstallod = ask "Do you want to uninstall Microsoft OneDrive? [y/N]"
	}

	space

	# Feature Deployment
	print "FEATURE DEPLOYMENT"
	
	$uninstallfeatures = ask "Do you want to uninstall non-essential optional features? [Y/n]"
	if (!($uninstallfeatures))
	{
		$uninstallfeatures = "y"
		print "  NO input detected, non-essential features WILL be uninstalled."
	}

	if ($CurrentBuild -ge 22000) {
		$widgets = ask "Do you want to uninstall Widgets [y/N]"
	}

	$netfx3 = ask "Do you want to install .NET 3.5? (used for running legacy programs) [y/N]"

	$wsl = ask "Do you want to install Windows Subsystem for Linux? [y/N]"

	$sandbox = ask "Do you want to install Windows Sandbox? [y/N]"

	
	
	# OS Changes
	if ( (!($Insider)) -and (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) )
	{	
		space
		print "WINDOWS UPDATE"

		$dwu = ask "Do you want to delay Windows updates by a few days? [Y/n]"
		$au = ask "Do you want to turn off automatic updates? [Y/n]"
		$drivers = ask "Do you want to turn off driver updates from Windows Update? [y/N]"
	}
	space
	$UseUTSCWhenFollowBIOSTime = ask "Do you want Windows to use UTC when it follows BIOS time? Warning: This may have unintended consequences. [y/N]"
	if (!($UseUTSCWhenFollowBIOSTime))
	{
		$UseUTSCWhenFollowBIOSTime = "n"
	}
	Write-Host "For some changes to take proper effect, they must be applied to all users in this device."
	$systemwidepolicies = ask "Do you want to apply those changes? [Y/n]"
	$systemrestore = ask "Do you want to create a system restore point? [Y/n]"
	print "------------------------------- "
	space 
	space

	# REPRINT CONFIG TO USER
	Write-Host "To sum it up, you've chosen to: "

	## App Installation
	if (check($installapps))
	{
		Write-Host " - Install apps using " -NoNewline -ForegroundColor Cyan
		if ($installusing -like "2")
		{
			Write-Host "Winstall." -ForegroundColor Cyan
		}
		elseif ($installusing -like "1")
		{
			Write-Host "winget import method." -ForegroundColor Cyan
		}
	}

	## App Uninstallation
	if (check($uninstallapps))
	{
	
		Write-Host " - Uninstall non-essential apps" -NoNewline -ForegroundColor Cyan
		if ($uninstallmethod -like "list")
		{
			Write-Host " using a custom List." -ForegroundColor Cyan
		}
		elseif (check($uninstallmethod))
		{
			Write-Host " which you will select later on." -ForegroundColor Cyan
		}
		elseif (!(check($uninstallmethod)) -and (check($uninstallapps)))
		{
			Write-Host " from our predefined list." -ForegroundColor Cyan
		}
	}
	
	if (check($uninstallod))
	{
		Write-Host " - Uninstall OneDrive." -ForegroundColor Cyan
	}


	## Feature Uninstallation
	if (check($uninstallfeatures))
	{
		Write-Host " - Uninstall non-essential features." -ForegroundColor Cyan
	}

	if (check($widgets))
	{
		Write-Host " - Uninstall Widgets." -ForegroundColor Cyan
	}


	## Feature Installation
	if (check($netfx3))
	{
		Write-Host " - Install .NET 3.5." -ForegroundColor Cyan
	}

	if (check($wsl))
	{
		Write-Host " - Install WSL." -ForegroundColor Cyan
	}
	
	if (check($sandbox))
	{
		Write-Host " - Install Windows Sandbox." -ForegroundColor Cyan
	}

	
	# Extras
	if (!(check($systemwidepolicies)))
	{
		Write-Host " - Not configure specific changes that apply to all users in this device." -ForegroundColor Yellow
	}
	elseif (check($systemwidepolicies))
	{
		Write-Host " - Configure specific changes that apply to all users in this device." -ForegroundColor Cyan
	}
	if (!(check($systemrestore)))
	{
		Write-Host " - Not create a System Restore point." -ForegroundColor Yellow
	}
	elseif (check($systemrestore))
	{
		Write-Host " - Create a System restore point." -ForegroundColor Cyan
	}
	if (check($UseUTSCWhenFollowBIOSTime))
	{
		Write-Host " - Set Windows to use UTC when following BIOS time." -ForegroundColor DarkRed
	}


	# Windows Update
	if ((check($au)) -or (check($dwu)) -or (check($drivers)))
	{	
		space
		Write-Host "You have chosen these Windows Update policies:"
	}
	
	if (check($au))
	{
		Write-Host " - Disable automatic updates." -ForegroundColor Cyan
	}
	
	if (check($dwu))
	{
		Write-Host " - Delay Windows quality updates by 4 days and feature updates by 20 days." -ForegroundColor Cyan
	}

	if (check($drivers))
	{
		Write-Host " - Disable driver delivery via Windows Update." -ForegroundColor Cyan
	}
	space
	
	Write-Host "If this configuration is correct, " -NoNewline
	Write-Host "press any key to go ahead." -ForegroundColor Green
	Write-Host "If this configuration is not correct, restart WinRice and create a new one."
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}


print "Starting WinRice..."

# Intro.
function WinRice {
	Clear-Host
	print "pratyakshm's WinRice"
	space
	print "Copyright (c) Pratyaksh Mehrotra and contributors"
	print "https://github.com/pratyakshm/WinRice"
	Start-Sleep 1
}

# OS Build.
function OSBuildInfo {
	space
	# If Windows 11 (OS build is greater than or equal to 22000)
	if ($CurrentBuild -ge 22000)
	{
		# If a Windows Insider
		if ($Insider)
		{
			print "$ProductName Insider Preview"
			print "OS Build: $OSBuild, Channel: $DisplayVersion, Branch: $BuildBranch"
		}
		# If on Retail / prod build
		else 
		{
			print "$ProductName $DisplayVersion"
			print "OS Build: $OSBuild, Channel: General Availability, Branch: $BuildBranch"
		}
	}
	# If Windows 10 (OS build is lesser than 22000)
	elseif ($CurrentBuild -lt 22000)
	{
		print "$ProductName $DisplayVersion"
		print "OS Build: $OSBuildCore, Branch: $BuildBranch" # Windows Insiders on Windows 10 are not considered due to less number of users.
	}
	space
	print "---------------------------------------------------"
	Start-Sleep 1
}

# Changes performed.
function ChangesDone {
	space
	print "---------------------------"
	print "     CHANGES PERFORMED     "
	print "---------------------------"
	Start-Sleep 1
}

# Create a system restore point with type MODIFY_SETTINGS.
function CreateSystemRestore {
$ProgressPreference = 'SilentlyContinue'
	if (!(check($systemrestore)))
	{
		return
	}
	space
	print "Creating a system restore point..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -Type DWord -Value 0 -Force
	Enable-ComputerRestore -Drive $env:SystemDrive
	Checkpoint-Computer -Description "WinRice" -RestorePointType "MODIFY_SETTINGS" -WarningAction SilentlyContinue
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -Type DWord -Value 1440 -Force
	Disable-ComputerRestore -Drive $env:SystemDrive
	print "Created system restore point."
}

# Prevent the console output from freezing by emulating backspace key. (https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%205.1/Module/Sophia.psm1#L728-L767)
function Activity {
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

	Get-Process | Where-Object -FilterScript {$_.MainWindowTitle -like "*PowerShell*" -or $_.MainWindowTitle -like "*pratyakshm's WinRice*" -or $_.MainWindowTitle -like "*pwsh*"} | ForEach-Object -Process {
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
function AppsFeatures {
	space
	print "-------------------------"
	print "     APPS & FEATURES     "
	print "-------------------------"
}

# Install VCLibs packages .
function InstallVCLibs {
$ProgressPreference = 'SilentlyContinue'
	# Create new folder and set location.
	if (!(Test-Path WinRice)) 
	{
		New-Item WinRice -ItemType Directory | out-Null
		$currentdir = $(Get-Location).Path; $dir = "$currentdir/WinRice"; Set-Location $dir
	}
	else 
	{
		Set-Location WinRice
	}
	
	# Download VCLibs.
	print "Updating Visual C++ Libraries..."
	$VCLibs = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
	$VCLibsUWP = "https://github.com/WinRice/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_8wekyb3d8bbwe.Appx"
	Start-BitsTransfer $VCLibs ; Start-BitsTransfer $VCLibsUWP

	# Install VCLibs.
	Add-AppxPackage "Microsoft.VCLibs.x64.14.00.Desktop.appx" ; Add-AppxPackage "Microsoft.VCLibs.140.00.UWPDesktop_8wekyb3d8bbwe.Appx"
	Set-Location ..
	Remove-Item WinRice -Recurse -Force
		
	# Get-Command VCLibs, if it works then print success message.
	if ((Get-AppxPackage *UWPDesktop*).Version -ge 14.0.30035.0) 
	{
		print "Updated Visual C++ Libraries."
		return
	}
	else
	{
		print "Could not update Visual C++ Libraries."
	}
}

function UninstallVCLibs {
	if (!(Get-AppxPackage *VCLibs*)) 
	{
		print "Visual C++ Libraries are not present on this device."
		return
	}
	space
	print "Uninstalling Visual C++ Libraries..."
	Get-AppxPackage *VCLibs* | Remove-AppxPackage
	if (Get-AppxPackage *VCLibs*) 
	{
		print "Could not uninstall Visual C++ Libraries."
		return
	}
	print "Uninstalled Visual C++ Libraries."
}

# Install WinGet (Windows Package Manager)
function InstallWinGet {
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
	if (Get-Command winget) 
	{
		return 
	}
	space
	print "Installing WinGet..."
	Start-BitsTransfer https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
	Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
	Remove-Item Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
	if (!(Get-Command winget))
	{
		print "Could not install WinGet."
		return
	}
	print "Installed WinGet."
}
	
# Install NanaZip.
function InstallNanaZip {
	space
	if (!(Get-Command winget)) 
	{
		print "WinGet is not installed. Couldn't install NanaZip."
		return 
	}
	if (Get-AppxPackage *NanaZip*)
	{
		print "Skipped NanaZip installation because it is already installed on this device."
		return
	}
	print "Installing NanaZip... (https://github.com/M2Team/NanaZip)"
	winget install NanaZip -s msstore --accept-source-agreements --accept-package-agreements --accept-source-agreements | Out-Null
	print "Installed NanaZip."
}

# Uninstall NanaZip.
function UninstallNanaZip {
	space
	print "Uninstalling NanaZip..."
	winget uninstall 40174MouriNaruto.NanaZip_gnj4mf6z9tkrc --accept-package-agreements --accept-source-agreements | Out-Null
	print "Uninstalled NanaZip."
}

# Use winget import (part of code used here was picked from https://devblogs.microsoft.com/scripting/hey-scripting-guy-can-i-open-a-file-dialog-box-with-windows-powershell/)
function WinGetImport {
	if (($installusing -like "2") -or (!($installusing)))
	{
		return
	}
	if (!(Get-Command winget)) 
	{
		print "WinGet is not installed. Please install WinGet first before using winget import."
		return
	}
	space
	[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
	print "WinGet Import"
	print "Select the exported JSON from File Picker UI"
	$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	$OpenFileDialog.InitialDirectory = $initialDirectory
	$OpenFileDialog.Filter = "JSON (*.json)| *.json"
	$OpenFileDialog.ShowDialog() | Out-Null
	if ($OpenFileDialog.FileName) 
	{
		print "Starting winget import..."
		winget import $OpenFileDialog.FileName --accept-package-agreements --accept-source-agreements | Out-Null
	}
	elseif (!($OpenFileDialog.FileName)) 
	{
		print "No JSON selected."
		return
	}
	print "WinGet import has successfully imported the apps."
}

# Install apps from Winstall file (the Winstall.txt file must be on the same directory as WinRice).
function Winstall {
$ErrorActionPreference = 'Continue'
	if (($installusing -like "1") -or (!($installusing)))
	{
		return
	}
	space
	if (!(Get-Command winget)) 
	{ 
		print "WinGet is not installed. Please install WinGet first before using Winstall."
		Start-Process "https://bit.ly/Winstall" 
		return
	}
	# Try Winstall.txt
	if (Test-Path Winstall.txt) 
	{
		print "Winstall"
		# Get each line from the text file and use winget install command on it.
		print "Select Winstall text file from File Picker UI"
		Get-Content 'Winstall.txt' | ForEach-Object 
		{
			$App = $_.Split('=')
			print "    Installing $App..."
			winget install "$App" --source winget --accept-package-agreements --accept-source-agreements --silent | Out-Null
		}
		print "Winstall has successfully installed the app(s)."
	}
	# Try winstall.txt
	elseif (Test-Path winstall.txt)
	{
		print "Winstall"
		# Get each line from the text file and use winget install command on it.
		print "Select Winstall text file from File Picker UI"
		Get-Content 'winstall.txt' | ForEach-Object 
		{
			$App = $_.Split('=')
			print "    Installing $App..."
			winget install "$App" --source winget --accept-package-agreements --accept-source-agreements --silent | Out-Null
		}
		print "Winstall has successfully installed the app(s)."
	}
	else 
	{
		[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
		print "Winstall"
		print "Select Winstall text file from File Picker UI"
		$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
		$OpenFileDialog.InitialDirectory = $initialDirectory
		$OpenFileDialog.Filter = "Text file (*.txt)| *.txt"
		$OpenFileDialog.ShowDialog() | Out-Null
		if ($OpenFileDialog.FileName) 
		{
			print "Starting Winstall..."
			Get-Content $OpenFileDialog.FileName | ForEach-Object 
			{					
				$App = $_.Split('=')
				print "  Installing $App..."
				winget install "$App" --source winget --accept-package-agreements --accept-source-agreements --silent | Out-Null
			}
			print "Winstall has successfully installed the app(s)."
		}
		else 
		{
			print "No text file was picked."
		}
	}
}

# Uninstall apps from Winstall file (the Winstall.txt file must be on the same directory as WinRice).
# Using this is NOT recommended.
function Winuninstall {
$ErrorActionPreference = 'Continue'
	space
	if (!(Get-Command winget)) 
	{ 
		print "WinGet is not installed. Please install WinGet first before using Winstall."
		Start-Process "https://bit.ly/Winstall" 
		return
	}
	$sure = ask "Are you sure you want to uninstall apps installed using Winstall? This is not recommended.[y/N]"
	if (!(check($sure)))
	{
		return
	}

	# Try Winstall.txt
	if (Test-Path Winstall.txt) 
	{
		print "Winstall"
		# Get each line from the text file and use winget install command on it.
		print "Select Winstall text file from File Picker UI"
		Get-Content 'Winstall.txt' | ForEach-Object 
		{
			$App = $_.Split('=')
			print "    Uninstalling $App..."
			winget uninstall "$App" --accept-source-agreements --silent | Out-Null
		}
		print "Winstall has uninstalled the app(s)."
	}
	# Try winstall.txt
	elseif (Test-Path winstall.txt)
	{
		print "Winstall"
		# Get each line from the text file and use winget install command on it.
		print "Select Winstall text file from File Picker UI"
		Get-Content 'winstall.txt' | ForEach-Object 
		{
			$App = $_.Split('=')
			print "    Uninstalling $App..."
			winget uninstall "$App" --accept-source-agreements --silent | Out-Null
		}
		print "Winstall has uninstalled the app(s)."
	}
	else 
	{
		[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
		print "Winstall"
		print "Select Winstall text file from File Picker UI"
		$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
		$OpenFileDialog.InitialDirectory = $initialDirectory
		$OpenFileDialog.Filter = "Text file (*.txt)| *.txt"
		$OpenFileDialog.ShowDialog() | Out-Null
		if ($OpenFileDialog.FileName) 
		{
			print "Starting Winstall..."
				Get-Content $OpenFileDialog.FileName | ForEach-Object 
			{					
				$App = $_.Split('=')
				print "    Uninstalling $App..."
				winget uninstall "$App" --accept-source-agreements --silent | Out-Null
			}
			print "Winstall has uninstalled the app(s)."
		}
		else 
		{
			print "No text file was picked."
		}
	}
}

# Install HEVC Video Extensions.
function InstallHEVC {
$ProgressPreference = 'SilentlyContinue'
	space
	if (Get-AppxPackage -Name Microsoft.HEVCVideoExtension) 
	{
		print "HEVC Video Extensions are already installed in this device."
		return
	}
	# Credit: https://dev.to/kaiwalter/download-windows-store-apps-with-powershell-from-https-store-rg-adguard-net-155m.
	Write-Host "Installing HEVC Video Extensions..."
	$apiUrl = "https://store.rg-adguard.net/api/GetFiles"
	$productUrl = "https://www.microsoft.com/en-us/p/9nmzlz57r3t7"
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
	
		if($text -match "_(x64|neutral).*appx(|bundle)$")
		{
			$downloadFile = Join-Path $downloadFolder $text
			Invoke-WebRequest -Uri $url -OutFile $downloadFile
		}
	}
	Set-Location WinRice
	Add-AppxPackage Microsoft.HEVC*
	Set-Location ../
	Remove-Item WinRice -Recurse -Force
	if (!(Get-AppxPackage *HEVC*))
	{
		print "Could not install HEVC Video Extensions."
		return
	}
	
	print "Installed HEVC Video Extensions."
}

# Uninstall HEVC 
function UninstallHEVC {
$ProgressPreference = 'SilentlyContinue'
	if (!(Get-AppxPackage "Microsoft.HEVCVideoExtension")) 
	{
		print "HEVC Video Extensions may have already been uninstalled."
		return
	}
	space
	print "Uninstalling HEVC Video Extensions..."
	Get-AppxPackage "Microsoft.HEVCVideoExtension" | Remove-AppxPackage
	if (!(Get-AppxPackage "Microsoft.HEVCVideoExtension")) 
	{
		print "Uninstalled HEVC Video Extensions."
	}
	else 
	{
		print "Could not uninstall HEVC Video Extensions."
	}
}

# App Uninstaller GUI. (code reused from https://github.com/farag2/Sophia-Script-for-Windows)
function UninstallerGUI {
	space
	print "Launching App Uninstaller GUI..."
	Add-Type -AssemblyName PresentationCore, PresentationFramework
	#region Variables
	# Apps unchecked by default.
	$UncheckedAppxPackages = @(
    # AMD Radeon Software
    "AdvancedMicroDevicesInc-2.AMDRadeonSoftware",
	
	# Camera
	"Microsoft.WindowsCamera",

    # Calculator
    "Microsoft.WindowsCalculator",

    # Intel Graphics Control Center
    "AppUp.IntelGraphicsControlPanel",
    "AppUp.IntelGraphicsExperience",

	# Microsoft Office
	"Microsoft.Office.Desktop.OneNote",
	"Microsoft.Office.Desktop.Word",
	"Microsoft.Office.Desktop",
	"Microsoft.Office.Desktop.Outlook",
	"Microsoft.Office.Desktop.Excel",
	"Microsoft.Office.Desktop.Access",
	"Microsoft.Office.Desktop.PowerPoint",

    # NVIDIA Control Panel
    "NVIDIACorp.NVIDIAControlPanel",

    # Paint
    "Microsoft.Paint",

    # Realtek Audio Console
    "RealtekSemiconductorCorp.RealtekAudioControl"

    # Sticky Notes
    "Microsoft.MicrosoftStickyNotes",

    # Screen Sketch
    "Microsoft.ScreenSketch",

    # Xbox TCUI
    "Microsoft.Xbox.TCUI",

    # Xbox Speech To Text Overlay
    "Microsoft.XboxSpeechToTextOverlay",

    # Xbox Game Bar
    "Microsoft.XboxGamingOverlay",

    # Xbox Game Bar Plugin
    "Microsoft.XboxGameOverlay",

	# Xbox Identity Provider
    "Microsoft.XboxIdentityProvider",

    # Xbox Console Companion
    "Microsoft.XboxApp",

    # Xbox
    "Microsoft.GamingApp",
    "Microsoft.GamingServices",

	# Windows Terminal
	"Microsoft.WindowsTerminal",
	"Microsoft.WindowsTerminalPreview"
	)

	# Apps not displayed.
	$ExcludedAppxPackages = @(
	# HEVC Video Extensions (personal & OEM)
	"Microsoft.HEVCVideoExtension",
	"Microsoft.HEVCVideoExtensions",

    # Desktop App Installer
    "Microsoft.DesktopAppInstaller",

    # Microsoft Store
    "Microsoft.WindowsStore",
	
    # Notepad
    "Microsoft.WindowsNotepad",

	# Photos     
    "Microsoft.Windows.Photos",
    "Microsoft.Photos.MediaEngineDLC",

    # Store Experience Host
    "Microsoft.StorePurchaseApp",

    # Web Media Extensions
    "Microsoft.WebMediaExtensions"
	)

	#region Variables
	#region XAML Markup
	# The section defines the design of the upcoming dialog box
[xml]$XAML = '
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Name="Window"
    MinHeight="400" MinWidth="415"
    SizeToContent="Width" WindowStartupLocation="CenterScreen"
    TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
    FontFamily="Candara" FontSize="16" ShowInTaskbar="True"
    Background="#F1F1F1" Foreground="#262626">
    <Window.Resources>
        <Style TargetType="StackPanel">
            <Setter Property="Orientation" Value="Horizontal"/>
            <Setter Property="VerticalAlignment" Value="Top"/>
        </Style>
        <Style TargetType="CheckBox">
            <Setter Property="Margin" Value="10, 13, 10, 10"/>
            <Setter Property="IsChecked" Value="True"/>
        </Style>
        <Style TargetType="TextBlock">
            <Setter Property="Margin" Value="0, 10, 10, 10"/>
        </Style>
        <Style TargetType="Button">
            <Setter Property="Margin" Value="20"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="IsEnabled" Value="False"/>
        </Style>
        <Style TargetType="Border">
            <Setter Property="Grid.Row" Value="1"/>
            <Setter Property="CornerRadius" Value="0"/>
            <Setter Property="BorderThickness" Value="0, 1, 0, 1"/>
            <Setter Property="BorderBrush" Value="#000000"/>
        </Style>
        <Style TargetType="ScrollViewer">
            <Setter Property="HorizontalScrollBarVisibility" Value="Disabled"/>
            <Setter Property="BorderBrush" Value="#000000"/>
            <Setter Property="BorderThickness" Value="0, 1, 0, 1"/>
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
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <StackPanel Name="PanelSelectAll" Grid.Column="0" HorizontalAlignment="Left">
                <CheckBox Name="CheckBoxSelectAll" IsChecked="False"/>
                <TextBlock Name="TextBlockSelectAll" Margin="10,10, 0, 10"/>
            </StackPanel>
            <StackPanel Name="PanelRemoveForAll" Grid.Column="1" HorizontalAlignment="Right">
                <TextBlock Name="TextBlockRemoveForAll" Margin="10,10, 0, 10"/>
                <CheckBox Name="CheckBoxForAllUsers" IsChecked="False"/>
            </StackPanel>
        </Grid>
        <Border>
            <ScrollViewer>
                <StackPanel Name="PanelContainer" Orientation="Vertical"/>
            </ScrollViewer>
        </Border>
        <Button Name="ButtonUninstall" Grid.Row="2"/>
    </Grid>
</Window>
'
#endregion XAML Markup

	$Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
	$Form = [Windows.Markup.XamlReader]::Load($Reader)
	$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
		Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)
	}

	$Window.Title               = "Windows apps"
	$ButtonUninstall.Content    = "Uninstall"
	$TextBlockRemoveForAll.Text = "For all users"
	$TextBlockSelectAll.Text    = "Select all"

	$ButtonUninstall.Add_Click({ButtonUninstallClick})
	$CheckBoxForAllUsers.Add_Click({CheckBoxForAllUsersClick})
	$CheckBoxSelectAll.Add_Click({CheckBoxSelectAllClick})
	#endregion Variables

	#region Functions
	function Get-AppxBundle
	{
		[CmdletBinding()]
		param
		(
			[string[]]
			$Exclude,

			[switch]
			$AllUsers
		)

		$AppxPackages = @(Get-AppxPackage -PackageTypeFilter Bundle -AllUsers:$AllUsers | Where-Object -FilterScript {$_.Name -notin $ExcludedAppxPackages})

		# The Bundle packages contains no Microsoft Teams
		if (Get-AppxPackage -Name MicrosoftTeams -AllUsers:$AllUsers)
		{
			# Temporarily hack: due to the fact that there are actually two Microsoft Teams packages, we need to choose the first one to display
			$AppxPackages += Get-AppxPackage -Name MicrosoftTeams -AllUsers:$AllUsers | Select-Object -Index 0
		}

		# The Bundle packages contains no Spotify
		if (Get-AppxPackage -Name SpotifyAB.SpotifyMusic -AllUsers:$AllUsers)
		{
			# Temporarily hack: due to the fact that there are actually two Microsoft Teams packages, we need to choose the first one to display
			$AppxPackages += Get-AppxPackage -Name SpotifyAB.SpotifyMusic -AllUsers:$AllUsers | Select-Object -Index 0
		}

		$PackagesIds = [Windows.Management.Deployment.PackageManager, Windows.Web, ContentType = WindowsRuntime]::new().FindPackages() | Select-Object -Property DisplayName -ExpandProperty Id | Select-Object -Property Name, DisplayName

		foreach ($AppxPackage in $AppxPackages)
		{
			$PackageId = $PackagesIds | Where-Object -FilterScript {$_.Name -eq $AppxPackage.Name}

			if (-not $PackageId)
			{
				continue
			}

			[PSCustomObject]@{
				Name            = $AppxPackage.Name
				PackageFullName = $AppxPackage.PackageFullName
				DisplayName     = $PackageId.DisplayName
			}
		}
	}

	function Add-Control
	{
		[CmdletBinding()]
		param
		(
			[Parameter(
				Mandatory = $true,
				ValueFromPipeline = $true
			)]
			[ValidateNotNull()]
			[PSCustomObject[]]
			$Packages
		)

		process
		{
			foreach ($Package in $Packages)
			{
				$CheckBox = New-Object -TypeName System.Windows.Controls.CheckBox
				$CheckBox.Tag = $Package.PackageFullName

				$TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock

				if ($Package.DisplayName)
				{
					$TextBlock.Text = $Package.DisplayName
				}
				else
				{
					$TextBlock.Text = $Package.Name
				}

				$StackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
				$StackPanel.Children.Add($CheckBox) | Out-Null
				$StackPanel.Children.Add($TextBlock) | Out-Null

				$PanelContainer.Children.Add($StackPanel) | Out-Null

				if ($UncheckedAppxPackages.Contains($Package.Name))
				{
					$CheckBox.IsChecked = $false
				}
				else
				{
					$CheckBox.IsChecked = $true
					$PackagesToRemove.Add($Package.PackageFullName)
				}

				$CheckBox.Add_Click({CheckBoxClick})
			}
		}
	}

	function CheckBoxForAllUsersClick
	{
		$PanelContainer.Children.RemoveRange(0, $PanelContainer.Children.Count)
		$PackagesToRemove.Clear()
		$AppXPackages = Get-AppxBundle -Exclude $ExcludedAppxPackages -AllUsers:$CheckBoxForAllUsers.IsChecked
		$AppXPackages | Add-Control

		ButtonUninstallSetIsEnabled
	}

	function ButtonUninstallClick
	{
		print "Uninstalling selected apps..."

		$Window.Close() | Out-Null

		# If Xbox Game Bar is selected to uninstall stop its' processes
		if ($PackagesToRemove -match "Microsoft.XboxGamingOverlay")
		{
			Get-Process -Name GameBar, GameBarFTServer -ErrorAction Ignore | Stop-Process -Force
		}

		$PackagesToRemove | Remove-AppxPackage -AllUsers:$CheckBoxForAllUsers.IsChecked -Verbose

		print "Uninstalled selected apps."
	}

	function CheckBoxClick
	{
		$CheckBox = $_.Source

		if ($CheckBox.IsChecked)
		{
			$PackagesToRemove.Add($CheckBox.Tag) | Out-Null
		}
		else
		{
			$PackagesToRemove.Remove($CheckBox.Tag)
		}

		ButtonUninstallSetIsEnabled
	}

	function CheckBoxSelectAllClick
	{
		$CheckBox = $_.Source

		if ($CheckBox.IsChecked)
		{
			$PackagesToRemove.Clear()

			foreach ($Item in $PanelContainer.Children.Children)
			{
				if ($Item -is [System.Windows.Controls.CheckBox])
				{
					$Item.IsChecked = $true
					$PackagesToRemove.Add($Item.Tag)
				}
			}
		}
		else
		{
			$PackagesToRemove.Clear()

			foreach ($Item in $PanelContainer.Children.Children)
			{
				if ($Item -is [System.Windows.Controls.CheckBox])
				{
					$Item.IsChecked = $false
				}
			}
		}

		ButtonUninstallSetIsEnabled
	}

	function ButtonUninstallSetIsEnabled
	{
		if ($PackagesToRemove.Count -gt 0)
		{
			$ButtonUninstall.IsEnabled = $true
		}
		else
		{
			$ButtonUninstall.IsEnabled = $false
		}
	}
	#endregion Functions

	# Check "For all users" checkbox to uninstall packages from all accounts.
	if ($ForAllUsers)
	{
		$CheckBoxForAllUsers.IsChecked = $true
	}

	$PackagesToRemove = [Collections.Generic.List[string]]::new()
	$AppXPackages = Get-AppxBundle -Exclude $ExcludedAppxPackages -AllUsers:$ForAllUsers
	$AppXPackages | Add-Control

	if ($AppxPackages.Count -eq 0)
	{
		print "No uninstallable apps found."
	}
	else
	{
		#region Sendkey function
		# Emulate the Backspace key sending to prevent the console window to freeze
		Start-Sleep -Milliseconds 500

		Add-Type -AssemblyName System.Windows.Forms

		$SetForegroundWindow = @{
			Namespace        = "WinAPI"
			Name             = "ForegroundWindow"
			Language         = "CSharp"
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

		Get-Process | Where-Object -FilterScript {(($_.ProcessName -eq "powershell") -or ($_.ProcessName -eq "WindowsTerminal")) -and ($_.MainWindowTitle -like "*pratyakshm's WinRice*")} | ForEach-Object -Process {
			# Show window if its minimized
			[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10)

			Start-Sleep -Seconds 1

			# Force move the console window to the foreground
			[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle)

			Start-Sleep -Seconds 1

			# Emulate the Backspace key sending to prevent the console window to freeze
			[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
		}
		#endregion Sendkey function

		if ($PackagesToRemove.Count -gt 0)
		{
			$ButtonUninstall.IsEnabled = $true
		}

		# Force move the WPF form to the foreground
		$Window.Add_Loaded({$Window.Activate()})
		$Form.ShowDialog() | Out-Null
	}
}

# App Uninstaller CLI.
function UninstallerCLI {
	# Remove inbox apps.
	print "Uninstalling inbox apps..." 
	$InboxApps = @(
		"Clipchamp.Clipchamp"
		"MicrosoftTeams"
		"Microsoft.549981C3F5F10"
		"Microsoft.BingNews"
		"Microsoft.BingWeather"
		"Microsoft.GetHelp" 
		"Microsoft.Getstarted" # Tips 
		"Microsoft.Microsoft3DViewer"
		"Microsoft.MSPaint" # Paint 3D
		# "Microsoft.Paint"  # Paint app (MSIX)
		"Microsoft.MicrosoftOfficeHub" # Office WebView app
		"Microsoft.Office.OneNote" # OneNote for Windows 10
		"Microsoft.MixedReality.Portal"
		"Microsoft.MicrosoftSolitaireCollection" 
		"Microsoft.News" 
		"Microsoft.PowerAutomateDesktop"
		"Microsoft.SkypeApp"
		"Microsoft.Whiteboard"
		"Microsoft.WindowsCommunicationsApps" 
		"Microsoft.WindowsMaps" 
	)
	ForEach ($InboxApp in $InboxApps) 
	{
		if (Get-AppxPackage $InboxApp) 
		{
			print "  Uninstalling $InboxApp..."
			Get-AppxPackage -Name $InboxApp | Remove-AppxPackage 
			Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $InboxApp | Remove-AppxProvisionedPackage -Online | Out-Null
		}
	}

	if (!(Get-CimInstance -ClassName Win32_PnPEntity | Where-Object -FilterScript {($_.PNPClass -eq "Camera") -or ($_.PNPClass -eq "Image")})) 
	{
		print "  Uninstalling Microsoft.WindowsCamera..."
		if (Get-AppxPackage "Microsoft.WindowsCamera")
		{
			Get-AppxPackage "Microsoft.WindowsCamera" | Remove-AppxPackage
			Get-AppxProvisionedPackage -Online "Microsoft.WindowsCamera" | Remove-AppxProvisionedPackage 
		}
	}

	# Remove Sponsored apps.
	$SponsoredApps = @(		
		"*AdobePhotoshopExpress*"
		"*CandyCrush*"
		"*BubbleWitch3Saga*"
		"*Twitter*"
		"*Facebook*"
		"*Spotify*"
		"*Minecraft*"
		"*Dolby*"
	)
	ForEach ($SponsoredApp in $SponsoredApps) 
	{
		if (Get-AppxPackage $SponsoredApp) 
		{
			print "  Uninstalling $SponsoredApp.."
			Get-AppxPackage -Name $SponsoredApp | Remove-AppxPackage 
			Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $SponsoredApp | Remove-AppxProvisionedPackage -Online | Out-Null
		}
	}
	print "Uninstalled inbox apps."
}

# Get apps and uninstall from text file
function UninstallerList {
	if (Test-Path uninstallapps.txt) 
    {
		print "Uninstalling listed apps..."
		# Get each line from the text file and use winget install command on it.
		Get-Content 'uninstallapps.txt' | ForEach-Object 
		{
			if (Get-AppxPackage $App) 
			{
				print "  Uninstalling $App"
				Get-AppxPackage "$App" | Remove-AppxPackage
			}
			elseif (!(Get-AppxPackage $App))
			{
				print "  Couldn't find: $App"
			}
		}
		print "Uninstalled listed apps."
	}
    elseif (Test-Path Uninstallapps.txt)
    {
		print "Uninstalling listed apps..."
		# Get each line from the text file and use winget install command on it.
		Get-Content 'Uninstallapps.txt' | ForEach-Object 
		{
			if (Get-AppxPackage $App) 
			{
				print "  Uninstalling $App"
				Get-AppxPackage "$App" | Remove-AppxPackage
			}
			elseif (!(Get-AppxPackage $App))
			{
				print "  Couldn't find: $App"
			}
		}
		print "Uninstalled listed apps."
    }
    elseif (Test-Path UninstallApps.txt)
    {
        print "Uninstalling listed apps..."
		# Get each line from the text file and use winget install command on it.
		Get-Content 'UninstallApps.txt' | ForEach-Object 
		{
			if (Get-AppxPackage $App) 
			{
				print "  Uninstalling $App"
				Get-AppxPackage "$App" | Remove-AppxPackage
			}
			elseif (!(Get-AppxPackage $App))
			{
				print "  Couldn't find: $App"
			}
		}
		print "Uninstalled listed apps."
    }
}

# Main Uninstall function.
function UninstallApps {
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
	if (!(check($uninstallapps)))
	{
		return
	}
	elseif (check($uninstallmethod))
	{
		UninstallerGUI
	}
	elseif (!(check($uninstallmethod)))
	{
		UninstallerCLI
	}
	elseif ($uninstallmethod -like "list")
	{
		UninstallerList
	}
	if (check($widgets))
	{
		Get-AppxPackage "MicrosoftWindows.Client.WebExperience" | Remove-AppxPackage
		Get-AppxProvisionedPackage -Online "MicrosoftWindows.Client.WebExperience" | Remove-AppxProvisionedPackage
	}
}

# Remove Office webapps.
function WebApps {
	# Test if the web-app exists. If it does not,
	# do not proceed with the function.
	if (!(Test-Path "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk")) 
	{
		return
	}

	# Remove web-apps shortcuts.
	print "Removing Office web-apps..."
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Outlook.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Word.lnk"
	print "Removed Office web-apps."
}

# Unpin all start menu tiles.
function UnpinStartTiles {
	# Check the OS build number.
	# If the device is running Windows 11, do not
	# proceed with the function.
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	if (!(check($systemwidepolicies)))
	{
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
	foreach ($regAlias in $regAliases)
	{
		$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
		$keyPath = $basePath + "\Explorer" 
		if(!(Test-Path -Path $keyPath)) 
		{ 
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
	foreach ($regAlias in $regAliases)
	{
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

# Unpin apps from taskbar (https://docs.microsoft.com/en-us/answers/questions/214599/unpin-icons-from-taskbar-in-windows-10-20h2.html).
function UnpinAppsFromTaskbar {
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
	ForEach ($AppName in $AppNames) 
	{
		if ( $App = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object { $_.Name -eq $AppName })) {
			$App.Verbs() | Where-Object { $_.Name.replace('&', '') -match 'Unpin from taskbar' } | ForEach-Object {$_.DoIt()} -ErrorAction SilentlyContinue | Out-Null
		}	
	}
	print "Unpinned apps from taskbar."
}

# Uninstall Microsoft OneDrive.
function UninstallOneDrive {
$ErrorActionPreference = 'SilentlyContinue'
	# Check if the user has set preference to uninstall OneDrive. 
	# Proceed if the user has set preference otherwise do not run 
	# this function further.
	if (!(check($uninstallod))) 
	{ 
		return 
	}
	space
	# Check if winget is installed. If winget is not installed,
	# do not proceed to run this function further.
	if (!(Get-Command winget)) 
	{
		print "WinGet is not installed. Microsoft OneDrive could not be uninstalled."
		return
	}
	print "Uninstalling Microsoft OneDrive..."

	# Uninstall using winget.
	winget uninstall Microsoft.OneDrive | Out-Null
	winget uninstall Microsoft.OneDriveSync_8wekyb3d8bbwe | Out-Null
	
	# Cleanup leftover folders.
	Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force
	Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -Force
	Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force
	Remove-Item "$env:LOCALAPPDATA\OneDrive" -Recurse -Force

	print "Uninstalled Microsoft OneDrive."
}


# Install Microsoft OneDrive 
function InstallOneDrive {
	# Check if winget is installed. If winget is not installed,
	# do not proceed to run this function further.
	if (!(Get-Command winget)) 
	{
		print "WinGet is not installed. Could not install Microsoft OneDrive."
		return
	}
	# Install OneDrive using winget
	print "Installing Microsoft OneDrive..."
	winget install Microsoft.OneDrive --source winget --accept-package-agreements --accept-source-agreements --silent | Out-Null
	
	# Check if OneDrive is successfully installed using winget, and inform the
	# user if installation has failed.
	$check = winget list Microsoft.OneDrive
	if ($check -like "No installed package found matching input criteria.") 
	{
		print "Could not install Microsoft OneDrive."
		return
	}
	print "Installed Microsoft OneDrive."
}


# Uninstall Windows Optional Features and Windows Capabilities.
function UninstallFeatures {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
	if (!(check($uninstallfeatures))) 
	{ 
		return 
	}
	space
	print "Removing capabilities and features..."

	# List capabilities separately for Windows 11 and Windows 10.
	if ($CurrentBuild -lt 22000) 
	{
		$Capabilities = @(
			"MathRecognizer*"
			"Microsoft-Windows-SnippingTool*"
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
			"MathRecognizer*"
			"Microsoft.Windows.PowerShell.ISE*"
			"Microsoft.Windows.WordPad*"
			"Print.Fax.Scan*"
			"Print.Management.Console*"
			"XPS.Viewer*"
		)
	}

	# Remove listed capabilities.
	ForEach ($Capability in $Capabilities) 
	{
		Get-WindowsCapability -Online | Where-Object {$_.Name -like $Capability} | Remove-WindowsCapability -Online | Out-Null
	}
	
	if (!(Get-CimInstance -ClassName Win32_PnPEntity | Where-Object -FilterScript {($_.PNPClass -eq "Camera") -or ($_.PNPClass -eq "Image")})) 
	{
		Get-WindowsPackage -Online | Where-Object PackageName -like *Hello-Face* | Remove-WindowsPackage -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
		print "  - Uninstalled Windows Hello Face"
	}

	# Print the list of capabilities to the user.

	# Capabilities in Windows 10.
	if ($CurrentBuild -lt 22000)
	{
		$CapLists =@(
			"Math Recognizer"
			"Snipping Tool" 
			"Windows Fax & Scan"
			"Windows Hello Face"
			"Windows PowerShell ISE"
			"Windows XPS Features"
			"WordPad"
		)
		ForEach ($CapList in $CapLists) {
			Start-Sleep -Milliseconds 20
			print "  - Uninstalled $CapList"
		}
	}

	# Capabilities in Windows 11.
	elseif ($CurrentBuild -ge 22000)
	{
		$CapLists =@(
			"Math Recognizer"
			"Windows Fax & Scan"
			"Windows Hello Face"
			"Windows PowerShell ISE"
			"Windows XPS Features"
			"WordPad"
		)
		ForEach ($CapList in $CapLists) {
			Start-Sleep -Milliseconds 20
			print "  - Uninstalled $CapList"
		}
	}

	# List optional features.
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
	ForEach ($OptionalFeature in $OptionalFeatures)
	{
		Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like $OptionalFeature} | Disable-WindowsOptionalFeature -Online -NoRestart | Out-Null
	}

	# Print the list of features to the user.
	$Features =@(
		"DirectPlay"
		"PowerShell v2 (root)"
		"SMB1 protocol"
		"SMB Direct"
		"Work Folders Client"
		"XPS Document Writer"
	)
	ForEach ($Feature in $Features) 
	{
		Start-Sleep -Milliseconds 20
		print "  - Disabled $Feature"
	}
	
	print "Removed capabilities and features."
}

# Install Windows Optional Features and Windows Capabilities.
function InstallFeatures {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Adding capabilities and features..."

	# Install capabilities.
	$Capabilities = @(
		"Hello.Face*"
		"MathRecognizer*"
		"Microsoft-Windows-SnippingTool*"
		"Microsoft.Windows.MSPaint*" 
		"Microsoft.Windows.PowerShell.ISE*"
		"Microsoft.Windows.WordPad*"
		"Print.Fax.Scan*"
		"XPS.Viewer*"
	)
	ForEach ($Capability in $Capabilities) 
	{
		Get-WindowsCapability -Online | Where-Object {$_.Name -like $Capability} | Add-WindowsCapability -Online | Out-Null
	}

	# Print user friendly list of capabilities & features installed.
	$CapLists =@(
		"Math Recognizer"
		"Microsoft Paint"
		"Snipping Tool"
		"Windows Fax & Scan"
		"Windows Hello Face"
		"Windows PowerShell ISE"
		"Windows XPS Features"
		"WordPad"
	)
	ForEach ($CapList in $CapLists) 
	{
		Start-Sleep -Milliseconds 70
		print "  - Installed $CapList"
	}

	$OptionalFeatures = @(
		"WorkFolders-Client*"
		"Printing-XPSServices-Feature*"
	)
	ForEach ($OptionalFeature in $OptionalFeatures) 
	{
		Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like $OptionalFeature} | Enable-WindowsOptionalFeature -Online -NoRestart | Out-Null
	}
	print " - Enabled Work Folders Client."
	
	print "Added capabilities and features."
}

# Install Windows Subsystem for Linux.
function InstallWSL {
$ProgressPreference = 'SilentlyContinue'
	if (!(check($wsl))) 
	{ 
		return 
	}
	space 

	# Inform user if WSL is already installed.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State -like "Enabled") 
	{
		print "Windows Subsystem for Linux is already installed."
		return
	}

	# Install WSL.
	print "Installing Windows Subsystem for Linux..."
	Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -All -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
	Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -All -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
	Start-BitsTransfer https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi 
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State -like "Disabled") 
	{
		print "Could not install Windows Subsystem for Linux."
		return
	}
	Set-Content -Path 'WSL2.ps1' -value 'wsl --set-default-version 2'
	$path = (Get-Location).Path
	print "    In the current folder ($path), you will find two files: wsl_update_x64.msi and WSL2.ps1."
	print "    Once your PC has restarted, install wsl_update_x64.msi. Next, right click on WSL2.ps1 and run it with PowerShell."
	print "Installed Windows Subsystem for Linux."
}

# Uninstall Windows Subsystem for Linux.
function UninstallWSL {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
	space

	# Inform user if WSL is already uninstalled.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State -like "Disabled") 
	{
		print "Windows Subsystem for Linux is already uninstalled."
		return
	}

	# Uninstall WSL.
	print "Uninstalling Windows Subsystem for Linux..."
	Disable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart | Out-Null

	# Print status.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State -like "Enabled") 
	{
		print "Could not uninstall Windows Subsystem for Linux."
		return
	}
	print "Uninstalled Windows Subsystem for Linux."
}

# Install Windows Sandbox.
function InstallSandbox {
$ProgressPreference = 'SilentlyContinue'
	if (!(check($sandbox)))
	{
		return
	}
	space
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM").State -like "Enabled")
	 {
		print "Windows Sandbox is already installed."
		return
	}

	# Warn if unsupported Edition (not version).
	if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"})) 
	{
		print "Could not install Windows Sandbox since $ProductName does not support it."
		return
	}

	# Install Windows Sandbox.
	print "Enabling Windows Sandbox..."
	Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart -WarningAction Ignore | Out-Null

	# Print status.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM").State -like "Disabled") 
	{
		print "Could not install Windows Sandbox."
		return
	}
	print "Install Windows Sandbox."
}

# Uninstall Windows Sandbox.
function UninstallSandbox {
$ProgressPreference = 'SilentlyContinue'
	space

	# Check if already uninstalled.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM").State -like "Disabled") 
	{
		print "Windows Sandbox is already uninstalled."
		return
	}

	# Warn if unsupported Edition (not version)
	if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}))
	{
		print "Windows Sandbox can't be configured in $ProductName."
		return
	}

	# Uninstall Windows Sandbox.
	print "Uninstalling Windows Sandbox..."
	Disable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart -WarningAction Ignore | Out-Null
	
	# Print status.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM").State -like "Enabled") 
	{
		print "Could not uninstall Windows Sandbox."
		return
	}
	print "Uninstalled Windows Sandbox."
}

# Install dotNET 3.5.
function InstalldotNET3.5 {
$ProgressPreference = 'SilentlyContinue'
	if (!(check($netfx3))) 
	{ 
		return 
	}
	space

	# Check if already install.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State -like "Enabled")
	{
		print ".NET 3.5 is already installed."
		return
	}

	# Install dotNET 3.5.
	print "Installing .NET 3.5..."
	Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -NoRestart | Out-Null

	# Print status.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State -like "Disabled")
	{
		print "Could not install .NET 3.5."
		return
	}
	print "Installed .NET 3.5."
}

# Uninstall dotNET 3.5
function UninstalldotNET3.5 {
$ProgressPreference = 'SilentlyContinue'
	space

	# Check if already uninstalled.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State -like "Disabled")
	{
		print ".NET 3.5 is already uninstalled."
		return
	}

	# Uninstall dotNET 3.5.
	print "Uninstalling .NET 3.5..."
	Disable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -NoRestart | Out-Null

	# Print status.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State -like "Enabled")
	{
		print ".NET 3.5 is already uninstalled."
		return
	}
	print "Uninstalled .NET 3.5."
}




######################################
######### PRIVACY & SECURITY #########
######################################

# Update status
function PrivacySecurity {
	space
	print "-------------------------"
	print "    PRIVACY & SECURITY   "
	print "-------------------------"
}


# Disable Activity History.
function DisableActivityHistory {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling Activity History..."
	$ActivityFeed = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityFeed -Name "EnableActivityFeed" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "PublishUserActivities" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "UploadUserActivities" -Type DWord -Value 0	
	print "Disabled Activity History."
}

# Enable Activity History.
function EnableActivityHistory {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	print "Enabling Activity History..."
	$ActivityHistory = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityHistory -Name "EnableActivityFeed" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "PublishUserActivities" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "UploadUserActivities" -Type DWord -Value 1
	print "Enabled Activity History."
}

# Disable Advertising ID.
function DisableAdvertisingID {
	space
	print "Disabling Advertising ID..."
	currentuser
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 0
	print "Disabled Advertising ID."
}

# Enable Advertising ID.
function EnableAdvertisingID {
	print "Enabling Advertising ID..."
	currentuser
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 1
	print "Enabled Advertising ID."
}

# Disable Background apps (https://github.com/farag2/Windows-10-Sophia-Script).
function DisableBackgroundApps {
	space
	print "Disabling Background apps..."
	Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process 
	{
		Remove-ItemProperty -Path $_.PsPath -Name * -Force
	}
	$ExcludedApps = @(
		"Microsoft.LockApp",
		"Microsoft.Windows.ContentDeliveryManager",
		"Microsoft.549981C3F5F10",
		"Microsoft.Windows.Search",
		"MicrosoftWindows.Client.CBS",
		"Microsoft.Windows.SecHealthUI"
		"Microsoft.SecHealthUI",
		"Microsoft.Windows.ShellExperienceHost",
		"Microsoft.Windows.StartMenuExperienceHost",
		"Microsoft.WindowsStore"
		)
		$OFS = "|"
		Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | Where-Object -FilterScript {$_.PSChildName -notmatch "^$($ExcludedApps.ForEach({[regex]::Escape($_)}))"} | ForEach-Object -Process 
		{
			New-ItemProperty -Path $_.PsPath -Name Disabled -PropertyType DWord -Value 1 -Force | Out-Null
			New-ItemProperty -Path $_.PsPath -Name DisabledByUser -PropertyType DWord -Value 1 -Force | Out-Null
		}
		$OFS = " "
	print "Disabled Background apps."
}

# Enable Background apps.
function EnableBackgroundApps {
	print "Enabling Background apps..."
	Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process 
	{
		Remove-ItemProperty -Path $_.PsPath -Name * -Force
	}
	print "Enabled Background apps."
}

# Disable Windows Error Reporting. 
function DisableErrorReporting {
	space
	if ($Insider)
	{
		print "Error reporting is left unchanged in Windows pre-release software."
		return
	}
	print "Disabling Windows Error Reporting..."
	Disable-WindowsErrorReporting | Out-Null
	print "Disabled Windows Error Reporting."
}

# Enable Windows Error Reporting. 
function EnableErrorReporting {
	print "Enabling Windows Error Reporting..."
	Enable-WindowsErrorReporting | Out-Null
	print "Enabled Windows Error Reporting."
}

# Disable Feedback.
function DisableFeedback {
$ErrorActionPreference = 'SilentlyContinue'
	space
	if ($Insider)
	{
		print "Feedback notifications are left unchanged in Windows pre-release software."
		return
	}
	print "Disabling Feedback notifications..."
	$Feedback1 = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	$Feedback2 = "Microsoft\Windows\Feedback\Siuf\DmClient"
	$Feedback3 = "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
	if (!(Test-Path $Feedback1)) 
	{
		New-Item -Path $Feedback1 -Force | Out-Null
	}
	Set-ItemProperty -Path $Feedback1 -Name "NumberOfSIUFInPeriod" -Type DWord -Value 1
	if (!(Test-Path $Feedback2)) 
	{
		New-Item -Path $Feedback2 -Force | Out-Null
	}
	Disable-ScheduledTask -TaskName $Feedback2 | Out-Null
	Disable-ScheduledTask -TaskName $Feedback3 | Out-Null
	print "Disabled Feedback notifications."
}

# Enable Feedback.
function EnableFeedback {
	print "Enabling Feedback notifications..."
	$Feedback1 = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	$Feedback2 = "Microsoft\Windows\Feedback\Siuf\DmClient"
	$Feedback3 = "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
	if (!(Test-Path $Feedback1 )) 
	{
		New-Item $Feedback1 -Force | Out-Null
	}
	Enable-ScheduledTask -TaskName $Feedback2 | Out-Null
	Enable-ScheduledTask` -TaskName $Feedback3 | Out-Null
	print "Enabled Feedback notifications."
}

# Disable inking personalization.
function DisableInkHarvesting {
	space
	print "Disabling Inking & typing personalization..."
	$Ink1 = "HKCU:\Software\Microsoft\InputPersonalization"
	$Ink2 = "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore"
	$Ink3 = "HKCU:\Software\Microsoft\Personalization\Settings"
	if (!(Test-Path $Ink1)) 
	{
		New-Item -Path $Ink1 -Force | Out-Null
	}
	New-ItemProperty -Path $Ink1 -Name "RestrictImplicitInkCollection" -Type DWord -Value 1 -Force | Out-Null 
	Set-ItemProperty -Path $Ink2 -Name "HarvestContacts" -Type DWord -Value 0
	Set-ItemProperty -Path $Ink3 -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
	print "Disabled Inking & typing personalization."
}

# Enable inking personalization. 
function EnableInkHarvesting {
	space
	print "Enabling Inking & typing personalization..."
	$Ink1 = "HKCU:\Software\Microsoft\InputPersonalization"
	$Ink2 = "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore"
	$Ink3 = "HKCU:\Software\Microsoft\Personalization\Settings"
	if (!(Test-Path $Ink1))
	{
		New-Item -Path $Ink1 -Force | Out-Null
	}
	New-ItemProperty -Path $Ink1 -Name "RestrictImplicitInkCollection" -Type DWord -Value 0 -Force | Out-Null 
	Set-ItemProperty -Path $Ink2 -Name "HarvestContacts" -Type DWord -Value 1
	Set-ItemProperty -Path $Ink3 -Name "AcceptedPrivacyPolicy" -Type DWord -Value 1
	print "Enabled Inking & typing personalization."
}

# Disable "Let websites provide locally relevant content by accessing my language list".
function DisableLangAccess {
	space
	print "Disabling websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Remove-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 1 | Out-Null
	print "Disabled websites' ability to provide you with locally relevant content by accessing your language list."
}

# Enable "Let websites provide locally relevant content by accessing my language list".
function EnableLangAccess {
	print "Enabling websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Set-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 0
	print "Enabled websites' ability to provide you with locally relevant content by accessing your language list."
}

# Disable Location Tracking.
function DisableLocationTracking {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling location tracking..."
	$Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	$Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
	if (!(Test-Path $Location1)) 
	{
		New-Item -Path $Location1 -Force | Out-Null
	}
	Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Deny"
	Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 0
	print "Disabled Location tracking."
}

# Enable location tracking.
function EnableLocationTracking {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling Location tracking..."
	$Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	$Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
	if (!(Test-Path )) 
	{
		New-Item -Path $Location1 -Force | Out-Null
	}
	Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Allow"
	Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 1
	print "Enabled Location tracking."
}

# Disable automatic Maps updates.
function DisableMapUpdates {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling automatic Maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
	print "Disabled automatic Maps updates."
}

# Enable maps updates.
function EnableMapsUpdates {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling automatic Maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 1
	print "Enabled automatic Maps updates."
}

# Disable Speech Recognition.
function DisableSpeechRecognition {
	space
	print "Disabling Online Speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	if (!(Test-Path $Speech)) 
	{
		New-Item -Path $Speech -ErrorAction SilentlyContinue | Out-Null
	}
	Remove-ItemProperty -Path $Speech -Name "HasAccepted" -ErrorAction SilentlyContinue
	New-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 0 -ErrorAction SilentlyContinue | Out-Null
	print "Disabled Online Speech recognition."
}

# Enable speech recognition. 
function EnableSpeechRecognition {
	space
	print "Enabling Speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	if (!(Test-Path )) 
	{
		New-Item -Path $Speech | Out-Null
	}
	Set-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 1
	print "Enabled Online Speech recognition"
}

# Disable silent installation of recommended apps.
function DisableSilentInstallApps {
	space
	print "Disabling silent installation of suggested apps..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -Type DWord -Value 1
	print "Disabled silent installation of suggested apps."
}

# Enable silent installation of recommended apps.
function EnableSilentInstallApps {
	space
	print "Enabling silent installation of suggested apps..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -Type DWord -Value 1
	print "Enabled silent installation of suggested apps."
}

# Disable "Show suggested content in Settings app"
function HideSuggestedContentInSettings {
	space
	print "Disabling suggested content in Settings app..."
	$CDN = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353694Enabled -Type DWord -Value 0
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353696Enabled -Type DWord -Value 0
	Set-ItemProperty -Path $CDN -Name SubscribedContent-338393Enabled -Type DWord -Value 0
	print "Disabled suggested content in Settings app."
}

# Enable "Show suggested content in Settings app"
function ShowSuggestedContentInSettings {
	space
	print "Enabling suggested content in Settings app..."
	$CDN = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353694Enabled -Type DWord -Value 1
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353696Enabled -Type DWord -Value 1
	Set-ItemProperty -Path $CDN -Name SubscribedContent-338393Enabled -Type DWord -Value 1
	print "Enabled suggested content in Settings app."
}

# Disable "Show me suggested content in Start menu".
function HideSuggestedContentInStart {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space 
	print "Disabling suggested content in Start menu..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -Type DWord -Value 0
	print "Disabled suggested content in Start menu."
}

# Enable "Show me suggested content in Start menu".
function ShowSuggestedContentInStart {
	if ($CurrentBuild -ge 22000)
	{
		return
	}
	space 
	print "Enabling Suggested content in Start menu..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -Type DWord -Value 1
	print "Enabled Suggested content in Start menu."
}

# Disable Tailored experiences.
function DisableTailoredExperiences {
	space
	print "Disabling Tailored experiences..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value 0
	print "Disabled Tailored experiences."
}

# Enable Tailored experiences.
function EnableTailoredExperiences {
	space
	print "Enabling Tailored experiences..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value 1
	print "Enabled Tailed experiences."
}

# Set Diagnostic Data to Required. 
function TelemetryRequired {
	space
	if ($Insider)
	{
		return
	}
	if (!(check($systemwidepolicies)))
	{
		return
	}
	print "Setting Diagnostic data level to Required..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"  -Name "AllowTelemetry" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"  -Name "MaxTelemetryAllowed" -Type DWord -Value 1
	print "Set Diagnostic data level to Required."
}

# Set Diagnostic Data to Optional.
function TelemetryOptional {
	if (!($Insider))
	{	
		return
	}
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "This device is flighting in the Windows Insider Program, hence Diagnostic data will be set to optional..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"  -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"  -Name "MaxTelemetryAllowed" -Type DWord -Value 3
	print "Diagnostic data is set to Optional."
}

# Enable Clipboard History.
function EnableClipboard {
	space
	print "Enabling Clipboard History..."
	$Clipboard = "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Value 1 -ErrorAction SilentlyContinue
	print "Enabled Clipboard History."
    Start-Sleep 1
    Set-Clipboard "Demo text by WinRice."
    print "Access your clipboard now using Windows key + V."
	Write-Warning "If the Clipboard History feature does not work, retry it after a device restart."
}

# Disable Clipboard History.
function DisableClipboard {
	space
	print "Disabling Clipboard History..."
	$Clipboard = "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Value 0 -ErrorAction SilentlyContinue
	print "Disabled Clipboard History."
}

# Security features

function AutoLoginPostUpdate {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling automatic login post updates..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent" -Type DWord -Value 1
	print "Enabled Automatic login applying updates."
} 

function StayOnLockscreenPostUpdate {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling automatic login post updates..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent"
	print "Disabled Automatic login after applying updates."
}

function DisableVBS {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	# Check if current processor supports MBEC.
	# (https://docs.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity)
	# This function disables Virtualization based security if your device's
	# processor does not support MBEC. On unsupported processors, MBEC is emulated
	# which taxes CPU performance.
	$mbec = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard | Select-Object AvailableSecurityProperties
	if ($mbec -contains 7)
	{
		return
	}
	print "Disabling Virtualization-based security..."
	print "  This processor does not natively support MBEC. Emulating it will result in bigger impact on performance on MBEC-unsupported CPUs."
	print "  See https://docs.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity."
	Start-Sleep -Milliseconds 400
	# Disable Memory Integrity Core isolation.
	# Memory Integrity Core Isolation must be disabled before we disable Virtual-ization based security.
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Type DWord -Value 0
	# Disable Virtualization-based security.
	bcdedit.exe /set hypervisorlaunchtype off | Out-Null
	print "Disabled Virtualization-based security."
	space
	print "  Note that virtualization features powered by Hyper-V such as WSL and WSA will not work until you re-enable Virtualization-based security."
	print "  Read https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#virtualization-based-security for more."
	space
}

function EnableVBS {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling Virtualization-based security..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Type DWord -Value 1
	bcdedit.exe /set hypervisorlaunchtype auto | Out-Null
	print "Enabled Virtualization-based security."
}

# Disables Windows WDigest credential caching (https://stealthbits.com/blog/wdigest-clear-text-passwords-stealing-more-than-a-hash/).
function DisableLogonCredential {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling Windows WDigest credential caching..."
	# https://stealthbits.com/blog/wdigest-clear-text-passwords-stealing-more-than-a-hash/
	Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\SecurityProviders\Wdigest" -Name "UseLogonCredential" -Type "DWORD" -Value 0
	print "Disabled Windows WDigest credential caching."
}

# Enables Windows WDigest credential caching.
function EnableLogonCredential {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling Windows WDigest credential caching..."
	Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\SecurityProviders\Wdigest" -Name "UseLogonCredential" -Type "DWORD" -Value 1
	print "Enabled Windows WDigest credential caching."
}

# Disable LLMNR (https://www.blackhillsinfosec.com/how-to-disable-llmnr-why-you-want-to/).
function DisableLLMNR {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling LLMNR..."
	New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows NT\" -Name "DNSClient" -Force | Out-Null
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -Type "DWORD" -Value 0 -Force | Out-Null
	print "Disabled LLMNR."
}

# Enable LLMNR
function EnableLLMNR {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling LLMNR..."
	Remove-Item -Path "HKLM:\Software\Policies\Microsoft\Windows NT\DNS Client" | Out-Null
	print "Enabled LLMNR."
}

function EnableSEHOP {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	$SEHOP = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel"
	$Enabled = Get-ItemPropertyValue -Path $SEHOP -Name DisableExceptionChainValidation
	if ($Enabled -like 0)
	{
		return
	}
	print "Enabling Structured Exception Handling Overwrite Protection..."
	New-ItemProperty -Path $SEHOP -Type DWord -Name DisableExceptionChainValidation -Value 0 -Force | Out-Null
	print "Enabled Structured Exception Handling Overwrite Protection."
}

function DisableSEHOP {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling Structured Exception Handling Overwrite Protection..."
	$SEHOP = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel"
	Remove-ItemProperty -Path $SEHOP -Type DWord -Name DisableExceptionChainValidation | Out-Null
	print "Disabled Structured Exception Handling Overwrite Protection."
}

function DisableWPAD {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling Web Proxy Auto-Discovery..."
	New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\" -Name "Wpad" -Force | Out-Null
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" -Name "Wpad" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" -Name "WpadOverride" -Type "DWORD" -Value 1 -Force
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" -Name "WpadOverride" -Type "DWORD" -Value 1 -Force
	print "Disabled Web Proxy Auto-Discovery."
}

function EnableWPAD {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling Web Proxy Auto-Discovery..."
	Remove-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" -Force | Out-Null
    Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" -Force | Out-Null
	print "Enabled Web Proxy Auto-Discovery."
}

function EnableLSAProtection {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling LSA Protection/Auditing..."
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\" -Name "LSASSs.exe" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\LSASS.exe" -Name "AuditLevel" -Type "DWORD" -Value 8 -Force
	print "Enabled LSA Protection/Auditing."
}

function DisableLSAProtection {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling LSA Protection/Auditing..."
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\LSASS.exe"
	print "Disabled LSA Protection/Auditing."
}

function DisableScriptHost {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling Windows Script Host..."
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\" -Name "Settings" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name "Enabled" -Type "DWORD" -Value 0 -Force
	print "Disabled Windows Script Host."
}

function EnableScriptHost {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling Windows Script Host..."
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Force | Out-Null
	print "Enabled Windows Script Host."
}

function DisableOfficeOLE {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space 
	if (-not (Test-Path "C:\Program Files\Microsoft Office"))
	{
		return
	}
	print "Disabling Office OLE..."
	$Keys = Get-Item -Path "HKLM:\Software\RegisteredApplications" | Select-Object -ExpandProperty property
	$Product = $Keys | Where-Object {$_ -Match "Outlook.Application."}
	$OfficeVersion = ($Product.Replace("Outlook.Application.","")+".0")
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Office\$OfficeVersion\Outlook\" -Name "Security" -Force | Out-Null
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Office\$OfficeVersion\Outlook\" -Name "Security" -Force | Out-Null
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\$OfficeVersion\Outlook\Security\" -Name "ShowOLEPackageObj" -Type "DWORD" -Value "0" -Force
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\$OfficeVersion\Outlook\Security\" -Name "ShowOLEPackageObj" -Type "DWORD" -Value "0" -Force
	print "Disabled Office OLE."
}

function EnableOfficeOLE {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	if (-not (Test-Path "C:\Program Files\Microsoft Office"))
	{
		return
	}
	print "Enabling Office OLE..."
	$Keys = Get-Item -Path "HKLM:\Software\RegisteredApplications" | Select-Object -ExpandProperty property
	$Product = $Keys | Where-Object {$_ -Match "Outlook.Application."}
	$OfficeVersion = ($Product.Replace("Outlook.Application.","")+".0")
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Office\$OfficeVersion\Outlook\Security"
	Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Office\$OfficeVersion\Outlook\Security"
	print "Enabled Office OLE."
}



####################################
######### OPERATING SYSTEM #########
####################################

# Update status.
function OS {
	space
	print "---------------------------"
	print "      OPERATING SYSTEM     "   
	print "---------------------------"
}

# Restore Power Options
function RestorePowerOptions {
	space
	print "Restoring power options in Advanced power settings menu..."
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\0012ee47-9041-4b5d-9b77-535fba8b1442\6738e2c4-e8a5-4a42-b16a-e040e769756e" -Name Attributes -Type DWord -Value 0 -Force | Out-Null
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\F15576E8-98B7-4186-B944-EAFA664402D9" -Name Attributes -Type DWord -Value 0 -Force | Out-Null
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\19cbb8fa-5279-450e-9fac-8a3d5fedd0c1\12bbebe6-58d6-4636-95bb-3217ef867c1a"  -Name Attributes -Type DWord -Value 0 -Force | Out-Null
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226"  -Name Attributes -Type DWord -Value 0 -Force | Out-Null
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\bc5038f7-23e0-4960-96da-33abaf5935ec"  -Name Attributes -Type DWord -Value 0 -Force | Out-Null
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c"  -Name Attributes -Type DWord -Value 0 -Force | Out-Null
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\94D3A615-A899-4AC5-AE2B-E4D8F634367F"  -Name Attributes -Type DWord -Value 0 -Force | Out-Null
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5"  -Name Attributes -Type DWord -Value 0 -Force | Out-Null
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\9596FB26-9850-41fd-AC3E-F7C3C00AFD4B\34C7B99F-9A6D-4b3c-8DC7-B6693B78CEF4"  -Name Attributes -Type DWord -Value 0 -Force | Out-Null
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7"  -Name Attributes -Type DWord -Value 0 -Force | Out-Null
	print "Restored power options in Advanced power settings menu."
}

# Disable Autoplay.
function DisableAutoplay {
	space
	print "Disabling AutoPlay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
	print "Disabled AutoPlay."
}

# Enable Autoplay.
function EnableAutoplay {
	space
	print "Enabling Autoplay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
	print "Enabled AutoPlay."
}

# Disable Autorun for all drives.
function DisableAutorun {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling Autorun for all drives..."
	$Autorun = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	if (!(Test-Path $Autorun)) 
	{
		New-Item -Path $Autorun | Out-Null
	}
	Set-ItemProperty -Path $Autorun -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
	print "Disabled Autorun for all drives."
}

# Enable Autorun for removable drives.
function EnableAutorun {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling Autorun for all drives..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
	print "Enabled Autorun for all drives."
}

# Disable Hiberfile.sys
function DisableHibernation {
	if ($isLaptop)
	{
		return
	}
	space 
	print "Disabling hibernation..."
	powercfg.exe -h off
	print "Disabled hibernation."
}

# Enable Hibernation
function EnableHibernation {
	if ($isLaptop) 
	{
		return
	}
	space 
	print "Enabling hibernation..."
	powercfg.exe -h on
	print "Enabled hibernation."
}

# Make Windows follow BIOS time
function BIOSTimeUTC {
	if (!(check($UseUTSCWhenFollowBIOSTime)))
	{
		return
	}
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Setting Windows to use UTC when following BIOS time..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
	print "Set Windows to use UTC when following BIOS time."
}

# Make Windows follow local time
function BIOSTimeLocal {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Setting Windows to use local time when following BIOS time..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -ErrorAction SilentlyContinue
	print "Set Windows to use local time when following BIOS time."
}

# Enable Num lock on startup.
function EnableNumLock {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Setting Num lock to turn on automatically on Startup..."
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force | Out-Null
	print "Num lock will turn on automatically on Startup."
}

# Disable Num lock on startup.
function DisableNumLock {
	space
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483648 -Force | Out-Null
	print "Num lock will no longer turn on automatically on Startup."
}

# Enable Storage Sense. 
function EnableStorageSense {
	space
	print "Enabling Storage Sense..."
	$StorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $StorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $StorageSense -Name 01 -PropertyType DWord -Value 1 -Force | Out-Null
	print "Enabled Storage Sense."
}

# Disable Storage Sense.
function DisableStorageSense {
	space
	print "Disabling Storage Sense..."
	$StorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $StorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $StorageSense -Name 01 -PropertyType DWord -Value 0 -Force | Out-Null
	print "Disabled Storage Sense."
}

# Disable Reserved Storage. 
function DisableReserves {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 0
	print "Disabled Reserved Storage."
}

# Enable Reserved Storage. 
function EnableReserves {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 1
	print "Enabled Reserved Storage."
}

# Disable non-essential services.
function DisableServices {
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Disabling non-essential services..."
    	$Services = @(
		"DiagTrack"
		"SysMain"
    )
    ForEach ($Service in $Services) 
	{
		Stop-Service $Service | Out-Null
		Set-Service $Service -StartupType Disabled
		print "    Stopped service: $Service."
	}
	print "Disabled unnecessary services."
}

# Enable non-essential services.
function EnableServices {
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Enabling non-essential services..."
    	$Services = @(
		"DiagTrack"
		"SysMain"
    )
    ForEach ($Service in $Services) 
	{
		Start-Service $Service | Out-Null
		Set-Service $Service -StartupType Automatic
		print "    Started service: $Service."
	}
	print "Enabled non-essential services."
}

# Disable non-essential scheduled tasks.
function DisableTasks {
	space
	print "Disabling non-essential tasks..."
	$Tasks = @(
		"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
		"Microsoft\Windows\Application Experience\ProgramDataUpdater"
        "Microsoft\Windows\Application Experience\PcaPatchDbTask"
		"Microsoft\Windows\Autochk\Proxy"
        "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
		"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
		"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 
		"Microsoft\Windows\Windows Error Reporting\QueueReporting" 
    )
    ForEach ($Task in $Tasks) 
	{
		Disable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		print "    Disabled task: $Task."
	}
    print "Disabled non-essential tasks."
}

# Enable non-essential scheduled tasks.
function EnableTasks {
	$Tasks = @(
		"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
		"Microsoft\Windows\Application Experience\ProgramDataUpdater"
		"Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
		"Microsoft\Windows\Autochk\Proxy"
		"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
		"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 
		"Microsoft\Windows\Windows Error Reporting\QueueReporting" 
    )
    ForEach ($Task in $Tasks) 
	{
		Enable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		print "    Enabled task: $Task."
	}
    print "Enabled non-essential tasks."
}

# Disable AMD tasks
function DisableAMDTasks {
	if ((Get-WmiObject Win32_Processor).Manufacturer -ne "AuthenticAMD")
	{
		return
	}
	space
	print "This device is powered by an AMD processor, disabling additional AMD specific tasks..."
	$Tasks = @(
		"AMDLinkUpdate"
		"AMDRyzenMasterSDKTask"
		"ModifyLinkUpdate"
		"StartCN"
		"StartDVR"
    )
	ForEach ($Task in $Tasks) 
	{
		Disable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		print "    Disabled task: $Task."
	}
	print "Disabled additional AMD specific tasks."
}

# Enable AMD tasks
function EnableAMDTasks {
	if ((Get-WmiObject Win32_Processor).Manufacturer -ne "AuthenticAMD")
	{
		return
	}
	print "Enabling additional AMD specific tasks..."
	$Tasks = @(
		"AMDLinkUpdate"
		"AMDRyzenMasterSDKTask"
		"ModifyLinkUpdate"
		"StartCN"
		"StartDVR"
    )
	ForEach ($Task in $Tasks) 
	{
		Enable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		print "    Enabled task: $Task."
	}
	print "Enabled additional AMD specific tasks."
}

# Intelligently setup Windows Update policies.
function SetupWindowsUpdate {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	# Perform checks.
	if ($Insider)
	{
		print "Windows Update policies are left unchanged in Windows pre-release software."
		return
	}
    if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"})) 
	{
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
	Set-ItemProperty -Path $Update2 -Name NoAutoRebootWithLoggedOnUsers -Type Dword -Value 1
    New-ItemProperty -Path $DeliveryOptimization -Name DownloadMode -Type DWord -Value 0 -Force

	if (check($au))
	{
		Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
		print "    - Disabled automatic updates"
	}

	if (check($dwu))
	{
		Set-ItemProperty -Path $Update1 -Name DeferQualityUpdates -Type DWord -Value 1
		Set-ItemProperty -Path $Update1 -Name DeferQualityUpdatesPeriodInDays -Type DWord -Value 4
		Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdates -Type DWord -Value 1
		Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 20
	
		# Print user message; policies applied.
		$WinUpdatePolicies =@(
			"Delayed quality updates by 4 days."
			"Delayed feature updates by 20 days."
		)
		ForEach ($WinUpdatePolicy in $WinUpdatePolicies) 
		{
			print "    - $WinUpdatePolicy"
		}
	}

	if (check($drivers))
	{
		Set-ItemProperty -Path $Update1 -Name ExcludeWUDriversInQualityUpdate -Type DWord -Value 1
		print "    - Disabled driver updates from Windows Update."
	}

	# Print user message; policies applied.
	$WinUpdatePolicies =@(
		"Disabled Delivery optimization."
		"Device will no longer auto restart if users are signed in."
		"Disabled re-installation of apps after Windows Updates."
	)
	ForEach ($WinUpdatePolicy in $WinUpdatePolicies) 
	{
		log "    - $WinUpdatePolicy"
	}

	print "Set up Windows Update policies."
}


# Reset all Windows Update policies
function ResetWindowsUpdate {
	if (!(check($systemwidepolicies)))
	{
		return
	}
    space
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse
    print "All Windows Update policies were reset."
}

# This function will disable "Device Installation" in sysdm.cpl > Hardware > Device 
# Installation Settings. Setting this policy will prevent automatic download of 
# custom apps, icons and device drivers from the manufacturer.
function DisableDeviceInstallation {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	print "Setting policy to prevent download of custom apps, device drivers and icons from your device manufacturer..."
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Value 1 -Force | Out-Null
	print "Windows will no longer download custom apps, device drivers and icons from your device manufacturer."
}

# This function will re-enable "Device Installation" in sysdm.cpl > Hardware > Device 
# Installation Settings. Setting this policy will allow automatic download of 
# custom apps, icons and device drivers from the manufacturer.
function EnableDeviceInstallation {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	print "Removing policies that prevents download of custom apps, device drivers and icons from your device manufacturer..."
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Value 0 -Force | Out-Null
	print "Windows can now download custom apps, device drivers and icons from your device manufacturer."
}

# A registry modification that fixes an issue where a small batch of devices turn back on after powering down.
function EnablePowerdownAfterShutdown {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling full powerdown on shut down..."
	print "This is known to fix issues where some PCs might boot up without user input after shutdown."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 1
	print "Enabled full power down on shut down."
}

# Revert the EnablePowerdownAfterShutdown edit.
function DisablePowerdownAfterShutdown {
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling full powerdown on shut down..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 0
	print "Disabled full powerdown on shut down."
}

function DisableWindowsTipsNotifications {
	space
	print "Disabling Windows tips and suggestions notifications...."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
	print "Disabled Windows tips and suggestions notifications."
}

function EnableWindowsTipsNotifications {
	space
	print "Enabling Windows tips and suggestions notifications...."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 1
	print "Enabled Windows tips and suggestions notifications."
}

function DisableWindowsWelcomeExperience {
	space
	print "Disabling Windows welcome experience..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Type DWord -Value 0 
	print "Disabled Windows welcome experience."
}

function EnableWindowsWelcomeExperience {
	space
	print "Enabling Windows welcome experience..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Type DWord -Value 1
	print "Enabled Windows welcome experience."
}



####################################
######### WINDOWS EXPLORER #########
####################################

# Update status: Explorer Changes.
function WindowsExplorer {	
	space
	print "----------------------------------"
	print "          WINDOWS EXPLORER        "
	print "----------------------------------"
}

# Use Print screen button to open screen skipping.
function EnablePrtScrToSnip {
	space
	print "Binding Print Screen key to launch Snip overlay..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 1
	print "Print screen key will now invoke Snip overlay."
}
	
# Don't use Print screen button to open screen skipping.
function DisablePrtScrSnip {
	space
	print "Unbinding Snip overlay launch from Print screen key...."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 0
	print "Print screen key will no longer invoke Snip overlay."
}

# Show extensions.
function EnableExtensions {
	space
	print "Showing extensions in file names..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
	print "Enabled showing of extensions next to files."
}

# Hide extensions.
function DisableExtensions {
	space
	print "Disabling extensions from file names..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 1
	print "Disabled showing extensions next to files."
}

# Hide Recent files in Quick Access.
function DisableRecentFilesInQuickAccess {
	space
	print "Disabling recent files from Quick Access..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowRecent -Type DWord -Value 0
	print "Disabled recent files in Quick Access."
}

# Show Recent files in Quick Access.
function ShowRecentFilesInQuickAccess {
	space 
	print "Enabling showing Recent files in Quick Access..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowRecent -Type DWord -Value 1
	print "Enabled showing recent files in Quick Access."
}

# Disable Sticky keys.
function DisableStickyKeys {
	space
	print "Disabling Sticky keys..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
	print "Disabled Sticky keys."
}

# Enable Sticky keys.
function EnableStickyKeys {
	space
	print "Enabling Sticky keys..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
	print "Enabled Sticky keys."
}

# Change default File Explorer view to This PC.
function SetExplorerThisPC {
	space
	print "Setting default File Explorer view to This PC..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo"
	New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1 -Force | Out-Null
	print "Set default File Explorer view to This PC."
}

# Change default File Explorer view to Quick Access.
function SetExplorerQuickAccess {
	space
	print "Setting default File Explorer view to Quick Access..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -ErrorAction SilentlyContinue
	print "Set default File Explorer view to Quick Access."
}

# Update threshold of taskbar thumbnails.
# 
# If you have opened an app and hover over it's icon in the taskbar, a 
# flyout opens up. The flyout usually displays a preview of currently 
# open window(s) inside that app. 
#
# Similarly, if you have a lot of windows open inside a particular app, 
# you might notice that hovering over the app on the taskbar displays a 
# list of currently opened windows and does not render their preview.
# 
# This behavior is determined by a threshold. The threshold is the number
# of concurrently open app windows inside an app. Once the threshold is
# exceeded, the flyout only displays a list of names of currently open 
# windows instead of displaying their previews.
#
# However, in rare scenarios, users may notice that if they hover over the
# app in the taskbar, the hover flyout shows a list without window previews
# even if only one window is open. 

# This function aims to repair this incorrect behavior by modifying the threshold 
# according to some of the most commonly used screen resolutions worldwide.

function FixAppHoverPreviewThreshold {
	# Check if the threshold is absurdly set to 1.
	$thumbnails = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name NumThumbnails
	if ($thumbnails -ne 1)
	{
		return
	}
	space
	print "Attempting to fix incorrect behavior where hovering on an opened app in taskbar does not show the window preview(s)..."
	# Save screen width to "monitorwidth" variable.
	Add-Type -AssemblyName System.Windows.Forms
	$monitorwidth = ([System.Windows.Forms.SystemInformation]::PrimaryMonitorSize).Width
	# The following code will set threshold according to resolutions.
	# Data is set in descending order of the most commonly used resolutions.
	# Data derived on 6th May, 2022 from 
	# https://gs.statcounter.com/screen-resolution-stats/desktop/worldwide 
	
	# If screen width is equal to 1920px (HD), set threshold to 16.
	if ($monitorwidth -eq 1920)
	{
		$threshold = 16
	}
	# Else if screen width is equal to 1536px, set threshold to 14.
	elseif ($monitorwidth -eq 1536)
	{
		$threshold = 14
	}
	# Else if screen width is equal to 1440px, set threshold to 12.
	elseif ($monitorwidth -eq 1440)
	{
		$threshold = 12
	}
	# Else if screen width is equal to 1366px or 1280px, set threshold to 11.
	elseif ($monitorwidth -eq 1366 -or $monitorwidth -eq 1280)
	{
		$threshold = 11
	}
	# Else, set threshold to 10.
	else
	{
		$threshold = 10
	}
	New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name NumThumbnails -Type DWord -Value $threshold -Force | Out-Null
	print "Fixed the behavior, hovering on an opened app in taskbar should show its' window preview(s)."
}

function RevertAppHoverPreviewThreshold {
	space
	print "Reverting fix for app hover in taskbar..."
	Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name NumThumbnails -Force
	print "The fix was reverted. Please restart your device for the changes to take effect."
}

# Hide 3D Objects.
# This function only runs in Windows 10.
function Disable3DObjects {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Disabling 3D Objects..."
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
	$Disable3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	$Disable3DObjects2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	if (!(Test-Path $Disable3DObjects1)) 
	{
		New-Item -Path $Disable3DObjects1 -Force | Out-Null
	}
	Set-ItemProperty -Path $Disable3DObjects1 -Name "ThisPCPolicy" -Type String -Value "Hide"
	if (!(Test-Path $Disable3DObjects2)) 
	{
		New-Item -Path $Disable3DObjects2 -Force | Out-Null
	}
	Set-ItemProperty -Path $Disable3DObjects2 -Name "ThisPCPolicy" -Type String -Value "Hide"
	print "Disabled 3D Objects."
}

# Restore 3D Objects.
# This function only runs in Windows 10.
function Enable3DObjects {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	if (!(check($systemwidepolicies)))
	{
		return
	}
	space
	print "Enabling 3D Objects..."
	$Enable3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	$Enable3DObjects2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	$Enable3DObjects3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	if (!(Test-Path $Enable3DObjects1)) 
	{
		New-Item -Path $Enable3DObjects1 | Out-Null
	}
	Remove-ItemProperty -Path $Enable3DObjects2 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $Enable3DObjects3 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	print "Enabled 3D Objects."
}

# Hide Search bar from taskbar.
function DisableSearch {
	space
	print "Disabling Search icon..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
	print "Disabled Search icon."
}

# Restore Search bar to taskbar.
function EnableSearch {
	space
	print "Enabling Search icon..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 2
	print "Enabled Search icon."
}

# Hide Task View.
function DisableSearchView {
	space
	print "Disabling Task view icon..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
	print "Disabled Task view icon."
}

# Restore Task View button.
function EnableTaskView {
	space
	print "Enabling Task view icon..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
	print "Enabled Task view icon."
}

# Hide Cortana icon from taskbar.
# This function only runs in Windows 10.
function DisableCortana {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Disabled Cortana icon..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
	print "Disabled Cortana icon."
}

# Restore Cortana button in taskbar.
# This function only runs in Windows 10.
function EnableCortana {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	print "Enabling Cortana icon..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1
	print "Enabled Cortana icon."
}

# Hide Meet Now icon from tray.
# This function only runs in Windows 10.
function DisableMeetNow {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Disabling Meet Now..."
	New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAMeetNow" -Type DWord -Value 1 -Force | Out-Null
	print "Disabled Meet Now."
}

# Restore Meet Now icon on tray.
# This function only runs in Windows 10.
function EnableMeetNow {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Enabling Meet Now..."
	Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
	print "Enabled Meet Now."
}

# Turn off News and interests feed.
# This function only runs in Windows 10.
function DisableNI {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Disabling News and interests..."
	$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
	$Feed2 = "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Feeds"
	Remove-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode
	Remove-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode
	New-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 2 -Force | Out-Null
	New-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 2 -Force | Out-Null
	print "Disabled News and interests."
}

# Turn on News and interests feed.
# This function only runs in Windows 10.
function EnableNI {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	print "Enabling News and interests..."
	$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
	$Feed2 = "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Feeds"
	Set-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 0 | Out-Null
	Set-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 0 | Out-Null
	print "Enabled News and interests."
}

# Disable Widgets icon.
# This function only runs in Windows 11.
function DisableWidgets {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Disabling Widgets icon..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Type DWord -Value 0
	print "Disabled Widgets icon."
}

# Enable Widgets icon.
# This function only runs in Windows 11.
function EnableWidgets {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Enabling Widgets icon..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Type DWord -Value 1
	print "Enabled Widgets icon."
}

# Disable chat icon.
# This function only runs in Windows 11.
function DisableChat {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Disabling Chat icon..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Type DWord -Value 0
	print "Disabled Chat icon."
}

# Enable Chat icon.
# This function only runs in Windows 11.
function EnableChat {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Enabling Chat icon..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Type DWord -Value 1
	print "Enabled Chat icon."
}

####################################
#### Tasks after successful run ####
####################################

function Success {
	# Clear all variables from the PowerShell session.
	Remove-Variable * -ErrorAction SilentlyContinue -Force

	# If device is running Windows 10, restart Windows Explorer for all
	# Windows Explorer changes to take effect immediately.
	if ($CurrentBuild -lt 22000)
	{
		Stop-Process -Name explorer -Force
	}

	# Sleep for 3 seconds and then stop logging.
	Start-Sleep 3
	Stop-Transcript

	# Produce ending message.
	Write-Host "WinRice has finished working."
	Write-Host "Thank you for using WinRice."
	
	# Ask if user wants to restart the device to apply all changes.
	Add-Type -AssemblyName PresentationCore, PresentationFramework
	switch (
	[System.Windows.MessageBox]::Show(
		"WinRice needs to restart this device to finish applying changes. Restart now?",
		'Restart required',
		'YesNo',
		'Warning'
	)
	) 
	{
		'Yes' 
		{
			Restart-Computer
		}
		'No' 
		{
			Write-Host "Skipped device restart. A device restart is pending."
		}
	}
}

# Call the desired functions.
$tasks | ForEach-Object { Invoke-Expression $_ }