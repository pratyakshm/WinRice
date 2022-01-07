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
	"EnableWSL", "Activity", 
	# "DisableWSL",
	"EnabledotNET3.5", "Activity", 
	# "DisabledotNET3.5",
	"EnableSandbox",
	# "DisableSandbox",
	"UninstallApps", "Activity", 
	"WebApps",
	"UnpinStartTiles", "Activity", 
	"UnpinAppsFromTaskbar", 
	"UninstallOneDrive", "Activity",
	# "InstallOneDrive",
	"UninstallFeatures", "Activity", 
	# "InstallFeatures", "Activity", 
	"ChangesDone",

### Privacy & Security ###
	"PrivacySecurity",
	"DisableActivityHistory",	
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
	"DisableVBS",
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

### Tasks & Services ###
	"TasksServices",
	# "DisableStorageSense",		   
	"EnableStorageSense",
	"DisableReserves",	   
	# "EnableReserves",
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
	"DisableServices",			   
	# "EnableServices",
	"DisableTasks",				   
	# "DisableTasks",
	"SetupWindowsUpdate",		   
	# "ResetWindowsUpdate",
	# "EnablePowerdownAfterShutdown",
	# "DisablePowerdownAfterShutdown",
	"ChangesDone",

### Windows Explorer ###
	"PrintExplorerChanges",
	"EnablePrtScrToSnip",		   
	# "DisablePrtScrSnip",
	# "ShowExtensions",
	# "HideExtensions",
	"HideRecentFilesInQuickAccess",
	# "ShowRecentFilesInQuickAccess",
	"DisableStickyKeys",           
	# "EnableStickyKeys",
	"SetExplorerThisPC",           
	# "SetExplorerQuickAccess",
    "Hide3DObjects",      		   
	# "Restore3DObjects",
	"HideSearch",			   
	# "RestoreSearch"
	"HideTaskView",                
	# "RestoreTaskView",
	"HideCortana",			       
	# "RestoreCortana",
	"HideMeetNow",				   
	# "RestoreMeetNow",
	"HideNI",		   
	# "RestoreNI",  (News and Interests)
	"HideWidgets",
	# "RestoreWidgets",
	"HideChat",
	# "RestoreChat",
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

Function wrexit {
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
$hkeyuser = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID

### DISPLAY INFO ###

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
Write-Host "Beginning checks..."

# Check if supported OS build.
$oscheck = {
	$CurrentBuild = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentBuild
	if ($CurrentBuild -lt 19044) {
		return $false
	}
	elseif ($CurrentBuild -ge 19044) {
		return $true
	}
}
RunWithProgress -Text "[1/5] Windows version is supported" -Task $oscheck -Exit $true | Out-Null


# Check if session is elevated.
$isadmin = {
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	$admin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
	return $admin
}

RunWithProgress -Text "[2/5] Session is elevated" -Task $isadmin -Exit $true | Out-Null

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

RunWithProgress -Text "[3/5] Device is connnected to the Internet" -Task $isonline -Exit $true | Out-Null

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

# Check PowerShell version and import required modules.
$pwshver = {
	if ((($PSVersionTable).PSVersion).Major -eq "5") { 
		return $true 
	}
	Import-Module -Name Appx -UseWindowsPowerShell -WarningAction "SilentlyContinue" | Out-Null
	return $true
}

RunWithProgress -Text "[4/5] Setting up PowerShell" -Task $pwshver -Exit $true | Out-Null

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
# Clear variables.
$WMI_Reg        = $null
$SCCM_Namespace = $null

RunWithProgress -Text "[5/5] Session is fresh" -Task $isrestartpending -Exit $true | Out-Null


Start-Sleep -Milliseconds 200
Write-Host "Completed checks." -ForegroundColor green 
Start-Sleep -Milliseconds 800
space

# Declare Express Settings.
$uninstallapps = "y"
if ((Test-Path uninstallapps.txt) -or (Test-Path UninstallApps.txt) -or (Test-Path Uninstallapps.txt))
{
	$uninstallmethod = "list"
}
$uninstallfeatures = "y"
$systemrestore = "y"

# TODO: User message contain link to main brief document.

# Print Express Settings.
print "Express Settings:"
$settings = @(	
	"A set of unessential apps WILL be uninstalled."	
	"A set of unessential features WILL be uninstalled."
	"Apps will NOT be installed."
	"NO optional features are installed."
)
ForEach ($setting in $settings) 
{
	print "  $setting"
}
if ( (-not($BuildBranch -like "rs_prerelease")) -and (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) ) 
{
	$dwu = "y"
	$au = "y"
	print "  Windows automatic updates will be disabled."
	print "  Windows quality updates will be delayed by 4 days and feature updates will be delayed by 20 days."
}
elseif ($BuildBranch -like "rs_prerelease")
{
	print "  Windows Update policies are left unchanged in Windows pre-release software."
}
space
print "To learn more, visit https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md"
print "Standard privacy, security, tasks, services and UI changes as listed in WinRice documentation will apply. These changes are not configurable."
space
$customize = ask "Do you want to proceed with Express Settings? [Y/n]"
if (!(check($customize)))
{
	space
	space
	print "Please take your time to answer the questions below in order to save user config."
	print "Press Enter to proceed after answering a question."
	space

	# App Deployment
	print "APP DEPLOYMENT"
	$installapps = ask "Do you want to install apps using WinGet? [y/N]"
	Start-Sleep -Milliseconds 100
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
	
	$uninstallapps = ask "Do you want to uninstall unessential apps? [Y/n]"
	Start-Sleep -Milliseconds 100
	if (!($uninstallapps))
	{
		$uninstallapps = "y"
		print "No input detected, unessential apps WILL be uninstalled."
	}
	elseif (check($uninstallapps))
	{
		print "  Unessential apps WILL be uninstalled."
		if ((Test-Path uninstallapps.txt) -or (Test-Path UninstallApps.txt) -or (Test-Path Uninstallapps.txt))
		{
			$uninstallmethod = "list"
		}
		elseif (!(Test-Path uninstallapps.txt) -or (!(Test-Path UninstallApps.txt)) -or (!(Test-Path Uninstallapps.txt)))
		{
			$uninstallmethod = ask "Do you want to select which apps to uninstall? [y/N]"
			Start-Sleep -Milliseconds 100
			if (check($uninstallmethod))
			{
				print "  You will select which apps you want to uninstall."
			}
			elseif (!(check($uninstallmethod)))
			{
				print " A predefined list of apps will be uninstalled."
			}
		}
		$uninstallod = ask "Do you want to uninstall Microsoft OneDrive? [y/N]"
		Start-Sleep -Milliseconds 100
		if (check($uninstallod))
		{
			print "  Microsoft OneDrive WILL be uninstalled."
		}
		elseif (!(check($uninstallod)))
		{
			print "  Microsoft OneDrive will NOT be uninstalled."
		}
	}
	elseif (!(check($uninstallapps)))
	{
		print "  No changes will be made to unessential apps."
	}

	space

	# Feature Deployment
	print "FEATURE DEPLOYMENT"

	$netfx3 = ask "Do you want to install .NET 3.5? (used for running legacy programs) [y/N]"
	Start-Sleep -Milliseconds 100
	if (check($netfx3))
	{
		print "  .NET 3.5 WILL be installed."
	}
	elseif (!(check($netfx3)))
	{
		print "  NO changes will be made to .NET 3.5."
	}

	$wsl = ask "Do you want to install Windows Subsystem for Linux? [y/N]"
	Start-Sleep -Milliseconds 100
	if (check($wsl))
	{
		print "  Windows Subsystem for Linux WILL be installed."
	}
	elseif (!(check($wsl)))
	{
		print "  NO changes will be made to Windows Subsystem for Linux."
	}

	$sandbox = ask "Do you want to install Windows Sandbox? [y/N]"
	Start-Sleep -Milliseconds 100
	if (check($sandbox))
	{
		print " Windows Sandbox WILL be installed."
	}
	elseif (!(check($sandbox)))
	{
		print "  NO changes will be made to Windows Sandbox."
	}

	$uninstallfeatures = ask "Do you want to uninstall unessential optional features? [Y/n]"
	Start-Sleep -Milliseconds 100
	if (!($uninstallfeatures))
	{
		$uninstallfeatures = "y"
		print "  NO input detected, unessential features WILL be uninstalled."
	}
	if (check($uninstallfeatures))
	{
		print "  Unessential features WILL be uninstalled."
	}
	elseif (!(check($uninstallfeatures)))
	{
		print "  NO changes will be made to unessential features."
	}

	if ($CurrentBuild -ge 22000) {
		$widgets = ask "Do you want to uninstall Widgets [y/N]"
	}
	Start-Sleep -Milliseconds 100
	if (check($widgets))
	{
		print "  Widgets WILL be uninstalled."
	}
	elseif (!(check($widgets)))
	{
		print "  NO changes will be made to Widgets."
	}
	
	if ( (-not($BuildBranch -like "rs_prerelease")) -and (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) )
	{	
		space
		print "WINDOWS UPDATE"

		$dwu = ask "Do you want to delay Windows updates by a few days? [Y/n]"
		Start-Sleep -Milliseconds 100
		if (check($dwu))
		{
			print "  Windows updates will be delayed."
		}
		elseif (!(check($dwu)))
		{
			print "  NO changes will be made to Windows update delivery time."
		}

		$au = ask "Do you want to turn off automatic updates? [Y/n]"
		Start-Sleep -Milliseconds 100
		if (check($au))
		{
			print "  Windows automatic updates will be disabled."
		}
		elseif (!(check($au)))
		{
			print "  NO changes will be made to automatic Windows updates."
		}
	}
	space

	$systemrestore = ask "Do you want to create a system restore point? [Y/n]"
	Start-Sleep -Milliseconds 100
	if (check($systemrestore))
	{
		print "  A system restore point will be created."
	}
	elseif (!(check($systemrestore)))
	{
		print " NO system restore point will be created."
	}

	space 
	space

	# REPRINT CONFIG TO USER
	print "To sum it up,"
	if (check($installapps))
	{
		Write-Host "Apps will be installed using " -NoNewline -ForegroundColor DarkCyan
		if ($installusing -like "2")
		{
			Write-Host "Winstall." -ForegroundColor DarkCyan
		}
		elseif ($installusing -like "1")
		{
			Write-Host "winget import method." -ForegroundColor Cyan
		}
	}
	elseif (!(check($installapps)))
	{
		Write-Host "NO apps will be installed." -ForegroundColor DarkGray
	}
	
	elseif (!(check($uninstallapps)))
	{
		Write-Host "NO changes will be made to unessential features." -ForegroundColor DarkGray
	}
	elseif (check($uninstallapps))
	{
	
		Write-Host "Unessential apps will be uninstalled" -NoNewline -ForegroundColor DarkCyan
		if ($uninstallmethod -like "list")
		{
			Write-Host " using List." -ForegroundColor DarkCyan
		}
		elseif (check($uninstallmethod))
		{
			Write-Host " and you will SELECT which apps to uninstall down the line." -ForegroundColor Cyan
		}
		elseif (!(check($uninstallmethod)) -and (check($uninstallapps)))
		{
			Write-Host " from the predefined list." -ForegroundColor DarkCyan
		}
	}
	
	if (check($netfx3))
	{
		Write-Host ".NET 3.5 will be installed." -ForegroundColor DarkCyan
	}
	elseif (!(check($netfx3)))
	{
		Write-Host "NO changes will be made to .NET 3.5." -ForegroundColor DarkGray
	}
	
	if (check($wsl))
	{
		Write-Host "Windows Subsystem for Linux will be installed." -ForegroundColor DarkCyan
	}
	elseif (!(check($wsl)))
	{
		Write-Host "NO changes will be made to Windows Subsystem for Linux." -ForegroundColor DarkGray
	}
	
	if (check($sandbox))
	{
		Write-Host "Windows Sandbox will be installed." -ForegroundColor DarkCyan
	}
	elseif (!(check($sandbox)))
	{
		Write-Host "NO changes will be made to Windows Sandbox." -ForegroundColor DarkGray
	}
	
	if (!(check($uninstallfeatures)))
	{
		Write-Host "NO changes will be made to unessential features." -ForegroundColor DarkGray
	}
	elseif (check($uninstallfeatures))
	{
		Write-Host "Unessential features will be uninstalled." -ForegroundColor DarkCyan
	}
	
	if (!(check($widgets)))
	{
		Write-Host "NO changes will be made to Widgets." -ForegroundColor DarkGray
	}
	elseif (check($widgets))
	{
		Write-Host "Widgets will be uninstalled." -ForegroundColor DarkCyan
	}
	
	if (check($au))
	{
		Write-Host "Windows automatic updates will be disabled." -ForegroundColor DarkCyan
	}
	elseif (!(check($au)))
	{
		Write-Host "No changes will be made to automatic Windows updates." -ForegroundColor DarkGray
	}
	
	if (check($dwu))
	{
		Write-Host "Windows quality updates will be delayed by 4 days and feature updates will be delayed by 20 days." -ForegroundColor DarkCyan
	}
	elseif (!(check($dwu)))
	{
		Write-Host "No changes will be made to Windows updates' delivery time." -ForegroundColor DarkGray
	}
	
	if (!($systemrestore))
	{
		$systemrestore = "y"
		Write-Host "A System restore point WILL be created." -ForegroundColor DarkCyan
	}
	if (!(check($systemrestore)))
	{
		Write-Host "NO system restore point will be created." -ForegroundColor DarkGray
	}

	Start-Sleep -Milliseconds 1700
	space
	
	Write-Host "If this configuration is correct, " -NoNewline
	Write-Host "press any key to go ahead." -ForegroundColor Yellow
	Write-Host "If this configuration is not correct, restart WinRice and create a new one."
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}


print "Starting WinRice..."
Start-Sleep -Milliseconds 200

# Intro.
Function WinRice {
	Clear-Host
	space
	print "pratyakshm's WinRice - main branch"
	Start-Sleep -Milliseconds 100
	space
	print "Copyright (c) Pratyaksh Mehrotra and contributors"
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

# Install VCLibs packages .
Function InstallVCLibs {
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
	Start-Sleep -Milliseconds 200
}

Function UninstallVCLibs {
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
	Start-Sleep -Milliseconds 200
}

# Install WinGet (Windows Package Manager)
Function InstallWinGet {
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
	Start-Sleep -Milliseconds 200
}
	
# Install NanaZip.
Function InstallNanaZip {
	space
	if (!(Get-Command winget)) 
	{
		print "WinGet is not installed. Couldn't install NanaZip."
		return 
	}
	print "Installing NanaZip... (https://github.com/M2Team/NanaZip)"
	winget install NanaZip -s msstore --accept-source-agreements --accept-package-agreements | Out-Null
	print "Installed NanaZip."
}

# Uninstall NanaZip.
Function UninstallNanaZip {
	space
	print "Uninstalling NanaZip..."
	winget uninstall 40174MouriNaruto.NanaZip_gnj4mf6z9tkrc --accept-package-agreements | Out-Null
	print "Uninstalled NanaZip."
	Start-Sleep -Milliseconds 200
}

# Use winget import (part of code used here was picked from https://devblogs.microsoft.com/scripting/hey-scripting-guy-can-i-open-a-file-dialog-box-with-windows-powershell/)
Function WinGetImport {
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
		Start-Sleep -Milliseconds 200
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
Function Winstall {
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
				print "    Installing $App..."
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

# Uninstall apps from Winstall file (the Winstall.txt file must be on the same directory as WinRice). [reverting Winstall changes]
# Using this is not recommended
Function Winuninstall {
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

# Install HEVC.
Function InstallHEVC {
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
Function UninstallHEVC {
$ProgressPreference = 'SilentlyContinue'
	space
	if (!(Get-AppxPackage "Microsoft.HEVCVideoExtension")) 
	{
		print "HEVC Video Extensions may have already been uninstalled."
		return
	}
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
	Start-Sleep -Milliseconds 200
}

# Uninstaller GUI.
Function UninstallerGUI {
	space
    Add-Type -AssemblyName PresentationCore, PresentationFramework

    #region Variables.
    # ArrayList containing the UWP apps to remove.
    $AppxPackages = New-Object -TypeName System.Collections.ArrayList($null)

	print "App Uninstaller GUI"
	print "If app selection menu is not visible, use Alt + Tab to switch to that window."

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
            print "Uninstalling selected apps..."
            Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cmatch $AppxPackages} | Remove-AppxPackage -AllUsers
            print "Uninstalled."
        }
        else {  
            print "Uninstalling selected apps..."
            Get-AppxPackage -PackageTypeFilter Bundle | Where-Object -FilterScript {$_.Name -cmatch $AppxPackages} | Remove-AppxPackage
            print "Uninstalled."
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
		"MicrosoftTeams"
		"Microsoft.549981C3F5F10"
		"Microsoft.BingNews"
		"Microsoft.BingWeather"
		"Microsoft.GamingApp"
		"Microsoft.GetHelp" 
		"Microsoft.Getstarted" # Tips app 
		"Microsoft.MSPaint" # Paint 3D app
		# "Microsoft.Paint"  # Paint app (MSIX)
		"Microsoft.MicrosoftOfficeHub" # Office webview
		"Microsoft.Office.OneNote" # OneNote for Windows 10
		"Microsoft.MixedReality.Portal"
		"Microsoft.MicrosoftSolitaireCollection" 
		"Microsoft.News" 
		"Microsoft.PowerAutomateDesktop"
		"Microsoft.Whiteboard"
		"Microsoft.WindowsCommunicationsApps" 
		"Microsoft.WindowsFeedbackHub" 
		"Microsoft.WindowsMaps" 
		"Microsoft.WindowsSoundRecorder"
		"Microsoft.XboxApp"
	)
	ForEach ($InboxApp in $InboxApps) 
	{
		if (Get-AppxPackage $InboxApp) 
		{
			print "     Uninstalling $InboxApp..."
			Get-AppxPackage -Name $InboxApp | Remove-AppxPackage 
			Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $InboxApp | Remove-AppxProvisionedPackage -Online | Out-Null
		}
	}

	if (!(Get-CimInstance -ClassName Win32_PnPEntity | Where-Object -FilterScript {($_.PNPClass -eq "Camera") -or ($_.PNPClass -eq "Image")})) 
	{
		print "     Uninstalling Microsoft.WindowsCamera..."
		if (Get-AppxPackage "Microsoft.WindowsCamera")
		{
			Get-AppxPackage "Microsoft.WindowsCamera" | Remove-AppxPackage
			Get-AppxProvisionedPackage -Online "Microsoft.WindowsCamera" | Remove-AppxProvisionedPackage 
		}
	}

	if (check($widgets))
	{
		Get-AppxPackage "MicrosoftWindows.Client.WebExperience" | Remove-AppxPackage
		Get-AppxProvisionedPackage -Online "MicrosoftWindows.Client.WebExperience" | Remove-AppxProvisionedPackage
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
	ForEach ($SponsoredApp in $SponsoredApps) 
	{
		if (Get-AppxPackage $SponsoredApp) 
		{
			print "     Uninstalling $SponsoredApp.."
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
				print "     Uninstalling $App"
				Get-AppxPackage "$App" | Remove-AppxPackage
			}
			elseif (!(Get-AppxPackage $App))
			{
				print "     Couldn't find: $App"
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
				print "     Uninstalling $App"
				Get-AppxPackage "$App" | Remove-AppxPackage
			}
			elseif (!(Get-AppxPackage $App))
			{
				print "     Couldn't find: $App"
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
				print "     Uninstalling $App"
				Get-AppxPackage "$App" | Remove-AppxPackage
			}
			elseif (!(Get-AppxPackage $App))
			{
				print "     Couldn't find: $App"
			}
		}
		print "Uninstalled listed apps."
    }
}

# Main Uninstall function.
Function UninstallApps {
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
}

# Remove Office webapps.
function WebApps {
	if (!(Test-Path "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk")) 
	{
		return
	}
	print "Removing Office web-apps..."
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Outlook.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Word.lnk"
	print "Removed Office web-apps."
}

# Unpin all start menu tiles.
Function UnpinStartTiles {
	if ($CurrentBuild -ge 22000) 
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
	Start-Sleep -Milliseconds 200
}

# Unpin apps from taskbar (https://docs.microsoft.com/en-us/answers/questions/214599/unpin-icons-from-taskbar-in-windows-10-20h2.html).
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
	ForEach ($AppName in $AppNames) 
	{
		if ( $App = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object { $_.Name -eq $AppName })) {
			$App.Verbs() | Where-Object { $_.Name.replace('&', '') -match 'Unpin from taskbar' } | ForEach-Object {$_.DoIt()} -ErrorAction SilentlyContinue | Out-Null
		}	
	}
	print "Unpinned apps from taskbar."
	Start-Sleep -Milliseconds 200
}

# Uninstall Microsoft OneDrive.
Function UninstallOneDrive {
$ErrorActionPreference = 'SilentlyContinue'
	if (!(check($uninstallod))) 
	{ 
		return 
	}
	space
	if (!(Get-Command winget)) 
	{
		print "WinGet is not installed. Microsoft OneDrive could not be uninstalled."
		return
	}
	print "Uninstalling Microsoft OneDrive..."

	# Uninstall using WinGet.
	winget uninstall Microsoft.OneDrive --accept-source-agreements --accept-package-agreements --silent | Out-Null

	# Cleanup leftover folders.
	Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force
	Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -Force
	Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force
	Remove-Item "$env:LOCALAPPDATA\OneDrive" -Recurse -Force

	print "Uninstalled Microsoft OneDrive."
	Start-Sleep -Milliseconds 200
}


# Install Microsoft OneDrive 
Function InstallOneDrive {
	if (!(Get-Command winget)) 
	{
		print "WinGet is not installed. Could not install Microsoft OneDrive."
		return
	}
	print "Installing Microsoft OneDrive..."
	winget install Microsoft.OneDrive --source winget --accept-package-agreements --accept-source-agreements --silent | Out-Null
	$check = winget list Microsoft.OneDrive
	if ($check -like "No installed package found matching input criteria.") 
	{
		print "Could not install Microsoft OneDrive."
		return
	}
	print "Installed Microsoft OneDrive."
	Start-Sleep -Milliseconds 200
}


# Uninstall Windows Optional Features and Windows Capabilities.
Function UninstallFeatures {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
	if (!(check($uninstallfeatures))) 
	{ 
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

	ForEach ($Capability in $Capabilities) 
	{
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
	ForEach ($OptionalFeature in $OptionalFeatures)
	{
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
	ForEach ($Feature in $Features) 
	{
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
	ForEach ($Capability in $Capabilities) 
	{
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
	ForEach ($CapList in $CapLists) 
	{
		Start-Sleep -Milliseconds 70
		print "    - Installed $CapList"
	}

	$OptionalFeatures = @(
		"WorkFolders-Client*"
		"Printing-XPSServices-Feature*"
	)
	ForEach ($OptionalFeature in $OptionalFeatures) 
	{
		Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like $OptionalFeature} | Enable-WindowsOptionalFeature -Online -NoRestart | Out-Null
	}
	# Print user friendly list of features uninstalled.
	print "    - Enabled Work Folders Client."
	
	print "Added capabilities and features."
}

# Enable Windows Subsystem for Linux.
Function EnableWSL {
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
	Start-Sleep -Milliseconds 200
}

# Disable Windows Subsystem for Linux.
Function DisableWSL {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
	space

	# Inform user if WSL is already disabled.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State -like "Disabled") 
	{
		print "Windows Subsystem for Linux is already disabled."
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
	Start-Sleep -Milliseconds 200
}

# Enable Sandbox.
Function EnableSandbox {
$ProgressPreference = 'SilentlyContinue'
	if (!(check($sandbox)))
	{
		return
	}
	space
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM").State -like "Enabled")
	 {
		print "Windows Sandbox is already enabled."
		return
	}

	# Warn if unsupported Edition (not version).
	if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"})) 
	{
		print "Could not enable Windows Sandbox since $ProductName does not support it."
		return
	}

	# Enable Sandbox.
	print "Enabling Windows Sandbox..."
	Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart -WarningAction Ignore | Out-Null

	# Print status.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM").State -like "Disabled") 
	{
		print "Could not enable Windows Sandbox."
		return
	}
	print "Enabled Windows Sandbox."
	Start-Sleep -Milliseconds 200
}

# Disable Sandbox
Function DisableSandbox {
$ProgressPreference = 'SilentlyContinue'
	space

	# Check if already disabled.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM").State -like "Disabled") 
	{
		print "Windows Sandbox is already disabled."
		return
	}

	# Warn if unsupported Edition (not version)
	if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}))
	{
		print "Windows Sandbox can't be toggled in $ProductName."
		return
	}

	# Enable Sandbox
	print "Disabling Windows Sandbox..."
	Disable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart -WarningAction Ignore | Out-Null
	
	# Print status.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM").State -like "Enabled") 
	{
		print "Could not disable Windows Sandbox."
		return
	}
	print "Disabled Windows Sandbox."
	Start-Sleep -Milliseconds 200
}

# Enable dotNET 3.5.
Function EnabledotNET3.5 {
$ProgressPreference = 'SilentlyContinue'
	if (!(check($netfx3))) 
	{ 
		return 
	}
	space

	# Check if already enabled.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State -like "Enabled")
	{
		print ".NET 3.5 is already enabled."
		return
	}

	# Enable dotNET 3.5.
	print "Enabling .NET 3.5..."
	Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -NoRestart | Out-Null

	# Print status.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State -like "Disabled")
	{
		print "Could not enable .NET 3.5."
		return
	}
	print "Enabled .NET 3.5."
	Start-Sleep -Milliseconds 200
}

# Disable dotNET 3.5
Function DisabledotNET3.5 {
$ProgressPreference = 'SilentlyContinue'
	space

	# Check if already disabled.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State -like "Disabled")
	{
		print ".NET 3.5 is already disabled."
		return
	}

	# Disable dotNET 3.5.
	print "Disabling .NET 3.5..."
	Disable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -NoRestart | Out-Null

	# Print status.
	if ((Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State -like "Enabled")
	{
		print ".NET 3.5 is already disabled."
		return
	}
	print "Disabled .NET 3.5."
	Start-Sleep -Milliseconds 200
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
	print "Disabling Activity History..."
	$ActivityFeed = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityFeed -Name "EnableActivityFeed" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "PublishUserActivities" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "UploadUserActivities" -Type DWord -Value 0	
	print "Disabled Activity History."
	Start-Sleep -Milliseconds 200
}

# Enable Activity History.
Function EnableActivityHistory {
	print "Enabling Activity History..."
	$ActivityHistory = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityHistory -Name "EnableActivityFeed" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "PublishUserActivities" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "UploadUserActivities" -Type DWord -Value 1
	print "Enabled Activity History."
	Start-Sleep -Milliseconds 200
}

# Disable Advertising ID.
Function DisableAdvertisingID {
	space
	print "Disabling Advertising ID..."
	$AdvertisingID = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	if (!(Test-Path $AdvertisingID)) 
	{
		New-Item -Path $AdvertisingID | Out-Null
	}
	Set-ItemProperty -Path $AdvertisingID -Name "DisabledByGroupPolicy" -Type DWord -Value 1
	print "Disabled Advertising ID."
	Start-Sleep -Milliseconds 200
}

# Enable Advertising ID.
Function EnableAdvertisingID {
	print "Enabling Advertising ID..."
	$Advertising = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	Remove-ItemProperty -Path $Advertising -Name "DisabledByGroupPolicy" -ErrorAction SilentlyContinue
	print "Enabled Advertising ID."
	Start-Sleep -Milliseconds 200
}

# Disable Background apps (https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%205.1/Sophia.psm1#L8988-L9033).
Function DisableBackgroundApps {
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
	Start-Sleep -Milliseconds 200
}

# Enable Background apps.
Function EnableBackgroundApps {
	print "Enabling Background apps..."
	Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process 
	{
		Remove-ItemProperty -Path $_.PsPath -Name * -Force
	}
	print "Enabled Background apps."
	Start-Sleep -Milliseconds 200
}

# Disable Windows Error Reporting 
function DisableErrorReporting {
	space
	if (!($BuildBranch -like "co_release" -or $BuildBranch -like "vb_release"))
	{
		print "Error reporting will be left unchanged in Windows pre-release software."
		return
	}
	print "Disabling Windows Error Reporting..."
	Disable-WindowsErrorReporting | Out-Null
	print "Disabled Windows Error Reporting."
	Start-Sleep -Milliseconds 200
}

# Enable Windows Error Reporting 
function EnableErrorReporting {
	print "Enabling Windows Error Reporting..."
	Enable-WindowsErrorReporting | Out-Null
	print "Enabled Windows Error Reporting."
	Start-Sleep -Milliseconds 200
}

# Disable Feedback.
Function DisableFeedback {
$ErrorActionPreference = 'SilentlyContinue'
	space
	if (!($BuildBranch -like "co_release" -or $BuildBranch -like "vb_release"))
	{
		print "Feedback notifications will be left unchanged in Windows pre-release software."
		return
	}
	print "Disabling Feedback notifications..."
	$Feedback1 = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	$Feedback2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	$Feedback3 = "Microsoft\Windows\Feedback\Siuf\DmClient"
	$Feedback4 = "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
	if (!(Test-Path $Feedback1)) 
	{
		New-Item -Path $Feedback1 -Force | Out-Null
	}
	Set-ItemProperty -Path $Feedback1 -Name "NumberOfSIUFInPeriod" -Type DWord -Value 1
	if (!(Test-Path $Feedback2)) 
	{
		New-Item -Path $Feedback2 -Force | Out-Null
	}
	Set-ItemProperty -Path $Feedback2 -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName $Feedback3 | Out-Null
	Disable-ScheduledTask -TaskName $Feedback4 | Out-Null
	print "Disabled Feedback notifications."
	Start-Sleep -Milliseconds 200
}

# Enable Feedback.
Function EnableFeedback {
	print "Enabling Feedback notifications..."
	$Feedback1 = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	$Feedback2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	$Feedback3 = "Microsoft\Windows\Feedback\Siuf\DmClient"
	$Feedback4 = "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
	if (!(Test-Path $Feedback1 )) 
	{
		New-Item $Feedback1 -Force | Out-Null
	}
	Remove-ItemProperty -Path $Feedback1 -Name "NumberOfSIUFInPeriod"
	Remove-ItemProperty -Path $Feedback2 -Name "DoNotShowFeedbackNotifications"
	Enable-ScheduledTask -TaskName $Feedback3 | Out-Null
	Enable-ScheduledTask` -TaskName $Feedback4 | Out-Null
	print "Enabled Feedback notifications."
	Start-Sleep -Milliseconds 200
}

# Disable inking personalization.
Function DisableInkHarvesting {
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
	Start-Sleep -Milliseconds 200
}

# Enable inking personalization. 
Function EnableInkHarvesting {
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
	Start-Sleep -Milliseconds 200
}

# Disable "Let websites provide locally relevant content by accessing my language list".
Function DisableLangAccess {
	space
	print "Disabling websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Remove-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 1 | Out-Null
	print "Disabled websites' ability to provide you with locally relevant content by accessing your language list."
	Start-Sleep -Milliseconds 200
}

# Enable "Let websites provide locally relevant content by accessing my language list".
Function EnableLangAccess {
	print "Enabling websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Set-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 0
	print "Enabled websites' ability to provide you with locally relevant content by accessing your language list."
	Start-Sleep -Milliseconds 200
}

# Disable Location Tracking.
Function DisableLocationTracking {
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
	Start-Sleep -Milliseconds 200
}

# Enable location tracking.
Function EnableLocationTracking {
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
	Start-Sleep -Milliseconds 200
}

# Disable automatic Maps updates.
Function DisableMapUpdates {
	space
	print "Disabling automatic Maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
	print "Disabled automatic Maps updates."
	Start-Sleep -Milliseconds 200
}

# Enable maps updates.
Function EnableMapsUpdates {
	space
	print "Enabling automatic Maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 1
	print "Enabled automatic Maps updates."
	Start-Sleep -Milliseconds 200
}

# Disable Speech Recognition.
Function DisableSpeechRecognition {
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
	Start-Sleep -Milliseconds 200
}

# Enable speech recognition. 
Function EnableSpeechRecognition {
	space
	print "Enabling Speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	if (!(Test-Path )) 
	{
		New-Item -Path $Speech | Out-Null
	}
	Set-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 1
	print "Enabled Online Speech recognition"
	Start-Sleep -Milliseconds 200
}

# Disable silent installation of recommended apps.
Function DisableSilentInstallApps {
	space
	print "Disabling silent installation of suggested apps..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -Type DWord -Value 1
	print "Disabled silent installation of suggested apps."
	Start-Sleep -Milliseconds 200
}

# Enable silent installation of recommended apps.
Function EnableSilentInstallApps {
	space
	print "Enabling silent installation of suggested apps..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -Type DWord -Value 1
	print "Enabled silent installation of suggested apps."
	Start-Sleep -Milliseconds 200
}

# Disable "Show suggested content in Settings app"
Function HideSuggestedContentInSettings {
	space
	print "Disabling suggested content in Settings app..."
	$CDN = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353694Enabled -Type DWord -Value 0
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353696Enabled -Type DWord -Value 0
	Set-ItemProperty -Path $CDN -Name SubscribedContent-338393Enabled -Type DWord -Value 0
	print "Disabled suggested content in Settings app."
	Start-Sleep -Milliseconds 200
}

# Enable "Show suggested content in Settings app"
Function ShowSuggestedContentInSettings {
	space
	print "Enabling suggested content in Settings app..."
	$CDN = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353694Enabled -Type DWord -Value 1
	Set-ItemProperty -Path $CDN -Name SubscribedContent-353696Enabled -Type DWord -Value 1
	Set-ItemProperty -Path $CDN -Name SubscribedContent-338393Enabled -Type DWord -Value 1
	print "Enabled suggested content in Settings app."
	Start-Sleep -Milliseconds 200
}

# Disable "Show me suggested content in Start menu".
Function HideSuggestedContentInStart {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space 
	print "Disabling suggested content in Start menu..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -Type DWord -Value 0
	print "Disabled suggested content in Start menu."
	Start-Sleep -Milliseconds 200
}

# Enable "Show me suggested content in Start menu".
Function ShowSuggestedContentInStart {
	if ($CurrentBuild -ge 22000)
	{
		return
	}
	space 
	print "Enabling Suggested content in Start menu..."
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -Type DWord -Value 1
	print "Enabled Suggested content in Start menu."
	Start-Sleep -Milliseconds 200
}

# Disable Tailored experiences.
Function DisableTailoredExperiences {
	space
	print "Disabling Tailored experiences..."
	$TailoredExp1 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	$TailoredExp2 = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
	if (!(Test-Path $CloudContent )) 
	{
		New-Item $CloudContent -Force | Out-Null
	}
	Set-ItemProperty -Path $TailoredExp1 -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
	Set-ItemProperty -Path $TailoredExp2 -Name "Disabled" -Type DWord -Value 1
	print "Disabled Tailored experiences."
	Start-Sleep -Milliseconds 200
}

# Enable Tailored experiences.
Function EnableTailoredExperiences {
	space
	print "Enabling Tailored experiences..."
	$TailoredExp1 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	$TailoredExp2 = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
	Remove-ItemProperty -Path $TailoredExp1 -Name "DisableTailoredExperiencesWithDiagnosticData" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $TailoredExp2 -Name "Disabled" -ErrorAction SilentlyContinue
	print "Enabled Tailed experiences."
	Start-Sleep -Milliseconds 200
}

# Disable Telemetry. 
Function DisableTelemetry {
	space
	if (!($BuildBranch -like "co_release" -or $BuildBranch -like "vb_release"))
	{
		print "Telemetry settings will be left unchanged in Windows pre-release software."
		return
	}
	print "Disabling telemetry..."
	$Telemetry1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Set-ItemProperty -Path $Telemetry1 -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path $Telemetry2 -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path $Telemetry3 -Name "AllowTelemetry" -Type DWord -Value 0
	print "Disabled telemetry."
	Start-Sleep -Milliseconds 200
}

# Enable Telemetry.
Function EnableTelemetry {
	space
	print "Enabling Telemetry..."
	$Telemetry1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Set-ItemProperty -Path $Telemetry1  -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry2 -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry3 -Name "AllowTelemetry" -Type DWord -Value 3
	print "Disabled telemetry."
	Start-Sleep -Milliseconds 200
}

# Enable Clipboard History.
Function EnableClipboard {
	space
	print "Enabling Clipboard History..."
	$Clipboard = "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Value 1 -ErrorAction SilentlyContinue
	print "Enabled Clipboard History."
    Start-Sleep 1
    Set-Clipboard "Demo text by WinRice."
	print "You can now copy multiple items to your clipboard."
    print "Access your clipboard now using Windows key + V."
	Write-Warning "If the Clipboard History feature does not work, retry it after a device restart."
	Start-Sleep -Milliseconds 200
}

# Disable Clipboard History.
Function DisableClipboard {
	space
	print "Disabling Clipboard History..."
	$Clipboard = "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Value 0 -ErrorAction SilentlyContinue
	print "Disabled Clipboard History."
	Start-Sleep -Milliseconds 200
}

Function AutoLoginPostUpdate {
	space
	print "Enabling automatic login post updates..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent" -Type DWord -Value 1
	print "Enabled Automatic login applying updates."
	Start-Sleep -Milliseconds 200
} 

Function StayOnLockscreenPostUpdate {
	space
	print "Disabling automatic login post updates..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent"
	print "Disabled Automatic login after applying updates."
	Start-Sleep -Milliseconds 200
}

Function DisableVBS {
	space
	# Check if current processor supports MBEC (https://docs.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity)
	# This function disables Virtualization based security if your device's processor does not support MBEC. On unsupported processors, MBEC is emulated which taxes CPU performance.
	$mbec = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard | Select-Object AvailableSecurityProperties
	if ($mbec -contains 7)
	{
		return
	}
	print "Disabling Virtualization-based security..."
	print "  This processor does not natively support MBEC. Emulating it will result in bigger impact on performance on MBEC-unsupported CPUs."
	print "  See https://docs.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity."
	Start-Sleep -Milliseconds 400
	# Disable Memory Integrity Core isolation (this needs to be disabled in order to disable VBS)
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Type DWord -Value 0
	# Disable VBS
	bcdedit.exe /set hypervisorlaunchtype off | Out-Null
	print "Disabled Virtualization-based security."
	space
	print "  Note that virtualization features powered by Hyper-V such as WSL and WSA will not work until you re-enable Virtualization-based security."
	print "  Read https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#virtualization-based-security for more."
	space 
	Start-Sleep -Milliseconds 200
}

Function EnableVBS {
	space
	print "Enabling Virtualization-based security..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Type DWord -Value 1
	bcdedit.exe /set hypervisorlaunchtype auto | Out-Null
	print "Enabled Virtualization-based security."
	Start-Sleep -Milliseconds 200
}

# Disables Windows WDigest credential caching (https://stealthbits.com/blog/wdigest-clear-text-passwords-stealing-more-than-a-hash/).
Function DisableLogonCredential {
	space
	print "Disabling Windows WDigest credential caching..."
	# https://stealthbits.com/blog/wdigest-clear-text-passwords-stealing-more-than-a-hash/
	Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\SecurityProviders\Wdigest" -Name "UseLogonCredential" -Type "DWORD" -Value 0
	print "Disabled Windows WDigest credential caching."
	Start-Sleep -Milliseconds 200
}

# Enables Windows WDigest credential caching.
Function EnableLogonCredential {
	space
	print "Enabling Windows WDigest credential caching..."
	Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\SecurityProviders\Wdigest" -Name "UseLogonCredential" -Type "DWORD" -Value 1
	print "Enabled Windows WDigest credential caching."
	Start-Sleep -Milliseconds 200
}

# Disable LLMNR (https://www.blackhillsinfosec.com/how-to-disable-llmnr-why-you-want-to/).
Function DisableLLMNR {
	space
	print "Disabling LLMNR..."
	New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows NT\" -Name "DNSClient" -Force | Out-Null
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -Type "DWORD" -Value 0 -Force | Out-Null
	print "Disabled LLMNR."
	Start-Sleep -Milliseconds 200
}

# Enable LLMNR
Function EnableLLMNR {
	space
	print "Enabling LLMNR..."
	Remove-Item -Path "HKLM:\Software\Policies\Microsoft\Windows NT\DNS Client" | Out-Null
	print "Enabled LLMNR."
	Start-Sleep -Milliseconds 200
}

Function EnableSEHOP {
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
	Start-Sleep -Milliseconds 200
}

Function DisableSEHOP {
	space
	print "Disabling Structured Exception Handling Overwrite Protection..."
	$SEHOP = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel"
	Remove-ItemProperty -Path $SEHOP -Type DWord -Name DisableExceptionChainValidation | Out-Null
	print "Disabled Structured Exception Handling Overwrite Protection."
	Start-Sleep -Milliseconds 200
}

Function DisableWPAD {
	space
	print "Disabling Web Proxy Auto-Discovery..."
	New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\" -Name "Wpad" -Force | Out-Null
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" -Name "Wpad" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" -Name "WpadOverride" -Type "DWORD" -Value 1 -Force
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" -Name "WpadOverride" -Type "DWORD" -Value 1 -Force
	print "Disabled Web Proxy Auto-Discovery."
	Start-Sleep -Milliseconds 200
}

Function EnableWPAD {
	space
	print "Enabling Web Proxy Auto-Discovery..."
	Remove-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" -Force | Out-Null
    Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" -Force | Out-Null
	print "Enabled Web Proxy Auto-Discovery."
	Start-Sleep -Milliseconds 200
}

Function EnableLSAProtection {
	space
	print "Enabling LSA Protection/Auditing..."
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\" -Name "LSASSs.exe" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\LSASS.exe" -Name "AuditLevel" -Type "DWORD" -Value 8 -Force
	print "Enabled LSA Protection/Auditing."
	Start-Sleep -Milliseconds 200
}

Function DisableLSAProtection {
	space
	print "Disabling LSA Protection/Auditing..."
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\LSASS.exe"
	print "Disabled LSA Protection/Auditing."
	Start-Sleep -Milliseconds 200
}

Function DisableScriptHost {
	space
	print "Disabling Windows Script Host..."
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\" -Name "Settings" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name "Enabled" -Type "DWORD" -Value 0 -Force
	print "Disabled Windows Script Host."
	Start-Sleep -Milliseconds 200
}

Function EnableScriptHost {
	space
	print "Enabling Windows Script Host..."
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Force | Out-Null
	print "Enabled Windows Script Host."
	Start-Sleep -Milliseconds 200
}

Function DisableOfficeOLE {
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
	Start-Sleep -Milliseconds 200
}

Function EnableOfficeOLE {
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
	Start-Sleep -Milliseconds 200
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
	print "Disabling AutoPlay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
	print "Disabled AutoPlay."
	Start-Sleep -Milliseconds 200
}

# Enable Autoplay.
Function EnableAutoplay {
	space
	print "Enabling Autoplay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
	print "Enabled AutoPlay."
	Start-Sleep -Milliseconds 200
}

# Disable Autorun for all drives.
Function DisableAutorun {
	space
	print "Disabling Autorun for all drives..."
	$Autorun = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	if (!(Test-Path $Autorun)) 
	{
		New-Item -Path $Autorun | Out-Null
	}
	Set-ItemProperty -Path $Autorun -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
	print "Disabled Autorun for all drives."
	Start-Sleep -Milliseconds 200
}

# Enable Autorun for removable drives.
Function EnableAutorun {
	space
	print "Enabling Autorun for all drives..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
	print "Enabled Autorun for all drives."
	Start-Sleep -Milliseconds 200
}

# Disable Hiberfile.sys
Function DisableHibernation {
	if ($isLaptop)
	{
		return
	}
	space 
	print "Disabling hibernation..."
	powercfg.exe -h off
	print "Disabled hibernation."
	Start-Sleep -Milliseconds 200
}

# Enable Hibernation
Function EnableHibernation {
	if ($isLaptop) 
	{
		return
	}
	space 
	print "Enabling hibernation..."
	powercfg.exe -h on
	print "Enabled hibernation."
	Start-Sleep -Milliseconds 200
}

# Set BIOS time to UTC.
Function BIOSTimeUTC {
	space
	print "Setting BIOS time to UTC..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
	print "BIOS Time is set to UTC."
	Start-Sleep -Milliseconds 200
}

# Set BIOS time to local time.
Function BIOSTimeLocal {
	space
	print "Setting BIOS time to Local time..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -ErrorAction SilentlyContinue
	print "BIOS Time is set to Local time."
	Start-Sleep -Milliseconds 200
}

# Enable Num lock on startup.
Function EnableNumLock {
	space
	print "Setting Num lock to turn on autoamtically on Startup..."
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force | Out-Null
	print "Num lock will turn on automatically on Startup."
	Start-Sleep -Milliseconds 200
}

# Disable Num lock on startup.
Function DisableNumLock {
	space
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483648 -Force | Out-Null
	print "Num lock will no longer turn on automatically on Startup."
	Start-Sleep -Milliseconds 200
}

# Enable Storage Sense. 
Function EnableStorageSense {
	space
	print "Enabling Storage Sense..."
	$StorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $StorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $StorageSense -Name 01 -PropertyType DWord -Value 1 -Force | Out-Null
	print "Enabled Storage Sense."
	Start-Sleep -Milliseconds 200
}

# Disable Storage Sense.
Function DisableStorageSense {
	space
	print "Disabling Storage Sense..."
	$StorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $StorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $StorageSense -Name 01 -PropertyType DWord -Value 0 -Force | Out-Null
	print "Disabled Storage Sense."
	Start-Sleep -Milliseconds 200
}

# Disable Reserved Storage. 
Function DisableReserves {
	space
	print "Disabling Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 0
	print "Disabled Reserved Storage."
	Start-Sleep -Milliseconds 200
}

# Enable Reserved Storage. 
Function EnableReserves {
	space
	print "Enabling Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 1
	print "Enabled Reserved Storage."
	Start-Sleep -Milliseconds 200
}

# Disable unessential services.
Function DisableServices {
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Disabling unessential services..."
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
	print "Disabled unnecesarry services."
	Start-Sleep -Milliseconds 200
}

# Enable unessential services.
Function EnableServices {
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Enabling unessential services..."
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
	print "Enabled unessential services."
	Start-Sleep -Milliseconds 200
}

# Disable unessential scheduled tasks.
Function DisableTasks {
	space
	print "Disabling unessential tasks..."
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
    ForEach ($Task in $Tasks) 
	{
		Disable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		print "    Disabled task: $Task."
	}
    print "Disabled unessential tasks."
	Start-Sleep -Milliseconds 200
}

# Enable unessential scheduled tasks.
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
    ForEach ($Task in $Tasks) 
	{
		Enable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		print "    Enabled task: $Task."
	}
    print "Enabled unessential tasks."
	Start-Sleep -Milliseconds 200
}

# Intelligently setup Windows Update policies.
Function SetupWindowsUpdate {
	space
	# Perform checks.
	if ($BuildBranch -like "rs_prerelease")
	{
		print "Windows Update policies will be left unchanged in Windows pre-release software."
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
		Set-ItemProperty -Path $wureg -Name DeferQualityUpdates -Type DWord -Value 1
		Set-ItemProperty -Path $wureg -Name DeferQualityUpdatesPeriodInDays -Type DWord -Value 4
		Set-ItemProperty -Path $wureg -Name DeferFeatureUpdates -Type DWord -Value 1
		Set-ItemProperty -Path $wureg -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 20
	
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

	# Print user message; policies applied.
	$WinUpdatePolicies =@(
		"Disabled Delivery optimization."
		"Device will no longer auto restart if users are signed in."
		"Disabled re-installation of apps after Windows Updates."
	)
	ForEach ($WinUpdatePolicy in $WinUpdatePolicies) 
	{
		print "    - $WinUpdatePolicy"
	}

	print "Set up Windows Update policies."
	Start-Sleep -Milliseconds 200
}

# Reset all Windows Update policies
Function ResetWindowsUpdate {
    space
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse
    print "All Windows Update policies were reset."
	Start-Sleep -Milliseconds 200
}

# A simple registry edit that fixes an issue where a small batch of devices turn back on after powering down.
Function EnablePowerdownAfterShutdown {
	space
	print "Enabling full powerdown on shut down..."
	print "This is known to fix issues where some PCs might boot up without user input after shutdown."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 1
	print "Enabled full power down on shut down."
	Start-Sleep -Milliseconds 200
}

# Revert the EnablePowerdownAfterShutdown edit.
Function DisablePowerdownAfterShutdown {
	space
	print "Disabling full powerdown on shut down..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 0
	print "Disabled full powerdown on shut down."
	Start-Sleep -Milliseconds 200
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
	Start-Sleep -Milliseconds 200
}

# Show extensions.
Function ShowExtensions {
	space
	print "Showing extensions in file names..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
	print "Showed extensions in file names."
	Start-Sleep -Milliseconds 200
}

# Hide extensions.
function HideExtensions {
	space
	print "Hiding extensions from file names..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 1
	print "Hidden extensions in file names."
	Start-Sleep -Milliseconds 200
}

# Hide Recent files in Quick Access.
function HideRecentFilesInQuickAccess {
	space
	print "Hiding recent files from Quick Access..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowRecent -Type DWord -Value 0
	print "Hidden recent files from Quick Access."
	Start-Sleep -Milliseconds 200
}

# Show Recent files in Quick Access.
function ShowRecentFilesInQuickAccess {
	space 
	print "Showing Recent files in Quick Access..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowRecent -Type DWord -Value 1
	print "Shown Recent files in Quick Access."
	Start-Sleep -Milliseconds 200
}

# Disable Sticky keys.
Function DisableStickyKeys {
	space
	print "Disabling Sticky keys..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
	print "Disabled Sticky keys."
	Start-Sleep -Milliseconds 200
}

# Enable Sticky keys.
Function EnableStickyKeys {
	space
	print "Enabling Sticky keys..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
	print "Enabled Sticky keys."
	Start-Sleep -Milliseconds 200
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
	Start-Sleep -Milliseconds 200
}

# Hide 3D Objects.
Function Hide3DObjects {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Hiding 3D Objects..."
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
	$Hide3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	$Hide3DObjects2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	if (!(Test-Path $Hide3DObjects1)) 
	{
		New-Item -Path $Hide3DObjects1 -Force | Out-Null
	}
	Set-ItemProperty -Path $Hide3DObjects1 -Name "ThisPCPolicy" -Type String -Value "Hide"
	if (!(Test-Path $Hide3DObjects2)) 
	{
		New-Item -Path $Hide3DObjects2 -Force | Out-Null
	}
	Set-ItemProperty -Path $Hide3DObjects2 -Name "ThisPCPolicy" -Type String -Value "Hide"
	print "Hid 3D Objects."
	Start-Sleep -Milliseconds 200
}

# Restore 3D Objects.
Function Restore3DObjects {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Restoring 3D Objects..."
	$Restore3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	$Restore3DObjects2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	$Restore3DObjects3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	if (!(Test-Path $Restore3DObjects1)) 
	{
		New-Item -Path $Restore3DObjects1 | Out-Null
	}
	Remove-ItemProperty -Path $Restore3DObjects2 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $Restore3DObjects3 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	print "Restoring 3D Objects."
	Start-Sleep -Milliseconds 200
}

# Hide Search bar from taskbar.
Function HideSearch {
	space
	print "Hiding Search button..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
	print "Hid Search button."
	Start-Sleep -Milliseconds 200
}

# Restore Search bar to taskbar.
Function RestoreSearch {
	space
	print "Restoring Search button..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 2
	print "Restored Search button."
	Start-Sleep -Milliseconds 200
}

# Hide Task View.
Function HideTaskView {
	space
	print "Hiding Task view button..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
	print "Hid Task view button."
	Start-Sleep -Milliseconds 200
}

# Restore Task View button.
Function RestoreTaskView {
	space
	print "Restoring Task view button..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
	print "Restored Task view icon."
	Start-Sleep -Milliseconds 200
}

# Hide Cortana icon from taskbar.
Function HideCortana {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Hiding Cortana button..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
	print "Hid Cortana button."
	Start-Sleep -Milliseconds 200
}

# Restore Cortana button in taskbar.
Function RestoreCortana {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	print "Restoring Cortana button..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1
	print "Restored Cortana button."
	Start-Sleep -Milliseconds 200
}

# Hide Meet Now icon from tray.
Function HideMeetNow {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Hiding Meet now..."
    $Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    $Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 1
    Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
	print "Hid Meet now."
	Start-Sleep -Milliseconds 200
}

# Restore Meet Now icon on tray.
Function RestoreMeetNow {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Restoring Meet now..."
    $Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    $Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 0
    Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
	print "Restored Meet now."
	Start-Sleep -Milliseconds 200
}

# Turn off News and interests feed.
Function HideNI {
	if ($CurrentBuild -ge 22000) 
	{
		return
	}
	space
	print "Disabling News and interests..."
	$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
	$Feed2 = "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Feeds"
	Set-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 2 | Out-Null
	Set-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 2 | Out-Null
	print "Disabled News and interests."
	Start-Sleep -Milliseconds 200
}

# Turn on News and interests feed.
Function RestoreNI {
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
	Start-Sleep -Milliseconds 200
}

# Disable Widgets item - Windows 11 only.
function HideWidgets {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Hiding Widgets..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Type DWord -Value 0
	print "Hidden Widgets."
	Start-Sleep -Milliseconds 200
}

# Enable Widgets item - Windows 11 only
function RestoreWidgets {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Restoring Widgets..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Type DWord -Value 1
	print "Restored Widgets."
	Start-Sleep -Milliseconds 200
}

# Disable chat item - Windows 11 only
function HideChat {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Hiding Chat..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Type DWord -Value 0
	print "Hid Chat."
	Start-Sleep -Milliseconds 200
}

# Enable Chat item - Windows 11 only
function RestoreChat {
	if ($CurrentBuild -lt 22000)
	{
		return
	}
	space
	print "Restoring Chat..."
	Set-ItemProperty -Path "Registry::HKEY_USERS\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Type DWord -Value 1
	print "Restored Chat."
	Start-Sleep -Milliseconds 200
}

Start-Sleep -Seconds 2

######### Tasks after successful run #########

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