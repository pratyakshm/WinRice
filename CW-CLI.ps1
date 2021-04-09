# This file is a part of the CleanWin software
# Copyright (c) 2021 PratyakshM <pratyakshm@protonmail.com>
# All rights reserved.

# Default preset
$tasks = @(

### Maintenance Tasks ###
 	"Setup",
	"CleanWin",
	"ProductInformation",
	"PowerShell7Ready",
	"CreateSystemRestore",

### Apps & Features ###
	"AppsFeatures",
	"DebloatApps", "UnpinStartTiles", "InstallWinGet", "UninstallOneDrive", "CleanupRegistry", 
	"DisableBrowserRestoreAd",      #"EnableBrowserRestoreAd",
	"UninstallFeatures", "EnableWSL", "EnableSandbox",
	"Install7zip", "Winstall", 
	"ChangesDone",

### Privacy & Security ###
	"PrivacySecurity",
	"DisableActivityHistory",		# "EnableActivityHistory",
	"DisableAdvertisingID",			# "EnableAdvertisingID",
	# "DisableBackgroundApps",      # "EnableBackgroundApps",
	"DisableFeedback",		        # "EnableFeedback",
	"DisableLangAccess",  		    # "EnableLangListAccess",
	"DisableLocationTracking",      # "EnableLocationTracking",
	"DisableMapUpdates",			# "EnableMapsUpdates",
	"DisableSuggestions",		    # "EnableSuggestions",
	# "DisableSpeechRecognition",		# "EnableSpeechRecognition",
	"DisableTailoredExperiences",	# "EnableTailoredExperiences",
	"DisableTelemetry",				# "EnableTelemetry",
	"AutoLoginPostUpdate", 		    # "StayOnLockscreenPostUpdate",
	"DisableMeltdownCompatFlag",    # "EnableMeltdownCompatFlag",
	"ChangesDone",

### Tasks & Services ###
	"TasksServices",
	"DisableAutoUpdates",		   # "EnableAutoUpdates",
	"DisableLANP2P"                # "EnableLANP2P",
	"DisableAutoplay",             # "EnableAutoplay",
	"DisableAutorun",              # "EnableAutorun",
	"SetBIOSTimeUTC",              # "SetBIOSTimeLocal",
	"DisableServices",			   # "EnableServices",
	"DisableTasks",				   # "EnableTasks",
	"SetupWindowsUpdate",		   # "ResetWindowsUpdate",
	"ChangesDone",

### Windows Explorer ###
	"PrintExplorerChanges",
	"EnablePrtScrToSnip",		   # "DisablePrtScrSnip",
	"DisableStickyKeys",           # "EnableStickyKeys",
	"SetExplorerThisPC",           # "SetExplorerQuickAccess",
    "Hide3DObjectsInThisPC",       # "Restore3DObjectsInThisPC",
	"Hide3DObjectsInExplorer",     # "Restore3DObjectsInExplorer",
	"HideSearchBar",			   # "RestoreSearchBar"
	"HideTaskView",                # "RestoreTaskView",
	"HideCortana",			       # "RestoreCortana",
	"HideMeetNow",				   # "RestoreMeetNow",
	"ChangesDone",

###  Tasks after successful run ###
	"RestartPC"
)


### Maintenance tasks ###

# CleanWin
Function CleanWin {
	Clear-Host
	Write-Host " "
	Write-Host "CleanWin v0.3.6 by pratyakshm"
	Write-Host "https://github.com/pratyakshm/CleanWin"
	Write-Host "CleanWin is licensed under the MIT License: https://github.com/pratyakshm/CleanWin/blob/main/LICENSE"
	Write-Host "All rights reserved."
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
	Start-Sleep 4
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

# Import modules from Windows PowerShell 5.1 
Function PowerShell7Ready {
	switch ($PSVersionTable.PSVersion.Major)
	{
		"7"
		{
			Import-Module -Name Microsoft.PowerShell.Management, PackageManagement, Appx -UseWindowsPowerShell
		}
	}
}

# Create a system restore point with type MODIFY_SETTINGS, silently continue if already created within the past 24 hours
Function CreateSystemRestore {
	Enable-ComputerRestore -Drive "C:\"
	Checkpoint-Computer -Description "RestorePoint1" -RestorePointType "MODIFY_SETTINGS" -WarningAction SilentlyContinue
}



######### APPS & FEATURES #########

# Update status
Function AppsFeatures {
	Write-Host " "
	Write-Host " "
	Write-Host "-------------------------"
	Write-Host "     APPS & FEATURES     "
	Write-Host "-------------------------"
	Write-Host " "
}

# Debloat apps
Function DebloatApps {
$ErrorActionPreference = 'SilentlyContinue'

	# Prebuilt apps
	Write-Host "Uninstalling bloatware..."
	$Bloatware = @(
	"Microsoft.549981C3F5F10"
	"Microsoft.BingNews"
	"Microsoft.BingWeather"
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
	"Microsoft.People" 
	"Microsoft.PowerAutomateDesktop"
	"Microsoft.Print3D" 
	"Microsoft.SkypeApp"
	"Microsoft.ScreenSketch"
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

	#Sponsored Windows 10 AppX Apps
	#Add sponsored/featured apps to remove in the "*AppName*" format
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

	Remove-Item "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
	Remove-Item "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Outlook.lnk"
	Remove-Item "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk"
	Remove-Item "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Word.lnk"

	# Uninstall Connect app
	Import-Module BitsTransfer
	Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/install_wim_tweak.exe
	Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/connect.cmd
	./connect.cmd | Out-Null
	Remove-Item install_wim_tweak.exe
	Remove-Item connect.cmd

	Write-Host "Done."
}


# Unpin all start menu tiles
Function UnpinStartTiles {
	Write-Host " "
	Write-Host "Unpinning all tiles in start menu..."
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
	
	# Delete layout file if it already exists
	If(Test-Path $layoutFile)
	{
		Remove-Item $layoutFile
	}
	
	# Creates the blank layout file
	$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
	
	$regAliases = @("HKLM", "HKCU")
	
	# Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
	foreach ($regAlias in $regAliases){
		$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
		$keyPath = $basePath + "\Explorer" 
		IF(!(Test-Path -Path $keyPath)) { 
			New-Item -Path $basePath -Name "Explorer" | Out-Null
		}
		Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
		Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
	}
	
	# Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
	Stop-Process -name explorer -Force
	Start-Sleep -s 5
	$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
	Start-Sleep -s 5
	
	# Enable the ability to pin items again by disabling "LockedStartLayout"
	foreach ($regAlias in $regAliases){
		$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
		$keyPath = $basePath + "\Explorer" 
		Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
	}
	
	# Restart Explorer and delete the layout file
	Stop-Process -name explorer -Force
	
	# Uncomment the next line to make clean start menu default for all new users
	Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
	
	Remove-Item $layoutFile
	Write-Host "Done."
}

# Install WinGet
Function InstallWinGet {
	Write-Host " "
	# Import BitsTransfer module and download NetTestFile
    Import-Module BitsTransfer 
    Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/NetTestFile
    # If the file exists, proceed with downloading WinGet files, else inform user about no internet connection.
    If (Test-Path NetTestFile) {
        Remove-Item NetTestFile
        Write-Host "Downloading WinGet..."
        Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle
        Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
        Write-Host "Installing WinGet..."
        Add-AppxPackage -Path .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -DependencyPath .\Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
        Remove-Item Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle
        Remove-Item Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx
        Write-Host "Done."
	} 
	else {
	  Write-Host "We can't connect to GitHub to download the installation files. Are you sure that your internet connection is working?"
	}
}

Function UninstallOneDrive {
	Write-Host " "
	Write-Host "Uninstalling OneDrive..."
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
	Start-Process explorer.exe
	# For 64-bit versions of Microsoft OneDrive (in preview)
	Remove-Item "C:\Users\$env:UserName\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
	Remove-Item "C:\Users\$env:UserName\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json.backup" -ErrorAction SilentlyContinue
	Start-BitsTransfer -Source "https://raw.githubusercontent.com/CleanWin/Files/main/settings.json" -Destination "C:\Users\$env:UserName\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
	winget uninstall OneDriveSetup.exe -ErrorAction SilentlyContinue
	Remove-Item env:OneDrive
	Write-Host "Done."
}

Function CleanupRegistry {
$ErrorActionPreference = 'SilentlyContinue'
	Write-Host " "
	Write-Host "Cleaning up registry..."
    	$Keys = @(
		
		New-PSDrive HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
        #Remove Background Tasks
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
        #Windows File
        "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            
        #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
        #Scheduled Tasks to delete
        "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            
        #Windows Protocol Keys
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
               
        #Windows Share Target
        "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    )
        
    #This writes the output of each key it is removing and also removes the keys listed above.
    ForEach ($Key in $Keys) {
		Remove-Item $Key -Recurse
	}
	Write-Host "Done."
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
	Write-Host "Done."
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
        Write-Host "Hiding 'Web browsing: Restore recommended' suggestion from Settings..."
		./ViVeTool.exe delconfig 23531064 1 | Out-Null
		Remove-Item ViVeTool.exe
		Remove-Item Albacore.ViVe.dll
        Write-Host "Done."
	} 
	else {
	  Write-Host "We can't connect to GitHub to download the required files. Are you sure that your internet connection is working?"
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
        Write-Host "Done."
	} 
	else {
	  Write-Host "We can't connect to GitHub to download the required files. Are you sure that your internet connection is working?"
	}
}

# Uninstall Features
Function UninstallFeatures {
	Write-Host " "
	Write-Host "Uninstalling unnecessary features, please standby..."
	Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq "WorkFolders-Client" } | Disable-WindowsOptionalFeature -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
	Get-WindowsCapability -Online | Where-Object { $_.Name -like "Hello.Face*" } | Remove-WindowsCapability -Online | Out-Null
	Get-WindowsCapability -Online | Where-Object { $_.Name -like "MathRecognizer*" } | Remove-WindowsCapability -Online | Out-Null
	Remove-WindowsCapability -Name "App.StepsRecorder~~~~0.0.1.0" -Online | Out-Null
	Remove-WindowsCapability -Name "App.Support.QuickAssist~~~~0.0.1.0" -Online | Out-Null
	Remove-WindowsCapability -Name "Browser.InternetExplorer~~~~0.0.11.0" -Online | Out-Null
	Remove-WindowsCapability -Name "Media.WindowsMediaPlayer~~~~0.0.12.0" -Online | Out-Null
	Remove-WindowsCapability -Name "Microsoft-Windows-SnippingTool~~~~0.0.1.0" -Online | Out-Null
	Remove-WindowsCapability -Name "Microsoft.Windows.MSPaint~~~~0.0.1.0" -Online | Out-Null
	Remove-WindowsCapability -Name "Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0" -Online | Out-Null
	Remove-WindowsCapability -Name "Microsoft.Windows.WordPad~~~~0.0.1.0" -Online | Out-Null
	Remove-WindowsCapability -Name "Print.Fax.Scan~~~~0.0.1.0" -Online | Out-Null
	Remove-WindowsCapability -Name "OpenSSH.Client~~~~0.0.1.0" -Online | Out-Null
	Remove-WindowsCapability -Name "Print.Fax.Scan~~~~0.0.1.0" -Online | Out-Null
	Remove-WindowsCapability -Name "XPS.Viewer~~~~0.0.1.0" -Online | Out-Null
    Disable-WindowsOptionalFeature -FeatureName "Printing-XPSServices-Features" -Online -NoRestart -WarningAction Ignore | Out-Null 
	Write-Host "Done."
}

# Enable WSL
Function EnableWSL {
	Write-Host " "
	Write-Host "Enabling Windows Subsystem for Linux..."
	Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart -WarningAction Ignore | Out-Null
	Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -Online -All -NoRestart -WarningAction Ignore | Out-Null
	Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -Online -All -NoRestart -WarningAction Ignore | Out-Null
	Write-Host "Done."
}

# Enable Sandbox
Function EnableSandbox {
	Write-Host " "
	Write-Host "Enabling Windows Sandbox..."
	Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart -WarningAction Ignore | Out-Null
	Write-Host "Done."
}


# Install 7zip
Function Install7zip {
	Write-Host " "
	Write-Host "Installing 7-zip..."
	winget install 7zip
}

# Install apps from Winstall file (the Winstall.txt file must be on the same directory where CleanWin is)
Function Winstall {
	Write-Host " "
	If (Test-Path Winstall.txt) {
		Write-Host "Found Winstall.txt! Beginning Winstall..."
        Get-Content 'Winstall.txt' | Foreach-Object {
            $App = $_.Split('=')
            Write-Host "Installing $App..."
            winget install $App
        }
        Write-Host "Winstall has successfully installed the package(s)."
    }
    else {
        Write-Host "Winstall.txt was not found. Learn more at bit.ly/Winstall."
    }
}



######### Privacy & Security #########

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
	Write-Host "Done."
}

# Enable Activity History 
Function EnableActivityHistory {
	Write-Host "Turning on Activity History..."
	$ActivityHistory = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityHistory -Name "EnableActivityFeed" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "PublishUserActivities" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "UploadUserActivities" -Type DWord -Value 1
	Write-Host "Done."
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
	Write-Host "Done."
}

# Enable Advertising ID
Function EnableAdvertisingID {
	Write-Host "Turning on Advertising ID..."
	$Advertising = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	Remove-ItemProperty -Path $Advertising -Name "DisabledByGroupPolicy" -ErrorAction SilentlyContinue
	Write-Host "Done."
}

# Disable Background application access - ie. if apps can download or update when they aren't used - Cortana is excluded as its inclusion breaks start menu search
Function DisableBackgroundApps {
	Write-Host " "
	Write-Host "Turning off background apps..."
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach-Object {
		Set-ItemProperty -Path $_.PsPath -Name "Disabled" -Type DWord -Value 1
		Set-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -Type DWord -Value 1
		}
	Write-Host "Done."
}

# Enable Background application access
Function EnableBackgroundApps {
	Write-Host "Turning on background apps..."
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach-Object {
		Set-ItemProperty -Path $_.PsPath -Name "Disabled" -Type DWord -Value 0
		Set-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -Type DWord -Value 0
		}
	Write-Host "Done."
}

# Disable Feedback
Function DisableFeedback {
$ErrorActionPreference = "SilentlyContinue"
	Write-Host " "
	Write-Host "Turning off Feedback..."
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
	Write-Host "Done."
}

# Enable Feedback
Function EnableFeedback {
	Write-Host "Turning on Feedback..."
	$Feedback = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	If (!(Test-Path $Feedback )) {
		New-Item $Feedback -Force | Out-Null
		}
	Remove-ItemProperty -Path $Feedback -Name "NumberOfSIUFInPeriod"
	Write-Host "Done."
}

# Disable language list access for relevant content
Function DisableLangAccess {
	Write-Host " "
	Write-Host "Restricting websites from accessing your language list..."
	$Language = "HKCU:\Control Panel\International\User Profile"
	If (!(Test-Path $Language)) {
		New-Item -Path $Language | Out-Null
	}
	Set-ItemProperty -Path $Language -Name "HttpAcceptLanguageOptOut " -Type DWord -Value 1
	Write-Host "Done."
}

# Enable language list access for relevant content
Function EnableLangListAccess {
	Write-Host "Turning on language list recommendation..."
	$LanguageList = "HKCU:\Control Panel\International\User Profile"
	If (!(Test-Path $LanguageList)) {
		New-Item -Path $LanguageList | Out-Null
		}
	Set-ItemProperty -Path $LanguageList  -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 0
	Write-Host "Done."
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
	Write-Host "Done."
}

# Enable location tracking 
Function EnableLocationTracking {
	Write-Host "Turning on location tracking..."
	$Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	$Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
	If (!(Test-Path )) {
		New-Item -Path $Location1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Allow"
	Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 1
	Write-Host "Done."
}

# Disable automatic Maps updates
Function DisableMapUpdates {
	Write-Host " "
	Write-Host "Turning off automatic maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
	Write-Host "Done."
}

# Enable maps updates
Function EnableMapsUpdates {
	Write-Host "Turning on Maps updates..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled"
	Write-Host "Maps updates have been turned on"
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
	Write-Host "Done."
}

# Enable app suggestions and automatic installation 
Function EnableSuggestions {
	Write-Host "Turning off app suggestions and automatic app installation..."
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
	Write-Host "Done."
}
# Disable Speech Recognition
Function DisableSpeechRecognition {
	Write-Host " "
	Write-Host "Turning off online speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	If (!(Test-Path $Speech)) {
		New-Item -Path $Speech | Out-Null
	}
	Set-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 0
	Write-Host "Done."
}

# Enable speech recognition 
Function EnableSpeechRecognition {
	Write-Host "Turning on speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	If (!(Test-Path )) {
		New-Item -Path $Speech | Out-Null
		}
	Set-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 1
	Write-Host "Done."
}

# Disable tailored experiences
Function DisableTailoredExperiences {
	Write-Host " "
	Write-Host "Turning off tailored experiences..."
	$CloudContent = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	If (!(Test-Path $CloudContent )) {
		New-Item $CloudContent -Force | Out-Null
		}
	Set-ItemProperty -Path $CloudContent -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
	Write-Host "Done."
}

# Enable Tailored experiences
Function EnableTailoredExperiences {
	Write-Host "Turning on Tailored experiences..."
	$TailoredExp1 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	$TailoredExp2 = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
	$TailoredExp3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Remove-ItemProperty -Path $TailoredExp1 -Name "DisableTailoredExperiencesWithDiagnosticData" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $TailoredExp2 -Name "Disabled" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $TailoredExp3 -Name "DoNotShowFeedbackNotifications" -ErrorAction SilentlyContinue
	Write-Host "Done."
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
	Write-Host "Done."
}

# Enable Telemetry
Function EnableTelemetry {
	Write-Host "Turning on Telemetry..."
	$Telemetry1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Set-ItemProperty -Path $Telemetry1  -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry2 -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry3 -Name "AllowTelemetry" -Type DWord -Value 3
	Write-Host "Done."
}

Function AutoLoginPostUpdate {
	Write-Host " "
	Write-Host "Turning on automatic login post updates..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent" -Type DWord -Value 1
	Write-Host "Done."
} 

Function StayOnLockscreenPostUpdate {
	Write-Host " "
	Write-Host "Turning off automatic login post updates..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent"
	Write-Host "Done."
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
	Write-Host "Done."
}

# Disable Meltdown (CVE-2017-5754) compatibility flag
Function DisableMeltdownCompatFlag {
	Write-Host " "
	Write-Host "Turning off Meltdown (CVE-2017-5754) compatibility flag..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -ErrorAction SilentlyContinue
	Write-Host "Done."
}


######### TASKS & SERVICES #########

# Update status
Function TasksServices {
	Write-Host " "
	Write-Host " "
	Write-Host "---------------------------"
	Write-Host "      TASKS & SERVICES     "   
	Write-Host "---------------------------"
	Write-Host " "
}

# Disable automatic updates
Function DisableAutoUpdates {
	Write-Host "Turning off automatic Windows updates..."
	$Update1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
	$Update2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
		If (!(Test-Path $Update1)) {
	  	New-Item -Path $Update1 | Out-Null
	  	New-Item -Path $Update2 | Out-Null
	  	}
	Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
	Write-Host "Done."
}

# Enable automatic updates
Function EnableAutoUpdates {
	Write-Host "Turning on automatic Windows updates..."
	Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue
	Write-Host "Done."
}

# Update only from MSFT (no LAN or P2P)
Function DisableLANP2P {
	Write-Host " "
	Write-Host "Turning off P2P and LAN updates..."
	$LANP2P1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization"
	$LANP2P2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
	If (!(Test-Path $LANP2P1)) {
		New-Item -Path $LANP2P1 | Out-Null
		New-Item -Path $LANP2P2 | Out-Null
		}
	Set-ItemProperty -Path $LANP2P2 -Name DownloadMode -Type DWord -Value 0
	Set-ItemProperty -Path $LANP2P2 -Name DODownloadMode -Type DWord -Value 0
	Write-Host "Done."
}

# Enable LAN-P2P update bits delivery
Function EnableLANP2P {
	Write-Host "Turning on P2P and LAN updates..."
	$LANP2P3 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
	Set-ItemProperty -Path $LANP2P3 -Name DownloadMode -Type DWord -Value 3
	Set-ItemProperty -Path $LANP2P3 -Name DODownloadMode -Type DWord -Value 3
	Write-Host "Done."
}

# Disable Autoplay
Function DisableAutoplay {
	Write-Host " "
	Write-Host "Turning off AutoPlay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
	Write-Host "Done."
}

# Enable Autoplay
Function EnableAutoplay {
	Write-Host "Turning on Autoplay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
	Write-Host "Done."
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
	Write-Host "Done."
}

# Enable Autorun for removable drives
Function EnableAutorun {
	Write-Host "Turning on Autorun for all drives..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
	Write-Host "Done."
}

# Set BIOS time to UTC
Function SetBIOSTimeUTC {
	Write-Host " "
	Write-Host "Setting BIOS time to UTC..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
	Write-Host "Done."
}

# Set BIOS time to local time
Function SetBIOSTimeLocal {
	Write-Host "Setting BIOS time to Local time..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -ErrorAction SilentlyContinue
	Write-Host "Done."
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
		Write-Host "Stopped $Service service."
	}
	Write-Host "Done."
}

# Enable unnecessary services
Function EnableServices {
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
		Write-Host "Started $Service service."
	}
	Write-Host "Done."
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
		Write-Host "Disabled $Task task."
	}
    Write-Host "Done."
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
		Write-Host "Enabled $Task task."
	}
    Write-Host "Done."
}

Function SetupWindowsUpdate {
	Write-Host " "
	Write-Host "Setting up Windows Update..."
	$Update1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    $Update2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
        If (!(Test-Path $Update1)) {
          New-Item -Path $Update1 | Out-Null
          New-Item -Path $Update2 | Out-Null
          }
    Set-ItemProperty -Path $Update1 -Name ExcludeWUDriversInQualityUpdate -Type DWord -Value 1
    Set-ItemProperty -Path $Update1 -Name DeferQualityUpdates -Type DWord -Value 1
    Set-ItemProperty -Path $Update1 -Name DeferQualityUpdatesPeriodInDays -Type DWord -Value 4
    Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdates -Type DWord -Value 1
    Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 20
    Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
    Write-Host "Done."
}

Function ResetWindowsUpdate {
	Write-Host " "
	Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse
	Write-Host "Windows Update policies have been removed."
}



######### Explorer changes #########

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
	Write-Host "Directing Print screen key to launch screen snipping..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 1
	Write-Host "Done."
}
	
# Disable use print screen key to open screen snipping
Function DisablePrtScrSnip {
	Write-Host "Revoking Print screen key's ability to launch screen snip..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 0
	Write-Host "Done."
}

# Disable Sticky keys prompt
Function DisableStickyKeys {
	Write-Host " "
	Write-Host "Turning off sticky keys prompt..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
	Write-Host "Done."
}

# Enable Sticky keys prompt
Function EnableStickyKeys {
	Write-Host "Turning on sticky keys prompt..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
	Write-Host "Done."
}

# Change default Explorer view to This PC
Function SetExplorerThisPC {
	Write-Host " "
	Write-Host "Changing default File Explorer view to This PC..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
	Write-Host "Done."
}

# Change default Explorer view to Quick Access
Function SetExplorerQuickAccess {
	Write-Host "Changing default File Explorer view back to Quick Access..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -ErrorAction SilentlyContinue
	Write-Host "Done."
}

# Hide 3D Objects icon from This PC - The icon remains in personal folders and open/save dialogs
Function Hide3DObjectsInThisPC {
	Write-Host " "
	Write-Host "Hiding 3D Objects icon from This PC..."
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
	Write-Host "Done."
}

# Restore 3D Objects icon in This PC
Function Restore3DObjectsInThisPC {
	Write-Host "Restoring 3D Objects icon in This PC..."
	$Restore3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	If (!(Test-Path $Restore3DObjects1)) {
		New-Item -Path $Restore3DObjects1 | Out-Null
		}
		Write-Host "Done."
}

# Hide 3D Objects icon from Explorer namespace - Hides the icon also from personal folders and open/save dialogs
Function Hide3DObjectsInExplorer {
	Write-Host " "
	Write-Host "Hiding 3D Objects from Explorer namespace..."
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
	Write-Host "Done."
}

# Restore 3D Objects icon in Explorer namespace
Function Restore3DObjectsInExplorer {
	Write-Host "Restoring 3D Objects icon in Explorer namespace..."
	$Restore3DObjects2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	$Restore3DObjects3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
	Remove-ItemProperty -Path $Restore3DObjects2 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $Restore3DObjects3 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	Write-Host "Done."
}

# Hide Search bar from taskbar
Function HideSearchBar {
	Write-Host " "
	Write-Host "Hiding search bar from taskbar..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
	Write-Host "Done."
}

# Restore Search bar to taskbar
Function RestoreSearchBar {
	Write-Host " "
	Write-Host "Restoring search bar from taskbar..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 2
	Write-Host "Done."
}

# Hide Task View button
Function HideTaskView {
	Write-Host " "
	Write-Host "Hiding Task View button from taskbar..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
	Write-Host "Done."
}

# Restore Task View button
Function RestoreTaskView {
	Write-Host "Restoring Task View button..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
	Write-Host "Done."
}

# Hide Cortana icon from taskbar
Function HideCortana {
	Write-Host " "
	Write-Host "Hiding Cortana icon from taskbar..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
	Write-Host "Done."
}

# Restore Cortana button in taskbar
Function RestoreCortana {
	Write-Host "Showing Cortana icon on taskbar..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1
	Write-Host "Done."
}

# Hide Meet Now icon from tray
Function HideMeetNow {
	Write-Host " "
	Write-Host "Hiding Meet now icon from tray..."
	$Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	$Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 1 -ErrorAction SilentlyContinue
	Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
	Write-Host "Done."
}

# Restore Meet Now icon on tray
Function RestoreMeetNow {
	Write-Host "Restoring Meet now icon in tray..."
	$Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	$Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 0
	Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 0
	Write-Host "Done."
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
