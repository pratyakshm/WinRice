# This file is a part of the CleanWin software
# Copyright (c) 2021 PratyakshM <pratyakshm@protonmail.com>
# All rights reserved.

# Default preset
$tasks = @(

### Maintenance Tasks ###
 	"Setup",
	"CleanWin",
	"ProductInformation",
	"InternetStatus",
	"CreateSystemRestore",
	"Activity",

### Apps & Features ###
	"AppsFeatures",
	"DebloatApps", "Activity", "UnpinStartTiles", "Activity", "UnpinAppsFromTaskbar", "Activity", "InstallWinGet", "UninstallOneDrive", "CleanupRegistry", "Activity",
	"DisableBrowserRestoreAd",      # "EnableBrowserRestoreAd",
	"UninstallFeatures", "Activity", "EnableWSL", "Activity", "EnabledotNET3.5", "Activity", # "EnableSandbox",
	"Install7zip", "Winstall", "InstallHEVC", "InstallFonts", "SetPhotoViewerAssociation", # "SetPhotoViewerAssociation",
	"ChangesDone",

### Privacy & Security ###
	"PrivacySecurity",
	"DisableActivityHistory",		# "EnableActivityHistory",
	"DisableAdvertisingID",			# "EnableAdvertisingID",
	"DisableBackgroundApps",      # "EnableBackgroundApps",
	"DisableFeedback",		        # "EnableFeedback",
	"DisableInkHarvesting",			# "EnableInkHarvesting",
	"DisableLangAccess",  		    # "EnableLangAccess",
	"DisableLocationTracking",      # "EnableLocationTracking",
	"DisableMapUpdates",			# "EnableMapsUpdates",
	"DisableSuggestions",		    # "EnableSuggestions",
	"DisableSpeechRecognition",		# "EnableSpeechRecognition",
	"DisableTailoredExperiences",	# "EnableTailoredExperiences",
	"DisableTelemetry",				# "EnableTelemetry",
	"EnableClipboard",				# "DisableClipboard",
	"AutoLoginPostUpdate", 		    # "StayOnLockscreenPostUpdate",
	"DisableMeltdownCompatFlag",    # "EnableMeltdownCompatFlag",
	"ChangesDone",

### Tasks & Services ###
	"TasksServices",
	"DisableStorageSense",		   # "EnableStorageSense",
	"DisableReservedStorage",	   # "EnableReservedStorage",
	"DisableAutoplay",             # "EnableAutoplay",
	"DisableAutorun",              # "EnableAutorun",
	"SetBIOSTimeUTC",              # "SetBIOSTimeLocal",
	"EnableNumLock",			   # "DisableNumLock",
	"DisableServices",			   # "EnableServices",
	"DisableTasks",				   # "EnableTasks",
	"SetupWindowsUpdate",		   # "ResetWindowsUpdate",
	"EnablePowerdownAfterShutdown", # "DisablePowerdownAfterShutdown",
	"ChangesDone",

### Windows Explorer ###
	"PrintExplorerChanges",
	"EnablePrtScrToSnip",		   # "DisablePrtScrSnip",
	"DisableStickyKeys",           # "EnableStickyKeys",
	"SetExplorerThisPC",           # "SetExplorerQuickAccess",
    "Hide3DObjectsInThisPC",       # "Restore3DObjectsInThisPC",
	"Hide3DObjectsInExplorer",     # "Restore3DObjectsInExplorer",
	"ExpandRibbonInExplorer",	   # "MinimizeRibbonInExplorer",
	"HideSearchBar",			   # "RestoreSearchBar"
	"HideTaskView",                # "RestoreTaskView",
	"HideCortana",			       # "RestoreCortana",
	"HideMeetNow",				   # "RestoreMeetNow",
	"DisableTaskbarFeed",		   # "EnableTaskbarFeed",
	"ChangesDone",

###  Tasks after successful run ###
	"Activity",
	"RestartPC"
)


### Maintenance tasks ###

# CleanWin
Function CleanWin {
	$host.UI.RawUI.WindowTitle = "pratyakshm's CleanWin"
	Clear-Host
	Write-Host " "
	Write-Host "                                        pratyakshm's CleanWin"
	Start-Sleep 1
}

# Set ExecutionPolicy to Unrestricted for session
Function Setup {
	Set-ExecutionPolicy Unrestricted -Scope Process
}

# Product Information 
Function ProductInformation {
	Write-Host " "
	Write-Host "OS Build info:"
	Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name ProductName, ReleaseId, DisplayVersion, BuildLab
	$winver = Get-ItemPropertyValue  'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name ProductName
	if ( $winver -match "Windows 11" ) {
		Write-Host " "
		Write-Host "This PC is detected to be running Windows 11."
		Write-Host "Please note that CleanWin's Windows 11 support is experimental and you might face issues."
	}
	Start-Sleep 2
	Write-Host " "
	Write-Host " "
	Write-Host " "
	Write-Host " "
}

# Changes performed
Function ChangesDone {
	Write-Host " "
	Write-Host "---------------------------"
	Write-Host "     CHANGES PERFORMED     "
	Write-Host "---------------------------"
	Write-Host " "
	Start-Sleep 1
}

# Test internet connection
Function InternetStatus {
	Write-Host " "
	Write-Host "Checking connectivity to the internet..."
	$result = Test-NetConnection github.com
	if( $result.PingSucceeded ) {
	  Write-Host "This PC is connected."
		} 
	else {
	  Write-Host "Can't connect to GitHub. Some features that require an internet connection will not work."
	}
}

# Create a system restore point with type MODIFY_SETTINGS, silently continue if already created within the past 24 hours
Function CreateSystemRestore {
	Write-Host " "
	Write-Host "Creating a system restore point with type MODIFY_SETTINGS..."
	Enable-ComputerRestore -Drive "C:\"
	Checkpoint-Computer -Description "RestorePoint1" -RestorePointType "MODIFY_SETTINGS" -WarningAction SilentlyContinue
	Write-Host "Created system restore point."
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
	Write-Host " "
	Write-Host "-------------------------"
	Write-Host "     APPS & FEATURES     "
	Write-Host "-------------------------"
	Write-Host " "
}

# Debloat apps.
Function DebloatApps {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host "Removing all bloatware..."
	# Inbox UWP apps.
	Write-Host "    Uninstalling unnecessary UWP apps..."
	$Bloatware = @(
	"Microsoft.549981C3F5F10"
	"Microsoft.BingNews"
	"Microsoft.BingWeather"
	"Microsoft.GamingApp"
	"Microsoft.GamingServices" 
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
	"Microsoft.Paint"
	"Microsoft.People" 
	"Microsoft.PowerAutomateDesktop"
	"Microsoft.Print3D" 
	"Microsoft.SkypeApp"
	"Microsoft.StorePurchaseApp" 
	"Microsoft.Todos"
	"Microsoft.WindowsAlarms"
	"Microsoft.WindowsCamera"
	"Microsoft.WindowsCommunicationsApps" 
	"Microsoft.WindowsFeedbackHub" 
	"Microsoft.WindowsMaps" 
	"Microsoft.WindowsSoundRecorder"
	"Microsoft.XboxApp"
	"Microsoft.XboxGamingOverlay"
	"Microsoft.YourPhone"
	"Microsoft.ZuneMusic"
	"Microsoft.ZuneVideo"

	# Sponsored Apps
	"*EclipseManager*"
	"*ActiproSoftwareLLC*"
	"*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
	"*Duolingo-LearnLanguagesforFree*"
	"*PandoraMediaInc*"
	"*CandyCrush*"
	"*BubbleWitch3Saga*"
	"*Wunderlist*"
	"*Flipboard*"
	"*Twitter*"
	"*Facebook*"
	"*Spotify*"
	"*Minecraft*"
	"*Royal Revolt*"
	"*Sway*"
	"*Speed Test*"
	"*Dolby*"
	)
	foreach ($Bloat in $Bloatware) {
		Get-AppxPackage -Name $Bloat| Remove-AppxPackage 
		Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online | Out-Null
	}
	Write-Host "    Uninstalled unnecessary UWP apps."

    # Remove Office webapps shortcuts.
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Outlook.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk"
	Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Word.lnk"
	Write-Host "    Removed Office Online web-app shortcuts."


	# Uninstall Connect app.
	Import-Module BitsTransfer
	Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/install_wim_tweak.exe
	Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/connect.cmd
	./connect.cmd | Out-Null
	Remove-Item install_wim_tweak.exe
	Remove-Item connect.cmd
	Remove-Item Packages.txt

	Write-Host "Removed all bloatware."
}


# Unpin all start menu tiles
Function UnpinStartTiles {
	Write-Host " "
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

# Unpin Apps from Taskbar (https://docs.microsoft.com/en-us/answers/questions/214599/unpin-icons-from-taskbar-in-windows-10-20h2.html)
Function UnpinAppsFromTaskbar {
	Write-Host " "
	Write-Host "Unpinning apps from Taskbar..."
	$AppNames = @(
		"Microsoft Store"
		"Office"
		"Xbox"
		"Mail"
	)
	ForEach ($AppName in $AppNames) {
		if ( $App = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object { $_.Name -eq $AppName })) {
			$App.Verbs() | Where-Object { $_.Name.replace('&', '') -match 'Unpin from taskbar' } | ForEach-Object { $_.DoIt(); $exec = $true } -ErrorAction SilentlyContinue | Out-Null
		}	
	}
	Write-Host "Unpinned apps from Taskbar."
}

# Install WinGet
Function InstallWinGet {
    $ErrorActionPreference = "Ignore"
	Write-Host " "
	# Import BitsTransfer module, ping GitHub - if success, proceed with installation, else print no connection message.
	Import-Module BitsTransfer
	$result = Test-NetConnection github.com 	
	if( $result.PingSucceeded ) {
		Write-Host "Downloading Windows Package Manager installation packages..."
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
		# Hash the files, if hashes match, begin installation or write warning.
		$filehash1 =(Get-FileHash "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle" -Algorithm SHA256).Hash
	    $filehash2 = (Get-FileHash "Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx" -Algorithm SHA256).Hash
			if ( ($filehash1 -eq "CEE94DB96EB0995BA36FAA3D6417CA908C368A2829D4F24791D96D83BDE6F724") -and ($filehash2 -eq "6602159C341BAFEA747D0EDF15669AC72DF8817299FBFAA90469909E06794256") ) {
				Write-Host "Successfully verified package hashes."
				Write-Host "Installing Windows Package Manager..."
				Add-AppxPackage -Path .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -DependencyPath .\Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
				Remove-Item Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle
				Remove-Item Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
				Write-Host "Installed Windows Package Manager."
			}
			else {
				Write-Host "Package hashes mismatch. Windows Package Manager won't be installed."
			}
		}
	else {
		Write-Host "Could not connect to the internet. Windows Package Manager can't be installed."
	}
}

Function UninstallOneDrive {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Uninstalling Microsoft OneDrive..."
	$OneDriveKey = 'HKLM:Software\Policies\Microsoft\Windows\OneDrive'
	If (!(Test-Path $OneDriveKey)) {
		mkdir $OneDriveKey | Out-Null
		Set-ItemProperty $OneDriveKey -Name OneDrive -Value DisableFileSyncNGSC
		}
	Set-ItemProperty $OneDriveKey -Name OneDrive -Value DisableFileSyncNGSC
	New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
	$onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
	$ExplorerReg1 = "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
	$ExplorerReg2 = "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
	Stop-Process -Name "OneDrive*"
	Start-Sleep 2
	If (!(Test-Path $onedrive)) {
		$onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
	}
	Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
	If (Test-Path "$env:USERPROFILE\OneDrive") {
		Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
	}
	If (Test-Path "$env:LOCALAPPDATA\Microsoft\OneDrive") {
		Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
	}
	If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive") {
		Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
	}
	If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") {
		Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
	}
	If (!(Test-Path $ExplorerReg1)) {
		New-Item $ExplorerReg1 | Out-Null
	}
	Set-ItemProperty $ExplorerReg1 System.IsPinnedToNameSpaceTree -Value 0 
	If (!(Test-Path $ExplorerReg2)) {
		New-Item $ExplorerReg2 | Out-Null
	}
	Set-ItemProperty $ExplorerReg2 System.IsPinnedToNameSpaceTree -Value 0

	# Microsoft OneDrive 64-bit.
	Remove-Item "%LocalAppData%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
	Remove-Item "%LocalAppData%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json.backup" -ErrorAction SilentlyContinue
	Start-BitsTransfer -Source "https://raw.githubusercontent.com/CleanWin/Files/main/settings.json" -Destination "%LocalAppData%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
	winget uninstall OneDriveSetup.exe | Out-Null
	Remove-Item env:OneDrive

	Write-Host "Uninstalled Microsoft OneDrive."
}

Function CleanupRegistry {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Deleting unnecessary registry keys..."
    	$Keys = @(
		New-PSDrive HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
        # Remove Background Tasks.
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
        # Windows File
        "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            
        # Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage.
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
        # Scheduled Tasks to delete.
        "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            
        # Windows Protocol Keys.
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
               
        # Windows Share Target.
        "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    )
        
    # Delete the keys.
    ForEach ($Key in $Keys) {
		Remove-Item $Key -Recurse
	}
	Write-Host "Deleted unnecessary registry keys."
}

# Enable Startup boost in Microsoft Edge
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

# Disable Startup boost in Microsoft Edge
Function DisableEdgeStartupBoost {
	Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Recurse
}

# Disable "Web Browsing - Restore recommended promo in Settings"
Function DisableBrowserRestoreAd {
	Write-Host " "
    Import-Module BitsTransfer 
    Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Albacore.ViVe.dll
	Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/ViVeTool.exe
    If (Test-Path ViVeTool.exe) {
        Write-Host "Turning off 'Web browsing: Restore recommended' suggestion from Settings..."
		./ViVeTool.exe delconfig 23531064 1 | Out-Null
		Remove-Item ViVeTool.exe
		Remove-Item Albacore.ViVe.dll
        Write-Host "Turned off 'Web browsing: Restore recommended' suggestion from Settings."
	} 
	else {
	  Write-Host "Could not connect to the internet. Browser Restore recommendation won't be turned off."
	}
}

Function EnableBrowserRestoreAd {
	Write-Host " "
    Import-Module BitsTransfer 
    Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Albacore.ViVe.dll
	Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/ViVeTool.exe
    If (Test-Path ViVeTool.exe) {
		./ViVeTool.exe addconfig 23531064 0 | Out-Null
		Remove-Item ViVeTool.exe
		Remove-Item Albacore.ViVe.dll
        Write-Host "Turned on 'Web browsing: Restore recommended' suggestion from Settings."
	} 
	else {
	  Write-Host "Could not connect to the internet. Browser Restore recommendation won't be turned on."
	}
}

# Uninstall Features
Function UninstallFeatures {
    Write-Host " "
    Write-Host "Disabling and uninstalling unnecessary features..."
	# Uninstall capabilities
    $Capabilities = @(
		"App.StepsRecorder*"
		"App.Support.QuickAssist*"
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
		Remove-WindowsCapability -Name $Capability -Online | Out-Null
	}
	# Print user friendly list of capabilities uninstalled
    $CapLists =@(
        "Math Recognizer"
		"Microsoft Paint"
		"Quick Assist"
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
        Write-Host "    - Uninstalled $CapList"
    }

	# Uninstall Optional features.
    $OptionalFeatures = @(
        "WorkFolders-Client*"
        "Printing-XPSServices-Feature*"
    )
    ForEach ($OptionalFeature in $OptionalFeatures) {
        Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq $OptionalFeature } | Disable-WindowsOptionalFeature -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
    }
    Write-Host "    - Disabled Work Folders Client."

    Write-Host "Finished disabling and uninstalling unnecessary features."
}

# Enable WSL
Function EnableWSL {
    Write-Host " "
    # Import BitsTransfer module, ping github - if success, enable WSL, else print no connection message.
    Import-Module BitsTransfer 
	$result = Test-NetConnection github.com
	if( $result.PingSucceeded ) {
        Write-Host "Enabling Windows Subsystem for Linux..."
        Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart -WarningAction Ignore | Out-Null
        Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -Online -All -NoRestart -WarningAction Ignore | Out-Null
        Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -Online -All -NoRestart -WarningAction Ignore | Out-Null
        Write-Host "Enabled Windows Subsystem for Linux."
    } 
    else {
        Write-Host "Could not connect to the internet. WSL won't be enabled."
    }
}

# Enable Sandbox
Function EnableSandbox {
	Write-Host " "
	Write-Host "Enabling Windows Sandbox..."
	Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart -WarningAction Ignore | Out-Null
	Write-Host "Enabled Windows Sandbox."
}

# Enable dotNET 3.5
Function EnabledotNET3.5 {
	Write-Host " "
	# Ping github - if success, enable WSL, else print no connection message.
	$result = Test-NetConnection github.com
	if( $result.PingSucceeded ) {
		Write-Host "Enabling dotNET 3.5..."
		Dism /online /Enable-Feature /FeatureName:NetFx3 /NoRestart /Quiet
		Write-Host "Enabled dotNET 3.5"
	}
	Else {
		Write-Host "Could not connect to the internet. dotNET 3.5 runtime won't be enabled."
	}
}

# Install 7zip
Function Install7zip {
	Write-Host " "
	$7zip = "HKLM:\SOFTWARE\7-Zip"
	If (!(Test-Path $7zip)) {
		Write-Host "Installing 7-zip..."
		winget install 7zip
	}
	else {
		Write-Host "7-zip is already installed on this device."
	}
}

# Install apps from Winstall file (the Winstall.txt file must be on the same directory as CleanWin)
Function Winstall {
    $ErrorActionPreference = "Stop"
    Write-Host " "
	# Check if WinGet is installed, then proceed.
    try {if(Get-Command winget) {
		if (Test-Path Winstall.txt) {
			Write-Host "Starting Winstall..."
			Get-Content 'Winstall.txt' | ForEach-Object {
				$App = $_.Split('=')
				Write-Host "    Installing $App..."
				winget install "$App"
			}
			Write-Host "Winstall has successfully installed the package(s)."
		}
		else {
			Write-Host "Winstall.txt was not found. Learn more at bit.ly/Winstall."
		}
        }}
	# Inform user if WinGet is not installed.
    catch {
		Write-Host "WinGet is not installed. Please install WinGet first before using Winstall."
	}
}

# Install HEVC
Function InstallHEVC {
	Write-Host " "
	# Import BitsTransfer module, ping github - if success, install HEVC Video Extensions, else print no connection message.
	$result = Test-NetConnection github.com
	if (-not (Get-AppxPackage -Name Microsoft.HEVCVideoExtension)) {
		if( $result.PingSucceeded ) {
			Import-Module BitsTransfer
			Write-Host "Downloading HEVC Video Extensions..."
			Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.HEVCVideoExtension_1.0.41023.0_x64__8wekyb3d8bbwe.Appx
			Write-Host "Installing HEVC Video Extensions..."
			Add-AppxPackage Microsoft.HEVCVideoExtension_1.0.41023.0_x64__8wekyb3d8bbwe.Appx
			Remove-Item Microsoft.HEVCVideoExtension_1.0.41023.0_x64__8wekyb3d8bbwe.Appx
			Write-Host "Installed HEVC Video Extensions."
		}
		else {
			Write-Host "Could not connect to the internet. HEVC Video Extensions won't be installed."
		}
	}
	else {
		Write-Host "HEVC Video Extensions are already installed on this device."
	}
}

# Install fonts (part of code here was picked from https://github.com/code-rgb/CleanWin)
Function InstallFonts {
	Write-Host " "
	$installed = "C:\Windows\Fonts\CascadiaCodePL.ttf"
	if (Test-Path -Path $installed) {
		Write-Host "Cascadia Code is already installed on this device."
	}
	else {
		Import-Module BitsTransfer
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

# Set Windows Photo Viewer association for bmp, gif, jpg, png and tif
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

# Unset Windows Photo Viewer association for bmp, gif, jpg, png and tif
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



# Disable Activity History
Function DisableActivityHistory {
	Write-Host " "
	Write-Host "Turning off Activity History..."
	$ActivityFeed = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityFeed -Name "EnableActivityFeed" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "PublishUserActivities" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "UploadUserActivities" -Type DWord -Value 0	
	Write-Host "Turned off Activity History."
}

# Enable Activity History 
Function EnableActivityHistory {
	Write-Host "Turning on Activity History..."
	$ActivityHistory = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityHistory -Name "EnableActivityFeed" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "PublishUserActivities" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "UploadUserActivities" -Type DWord -Value 1
	Write-Host "Turned on Activity History."
}

# Disable Advertising ID
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

# Enable Advertising ID
Function EnableAdvertisingID {
	Write-Host "Turning on Advertising ID..."
	$Advertising = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	Remove-ItemProperty -Path $Advertising -Name "DisabledByGroupPolicy" -ErrorAction SilentlyContinue
	Write-Host "Turned on Advertising ID."
}

# Disable Background apps (https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%205.1/Sophia.psm1#L8988-L9033)
Function DisableBackgroundApps {
	Write-Host " "
	Write-Output "Turning off Background apps..."
	Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
		Remove-ItemProperty -Path $_.PsPath -Name * -Force
	}
	$ExcludedApps = @(
		"Microsoft.LockApp",
		"Microsoft.Windows.ContentDeliveryManager",
		"Microsoft.Windows.Cortana",
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

# Enable Background apps 
Function EnableBackgroundApps {
	Write-Host "Turning on Background apps..."
	Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
		Remove-ItemProperty -Path $_.PsPath -Name * -Force
	}
	Write-Host "Turned on Background apps."
}

# Disable Feedback
Function DisableFeedback {
$ErrorActionPreference = "SilentlyContinue"
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

# Enable Feedback
Function EnableFeedback {
	Write-Host "Turning on Feedback notifications..."
	$Feedback = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	If (!(Test-Path $Feedback )) {
		New-Item $Feedback -Force | Out-Null
		}
	Remove-ItemProperty -Path $Feedback -Name "NumberOfSIUFInPeriod"
	Write-Host "Turned on Feedback notifications."
}

# Disable inking personalization
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

# Enable inking personalization 
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

# Disable "Let websites provide locally relevant content by accessing my language list"
Function DisableLangAccess {
	Write-Host " "
	Write-Host "Turning off websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Remove-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 1 | Out-Null
	Write-Host "Turned off websites' ability to provide you with locally relevant content by accessing your language list."
}

# Enable "Let websites provide locally relevant content by accessing my language list"
Function EnableLangAccess {
	Write-Host "Turning on websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Set-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 0
	Write-Host "Turned on websites' ability to provide you with locally relevant content by accessing your language list."
}

# Disable Location Tracking
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

# Enable location tracking 
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

# Disable automatic Maps updates
Function DisableMapUpdates {
	Write-Host " "
	Write-Host "Turning off automatic Maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
	Write-Host "Turned off automatic Maps updates."
}

# Enable maps updates
Function EnableMapsUpdates {
	Write-Host " "
	Write-Host "Turning on automatic Maps updates..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled"
	Write-Host "Turned on automatic Maps updates."
}

# Disable app suggestions and automatic installation
Function DisableSuggestions {
	Write-Host " "
	Write-Host "Turning off app suggestions and automatic app installation..."
	$Suggestions = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	$SyncNotification = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	Set-ItemProperty -Path $SyncNotification -Name "ShowSyncProviderNotifications" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SoftLandingEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "ContentDeliveryAllowed" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-310093Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-314559Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-338393Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-353694Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-353696Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
	Write-Host "Turned off app suggestions and automatic app installation."
}

# Enable app suggestions and automatic installation 
Function EnableSuggestions {
	Write-Host " "
	Write-Host "Turning on app suggestions and automatic app installation..."
	$Suggestions = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	$SyncNotification = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	Remove-ItemProperty -Path $SyncNotification -Name "ShowSyncProviderNotifications"
	Remove-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SystemPaneSuggestionsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SoftLandingEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent"
	Remove-ItemProperty -Path $Suggestions -Name "ContentDeliveryAllowed"
	Remove-ItemProperty -Path $Suggestions -Name "OemPreInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEverEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent-310093Enabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent-314559Enabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent-338387Enabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent-338388Enabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent-338389Enabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent-338393Enabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent-353694Enabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent-353696Enabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent-353698Enabled"
	Remove-ItemProperty -Path $Suggestions -Name "SystemPaneSuggestionsEnabled"
	Write-Host "Turned on app suggestions and automatic app installation."
}

# Disable Speech Recognition
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

# Enable speech recognition 
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

# Disable tailored experiences
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

# Enable Tailored experiences
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

# Disable telemetry 
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

# Enable Telemetry
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

# Enable clipboard history
Function EnableClipboard {
	Write-Host " "
	Write-Host "Turning on Clipboard History..."
    New-PSDrive HKU -PSProvider Registry -Root HKEY_Users | Out-Null
	$Clipboard = "HKU:\S-1-5-21-957919921-2019213666-2206391487-1001\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Value 1
	Write-Host "Turned on Clipboard History."
    Start-Sleep 1
    Set-Clipboard "Demo text by CleanWin."
	Write-Host "You can now copy multiple items to your clipboard."
    Write-Host "Access your clipboard now using Windows key + V."
}

# Disable clipboard history
Function DisableClipboard {
	Write-Host " "
	Write-Host "Turning off Clipboard History..."
	New-PSDrive HKU -PSProvider Registry -Root HKEY_Users | Out-Null
	$Clipboard = "HKU:\S-1-5-21-957919921-2019213666-2206391487-1001\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Type DWord -Value 0
	Write-Host "Turned off Clipboard History."
}

Function AutoLoginPostUpdate {
	Write-Host " "
	Write-Host "Turning on automatic login post updates..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent" -Type DWord -Value 1
	Write-Host "Turned on Automatic Login applying updates"
} 

Function StayOnLockscreenPostUpdate {
	Write-Host " "
	Write-Host "Turning off automatic login post updates..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent"
	Write-Host "Turned off Automatic Login after applying updates."
}

# Enable Meltdown (CVE-2017-5754) compatibility flag - Required for January 2018 and all subsequent Windows updates
# This flag is normally automatically enabled by compatible antivirus software (such as Windows Defender).
# Use the tweak only if you have confirmed that your AV is compatible but unable to set the flag automatically or if you don't use any AV at all.
# See https://support.microsoft.com/en-us/help/4072699/january-3-2018-windows-security-updates-and-antivirus-software for details.
Function EnableMeltdownCompatFlag {
	Write-Host " "
	Write-Host "Turning on Meltdown (CVE-2017-5754) compatibility flag..."
	$MeltdownCompat = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat"
	If (!(Test-Path $MeltdownCompat)) {
		New-Item -Path $MeltdownCompat | Out-Null
	}
	Set-ItemProperty -Path $MeltdownCompat -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -Type DWord -Value 0
	Write-Host "Turned on Meltdown (CVE-2017-5754) compatibility flag."
}

# Disable Meltdown (CVE-2017-5754) compatibility flag
Function DisableMeltdownCompatFlag {
	Write-Host " "
	Write-Host "Turning off Meltdown (CVE-2017-5754) compatibility flag..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -ErrorAction SilentlyContinue
	Write-Host "Turned off Meltdown (CVE-2017-5754) compatibility flag."
}


####################################
######### TASKS & SERVICES #########
####################################

# Update status
Function TasksServices {
	Write-Host " "
	Write-Host " "
	Write-Host "---------------------------"
	Write-Host "      TASKS & SERVICES     "   
	Write-Host "---------------------------"
	Write-Host " "
}

# Disable Autoplay
Function DisableAutoplay {
	Write-Host " "
	Write-Host "Turning off AutoPlay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
	Write-Host "Turned off AutoPlay."
}

# Enable Autoplay
Function EnableAutoplay {
	Write-Host " "
	Write-Host "Turning on Autoplay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
	Write-Host "Turned on AutoPlay."
}

# Disable Autorun for all drives
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

# Enable Autorun for removable drives
Function EnableAutorun {
	Write-Host " "
	Write-Host "Turning on Autorun for all drives..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
	Write-Host "Turned on Autorun for all drives."
}

# Set BIOS time to UTC
Function SetBIOSTimeUTC {
	Write-Host " "
	Write-Host "Setting BIOS time to UTC..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
	Write-Host "BIOS Time is set to UTC."
}

# Set BIOS time to local time
Function SetBIOSTimeLocal {
	Write-Host " "
	Write-Host "Setting BIOS time to Local time..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -ErrorAction SilentlyContinue
	Write-Host "BIOS Time is set to Local time."
}

# Enable Num lock on startup
Function EnableNumLock {
	Write-Host " "
	Write-Host "Setting Num lock to turn on autoamtically on Startup..."
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force | Out-Null
	Write-Host "Num lock will turn on automatically on Startup."
}

# Disable Num lock on startup 
Function DisableNumLock {
	Write-Host " "
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483648 -Force | Out-Null
	Write-Host "Num lock will no longer turn on automatically on Startup."
}

# Enable Storage Sense 
Function EnableStorageSense {
	Write-Host " "
	Write-Host "Turning on Storage Sense..."
	$EnableStorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $EnableStorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $EnableStorageSense -Name 01 -PropertyType DWord -Value 1 -Force | Out-Null
	Write-Host "Turned on Storage Sense."
}

# Disable Storage Sense 
Function DisableStorageSense {
	Write-Host " "
	Write-Host "Turning off Storage Sense..."
	$DisableStorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $DisableStorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $DisableStorageSense -Name 01 -PropertyType DWord -Value 0 -Force | Out-Null
	Write-Host "Turned off Storage Sense."
}

# Disable Reserved Storage 
Function DisableReservedStorage {
	Write-Host " "
	Write-Host "Turning off Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 0
	Write-Host "Turned off Reserved Storage."
}

# Enable Reserved Storage 
Function EnableReservedStorage {
	Write-Host " "
	Write-Host "Turning on Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 1
	Write-Host "Turned on Reserved Storage."
}

# Disable unnecessary services 
Function DisableServices {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Turning off unnecessary services..."
    	$Services = @(
		"DiagTrack"
		"dmwapppushservice"
		"SysMain"
		"RetailDemo"
		"diagnosticshub.standardcollector.service"
		"MapsBroker"
		"NetTcpPortSharing"
		"RemoteRegistry"
		"SharedAccess"
		"TrkWks"
    )
    ForEach ($Service in $Services) {
		Stop-Service $Service | Out-Null
		Set-Service $Service -StartupType Disabled
		Write-Host "    Stopped service: $Service."
	}
	Write-Host "Turned off unnecesarry services."
}

# Enable unnecessary services
Function EnableServices {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Turning on unnecessary services..."
    	$Services = @(
		"DiagTrack"
		"dmwapppushservice"
		"SysMain"
		"RetailDemo"
		"diagnosticshub.standardcollector.service"
		"MapsBroker"
		"NetTcpPortSharing"
		"RemoteRegistry"
		"SharedAccess"
		"TrkWks"
    )
    ForEach ($Service in $Services) {
		Start-Service $Service | Out-Null
		Set-Service $Service -StartupType Automatic
		Write-Host "    Started service: $Service."
	}
	Write-Host "Turned on redundant services."
}

Function DisableTasks {
	Write-Host " "
	Write-Host "Turning off unnecessary tasks..."
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
		Disable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		Write-Host "    Turned off task: $Task."
	}
    Write-Host "Turned off unnecessary tasks."
}

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

Function SetupWindowsUpdate {
	Write-Host " "
    Write-Host "Checking Windows OS update channel..."
    $channel = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name DisplayVersion
    if ($channel -match "Dev") {
        Write-Host "Device detected to be flighting in Windows Insider Dev channel."
        Write-Host "Update policies will be configured in accordance with Insider Dev channel."
    }
    else {
        Write-Host "Device was not detected to be in Dev channel."
        Write-Host "General update policies will be configured."
    }

    Write-Host " "
	Write-Host "Configuring Windows Update with the following policies..."
    $WinUpdatePolicies =@(
        "Turn off automatic updates"
        "Do not auto restart PC if users are signed in"
        "Turn off re-installation of bloatware after Windows Updates"
		"Delay quality updates by 4 days"
    )
    ForEach ($WinUpdatePolicy in $WinUpdatePolicies) {
    	Write-Host "    - $WinUpdatePolicy"
    }

	$Update1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    $Update2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
        If (!(Test-Path $Update1)) {
          New-Item -Path $Update1 | Out-Null
          New-Item -Path $Update2 | Out-Null
          }
	Set-ItemProperty -Path $Update1 -Name DeferQualityUpdates -Type DWord -Value 1
    Set-ItemProperty -Path $Update1 -Name DeferQualityUpdatesPeriodInDays -Type DWord -Value 4
    Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdates -Type DWord -Value 1
	$channel = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name DisplayVersion
	if ($channel -match "Dev") {
		Write-Host "    - Delay weekly flights by 2 days"
  		Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 2
	}
	else {
		Write-Host "    - Delay feature updates by 20 days"
  		Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 20
	}
    Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
	Set-ItemProperty -Path $Update2 -Name NoAutoRebootWithLoggedOnUsers -Type Dword -Value 1
    Write-Host "Windows Update policies have been configured."
    Write-Host "Note: These policies will have no effect effect on Windows Core editions."
}

Function ResetWindowsUpdate {
    Write-Host " "
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse
    Write-Host "All Windows Update policies were reset."
}

Function EnablePowerdownAfterShutdown {
	Write-Host " "
	Write-Host "Enabling full powerdown on shut down..."
	Write-Host "This is known to fix issues where some PCs might boot up without user input after shutdown."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 1
	Write-Host "Enabled full power down on Shut down."
}

Function DisablePowerdownAfterShutdown {
	Write-Host " "
	Write-Host "Disabling full powerdown on shut down..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 0
	Write-Host "Disabled full powerdown on shut down."
}



####################################
######### WINDOWS EXPLORER #########
####################################

# Update status: Explorer Changes
Function PrintExplorerChanges {	
	Write-Host " "
	Write-Host " "
	Write-Host "----------------------------------"
	Write-Host "          WINDOWS EXPLORER        "
	Write-Host "----------------------------------"
	Write-Host " "
}

# Enable use print screen key to open screen snipping
Function EnablePrtScrToSnip {
	Write-Host " "
	Write-Host "Binding Print Screen key to launch Snip overlay..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 1
	Write-Host "Bound Print Screen key to launch Snip overlay."
}
	
# Disable use print screen key to open screen snipping
Function DisablePrtScrSnip {
	Write-Host " "
	Write-Host "Unbinding Snip overlay launch from Print screen key...."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 0
	Write-Host "Unbound Snip overlay launch from Print screen key."
}

# Disable Sticky keys prompt
Function DisableStickyKeys {
	Write-Host " "
	Write-Host "Turning off sticky keys prompt..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
	Write-Host "Turned off Sticky keys prompt."
}

# Enable Sticky keys prompt
Function EnableStickyKeys {
	Write-Host " "
	Write-Host "Turning on sticky keys prompt..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
	Write-Host "Turned on sticky keys prompt."
}

# Change default Explorer view to This PC
Function SetExplorerThisPC {
	Write-Host " "
	Write-Host "Setting default File Explorer view to This PC..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
	Write-Host "Set default File Explorer view to This PC."
}

# Change default Explorer view to Quick Access
Function SetExplorerQuickAccess {
	Write-Host " "
	Write-Host "Setting default File Explorer view to Quick Access..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -ErrorAction SilentlyContinue
	Write-Host "Set default File Explorer view to Quick Access."
}

# Hide 3D Objects icon from This PC - The icon remains in personal folders and open/save dialogs
Function Hide3DObjectsInThisPC {
	Write-Host " "
	Write-Host "Hiding 3D Objects from This PC..."
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
	Write-Host "Hid 3D Objects from This PC."
}

# Restore 3D Objects icon in This PC
Function Restore3DObjectsInThisPC {
	Write-Host " "
	Write-Host "Restoring 3D Objects to This PC..."
	$Restore3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	If (!(Test-Path $Restore3DObjects1)) {
		New-Item -Path $Restore3DObjects1 | Out-Null
	}
	Write-Host "Restored 3D Objects to This PC."
}

# Hide 3D Objects icon from Explorer namespace - Hides the icon also from personal folders and open/save dialogs
Function Hide3DObjectsInExplorer {
	Write-Host " "
	Write-Host "Hiding 3D Objects from File Explorer.."
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
	Write-Host "Hid 3D Objects from File Explorer."
}

# Restore 3D Objects icon in Explorer namespace
Function Restore3DObjectsInExplorer {
	Write-Host " "
	Write-Host "Restoring 3D Objects icon to File Explorer..."
	$Restore3DObjects2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	$Restore3DObjects3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	Remove-ItemProperty -Path $Restore3DObjects2 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $Restore3DObjects3 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	Write-Host "Restored 3D Objects to File Explorer."
}

# Expand ribbon in File Explorer
Function ExpandRibbonInExplorer {
	Write-Host " "
	Write-Host "Expanding Ribbon in File Explorer..."
	$ExpandRibbonInExplorer = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon"
	New-Item -Path $ExpandRibbonInExplorer -Force | Out-Null
	New-ItemProperty -Path $ExpandRibbonInExplorer -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 0 -Force | Out-Null
	Write-Host "Expanded Ribbon in File Explorer."
}

# Minimize ribbon in File Explorer
Function MinimizeRibbonInExplorer {
	Write-Host " "
	Write-Host "Minimizing Ribbon in File Explorer..."
	$MinimizeRibbonInExplorer = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon"
	New-Item -Path $MinimizeRibbonInExplorer -Force | Out-Null
	New-ItemProperty -Path $MinimizeRibbonInExplorer -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 1 -Force
	Write-Host "Minimized Ribbon in File Explorer."
}

# Hide Search bar from Taskbar
Function HideSearchBar {
	Write-Host " "
	Write-Host "Hiding Search bar from Taskbar..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
	Write-Host "Hid Search bar from Taskbar."
}

# Restore Search bar to Taskbar
Function RestoreSearchBar {
	Write-Host " "
	Write-Host "Restoring Search bar to Taskbar..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 2
	Write-Host "Restored Search bar to Taskbar."
}

# Hide Task View
Function HideTaskView {
	Write-Host " "
	Write-Host "Hiding Task View from Taskbar..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
	Write-Host "Hid Task View from Taskbar."
}

# Restore Task View button
Function RestoreTaskView {
	Write-Host " "
	Write-Host "Restoring Task View button..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
	Write-Host "Restored Task View to Taskbar."
}

# Hide Cortana icon from Taskbar
Function HideCortana {
	Write-Host " "
	Write-Host "Hiding Cortana from Taskbar..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
	Write-Host "Hid Cortana from Taskbar."
}

# Restore Cortana button in Taskbar
Function RestoreCortana {
	Write-Host " "
	Write-Host "Restoring Cortana to Taskbar..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1
	Write-Host "Restored Cortana to Taskbar."
}

# Hide Meet Now icon from tray
Function HideMeetNow {
	Write-Host " "
	Write-Host "Hiding Meet Now from Taskbar..."
	$Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	$Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 1 -ErrorAction SilentlyContinue
	Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
	Write-Host "Hid Meet Now from Taskbar."
}

# Restore Meet Now icon on tray
Function RestoreMeetNow {
	Write-Host " "
	Write-Host "Restoring Meet Now to tray..."
	$Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	$Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 0
	Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 0
	Write-Host "Restored Meet Now to Taskbar."
}

# Turn off Taskbar feed
Function DisableTaskbarFeed {
	Write-Host " "
	Write-Host "Turning off News and interests..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name ShellFeedsTaskbarViewMode -Type DWord -Value 2 | Out-Null
	Write-Host "Turned off News and interests."
}

# Turn on Taskbar feed
Function EnableTaskbarFeed {
	Write-Host " "
	Write-Host "Turning on News and interests..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name ShellFeedsTaskbarViewMode -Type DWord -Value 0
	Write-Host "Turned on News and interests."
}

######### Tasks after successful run #########

# Update status: Script execution successful
Function RestartPC {
	Stop-Process -Name explorer -Force
	Start-Sleep 3
	Write-Host "CleanWin has finished working."
	Write-Host "This PC is set to restart in 10 seconds, please close this window if you want to halt the restart."
	Write-Host "Thank you for using CleanWin."
	Start-Sleep 10
	Restart-Computer
}

# Call the desired tweak functions
$tasks | ForEach-Object { Invoke-Expression $_ }
