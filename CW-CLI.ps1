# This file is a part of the CleanWin software
# Copyright (c) 2021 Pratyaksh Mehrotra <pratyakshm@protonmail.com>
# All rights reserved.

# Default preset
$tasks = @(

### Maintenance Tasks ###
	"ExecutionPolicy",
	"CleanWin",
	"OSBuildInfo",
	"CreateSystemRestore",
	"Activity",

### Apps & Features ###
	"AppsFeatures",
	"UninstallApps", "Activity", 
	"UnpinStartTiles", "Activity", 
	"UnpinAppsFromTaskbar", "Activity", 
	"InstallFrameworks",
	"InstallWinGet", 
	"UninstallOneDrive", 
	"Activity",
	# "DisableBrowserRestoreAd",
	# "EnableBrowserRestoreAd",
	# "DisableM365OnValueBanner", 
	# "RevertM365OnValueBanner",
	"UninstallFeatures", "Activity", 
	"DisableSuggestions",		    
	# "EnableSuggestions",
	"EnableWSL", "Activity", 
	"EnabledotNET3.5", "Activity", 
	# "EnableSandbox",
	"Install7zip", 
	"Winstall", 
	"Activity",
	"EnableExperimentsWinget",
	"WinGetImport",
	"Activity",
	"InstallHEVC", 
	"UpdateWidgets",
	"InstallFonts", 
	"SetPhotoViewerAssociation",
	# "SetPhotoViewerAssociation",
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
	"DisableTailoredExperiences",	
	# "EnableTailoredExperiences",
	"DisableTelemetry",				
	# "EnableTelemetry",
	"EnableClipboard",				
	# "DisableClipboard",
	"AutoLoginPostUpdate", 		    
	# "StayOnLockscreenPostUpdate",
	"ChangesDone",
	# To revert all privacy changes, use CleanWin GUI -> "Enable data collection".

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
	"EnablePowerdownAfterShutdown",
	# "DisablePowerdownAfterShutdown",
	"ChangesDone",

### Windows Explorer ###
	"PrintExplorerChanges",
	"EnablePrtScrToSnip",		   
	# "DisablePrtScrSnip",
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
	"ChangesDone",

###  Tasks after successful run ###
	"Activity",
	"Success"
)


### Pre-execution tasks ###
Clear-Host
Write-Host "CleanWin pre-execution environment"
Start-Sleep -Milliseconds 100
Write-Host " "
Write-Host "Copyright (c) Pratyaksh Mehrotra and contributors"
Start-Sleep -Milliseconds 100
Write-Host "https://github.com/pratyakshm/CleanWin"
Write-Host " "
Start-Sleep 1

# Store values, create PSDrives and get current window title.
$CurrentVersionPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$CurrentBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild
$DisplayVersion = Get-ItemPropertyValue $CurrentVersionPath -Name DisplayVersion
New-PSDrive -Name "HKU" -PSProvider "Registry" -Root "HKEY_Users" | Out-Null
if (!(Test-Path "C:\CleanWin")) {
	New-Item "C:\CleanWin" -ItemType Directory | Out-Null
}
else {
	# Do nothing.
}
$currenttitle = $(Get-Process | Where-Object {$_.MainWindowTitle -like "*PowerShell*" }).MainWindowTitle

# Check if supported OS build.
Write-Host " "
Write-Host "Checking if CleanWin supports this version of Windows..."
Start-Sleep 1
if ($CurrentBuild -lt 19042) {
	Write-Host "This device is running Windows 10 $DisplayVersion OS Build $CurrentBuild."
	Write-Host "CleanWin does not support this version. Please update your device."
	Write-Host "CleanWin will now exit."
	exit
}
elseif ($CurrentBuild -ge 19042) {
	Write-Host "This version of Windows is supported."
}
Start-Sleep -Milliseconds 600

# Check if session is elevated.
Write-Host " "
Write-Host "Checking if current session is elevated..."
Start-Sleep 2
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$admin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($admin -like "False") {
	Write-Host "Please run CleanWin in an elevated PowerShell session."
	exit
}
elseif ($admin -like "True") {
	Write-Host "Session is elevated."
	# Do nothing.
}
else {
	# Do nothing.
}
Start-Sleep -Milliseconds 600

# Exit CleanWin if PC is not connected.
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
Write-Host " "
Write-Host "Checking if this device is connected..."
Import-Module BitsTransfer
Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/File.txt
if (Test-Path File.txt) {
	Remove-Item File.txt
	Write-Host "This device is connected."
}
elseif (!(Test-Path File.txt)) {
	Write-Host "This device is not connected. CleanWin will now exit."
	exit
}
Start-Sleep -Milliseconds 600

# Check for updates and exit if found (part of code used here is picked from https://gist.github.com/Grimthorr/44727ea8cf5d3df11cf7).
Write-Host " "
Write-Host "Checking for Windows updates..."
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
$Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0 and AutoSelectOnWebSites=1").Updates)
$Title = $($Updates).Title
if (!($Title)) {
	Write-Host "This device is updated. "
}
else {
	Write-Host "The following updates are pending:"
	Write-Host " "
	$($Updates).Title
	Start-Sleep 1
	Write-Host " "
	Write-Host "Please update your device before running CleanWin."
	exit
}
Start-Sleep -Milliseconds 600

# Check for pending restart (part of code used here was picked from https://thesysadminchannel.com/remotely-check-pending-reboot-status-powershell).
Write-Host " "
Write-Host "Checking for pending restarts..."
Start-Sleep 1
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
            Write-Host "A device restart is pending."
            Write-Host "Please restart this device then run CleanWin."
        }
        else {
            Write-Host "No pending restarts detected."
			Start-Sleep 2
			Clear-Host
        }
        # Clear variables.
        $WMI_Reg        = $null
        $SCCM_Namespace = $null
    }   
}

# Take user configs.
Write-Host "Please take your time to answer the questions below in order to save user config."
Write-Host " "
Write-Host "Press Enter to proceed after answering a question."
$systemrestore = Read-Host "Create a system restore point? [y/N]"
$uninstallapps = Read-Host "Uninstall Windows apps?"
$onedrive = Read-Host "Uninstall Microsoft OneDrive?"
$uninstallfeatures = Read-Host "Uninstall unnecessary optional features?"
$wsl = Read-Host "Enable Windows Subsystem for Linux?"
$netfx3 = Read-Host "Enable dotNET 3.5?"
$winstall = Read-Host "Use Winstall? (bit.ly/Winstall)"
$wingetimport = Read-Host "Use winget import?"
$enableexperimentswinget = Read-Host "Enable experimental features in WinGet?"

Write-Host " "
Start-Sleep -Milliseconds 200
Write-Host "Choices saved, starting CleanWin..."
Start-Sleep -Milliseconds 1500

# Intro.
Function CleanWin {
	$host.UI.RawUI.WindowTitle = "pratyakshm's CleanWin"
	Clear-Host
	Write-Host " "
	Write-Host "pratyakshm's CleanWin"
	Start-Sleep -Milliseconds 100
	Write-Host " "
	Write-Host "Copyright (c) Pratyaksh Mehrotra (a.k.a. pratyakshm) and contributors"
	Start-Sleep -Milliseconds 100
	Write-Host "https://github.com/pratyakshm/CleanWin"
	Start-Sleep 1
}

# OS Build.
Function OSBuildInfo {
	Write-Host " "
	$CurrentVersionPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
	$CurrentBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild
	$BuildBranch = Get-ItemPropertyValue $CurrentVersionPath -Name BuildBranch
	$OSBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild
	$DisplayVersion = Get-ItemPropertyValue $CurrentVersionPath -Name DisplayVersion
	if ($CurrentBuild -lt 22000) {
		Write-Host "This PC is running Windows 10."
		Write-Host "Version $DisplayVersion, OS Build $OSBuild in $BuildBranch branch."
	}
	elseif ($CurrentBuild -ge 22000) {
		Write-Host "This PC is running Windows 11."
		Write-Host "Version $DisplayVersion, OS Build $OSBuild in $BuildBranch branch."
		Write-Host "Note that CleanWin's Windows 11 support is experimental and you might face issues."
	}
	Start-Sleep 2
	Write-Host " "
	Write-Host " "
}

# Changes performed.
Function ChangesDone {
	Write-Host " "
	Write-Host "---------------------------"
	Write-Host "     CHANGES PERFORMED     "
	Write-Host "---------------------------"
	Write-Host " "
	Start-Sleep 1
}

# Create a system restore point with type MODIFY_SETTINGS.
Function CreateSystemRestore {
$ProgressPreference = 'SilentlyContinue'
	if ($systemrestore -like "y") {
		Write-Host " "
		Write-Host "Creating a system restore point with type MODIFY_SETTINGS..."
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -Type DWord -Value 0 -Force
		Enable-ComputerRestore -Drive $env:SystemDrive
		Checkpoint-Computer -Description "CleanWin" -RestorePointType "MODIFY_SETTINGS" -WarningAction SilentlyContinue
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -Type DWord -Value 1440 -Force
		Disable-ComputerRestore -Drive $env:SystemDrive
		Write-Host "Created system restore point."
	}
	else {
		# Do nothing.
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

	Get-Process | Where-Object -FilterScript {$_.MainWindowTitle -like "pratyakshm's CleanWin*"} | ForEach-Object -Process {
		# Show window if minimized.
		[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10) | Out-Null 

		Start-Sleep -Milliseconds 100

		# Move the console window to the foreground.
		[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle) | Out-Null

		Start-Sleep -Milliseconds 100

		# Emulate Backspace key.
		[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
	}
}


###################################
######### APPS & FEATURES #########
###################################

# Update status
Function AppsFeatures {
	Write-Host " "
	Write-Host "-------------------------"
	Write-Host "     APPS & FEATURES     "
	Write-Host "-------------------------"
	Write-Host " "
}

# Debloat apps.
Function UninstallApps {
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
	if ($uninstallapps -like "y") {
		# Remove Windows inbox apps.
		Write-Host "Uninstalling Windows apps..."
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
			"Microsoft.MSPaint"
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
			"Microsoft.WindowsCamera"
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
				Write-Host "     Uninstalling $InboxApp..."
				Get-AppxPackage -Name $InboxApp| Remove-AppxPackage 
				Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $InboxApp | Remove-AppxProvisionedPackage -Online | Out-Null
			}
			else {
				# Do nothing.
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
		ForEach ($SponsoredApp in $SponsoredApps) {
			if (Get-AppxPackage $SponsoredApp) {
				Write-Host "     Uninstalling $SponsoredApp.."
				Get-AppxPackage -Name $SponsoredApp| Remove-AppxPackage 
				Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $SponsoredApp | Remove-AppxProvisionedPackage -Online | Out-Null
			}
			else {
				# Do nothing.
			}
		}

		# Remove Office webapps shortcuts.
		if (Test-Path "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk") {
			Write-Host "     Uninstalling Office web-apps..."
			Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
			Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Outlook.lnk"
			Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk"
			Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Word.lnk"
			Write-Host "     Uninstalled Office web-apps."
		}


		# Uninstall Connect app.
		if (Get-AppxPackage Microsoft-PPIProjection-Package) {
			Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/install_wim_tweak.exe
			Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/connect.cmd
			./connect.cmd | Out-Null
			Remove-Item install_wim_tweak.exe
			Remove-Item connect.cmd
			Remove-Item Packages.txt
		}
		else {
			# Do nothing.
		}

		Write-Host "Uninstalled Windows apps."

	}
	else {
		# Do nothing.
	}
}


# Unpin all start menu tiles.
Function UnpinStartTiles {
	Write-Host " "
	if ($CurrentBuild -lt 22000) {
		Write-Host "Unpinning all tiles from Start Menu..."
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
		If(Test-Path $layoutFile)
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
			IF(!(Test-Path -Path $keyPath)) { 
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
		Write-Host "Unpinned all tiles from Start Menu."
	}
	elseif ($CurrentBuild -ge 22000) {
		Write-Host "This device is currently on Windows 11"
		Write-Host "CleanWin does not support unpinning apps from Start menu in Windows 11 yet."
	}
	else {
		# Do nothing.
	}
}

# Unpin Apps from taskbar (https://docs.microsoft.com/en-us/answers/questions/214599/unpin-icons-from-taskbar-in-windows-10-20h2.html).
Function UnpinAppsFromTaskbar {
	Write-Host " "
	Write-Host "Unpinning apps from taskbar..."
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
	Write-Host "Unpinned apps from taskbar."
	Start-Sleep 1
}

# Uninstall Microsoft OneDrive (supports 64-bit versions).
Function UninstallOneDrive {
$ErrorActionPreference = 'SilentlyContinue'
	if ($onedrive -like "y") {
		Write-Host " "
		if (Get-Command winget) {
			Write-Host "Uninstalling Microsoft OneDrive..."

			# Uninstall using WinGet.
			winget uninstall Microsoft.OneDrive | Out-Null

			# Cleanup leftover folders if found.
			Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force
			Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -Force
			Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force
			Remove-Item "$env:LOCALAPPDATA\OneDrive" -Recurse -Force

			Write-Host "Uninstalled Microsoft OneDrive."
			}
		else {
			Write-Host "WinGet is not installed. Microsoft OneDrive could not be uninstalled."
		}
	}
	else {
		# Do nothing.
	}
}

# Enable Startup boost in Microsoft Edge.
Function EnableEdgeStartupBoost {
	Write-Host " "
	Write-Host "Enabling Startup boost for Microsoft Edge..."
	$EdgeStartupBoost = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
	If (!(Test-Path $EdgeStartupBoost )) {
		New-Item -Path $EdgeStartupBoost -Force | Out-Null
		}
	New-ItemProperty -Path $EdgeStartupBoost -Name "StartupBoostEnabled" -Type DWord -Value 1 | Out-Null
	Write-Host "Turned on Startup Boost in Microsoft Edge."
}	

# Disable Startup boost in Microsoft Edge.
Function DisableEdgeStartupBoost {
	Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Recurse
}

# Disable "Web Browsing - Restore recommended promo in Settings".
Function DisableBrowserRestoreAd {
$ProgressPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Turning off 'Web browsing: Restore recommended' suggestion in Settings..."
    Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Albacore.ViVe.dll
	Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/ViVeTool.exe
	./ViVeTool.exe delconfig 23531064 1 | Out-Null
	Remove-Item ViVeTool.exe
	Remove-Item Albacore.ViVe.dll
    Write-Host "Turned off 'Web browsing: Restore recommended' suggestion in Settings."
}

# Enable "Web Browsing - Restore recommended promo in Settings".
Function EnableBrowserRestoreAd {
$ProgressPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Turning on 'Web browsing: Restore recommended' suggestion in Settings..."
    Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Albacore.ViVe.dll
	Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/ViVeTool.exe
	./ViVeTool.exe addconfig 23531064 0 | Out-Null
	Remove-Item ViVeTool.exe
	Remove-Item Albacore.ViVe.dll
    Write-Host "Turned on 'Web browsing: Restore recommended' suggestion in Settings."
}

# Disable the Microsoft 365 banner in Settings app header (Windows 11 only as of now).
Function DisableM365OnValueBanner {
$ProgressPreference = 'SilentlyContinue'
	if ($CurrentBuild -ge 22000) {
		Write-Host " "
		Write-Host "Turning off Microsoft 365 suggestion banner in Settings..."
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/mach2.exe
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/msdia140.dll
		./mach2.exe disable 29174495 | Out-Null
		Remove-Item mach2.exe -Force; Remove-Item msdia140.dll -Force
		Write-Host "Turned off Microsoft 365 suggestion banner in Settings."
	}
	else {
		# Do nothing.
	}
}

# Revert Microsoft 365 banner in Settings app header to the default configuration (Windows 11 only as of now).
Function RevertM365OnValueBanner {
$ProgressPreference = 'SilentlyContinue'
	if ($CurrentBuild -ge 22000) {
		Write-Host " "
		Write-Host "Turning on Microsoft 365 suggestion banner in Settings..."
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/mach2.exe
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/msdia140.dll
		./mach2.exe revert 29174495 | Out-Null
		Remove-Item mach2.exe -Force; Remove-Item msdia140.dll -Force
		Write-Host "Turned on Microsoft 365 suggestion banner in Settings."
	}
	else {
		# Do nothing.
	}
}

# Uninstall Windows Optional Features and Windows Capabilities.
Function UninstallFeatures {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'

	if ($uninstallfeatures -like "y") {
		Write-Host " "
		Write-Host "Removing capabilites and features..."
		# Uninstall capabilities.
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
			Get-WindowsCapability -Online | Where-Object {$_.Name -like $Capability} | Remove-WindowsCapability -Online | Out-Null
		}
		# Print user friendly list of capabilities uninstalled.
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
			Write-Host "    - Uninstalled $CapList"
		}

		$OptionalFeatures = @(
			"WorkFolders-Client*"
			"Printing-XPSServices-Feature*"
		)
		ForEach ($OptionalFeature in $OptionalFeatures) {
			Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like $OptionalFeature} | Disable-WindowsOptionalFeature -Online -NoRestart | Out-Null
		}
		# Print user friendly list of features uninstalled.
		Write-Host "    - Disabled Work Folders Client."
	
		Write-Host "Removed capabilities and features."
	}
	else {
		# Do nothing.
	}
}



# Disable app suggestions and automatic installation.
Function DisableSuggestions {
	Write-Host " "
	Write-Host "Turning off app suggestions and automatic app installation..."
	if (!(Test-Path "C:\CleanWin\Suggestions.reg")) {
		reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "C:\CleanWin\Suggestions.reg" | Out-Null
	}
	else {
		reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "C:\CleanWin\SuggestionsThisMustWork.reg" | Out-Null
	}
	$SyncNotification = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	Set-ItemProperty -Path $SyncNotification -Name "ShowSyncProviderNotifications" -Type DWord -Value 0
	Remove-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SystemPaneSuggestionsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SoftLandingEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent"
	Remove-ItemProperty -Path $Suggestions -Name "ContentDeliveryAllowed"
	Remove-ItemProperty -Path $Suggestions -Name "OemPreInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEverEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent*"
	Remove-Item -Path "HKU:\S-1-5-21-*\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps"
	Write-Host "Turned off app suggestions and automatic app installation."
}

# Enable app suggestions and automatic installation.
Function EnableSuggestions {
	Write-Host " "
	Write-Host "Turning on app suggestions and automatic app installation..."
	if (Test-Path "C:\CleanWin\Suggestions.reg") {
		reg import "C:\CleanWin\Suggestions.reg" | Out-Null
		Write-Host "Turned on app suggestions and automatic app installation."
	}
	elseif (Test-Path "C:\CleanWin\SuggestionsThisMustWork.reg") {
		reg import "C:\CleanWin\SuggestionsThisMustWork.reg" | Out-Null
		Write-Host "Turned on app suggestions and automatic app installation."
	}
	else {
		Write-Host "Could not turn on suggestions and automatic app installation because the exported registry key was likely deleted."
	}
}

# Enable Windows Subsystem for Linux
Function EnableWSL {
$ProgressPreference = 'SilentlyContinue'
	if ($wsl -like "y") {
		Write-Host " "
		if ($CurrentBuild -lt 22000) {
			Write-Host "Enabling Windows Subsystem for Linux..."
			Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart -WarningAction Ignore | Out-Null
			Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -Online -All -NoRestart -WarningAction Ignore | Out-Null
			if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) {
				Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -Online -All -NoRestart -WarningAction Ignore | Out-Null
			}
			else {
				Write-Host "Could not enable optional feature: Hyper-V, since this edition of Windows does not support it. "
			}
			Write-Host "Enabled Windows Subsystem for Linux."
		}
		elseif ($CurrentBuild -ge 22000) {
			Write-Host "Enabling Windows Subsystem for Linux version 2 along with GUI App support..."
			wsl --install | Out-Null
			Write-Host "Enabled Windows Subsystem for Linux."
		}
		else {
			# Do nothing.
		}
	}
	else {
		# Do nothing.
	}
}

# Enable Sandbox.
Function EnableSandbox {
$ProgressPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Enabling Windows Sandbox..."
	Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart -WarningAction Ignore | Out-Null
	Write-Host "Enabled Windows Sandbox."
}

# Enable dotNET 3.5.
Function EnabledotNET3.5 {
$ProgressPreference = 'SilentlyContinue'
	if ($netfx3 -like "y") {
		Write-Host " "
		Write-Host "Enabling dotNET 3.5..."
		Dism /online /Enable-Feature /FeatureName:NetFx3 /NoRestart /Quiet
		Write-Host "Enabled dotNET 3.5."
	}
	else {
		# Do nothing.
	}
}

# Install runtime packages 
Function InstallFrameworks {
	if (!(Get-AppxPackage "Microsoft.VCLibs.*.UWPDesktop")) {
		Write-Host " "
		Write-Host "Preparing download..."
		# Create new folder and set location.
		if (!(Test-Path CleanWin)) {
			New-Item CleanWin -ItemType Directory | out-Null
			$currentdir = $(Get-Location).Path; $dir = "$currentdir/CleanWin"; Set-Location $dir
		}
		else {
			Set-Location CleanWin
		}
		# Download frameworks.
		Write-Host "Downloading app frameworks..."
		$VCLibs1 = "https://github.com/CleanWin/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.Appx"
		$VCLibs2 = "https://github.com/CleanWin/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x86__8wekyb3d8bbwe.Appx"
		$VCLibs3 = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
		$VCLibs4 = "https://aka.ms/Microsoft.VCLibs.x86.14.00.Desktop.appx"
		Start-BitsTransfer $VCLibs1; Start-BitsTransfer $VCLibs2; Start-BitsTransfer $VCLibs3; Start-BitsTransfer $VCLibs4

		# Install frameworks.
		Write-Host "Installing app frameworks..."
		$VCLibs1 = "Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.Appx"
		$VCLibs2 = "Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x86__8wekyb3d8bbwe.Appx"
		$VCLibs3 = "Microsoft.VCLibs.x64.14.00.Desktop.appx"
		$VCLibs4 = "Microsoft.VCLibs.x86.14.00.Desktop.appx"
		Add-AppxPackage $VCLibs1; Add-AppxPackage $VCLibs2; Add-AppxPackage $VCLibs3; Add-AppxPackage $VCLibs4

		# Cleanup installers.
		Set-Location ..
		Remove-Item CleanWin -Recurse -Force
		
		# Get-Command VCLibs, if it works then print success message.
		if (Get-AppxPackage "Microsoft.VCLibs.*.UWPDesktop") {
			Write-Host "Installed app frameworks."
		}
		elseif (!(Get-AppxPackage "Microsoft.VCLibs.*.UWPDesktop")) {
			Write-Host "Could not install app frameworks."
		}
		else {
			# Do nothing.
		}
	}
}

# Install WinGet (Windows Package Manager).
Function InstallWinGet {
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
		Write-Host " "
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
}

# Install 7zip.
Function Install7zip {
	Write-Host " "
	$7zip = "HKLM:\SOFTWARE\7-Zip"
	If (!(Test-Path $7zip)) {
		Write-Host "Installing 7-zip..."
		winget install 7zip --silent
	}
	else {
		Write-Host "7-zip is already installed on this device."
	}
}

# Install apps from Winstall file (the Winstall.txt file must be on the same directory as CleanWin).
Function Winstall {
$ErrorActionPreference = 'Stop'
	if ($winstall -like "y") {
		Write-Host " "
		# Check if WinGet is installed, then proceed.
		if (Get-Command winget) {
			# Try Winstall.txt
			if (Test-Path Winstall.txt) {
				Write-Host "Starting Winstall..."
				# Get each line from the text file and use winget install command on it.
				Get-Content 'Winstall.txt' | ForEach-Object {
					$App = $_.Split('=')
					Write-Host "    Installing $App..."
					winget install "$App" --silent 
				}
				Write-Host "Winstall has successfully installed the app(s)."
			}
			# Try winstall.txt
			elseif (Test-Path winstall.txt) {
				Write-Host "Starting Winstall..."
				# Get each line from the text file and use winget install command on it.
				Get-Content 'winstall.txt' | ForEach-Object {
					$App = $_.Split('=')
					Write-Host "    Installing $App..."
					winget install "$App" --silent
				}
				Write-Host "Winstall has successfully installed the app(s)."
			}
			else {
				[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
				Write-Host "Select Winstall text file from File Picker UI"
				$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
				$OpenFileDialog.InitialDirectory = $initialDirectory
				$OpenFileDialog.Filter = "Text file (*.txt)| *.txt"
				$OpenFileDialog.ShowDialog() | Out-Null
				if ($OpenFileDialog.FileName) {
					Write-Host "Starting Winstall..."
					Get-Content $OpenFileDialog.FileName | ForEach-Object {
						$App = $_.Split('=')
						Write-Host "    Installing $App..."
						winget install "$App" --silent
					}
					Write-Host "Winstall has successfully installed the app(s)."
				}
				else {
					Write-ost " "
				}
			}
		}
		# Inform user if WinGet is not installed.
		else {
			Write-Host "WinGet is not installed. Please install WinGet first before using Winstall."
			Start-Process "https://bit.ly/Winstall" 
		}
	}
	else {
		# Do nothing.
	}
}

# Enable all experimental features in WinGet.
Function EnableExperimentsWinget {
	if ($enableexperimentswinget -like "y") {
		Write-Host " "
		Write-Host "Turning on all experimental features in WinGet..."
		$currentdir = $(Get-Location).Path
		Set-Location "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\"
		Rename-Item settings.json settings.json.backup
		Start-BitsTransfer "https://raw.githubusercontent.com/CleanWin/Files/main/settings.json"
		Set-Location $currentdir
		Write-Host "Turned on all experimental features in WinGet."
	}
	else {
		# Do nothing.
	}
}


# Use winget import (optional) (part of code used here was picked from https://devblogs.microsoft.com/scripting/hey-scripting-guy-can-i-open-a-file-dialog-box-with-windows-powershell/)
Function WinGetImport {
	if ($wingetimport -like "y") {
		if (Get-Command winget) {
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
		}
		else {
			Write-Host "WinGet is not installed. Please install WinGet first before using winget import."
		}
	}
	else {
		# Do nothing.
	}
}

# Install HEVC.
Function InstallHEVC {
$ProgressPreference = 'SilentlyContinue'
	Write-Host " "
	if (!(Get-AppxPackage -Name Microsoft.HEVCVideoExtension)) {
		$OSArchitecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
		if ($OSArchitecture -like "64-bit") {
			Write-Host "Downloading HEVC Video Extensions..."
			Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.HEVCVideoExtension_1.0.41483.0_x64__8wekyb3d8bbwe.Appx
			Write-Host "Installing HEVC Video Extensions..."
			Add-AppxPackage Microsoft.HEVCVideoExtension_1.0.41483.0_x64__8wekyb3d8bbwe.Appx
			Remove-Item Microsoft.HEVCVideoExtension_1.0.41483.0_x64__8wekyb3d8bbwe.Appx
			Write-Host "Installed HEVC Video Extensions."
		}
		elseif ($OSArchitecture -like "32-bit") {
			Write-Host "Downloading HEVC Video Extensions..."
			Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.HEVCVideoExtension_1.0.41483.0_x86__8wekyb3d8bbwe.Appx
			Write-Host "Installing HEVC Video Extensions..."
			Add-AppxPackage Microsoft.HEVCVideoExtension_1.0.41483.0_x86__8wekyb3d8bbwe.Appx
			Remove-Item Microsoft.HEVCVideoExtension_1.0.41483.0_x86__8wekyb3d8bbwe.Appx
			Write-Host "Installed HEVC Video Extensions."
		}
		else {
			# Error out.
			Write-Host "Could not install HEVC Video Extensions."
		}
	}
	else {
		Write-Host "HEVC Video Extensions are already installed on this device."
	}
}

# Update MicrosoftWindows.Client.WebExperience
Function UpdateWidgets {
	if ($CurrentBuild -ge 22000) {
		$version = (Get-AppxPackage "MicrosoftWindows.Client.WebExperience").Version
		if ($version -lt 421.17400.0.0) {
			Write-Host " "
			Write-Host "Updating Widgets..."
			Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/MicrosoftWindows.Client.WebExperience_421.17400.0.0_neutral___cw5n1h2txyewy.AppxBundle
			Add-AppxPackage MicrosoftWindows.Client.WebExperience_421.17400.0.0_neutral___cw5n1h2txyewy.AppxBundle
			$version = (Get-AppxPackage "MicrosoftWindows.Client.WebExperience").Version
			Remove-Item MicrosoftWindows.Client.WebExperience_421.17400.0.0_neutral___cw5n1h2txyewy.AppxBundle
			if ($version -ge 421.17400.0.0) {
				Write-Host "Updated Widgets."

			}
			else {
				Write-Host "Could not update Widgets."
			}
		}
		else {
			# Do nothing.
		}
	}
	else {
		# Do nothing.
	}
}

# Install fonts (part of code here was picked from https://github.com/code-rgb/CleanWin).
Function InstallFonts {
$ProgressPreference = 'SilentlyContinue'
	Write-Host " "
	# Check if Cascadia Code is installed and inform user.
	$installed = "C:\Windows\Fonts\CascadiaCodePL.ttf"
	if (Test-Path -Path $installed) {
		Write-Host "Cascadia Code is already installed on this device."
	}
	# Install Cascadia Code if not already installed.
	else {
		Write-Host "Downloading the latest release of Cascadia Code..."
		$response = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/cascadia-code/releases/latest"
		Start-BitsTransfer -Source $response.assets.browser_download_url -Destination "CascadiaCode.zip"
		Write-Host "Installing Cascadia Code..."
		Expand-Archive CascadiaCode.zip
		$font = $(Get-ChildItem "CascadiaCode\ttf\CascadiaCodePL.ttf").FullName
		$installed = "C:\Windows\Fonts\CascadiaCodePL.ttf"
		Move-Item $font $installed
		Remove-Item CascadiaCode.zip
		Remove-Item CascadiaCode -Recurse -Force
		Write-Host "Installed Cascadia Code."
	}

}

# Set Windows Photo Viewer association for bmp, gif, jpg, png and tif.
Function SetPhotoViewerAssociation {
	Write-Host " "
	Write-Output "Adding Windows Photo Viewer (classic) to the 'Open with' menu..."
	If (!(Test-Path "HKCR:")) {
		New-PSDrive -Name "HKCR" -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" | Out-Null
	}
	ForEach ($type in @("Paint.Picture", "giffile", "jpegfile", "pngfile")) {
		New-Item -Path $("HKCR:\$type\shell\open") -Force | Out-Null
		New-Item -Path $("HKCR:\$type\shell\open\command") | Out-Null
		Set-ItemProperty -Path $("HKCR:\$type\shell\open") -Name "MuiVerb" -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
		Set-ItemProperty -Path $("HKCR:\$type\shell\open\command") -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
	}
	Write-Output "Added Windows Photo Viewer (classic) to the 'Open with' menu."

}

# Unset Windows Photo Viewer association for bmp, gif, jpg, png and tif.
Function UnsetPhotoViewerAssociation {
	Write-Output "Removing Windows Photo Viewer (classic) from the 'Open with' menu..."
	If (!(Test-Path "HKCR:")) {
		New-PSDrive -Name "HKCR" -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" | Out-Null
	}
	Remove-Item -Path "HKCR:\Paint.Picture\shell\open" -Recurse -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "MuiVerb" -ErrorAction SilentlyContinue
	Set-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "CommandId" -Type String -Value "IE.File"
	Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "(Default)" -Type String -Value "`"$env:SystemDrive\Program Files\Internet Explorer\iexplore.exe`" %1"
	Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "DelegateExecute" -Type String -Value "{17FE9752-0B5A-4665-84CD-569794602F5C}"
	Remove-Item -Path "HKCR:\jpegfile\shell\open" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\pngfile\shell\open" -Recurse -ErrorAction SilentlyContinue
	Write-Host "Removed Windows Photo Viewer association."
}



######################################
######### PRIVACY & SECURITY #########
######################################

# Update status
Function PrivacySecurity {
	Write-Host " "
	Write-Host "-------------------------"
	Write-Host "    PRIVACY & SECURITY   "
	Write-Host "-------------------------"
	Write-Host " "
}


# Disable Activity History.
Function DisableActivityHistory {
	Write-Host " "
	Write-Host "Turning off Activity History..."
	$ActivityFeed = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityFeed -Name "EnableActivityFeed" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "PublishUserActivities" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "UploadUserActivities" -Type DWord -Value 0	
	Write-Host "Turned off Activity History."
}

# Enable Activity History.
Function EnableActivityHistory {
	Write-Host "Turning on Activity History..."
	$ActivityHistory = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityHistory -Name "EnableActivityFeed" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "PublishUserActivities" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "UploadUserActivities" -Type DWord -Value 1
	Write-Host "Turned on Activity History."
}

# Disable Advertising ID.
Function DisableAdvertisingID {
	Write-Host " "
	Write-Host "Turning off Advertising ID..."
	$AdvertisingID = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	If (!(Test-Path $AdvertisingID)) {
		New-Item -Path $AdvertisingID | Out-Null
	}
	Set-ItemProperty -Path $AdvertisingID -Name "DisabledByGroupPolicy" -Type DWord -Value 1
	Write-Host "Turned off Advertising ID."
}

# Enable Advertising ID.
Function EnableAdvertisingID {
	Write-Host "Turning on Advertising ID..."
	$Advertising = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	Remove-ItemProperty -Path $Advertising -Name "DisabledByGroupPolicy" -ErrorAction SilentlyContinue
	Write-Host "Turned on Advertising ID."
}

# Disable Background apps (https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%205.1/Sophia.psm1#L8988-L9033).
Function DisableBackgroundApps {
	Write-Host " "
	Write-Output "Turning off Background apps..."
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
	Write-Host "Turned off Background apps."
}

# Enable Background apps.
Function EnableBackgroundApps {
	Write-Host "Turning on Background apps..."
	Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
		Remove-ItemProperty -Path $_.PsPath -Name * -Force
	}
	Write-Host "Turned on Background apps."
}

# Disable Feedback.
Function DisableFeedback {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Turning off Feedback notifications..."
	$Feedback1 = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	$Feedback2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	$Feedback3 = "Microsoft\Windows\Feedback\Siuf\DmClient"
	$Feedback4 = "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
	If (!(Test-Path $Feedback1)) {
		New-Item -Path $Feedback1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Feedback1 -Name "NumberOfSIUFInPeriod" -Type DWord -Value 1
	If (!(Test-Path $Feedback2)) {
		New-Item -Path $Feedback2 -Force | Out-Null
		}
	Set-ItemProperty -Path $Feedback2 -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName $Feedback3 | Out-Null
	Disable-ScheduledTask -TaskName $Feedback4 | Out-Null
	Write-Host "Turned off Feedback notifications."
}

# Enable Feedback.
Function EnableFeedback {
	Write-Host "Turning on Feedback notifications..."
	$Feedback = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	If (!(Test-Path $Feedback )) {
		New-Item $Feedback -Force | Out-Null
		}
	Remove-ItemProperty -Path $Feedback -Name "NumberOfSIUFInPeriod"
	Write-Host "Turned on Feedback notifications."
}

# Disable inking personalization.
Function DisableInkHarvesting {
	Write-Host " "
	Write-Host "Turning off Inking & typing personalization..."
	$Ink1 = "HKCU:\Software\Microsoft\InputPersonalization"
	$Ink2 = "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore"
	$Ink3 = "HKCU:\Software\Microsoft\Personalization\Settings"
	If (!(Test-Path $Ink1)) {
		New-Item -Path $Ink1 -Force | Out-Null
	}
	New-ItemProperty -Path $Ink1 -Name "RestrictImplicitInkCollection" -Type DWord -Value 1 -Force | Out-Null 
	Set-ItemProperty -Path $Ink2 -Name "HarvestContacts" -Type DWord -Value 0
	Set-ItemProperty -Path $Ink3 -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
	Write-Host "Turned off Inking & typing personalization."
}

# Enable inking personalization. 
Function EnableInkHarvesting {
	Write-Host " "
	Write-Host "Turning on Inking & typing personalization..."
	$Ink1 = "HKCU:\Software\Microsoft\InputPersonalization"
	$Ink2 = "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore"
	$Ink3 = "HKCU:\Software\Microsoft\Personalization\Settings"
	If (!(Test-Path $Ink1)) {
		New-Item -Path $Ink1 -Force | Out-Null
	}
	New-ItemProperty -Path $Ink1 -Name "RestrictImplicitInkCollection" -Type DWord -Value 0 -Force | Out-Null 
	Set-ItemProperty -Path $Ink2 -Name "HarvestContacts" -Type DWord -Value 1
	Set-ItemProperty -Path $Ink3 -Name "AcceptedPrivacyPolicy" -Type DWord -Value 1
	Write-Host "Turned on Inking & typing personalization."
}

# Disable "Let websites provide locally relevant content by accessing my language list".
Function DisableLangAccess {
	Write-Host " "
	Write-Host "Turning off websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Remove-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 1 | Out-Null
	Write-Host "Turned off websites' ability to provide you with locally relevant content by accessing your language list."
}

# Enable "Let websites provide locally relevant content by accessing my language list".
Function EnableLangAccess {
	Write-Host "Turning on websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Set-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 0
	Write-Host "Turned on websites' ability to provide you with locally relevant content by accessing your language list."
}

# Disable Location Tracking.
Function DisableLocationTracking {
	Write-Host " "
	Write-Host "Turning off location tracking..."
	$Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	$Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
	If (!(Test-Path $Location1)) {
		New-Item -Path $Location1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Deny"
	Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 0
	Write-Host "Turned off Location tracking."
}

# Enable location tracking.
Function EnableLocationTracking {
	Write-Host " "
	Write-Host "Turning on Location tracking..."
	$Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	$Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
	If (!(Test-Path )) {
		New-Item -Path $Location1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Allow"
	Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 1
	Write-Host "Turned on Location tracking."
}

# Disable automatic Maps updates.
Function DisableMapUpdates {
	Write-Host " "
	Write-Host "Turning off automatic Maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
	Write-Host "Turned off automatic Maps updates."
}

# Enable maps updates.
Function EnableMapsUpdates {
	Write-Host " "
	Write-Host "Turning on automatic Maps updates..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled"
	Write-Host "Turned on automatic Maps updates."
}

# Disable Speech Recognition.
Function DisableSpeechRecognition {
	Write-Host " "
	Write-Host "Turning off Online Speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	If (!(Test-Path $Speech)) {
		New-Item -Path $Speech -ErrorAction SilentlyContinue | Out-Null
	}
	Remove-ItemProperty -Path $Speech -Name "HasAccepted" -ErrorAction SilentlyContinue
	New-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 0 -ErrorAction SilentlyContinue | Out-Null
	Write-Host "Turned off Online Speech recognition."
}

# Enable speech recognition. 
Function EnableSpeechRecognition {
	Write-Host " "
	Write-Host "Turning on Speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	If (!(Test-Path )) {
		New-Item -Path $Speech | Out-Null
		}
	Set-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 1
	Write-Host "Turned on Online Speech recognition"
}

# Disable Tailored experiences.
Function DisableTailoredExperiences {
	Write-Host " "
	Write-Host "Turning off Tailored experiences..."
	$CloudContent = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	If (!(Test-Path $CloudContent )) {
		New-Item $CloudContent -Force | Out-Null
		}
	Set-ItemProperty -Path $CloudContent -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
	Write-Host "Turned off Tailored experiences."
}

# Enable Tailored experiences.
Function EnableTailoredExperiences {
	Write-Host " "
	Write-Host "Turning on Tailored experiences..."
	$TailoredExp1 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	$TailoredExp2 = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
	$TailoredExp3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Remove-ItemProperty -Path $TailoredExp1 -Name "DisableTailoredExperiencesWithDiagnosticData" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $TailoredExp2 -Name "Disabled" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $TailoredExp3 -Name "DoNotShowFeedbackNotifications" -ErrorAction SilentlyContinue
	Write-Host "Turned on Tailed experiences."
}

# Disable Telemetry. 
Function DisableTelemetry {
	Write-Host " "
	Write-Host "Turning off telemetry..."
	$DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$DataCollection2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$DataCollection3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Set-ItemProperty -Path $DataCollection1 -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path $DataCollection2 -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path $DataCollection3 -Name "AllowTelemetry" -Type DWord -Value 0
	Write-Host "Turned off telemetry."
}

# Enable Telemetry.
Function EnableTelemetry {
	Write-Host " "
	Write-Host "Turning on Telemetry..."
	$Telemetry1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Set-ItemProperty -Path $Telemetry1  -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry2 -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry3 -Name "AllowTelemetry" -Type DWord -Value 3
	Write-Host "Turned off telemetry."
}

# Enable Clipboard History.
Function EnableClipboard {
	Write-Host " "
	Write-Host "Turning on Clipboard History..."
	$Clipboard = "HKU:\S-1-5-21-*\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Value 1 -ErrorAction SilentlyContinue
	Write-Host "Turned on Clipboard History."
    Start-Sleep 1
    Set-Clipboard "Demo text by CleanWin."
	Write-Host "You can now copy multiple items to your clipboard."
    Write-Host "Access your clipboard now using Windows key + V."
}

# Disable Clipboard History.
Function DisableClipboard {
	Write-Host " "
	Write-Host "Turning off Clipboard History..."
	$Clipboard = "HKU:\S-1-5-21-*\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Value 0 -ErrorAction SilentlyContinue
	Write-Host "Turned off Clipboard History."
}

Function AutoLoginPostUpdate {
	Write-Host " "
	Write-Host "Turning on automatic login post updates..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent" -Type DWord -Value 1
	Write-Host "Turned on Automatic login applying updates"
} 

Function StayOnLockscreenPostUpdate {
	Write-Host " "
	Write-Host "Turning off automatic login post updates..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent"
	Write-Host "Turned off Automatic login after applying updates."
}



####################################
######### TASKS & SERVICES #########
####################################

# Update status.
Function TasksServices {
	Write-Host " "
	Write-Host " "
	Write-Host "---------------------------"
	Write-Host "      TASKS & SERVICES     "   
	Write-Host "---------------------------"
	Write-Host " "
}

# Disable Autoplay.
Function DisableAutoplay {
	Write-Host " "
	Write-Host "Turning off AutoPlay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
	Write-Host "Turned off AutoPlay."
}

# Enable Autoplay.
Function EnableAutoplay {
	Write-Host " "
	Write-Host "Turning on Autoplay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
	Write-Host "Turned on AutoPlay."
}

# Disable Autorun for all drives.
Function DisableAutorun {
	Write-Host " "
	Write-Host "Turning off Autorun for all drives..."
	$Autorun = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	If (!(Test-Path $Autorun)) {
		New-Item -Path $Autorun | Out-Null
		}
	Set-ItemProperty -Path $Autorun -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
	Write-Host "Turned off Autorun for all drives."
}

# Enable Autorun for removable drives.
Function EnableAutorun {
	Write-Host " "
	Write-Host "Turning on Autorun for all drives..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
	Write-Host "Turned on Autorun for all drives."
}

# Set BIOS time to UTC.
Function SetBIOSTimeUTC {
	Write-Host " "
	Write-Host "Setting BIOS time to UTC..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
	Write-Host "BIOS Time is set to UTC."
}

# Set BIOS time to local time.
Function SetBIOSTimeLocal {
	Write-Host " "
	Write-Host "Setting BIOS time to Local time..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -ErrorAction SilentlyContinue
	Write-Host "BIOS Time is set to Local time."
}

# Enable Num lock on startup.
Function EnableNumLock {
	Write-Host " "
	Write-Host "Setting Num lock to turn on autoamtically on Startup..."
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force | Out-Null
	Write-Host "Num lock will turn on automatically on Startup."
}

# Disable Num lock on startup.
Function DisableNumLock {
	Write-Host " "
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483648 -Force | Out-Null
	Write-Host "Num lock will no longer turn on automatically on Startup."
}

# Enable Storage Sense. 
Function EnableStorageSense {
	Write-Host " "
	Write-Host "Turning on Storage Sense..."
	$EnableStorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $EnableStorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $EnableStorageSense -Name 01 -PropertyType DWord -Value 1 -Force | Out-Null
	Write-Host "Turned on Storage Sense."
}

# Disable Storage Sense.
Function DisableStorageSense {
	Write-Host " "
	Write-Host "Turning off Storage Sense..."
	$DisableStorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $DisableStorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $DisableStorageSense -Name 01 -PropertyType DWord -Value 0 -Force | Out-Null
	Write-Host "Turned off Storage Sense."
}

# Disable Reserved Storage. 
Function DisableReservedStorage {
	Write-Host " "
	Write-Host "Turning off Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 0
	Write-Host "Turned off Reserved Storage."
}

# Enable Reserved Storage. 
Function EnableReservedStorage {
	Write-Host " "
	Write-Host "Turning on Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 1
	Write-Host "Turned on Reserved Storage."
}

# Disable unnecessary services.
Function DisableServices {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Turning off unnecessary services..."
    	$Services = @(
		"DiagTrack"
		"SysMain"
    )
    ForEach ($Service in $Services) {
		Stop-Service $Service | Out-Null
		Set-Service $Service -StartupType Disabled
		Write-Host "    Stopped service: $Service."
	}
	Write-Host "Turned off unnecesarry services."
}

# Enable unnecessary services.
Function EnableServices {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Turning on unnecessary services..."
    	$Services = @(
		"DiagTrack"
		"SysMain"
    )
    ForEach ($Service in $Services) {
		Start-Service $Service | Out-Null
		Set-Service $Service -StartupType Automatic
		Write-Host "    Started service: $Service."
	}
	Write-Host "Turned on redundant services."
}

# Disable unnecessary scheduled tasks.
Function DisableTasks {
	Write-Host " "
	Write-Host "Turning off unnecessary tasks..."
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
		Write-Host "    Turned off task: $Task."
	}
    Write-Host "Turned off unnecessary tasks."
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
		Write-Host "    Turned on task: $Task."
	}
    Write-Host "Turned on redundant tasks."
}

# Intelligently setup Windows Update policies.
Function SetupWindowsUpdate {
	Write-Host " "
	if ($CurrentBuild -lt 22000) {
	# Get Windows Edition, if its Professional, Education, or Enterprise.
    if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) {
			Write-Host "Setting up Windows Update policies..."

			# Declare registry keys locations.
			$Update1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
			$Update2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
			if (!(Test-Path $Update1)) {
				New-Item -Path $Update1 | Out-Null
				New-Item -Path $Update2 | Out-Null
			}

			# Write registry values.
			Set-ItemProperty -Path $Update1 -Name DeferQualityUpdates -Type DWord -Value 1
			Set-ItemProperty -Path $Update1 -Name DeferQualityUpdatesPeriodInDays -Type DWord -Value 4
			Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdates -Type DWord -Value 1
			Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 20
			Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
			Set-ItemProperty -Path $Update2 -Name NoAutoRebootWithLoggedOnUsers -Type Dword -Value 1

			# Print user message; policies applied.
			$WinUpdatePolicies =@(
				"Turned off automatic updates"
				"Device will no longer auto restart if users are signed in"
				"Turned off re-installation of apps after Windows Updates"
				"Delayed quality updates by 4 days"
				"Delayed feature updates by 20 days"
			)
			ForEach ($WinUpdatePolicy in $WinUpdatePolicies) {
				Write-Host "    - $WinUpdatePolicy"
			}

			Write-Host "Set up Windows Update policies."

		}

		# Print user message if unsupported edition.
		else {
			Write-Host "You are running an edition of Windows that does not support setting up Windows Update policies."
			Write-Host "Could not set up Windows Update policies."
		}
	}
	
	elseif ($CurrentBuild -ge 22000) {
		Write-Host "CleanWin currently cannot set up Windows Update policies on Windows 11."
	}

	else {
        # Do nothing.
    }
}

# Reset all Windows Update policies
Function ResetWindowsUpdate {
    Write-Host " "
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse
    Write-Host "All Windows Update policies were reset."
}

# A simple registry edit that fixes an issue where a small batch of devices turn back on after powering down.
Function EnablePowerdownAfterShutdown {
	Write-Host " "
	Write-Host "Enabling full powerdown on shut down..."
	Write-Host "This is known to fix issues where some PCs might boot up without user input after shutdown."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 1
	Write-Host "Enabled full power down on shut down."
}

# Revert the EnablePowerdownAfterShutdown edit.
Function DisablePowerdownAfterShutdown {
	Write-Host " "
	Write-Host "Disabling full powerdown on shut down..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 0
	Write-Host "Disabled full powerdown on shut down."
}



####################################
######### WINDOWS EXPLORER #########
####################################

# Update status: Explorer Changes.
Function PrintExplorerChanges {	
	Write-Host " "
	Write-Host " "
	Write-Host "----------------------------------"
	Write-Host "          WINDOWS EXPLORER        "
	Write-Host "----------------------------------"
	Write-Host " "
}

# Use Print screen button to open screen skipping.
Function EnablePrtScrToSnip {
	Write-Host " "
	Write-Host "Binding Print Screen key to launch Snip overlay..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 1
	Write-Host "Bound Print Screen key to launch Snip overlay."
	Start-Sleep -Milliseconds 200
}
	
# Don't use Print screen button to open screen skipping.
Function DisablePrtScrSnip {
	Write-Host " "
	Write-Host "Unbinding Snip overlay launch from Print screen key...."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 0
	Write-Host "Unbound Snip overlay launch from Print screen key."
}

# Disable Sticky keys.
Function DisableStickyKeys {
	Write-Host " "
	Write-Host "Turning off Sticky keys..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
	Write-Host "Turned off Sticky keys."
	Start-Sleep -Milliseconds 200
}

# Enable Sticky keys.
Function EnableStickyKeys {
	Write-Host " "
	Write-Host "Turning on Sticky keys..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
	Write-Host "Turned on Sticky keys."
}

# Change default File Explorer view to This PC.
Function SetExplorerThisPC {
	Write-Host " "
	Write-Host "Setting default File Explorer view to This PC..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
	Write-Host "Set default File Explorer view to This PC."
	Start-Sleep -Milliseconds 200
}

# Change default File Explorer view to Quick Access.
Function SetExplorerQuickAccess {
	Write-Host " "
	Write-Host "Setting default File Explorer view to Quick Access..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -ErrorAction SilentlyContinue
	Write-Host "Set default File Explorer view to Quick Access."
}

# Hide 3D Objects.
Function Hide3DObjects {
	if ($CurrentBuild -lt 22000) {
		Write-Host " "
		Write-Host "Turning off 3D Objects..."
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
		$Hide3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
		$Hide3DObjects2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
		If (!(Test-Path $Hide3DObjects1)) {
			New-Item -Path $Hide3DObjects1 -Force | Out-Null
			}
		Set-ItemProperty -Path $Hide3DObjects1 -Name "ThisPCPolicy" -Type String -Value "Hide"
		If (!(Test-Path $Hide3DObjects2)) {
			New-Item -Path $Hide3DObjects2 -Force | Out-Null
			}
		Set-ItemProperty -Path $Hide3DObjects2 -Name "ThisPCPolicy" -Type String -Value "Hide"
		Write-Host "Turned off 3D Objects."
		Start-Sleep -Milliseconds 200
	}
	else {
		# Do nothing
	}
}

# Restore 3D Objects.
Function Restore3DObjects {
	if ($CurrentBuild -lt 22000) {
		Write-Host " "
		Write-Host "Turning on 3D Objects..."
		$Restore3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
		$Restore3DObjects2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
		$Restore3DObjects3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
		if (!(Test-Path $Restore3DObjects1)) {
			New-Item -Path $Restore3DObjects1 | Out-Null
		}
		Remove-ItemProperty -Path $Restore3DObjects2 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path $Restore3DObjects3 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
		Write-Host "Turned on 3D Objects."
	}
	else {
		# Do nothing
	}
}

# Hide Search bar from taskbar.
Function HideSearchBar {
	if ($CurrentBuild -lt 22000) {
		Write-Host " "
		Write-Host "Turning off Search bar..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
		Write-Host "Turned off Search bar."
		Start-Sleep -Milliseconds 200
	}
	elseif ($CurrentBuild -ge 22000) {
		Write-Host " "
		Write-Host "Turning off Search icon..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
		Write-Host "Turned off Search icon."
		Start-Sleep -Milliseconds 200
	}
	else {
		# Do nothing.
	}
}

# Restore Search bar to taskbar.
Function RestoreSearchBar {
	if ($CurrentBuild -lt 22000) {
		Write-Host " "
		Write-Host "Turning on Search bar..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 2
		Write-Host "Turned on Search bar."
		Start-Sleep -Milliseconds 200
	}
	elseif ($CurrentBuild -ge 22000) {
		Write-Host " "
		Write-Host "Turning off Search icon..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 1
		Write-Host "Turned off Search icon."
		Start-Sleep -Milliseconds 200
	}
	else {
		# Do nothing.
	}
}

# Hide Task View.
Function HideTaskView {
	Write-Host " "
	Write-Host "Turning off Task view icon..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
	Write-Host "Turned off Task view icon."
	Start-Sleep -Milliseconds 200
}

# Restore Task View button.
Function RestoreTaskView {
	Write-Host " "
	Write-Host "Turning on Task view icon..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
	Write-Host "Turned on Task view icon."
}

# Hide Cortana icon from taskbar.
Function HideCortana {
	if ($CurrentBuild -lt 22000) {
		Write-Host " "
		Write-Host "Turning off Cortana icon..."
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
		Write-Host "Turned off Cortana icon."
		Start-Sleep -Milliseconds 200
	}
	else {
		# Do nothing
	}
}

# Restore Cortana button in taskbar.
Function RestoreCortana {
	if ($CurrentBuild -lt 22000) {
		Write-Host " "
		Write-Host "Turning on Cortana icon..."
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1
		Write-Host "Turned on Cortana icon."
	}
	else {
		# Do nothing
	}
	Start-Sleep -Milliseconds 200
}

# Hide Meet Now icon from tray.
Function HideMeetNow {
	if ($CurrentBuild -lt 22000) {
		Write-Host " "
		Write-Host "Turning off Meet now..."
        $Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        $Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 1
        Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
		Write-Host "Turned off Meet now."
		Start-Sleep -Milliseconds 200
	}
	else {
		# Do nothing
	}
}

# Restore Meet Now icon on tray.
Function RestoreMeetNow {
	if ($CurrentBuild -lt 22000) {
		Write-Host " "
		Write-Host "Turning on Meet now..."
        $Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        $Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 0
        Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
		Write-Host "Turned on Meet now."
	}
	else {
		# Do nothing
	}
	Start-Sleep -Milliseconds 200
}

# Turn off News and interests feed.
Function DisableTaskbarFeed {
	if ($CurrentBuild -lt 22000) {
		Write-Host " "
		Write-Host "Turning off News and interests..."
		$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
		$Feed2 = "HKU:\S-1-5-21-*\Software\Microsoft\Windows\CurrentVersion\Feeds"
		Set-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 2 | Out-Null
		Set-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 2 | Out-Null
		Write-Host "Turned off News and interests."
	}
	else {
		# Do nothing
	}
	Start-Sleep 2
}

# Turn on News and interests feed.
Function EnableTaskbarFeed {
	if ($CurrentBuild -lt 22000) {
		Write-Host " "
		Write-Host "Turning on News and interests..."
		$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
		$Feed2 = "HKU:\S-1-5-21-*\Software\Microsoft\Windows\CurrentVersion\Feeds"
		Set-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 0 | Out-Null
		Set-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 0 | Out-Null
		Write-Host "Turned on News and interests."
	}
	else {
		# Do nothing
	}
	Start-Sleep 2
}

# Remove created PSDrives
Remove-PSDrive -Name HKCR
Remove-PSDrive -Name HKU
$host.UI.RawUI.WindowTitle = $currenttitle

######### Tasks after successful run #########

# Update status: CleanWin execution successful.
Function Success {
	Stop-Process -Name explorer -Force
	Start-Sleep 3
	Write-Host "CleanWin has finished working."
	Write-Host "This PC is set to restart in 10 seconds, please close this window if you want to halt the restart."
	Write-Host "Thank you for using CleanWin."
	Start-Sleep 10
	Restart-Computer
}

# Call the desired functions.
$tasks | ForEach-Object { Invoke-Expression $_ }
