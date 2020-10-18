##############
#
# CleanWin
# Author: PratyakshM <pratyakshm@protonmail.com>
#
##############
# Default preset
$tweaks = @(

### Tasks ###
	"CleanWin",
	"Sleep",

### App changes ###
	"PrintAppsChanges",
	"InstallChoco",
	"InstallApps",
	"ClearScreen",
	
### Privacy changes ###
	"PrintPrivacyChanges",
	"DisableMapUpdates",	       # "EnableMapUpdates",
	"DisableFeedback",		       # "EnableFeedback",
	"DisableBackgroundApps",       # "EnableBackgroundApps",
	"DisableLocationTracking",     # "EnableLocationTracking",
	"DisableAdvertisingID",        # "EnableAdvertisingID",
	"LessSleep",

### Service changes ###
	"PrintServicesChanges",
	"DisableAutoUpdates",		   # "EnableAutoUpdates",
	"DisableLANP2P"                # "EnableLANP2P",
	"DisableAutoplay",             # "EnableAutoplay",
	"DisableAutorun",              # "EnableAutorun",
	"DisableDefragmentation",      # "EnableDefragmentation",
	"SetBIOSTimeUTC",              # "SetBIOSTimeLocal",
	"LessSleep",

### Windows Explorer Changes ###
	"PrintExplorerChanges",
	"ShowVerboseStatus",           # "HideVerboseStatus",
	"EnablePrtScrToSnip",		   # "DisablePrtScrSnip",
	"DisableStickyKeys",           # "EnableStickyKeys",
	"SetExplorerThisPC",           # "SetExplorerQuickAccess",
    "Hide3DObjectsInThisPC",       # "Restore3DObjectsInThisPC",
	"Hide3DObjectsInExplorer",     # "Restore3DObjectsInExplorer",
	"HideSearchBar",			   # "RestoreSearchBar"
	"HideTaskView",                # "RestoreTaskView",
	"HideCortana",			       # "RestoreCortana",
	"ShowSecondsInTaskbar",        # "HideSecondsFromTaskbar",
	"LessSleep",

### Features changes ###
	"PrintFeaturesChanges",
	"EnableWSL",
	"EnableVM",
	"LessSleep",

### Security changes ###
	"PrintSecurityChanges",
	"AutoLoginPostUpdate", 		   # "StayOnLockscreenPostUpdate",
	"DisableMeltdownCompatFlag",   # "EnableMeltdownCompatFlag",
	"DisableSMB",				   # "EnableSMB",
	"LessSleep",

### System changes ###
	"PrintSystemChanges",
	"EnableUltimatePerf",	
	"LessSleep",

### Application changes ###
	"PrintAppsChanges",
	"DebloatApps",
	"LessSleep",

###  Tasks after successful run ###
	"PrintEndTasksBegin",
	"PrintEndEndTasks"
)
### Tasks ###

# CleanWin
Function CleanWin {
	Write-Output " "
	Write-Output "CleanWin by pratyakshm"
	Write-Output "https://github.com/pratyakshm/CleanWin"
	Write-Output "Version 0.3"
	Write-Output "All rights reserved."
}

Function Sleep {
	Start-Sleep 5
}

Function LessSleep {
	Start-Sleep 2
}

######### Privacy Changes #########

# Update status: privacy changes
Function PrintPrivacyChanges {
	Write-Output " "
	Write-Output "-------------------------"
	Write-Output "     PRIVACY CHANGES     "
	Write-Output "-------------------------"
	Write-Output " "
}

# Disable automatic Maps updates
Function DisableMapUpdates {
	Write-Output "Turning off automatic maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
	Write-Output "Automatic Maps updates have been turned off."
}

# Enable automatic Maps updates
Function EnableMapUpdates {
	Write-Output "Turning on automatic maps updates..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -ErrorAction SilentlyContinue
	Write-Output "Automatic Maps updates have been turned on."
}

# Disable Feedback
Function DisableFeedback {
	Write-Output " "
	Write-Output "Turning off Feedback..."
	If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
	Write-Output "Feedback has been turned off."
}

# Enable Feedback
Function EnableFeedback {
	Write-Output "Turning on feedback..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -ErrorAction SilentlyContinue
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
	Write-Output "Feedback has been turned on."
}

# Disable Background application access - ie. if apps can download or update when they aren't used - Cortana is excluded as its inclusion breaks start menu search
Function DisableBackgroundApps {
	Write-Output " "
	Write-Output "Turning off background apps..."
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach {
		Set-ItemProperty -Path $_.PsPath -Name "Disabled" -Type DWord -Value 1
		Set-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -Type DWord -Value 1
	}
	Write-Output "Background apps have been turned off."
}

# Enable Background application access
Function EnableBackgroundApps {
	Write-Output "Turning on background apps..."
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | ForEach {
		Remove-ItemProperty -Path $_.PsPath -Name "Disabled" -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -ErrorAction SilentlyContinue
	}
	Write-Output "Background apps have been turned on."
}

# Disable Location Tracking
Function DisableLocationTracking {
	Write-Output " "
	Write-Output "Turning off location tracking..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
	Write-Output "Location tracking has been turned off."
}

# Enable Location Tracking
Function EnableLocationTracking {
	Write-Output "Turning on location Tracking..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Allow"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
	Write-Output "Location tracking has been turned on."
}

# Disable Advertising ID
Function DisableAdvertisingID {
	Write-Output " "
	Write-Output "Turning off Advertising ID..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1
	Write-Output "Advertising ID has been turned off."
}

# Enable Advertising ID
Function EnableAdvertisingID {
	Write-Output "Turning on Advertising ID..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -ErrorAction SilentlyContinue
	Write-Output "Advertising ID has been turned on."
}



######### Service Tweaks #########

# Update status: services changes
Function PrintServicesChanges {
	Write-Output " "
	Write-Output " "
	Write-Output "---------------------------"
	Write-Output "     SERVICES CHANGES      "   
	Write-Output "---------------------------"
	Write-Output " "
}

# Disable automatic updates
Function DisableAutoUpdates {
	Write-Output "Turning off automatic Windows updates..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) {
	  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" | Out-Null
	  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" | Out-Null
	  }
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoUpdate -Type DWord -Value 1
	Write-Output "Automatic Windows updates have been turned off."
}

# Enable automatic updates
Function EnableAutoUpdates {
	Write-Output "Turning on automatic Windows updates..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue
	Write-Output "Automatic Windows updates have been turned on."
}

# Update only from MSFT (no LAN or P2P)
Function DisableLANP2P {
	Write-Output " "
	Write-Output "Turning off P2P and LAN updates..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name DownloadMode -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name DODownloadMode -Type DWord -Value 0
	Write-Output "P2P and LAN updates have been turned off."
}

Function EnableLANP2P {
	Write-Output "Turning on P2P and LAN updates..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name DownloadMode -Type DWord -Value 3
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name DODownloadMode -Type DWord -Value 3
	Write-Output "LAN and P2P updates have been turned on."
}

# Disable Autoplay
Function DisableAutoplay {
	Write-Output " "
	Write-Output "Turning off AutoPlay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
	Write-Output "AutoPlay has been turned off."
}

# Enable Autoplay
Function EnableAutoplay {
	Write-Output "Turning on Autoplay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
	Write-Output "AutoPlay has been turned on."
}

# Disable Autorun for all drives
Function DisableAutorun {
	Write-Output " "
	Write-Output "Turning off Autorun for all drives..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
	Write-Output "Autorun has been turned off for all drives."
}

# Enable Autorun for removable drives
Function EnableAutorun {
	Write-Output "Turning on Autorun for all drives..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
		Write-Output "Autorun has been turned on."
}

# Disable scheduled defragmentation task
Function DisableDefragmentation {
	Write-Output " "
	Write-Output "Turning off scheduled defragmentation..."
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Defrag\ScheduledDefrag" | Out-Null
	Write-Output "Scheduled defragmentation has been turned off."
}

# Enable scheduled defragmentation task
Function EnableDefragmentation {
	Write-Output "Turning on scheduled defragmentation..."
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Defrag\ScheduledDefrag" | Out-Null
	Write-Output "Scheduled defragmentation has been turned on.."
}

# Set BIOS time to UTC
Function SetBIOSTimeUTC {
	Write-Output " "
	Write-Output "Setting BIOS time to UTC..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
	Write-Output "BIOS time has been set to UTC."
}

# Set BIOS time to local time
Function SetBIOSTimeLocal {
	Write-Output "Setting BIOS time to Local time..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -ErrorAction SilentlyContinue
	Write-Output "BIOS time has been set to Local time."
}



######### Explorer changes #########

# Update status: Explorer Changes
Function PrintExplorerChanges {	
	Write-Output " "
	Write-Output " "
	Write-Output "----------------------------------"
	Write-Output "     WINDOWS EXPLORER CHANGES     "
	Write-Output "----------------------------------"
	Write-Output " "
}

# Show verbose status
Function ShowVerboseStatus {
	Write-Output "Turning on Verbose Status..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "VerboseStatus" -Type DWord -Value 1
	Write-Output "Verbose Status has been turned on."
}

# Hide verbose status 
Function HideVerboseStatus {
	Write-Output "Turning off Verbose Status..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "VerboseStatus" -Type DWord -Value 0
	Write-Output "Verbose Status has been turned off."
}

# Enable use print screen key to open screen snipping
Function EnablePrtScrToSnip {
	Write-Output " "
	Write-Output "Directing Print screen key to launch screen snipping..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 1
	Write-Output "Print screen key has been directed to launch Snip window."
	}
	
# Disable use print screen key to open screen snipping
Function DisablePrtScrSnip {
	Write-Output "Revoking Print screen key's ability to launch screen snip..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 0
	Write-Output "Print screen key will now no longer launch snip window."
}

# Disable Sticky keys prompt
Function DisableStickyKeys {
	Write-Output " "
	Write-Output "Turning off sticky keys prompt..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
	Write-Output "Sticky keys prompt has been turned off."
}

# Enable Sticky keys prompt
Function EnableStickyKeys {
	Write-Output "Turning on sticky keys prompt..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
	Write-Output "Sticky keys prompt has been turned on."
}

# Change default Explorer view to This PC
Function SetExplorerThisPC {
	Write-Output " "
	Write-Output "Changing default File Explorer view to This PC..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
	Write-Output "Changed default File Explorer view to This PC."
}

# Change default Explorer view to Quick Access
Function SetExplorerQuickAccess {
	Write-Output "Changing default File Explorer view back to Quick Access..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -ErrorAction SilentlyContinue
	Write-Output "Changed default File Explorer view to Quick Access."
}

# Hide 3D Objects icon from This PC - The icon remains in personal folders and open/save dialogs
Function Hide3DObjectsInThisPC {
	Write-Output " "
	Write-Output "Hiding 3D Objects icon from This PC..."
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
	Write-Output "3D Objects has been hidden from This PC."
}

# Restore 3D Objects icon in This PC
Function Restore3DObjectsInThisPC {
	Write-Output "Restoring 3D Objects icon in This PC..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" | Out-Null
	}
	Write-Output "3D objects has been restored in This PC."
}

# Hide 3D Objects icon from Explorer namespace - Hides the icon also from personal folders and open/save dialogs
Function Hide3DObjectsInExplorer {
	Write-Output " "
	Write-Output "Hiding 3D Objects from Explorer namespace..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
	If (!(Test-Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag")) {
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
	Write-Output "3D Objects has been hidden from Explorer."
}

# Restore 3D Objects icon in Explorer namespace
Function Restore3DObjectsInExplorer {
	Write-Output "Restoring 3D Objects icon in Explorer namespace..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	Write-Output "3D Objects has been restored to Explorer namespace."
}

# Hide Search bar from taskbar
Function HideSearchBar {
	Write-Output " "
	Write-Output "Hiding search bar from taskbar..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
	Write-Output "Searchbar has been hidden from taskbar."
}

# Restore Search bar to taskbar
Function RestoreSearchBar {
	Write-Output " "
	Write-Output "Restoring search bar from taskbar..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 2
	Write-Output "Searchbar has been restored to taskbar."
}

# Hide Task View button
Function HideTaskView {
	Write-Output " "
	Write-Output "Hiding Task View button from taskbar..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
	Write-Output "Task View button has been hidden from taskbar."
}

# Restore Task View button
Function RestoreTaskView {
	Write-Output "Restoring Task View button..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
	Write-Output "Task view icon has been restored to taskbar."
}

# Hide Cortana icon from taskbar
Function HideCortana {
	Write-Output " "
	Write-Output "Hiding Cortana icon from taskbar..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
	Write-Output "Cortana button has been hidden from taskbar."
}

# Restore Cortana button in taskbar
Function RestoreCortana {
	Write-Output "Show Cortana icon on taskbar..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1
	Write-Output "Cortana button has been restored to taskbar."
}

# Show Seconds in taskbar clock
Function ShowSecondsInTaskbar {
	Write-Output " "
	Write-Output "Trying to show seconds in Taskbar clock..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
	Write-Output "Made taskbar clock display seconds."
}

# Hide Seconds in taskbar clock
Function HideSecondsFromTaskbar {
	Write-Output "Trying to hide seconds from Taskbar clock..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 0
	Write-Output "Made taskbar clock hide seconds."
}



######### Features changes #########

# Update status: features changes
Function PrintFeaturesChanges {
	Write-Output " "	
	Write-Output " "
	Write-Output "--------------------------------------------"
	Write-Output "     WINDOWS OPTIONAL FEATURES CHANGES      "
	Write-Output "--------------------------------------------"
	Write-Output " "
}

Function EnableWSL {
	Write-Output "Turning on Windows Subsystem for Linux..."
	dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
	Write-Output "Windows Subsystem for Linux has been turned on."
}

Function EnableVM {
	Write-Output "Turning on Virtual Machine feature..."
	dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
	Write-Output "Virtual Machine feature has been turned on."
}



######### Security changes #########

# Update status: beginning security changes
Function PrintSecurityChanges {
	Write-Output " "
	Write-Output " "
	Write-Output "----------------------------"
	Write-Output "      SECURITY CHANGES      "
	Write-Output "----------------------------"
	Write-Output " "
}

Function AutoLoginPostUpdate {
	Write-Output " "
	Write-Output "Telling this PC to automatically login after Windows Update..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent" -Type DWord -Value 1
	Write-Output "This PC is now set to automatically login after a Windows Update restart."
} 

Function StayOnLockscreenPostUpdate {
	Write-Output " "
	Write-Output "Telling this PC to not automatically login post a Windows Update reset."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent" -Type DWord -Value 0
	Write-Output "This PC will now no longer automatically login to the most recent user account post a Windows Update restart."
}

# Enable Meltdown (CVE-2017-5754) compatibility flag - Required for January 2018 and all subsequent Windows updates
# This flag is normally automatically enabled by compatible antivirus software (such as Windows Defender).
# Use the tweak only if you have confirmed that your AV is compatible but unable to set the flag automatically or if you don't use any AV at all.
# See https://support.microsoft.com/en-us/help/4072699/january-3-2018-windows-security-updates-and-antivirus-software for details.
Function EnableMeltdownCompatFlag {
	Write-Output " "
	Write-Output "Turning on Meltdown (CVE-2017-5754) compatibility flag..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -Type DWord -Value 0
	Write-Output "Meltdown (CVE-2017-5754) compatibility flag has been turned on."
}

# Disable Meltdown (CVE-2017-5754) compatibility flag
Function DisableMeltdownCompatFlag {
	Write-Output " "
	Write-Output "Turning off Meltdown (CVE-2017-5754) compatibility flag..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -ErrorAction SilentlyContinue
	Write-Output "Meltdown (CVE-2017-5754) compatibility flag has been turned off."
}

# Disable SMB1 and SMB2 
Function DisableSMB {
	Write-Output " "
	Write-Output "Turning off Server Message Block v1 and v2..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB2" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "SMBDeviceEnabled" -Type DWord -Value 0
	Write-Output "Server Message Block v1 and v2 have been turned off."
}

# Enable SMB1 and SMB2 
Function EnableSMB {
	Write-Output " "
	Write-Output "Turning on Server Message Block v1 and v2..."1
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB2" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "SMBDeviceEnabled" -Type DWord -Value 1
	Write-Output "Server Message Block v1 and v2 have been turned on."
}



######### System changes #########

Function PrintSystemChanges {
	Write-Output " "
	Write-Output " "
	Write-Output "--------------------------"
	Write-Output "      SYSTEM CHANGES      "
	Write-Output "--------------------------"
	Write-Output " "
}

# To delete Ultimate performance power plan (its safe to do so), you need to go to Control Panel\System and Security\Power Options, click on "Ultimate performance" and then click on "Delete this plan"
Function EnableUltimatePerf {
	Write-Output "Force enabling Ulimate performance power plan..."
	powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
	Write-Output "Ultimate Performance mode has been enabled. You can check it out under 'Control Panel\System and Security\Power Options'!"
}



######### App changes #########

# Update status: starting app changes
Function PrintAppsChanges {
	Write-Output " "
	Write-Output " "
	Write-Output "-------------------------"
	Write-Output "       APP CHANGES       "
	Write-Output "-------------------------"
	Write-Output " "
}

# Debloat apps
Function DebloatApps {
	# Prebuilt apps
	Write-Output "Beginning removal of UWP apps..."
	$Bloatware = @(
	 "Microsoft.549981C3F5F10"
	 "Microsoft.BingNews"
	 "Microsoft.BingWeather" 
	 "Microsoft.GetHelp" 
	 "Microsoft.Getstarted" 
	 "Microsoft.Messaging"
	 "Microsoft.Microsoft3DViewer" 
	 "Microsoft.MixedReality.Portal"
	 "Microsoft.MicrosoftStickyNotes"  
	 "Microsoft.MSPaint"
	 "Microsoft.Office.OneNote"
	 "Microsoft.MicrosoftOfficeHub"
	 "Microsoft.MicrosoftSolitaireCollection" 
	 "Microsoft.NetworkSpeedTest" 
	 "Microsoft.News" 
	 "Microsoft.Office.Lens" 
	 "Microsoft.Office.Sway" 
	 "Microsoft.OneConnect"
	 "Microsoft.People" 
	 "Microsoft.Print3D" 
	 "Microsoft.SkypeApp" 
	 "Microsoft.StorePurchaseApp" 
	 "Microsoft.Whiteboard" 
	 "Microsoft.WindowsAlarms"
	 "Microsoft.WindowsCamera"
	 "Microsoft.WindowsCommunicationsApps" 
	 "Microsoft.WindowsFeedbackHub" 
	 "Microsoft.WindowsMaps" 
	 "Microsoft.WindowsSoundRecorder" 
	 "Microsoft.XboxApp"
	 "Microsoft.XboxGamingOverlay"
	 "Microsoft.YourPhone"
	 "Microsoft.ZuneVideo"
	 "Microsoft.ZuneMusic"
	)
	foreach ($Bloat in $Bloatware) {
		Get-AppxPackage -Name $Bloat| Remove-AppxPackage 
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online | Out-Null
        Write-Output "Removing $Bloat."}
	Write-Output "Unnecessary apps have been removed from this PC."
}

# Install chocolatey
Function InstallChoco {
	Write-Output "Installing Chocolatey..."
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco install chocolatey-core.extension -y
	Write-Output "Chocolatey has been installed."
}

# Install apps
Function InstallApps {
	Write-Output "Installing 7-zip..."
	choco install 7zip -y --silent --limit-output
	Write-Output "7-zip has been installed."
}

# Clear screen because chocolatey fills it lol
Function ClearScreen {
	Write-Output "Clearing this screen..."
	Start-Sleep 1
	cls
}


######### Tasks after successful run #########

# Update status: Performing tasks after successful execution
Function PrintEndTasksBegin{
	Write-Output " "
	Write-Output "--------------"
	Write-Output "Performing tasks after successful execution of scripts..."
	Write-Output "--------------"
	Write-Output " "
}
		
# Update status: Script execution successful
Function PrintEndEndTasks {
	Write-Output " "
	Write-Output " "
	Write-Output " "
	Write-Output "Script execution successful, this PC will give you 10 seconds before it restarts so you can save your work."
	Start-Sleep 2
	Write-Output "To cancel restart, please press Ctrl+C."
	Start-Sleep 8
	Write-Output "Restarting PC now!"
	Start-Sleep 2
	Restart-Computer
}

# Call the desired tweak functions
$tweaks | ForEach { Invoke-Expression $_ }
