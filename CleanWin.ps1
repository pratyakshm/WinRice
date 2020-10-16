##############
#
# Windows 10 - Setup Script
# Author: PratyakshM <pratyakshm@protonmail.com>
# Notes: Please run the script ONLY after giving the documentation (here, README.md) a thorough read.
#
##############
# Default preset
$tweaks = @(

### Tasks before beginning execution ###
	"FetchAdmin",
	"StopExplorer",
	
### Privacy Tweaks ###
	"DisableMapUpdates",	       # "EnableMapUpdates",
	"DisableFeedback",		       # "EnableFeedback",
	"DisableBackgroundApps",       # "EnableBackgroundApps",
	"DisableLocationTracking",     # "EnableLocationTracking",
	"DisableAdvertisingID",        # "EnableAdvertisingID",

### Service Tweaks ###
	"PrintBeginServiceTweaks"
	"UpdateOnlyFromMSFT"           # "UpdateFromOtherSources",
	"DisableAutoplay",             # "EnableAutoplay",
	"DisableAutorun",              # "EnableAutorun",
	"DisableDefragmentation",      # "EnableDefragmentation",
	"SetBIOSTimeUTC",              # "SetBIOSTimeLocal",
	"PrintServiceTweaksDone"

### Windows Explorer Changes ###
	"PrintBeginExplorerTweaks",
	"ShowVerboseStatus",           # "HideVerboseStatus",
	"EnablePrtScrToSnip",		   # "DisablePrtScrSnip",
	"HideLangIcon",                # "ShowLangIcon",
	"DisableStickyKeys",           # "EnableStickyKeys",
	"SetExplorerThisPC",           # "SetExplorerQuickAccess",
    "Hide3DObjectsInThisPC",       # "Show3DObjectsInThisPC",
	"Hide3DObjectsInExplorer",     # "Show3DObjectsInExplorer",
	"HideTaskView",                # "ShowTaskView",
	"ShowSecondsInTaskbar",        # "HideSecondsFromTaskbar",
	"PrintExplorerTweaksDone",

### Features changes ###
	"PrintBeginFeatureTweaks",
	"EnableWSL",
	"EnableVM",
	"PrintFeatureTweaksDone",

### Security changes ###
	"PrintBeginSecurityTweaks",
	"AutoLoginPostUpdate", 		   # "StayOnLockscreenPostUpdate",
	"DisableMeltdownCompatFlag",   # "EnableMeltdownCompatFlag",
	"DisableSMB",				   # "EnableSMB",
	"PrintSecurityTweaksDone",
	
### Application changes ###
	"PrintBeginAppTweaks",
	"InstallChoco",
	"InstallApps",
	"DebloatAll",
	"PrintAppTweaksDone",

###  Tasks after successful run ###
	"PrintEndTasksBegin",
	"StartExplorer",
	"PrintEndTasksDone",
	"RestartOnInput"

)
### Tasks before beginning execution ###

# Fetch Administrator permissions
Function FetchAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
		Exit
	}
}

# Kill explorer.exe
Function StopExplorer {
	Write-Output "Shutting down Windows Explorer before beginning execution of script..."
	taskkill /f /im explorer.exe
	Write-Output "Beginning script execution..."
}



### Privacy Tweaks ###

# Update status: beginning privacy changes
Function PrintBeginPrivacyTweaks {
	Write-Output "###########"
	Write-Output "Beginning with privacy tweaks..."
	Write-Output "###########"
}

# Disable automatic Maps updates
Function DisableMapUpdates {
	Write-Output "Disabling automatic Maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
	Write-Output "Automatic Maps updates have been disabled."
}

# Enable automatic Maps updates
Function EnableMapUpdates {
	Write-Output "Enabling automatic Maps updates..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -ErrorAction SilentlyContinue
	Write-Output "Automatic Maps updates have been enabled."
}

# Disable Feedback
Function DisableFeedback {
	Write-Output "Disabling Feedback..."
	If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
	Write-Output "Feedback has been disabled."
}

# Enable Feedback
Function EnableFeedback {
	Write-Output "Enabling Feedback..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -ErrorAction SilentlyContinue
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
	Write-Output "Feedback has been enabled."
}

# Disable Background application access - ie. if apps can download or update when they aren't used - Cortana is excluded as its inclusion breaks start menu search
Function DisableBackgroundApps {
	Write-Output "Disabling Background app access..."
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach {
		Set-ItemProperty -Path $_.PsPath -Name "Disabled" -Type DWord -Value 1
		Set-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -Type DWord -Value 1
	}
	Write-Output "Background app access has been disabled."
}

# Enable Background application access
Function EnableBackgroundApps {
	Write-Output "Enabling Background app access..."
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | ForEach {
		Remove-ItemProperty -Path $_.PsPath -Name "Disabled" -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -ErrorAction SilentlyContinue
	}
	Write-Output "Background app access has been enabled."
}

# Disable Location Tracking
Function DisableLocationTracking {
	Write-Output "Disabling Location tracking..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
	Write-Output "Location tracking has been disabled."
}

# Enable Location Tracking
Function EnableLocationTracking {
	Write-Output "Enabling Location Tracking..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Allow"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 1
	Write-Output "Location Tracking has been enabled."
}

# Disable Advertising ID
Function DisableAdvertisingID {
	Write-Output "Disabling Advertising ID..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1
	Write-Output "Advertising ID has been disabled."
}

# Enable Advertising ID
Function EnableAdvertisingID {
	Write-Output "Enabling Advertising ID..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -ErrorAction SilentlyContinue
	Write-Output "Advertising ID has been enabled."
}

# Update status: beginning privacy changes
Function PrintPrivacyTweaksDone {
	Write-Output "###########"
	Write-Output "Privacy tweaks have been appplied."
	Write-Output "###########"
}



### Service Tweaks ###

# Update status: beginning service tweaks
Function PrintBeginServiceTweaks {
	Write-Output "###########"
	Write-Output "Beginning Service tweaks..."
	Write-Output "###########"
}

# Update only from MSFT (no LAN or P2P)
Function UpdateOnlyFromMSFT {
	Write-Output "Disabling P2P and LAN Updates so that this PC will recieve Windows Updates only from Microsoft servers..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name DownloadMode -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name DODownloadMode -Type DWord -Value 0
	Write-Output "This PC is now set to download updates only from Microsoft servers."
}

Function UpdateFromOtherSources {
	Write-Output "Enabling back P2P and LAN based Windows Updates delivery..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name DownloadMode -Type DWord -Value 3
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name DODownloadMode -Type DWord -Value 3
	Write-Output "This PC can now also recieve updates from other sources like LAN and P2P."
}

# Disable Autoplay
Function DisableAutoplay {
	Write-Output "Disabling Autoplay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
	Write-Output "AutoPlay has been disabled."
}

# Enable Autoplay
Function EnableAutoplay {
	Write-Output "Enabling Autoplay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
	Write-Output "AutoPlay has been enabled."
}

# Disable Autorun for all drives
Function DisableAutorun {
	Write-Output "Disabling Autorun for all drives..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
	Write-Output "Autorun has been disabled."
}

# Enable Autorun for removable drives
Function EnableAutorun {
	Write-Output "Enabling Autorun for all drives..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
		Write-Output "Autorun has been enabled."
}

# Disable scheduled defragmentation task
Function DisableDefragmentation {
	Write-Output "Disabling scheduled defragmentation..."
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Defrag\ScheduledDefrag" | Out-Null
	Write-Output "Scheduled defragmentation has been disabled."
}

# Enable scheduled defragmentation task
Function EnableDefragmentation {
	Write-Output "Enabling scheduled defragmentation..."
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Defrag\ScheduledDefrag" | Out-Null
	Write-Output "Scheduled defragmentation has been enabled."
}

# Set BIOS time to UTC
Function SetBIOSTimeUTC {
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

# Update status: service tweaks done
Function PrintServiceTweaksDone {
	Write-Output "###########"
	Write-Output "Service tweaks have been applied, next up: UI tweaks:"
	Write-Output "###########"
}



### Explorer  changes ###

# Update status: beginning Explorer Tweaks
Function PrintBeginExplorerTweaks {	
	Write-Output "###########"
	Write-Output "Beginning Explorer tweaks..."
	Write-Output "###########"
}

# Show verbose status
Function ShowVerboseStatus {
	Write-Output "Enabling Verbose Status..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "VerboseStatus" -Type DWord -Value 1
	Write-Output "Verbose Status has been enabled."
}

# Hide verbose status 
Function HideVerboseStatus {
	Write-Output "Disabling Verbose Status..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "VerboseStatus" -Type DWord -Value 0
	Write-Output "Verbose Status has been disabled."
}

# Enable use print screen key to open screen snipping
Function EnablePrtScrToSnip {
	Write-Output "Directing Print screen key to launch screen snipping..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 1
	Write-Output "Print screen key is set to launch screen snip."
	}
	
# Disable use print screen key to open screen snipping
Function DisablePrtScrSnip {
	Write-Output "Disabling Print screen key's ability to launch screen snip..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 0
	Write-Output "Print screen key will now no longer launch screen snip."
}

# Hide language icon in Taskbar
Function HideLangIcon {
	Write-Output "Hiding language icon from Taskbar..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\CTF\LangBar" -Name "ShowStatus" -Type DWord -Value 3
	Write-Output "Hid Language icon from Taskbar."
}

# Show lanugage icon in Taskbar
Function ShowLangIcon {
	Write-Output "Showing language icon in Taskbar..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\CTF\LangBar" -Name "ShowStatus" -Type DWord -Value 4
	Write-Output "Shown Language icon in Taskbar."
}

# Disable Sticky keys prompt
Function DisableStickyKeys {
	Write-Output "Disabling sticky keys prompt..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
	Write-Output "Disabled Sticky keys prompt."
}

# Enable Sticky keys prompt
Function EnableStickyKeys {
	Write-Output "Enaling sticky keys prompt..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
	Write-Output "Sticky keys prompt has been enabled."
}

# Change default Explorer view to This PC
Function SetExplorerThisPC {
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
	Write-Output "Hiding 3D Objects icon from This PC..."
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
	Write-Output "Hid 3D Objects icon from This PC."
}

# Show 3D Objects icon in This PC
Function Show3DObjectsInThisPC {
	Write-Output "Showing 3D Objects icon in This PC..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" | Out-Null
	}
	Write-Output "Shown 3D objects icon in This PC."
}

# Hide 3D Objects icon from Explorer namespace - Hides the icon also from personal folders and open/save dialogs
Function Hide3DObjectsInExplorer {
	Write-Output "Hiding 3D Objects icon from Explorer namespace..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
	If (!(Test-Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag")) {
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
	Write-Output "Hid 3D Objects icon from Explorer."
}

# Show 3D Objects icon in Explorer namespace
Function Show3DObjectsInExplorer {
	Write-Output "Showing 3D Objects icon in Explorer namespace..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
	Write-Output "Shown 3D objects icon in Explorer namespace."
}

# Hide Task View button
Function HideTaskView {
	Write-Output "Hiding Task View button..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
	Write-Output "Hid Task View button."
}

# Show Task View button
Function ShowTaskView {
	Write-Output "Showing Task View button..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
	Write-Output "Shown Task View button."
}

# Show Seconds in taskbar clock
Function ShowSecondsInTaskbar {
	Write-Output "Trying to show seconds in Taskbar clock..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
	Write-Output "Made taskbar clock display seconds"
}

# Hide Seconds in taskbar clock
Function HideSecondsFromTaskbar {
	Write-Output "Trying to hide seconds from Taskbar clock"
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 0
	Write-Output "Made taskbar clock hide seconds"
}

# Update status: Explorer Tweaks done
Function PrintExplorerTweaksDone {	
	Write-Output "###########"
	Write-Output "Explorer tweaks have been applied."
	Write-Output "###########"
}


### Features changes ###

# Update status: Beginning feature tweaks
Function PrintBeginFeatureTweaks {	
	Write-Output "###########"
	Write-Output "Beginning Windows feature changes..."
	Write-Output "###########"
}

Function EnableWSL {
	Write-Output "Enabling Windows Subsystem for Linux..."
	dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
	Write-Output "Windows Subsystem for Linux has been enabled."
}

Function EnableVM {
	Write-Output "Enabling Virtual Machine..."
	dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
	Write-Output "Virtual Machine has been enabled."
}

# Update status: Feature tweaks done
Function PrintFeatureTweaksDone {	
	Write-Output "###########"
	Write-Output "Feature changes have been performed."
	Write-Output "###########"
}



### Security changes ###

# Update status: beginning security tweaks
Function PrintBeginSecurityTweaks {
	Write-Output "###########"
	Write-Output "Beginning Security tweaks..."
	Write-Output "###########"
	}

Function AutoLoginPostUpdate {
	Write-Output "Enabling this PC to automatically login after Windows Update..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent" -Type DWord -Value 1
	Write-Output "This PC is now set to automatically login after a Windows Update restart."
} 

Function StayOnLockscreenPostUpdate {
	Write-Output "Telling this PC to not automatically login post a Windows Update reset."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent" -Type DWord -Value 0
	Write-Output "This PC will now no longer automatically login to the most recent user account post a Windows Update restart."
}

# Enable Meltdown (CVE-2017-5754) compatibility flag - Required for January 2018 and all subsequent Windows updates
# This flag is normally automatically enabled by compatible antivirus software (such as Windows Defender).
# Use the tweak only if you have confirmed that your AV is compatible but unable to set the flag automatically or if you don't use any AV at all.
# See https://support.microsoft.com/en-us/help/4072699/january-3-2018-windows-security-updates-and-antivirus-software for details.
Function EnableMeltdownCompatFlag {
	Write-Output "Enabling Meltdown (CVE-2017-5754) compatibility flag..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -Type DWord -Value 0
	Write-Output "Meltdown (CVE-2017-5754) compatibility flag has been enabled."
}

# Disable Meltdown (CVE-2017-5754) compatibility flag
Function DisableMeltdownCompatFlag {
	Write-Output "Disabling Meltdown (CVE-2017-5754) compatibility flag..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -ErrorAction SilentlyContinue
	Write-Output "Meltdown (CVE-2017-5754) compatibility flag has been disabled."
}

# Disable SMB1 and SMB2 
Function DisableSMB {
	Write-Output "Disabling Server Message Block v1 and v2..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB2" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "SMBDeviceEnabled" -Type DWord -Value 0
	Write-Output "Server Message Block v1 and v2 have been disabled."
}

# Enable SMB1 and SMB2 
Function EnableSMB {
	Write-Output "Enabling Server Message Block v1 and v2..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB2" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "SMBDeviceEnabled" -Type DWord -Value 1
	Write-Output "Server Message Block v1 and v2 have been enabled."
}

# Update status: security tweaks done
Function PrintSecurityTweaksDone {
	Write-Output "###########"
	Write-Output "Security tweaks have been applied."
	Write-Output "###########"
}



####### Application changes ###

# Update status: beginning application changes
Function PrintBeginAppTweaks {
	Write-Output "###########"
	Write-Output "Beginning with app tweaks..."
	Write-Output "###########"
}

# Debloat apps
Function DebloatAll {
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
	 "Microsoft.YourPhone"
	 "Microsoft.ZuneVideo"
	 "Microsoft.ZuneMusic"
	)
	foreach ($Bloat in $Bloatware) {
		Get-AppxPackage -Name $Bloat| Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Write-Output "Removing $Bloat."}
	Write-Output "UWP apps have been debloated."
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
	choco install 7zip -y
	Write-Output "7-zip has been installed."
}

# Update status: app tweaks done
Function PrintAppTweaksDone {
	Write-Output "###########"
	Write-Output "Apps tweaks have been applied."
	Write-Output "###########"
}




### Tasks after successful run ###

# Update status: Performing tasks after successful execution
Function PrintEndTasksBegin{
	Write-Output "###########"
	Write-Output "Performing tasks after successful execution of scripts..."
	Write-Output "###########"
}
	
# Start Explorer.exe
Function StartExplorer {
	Write-Output "Attempting to start Windows Explorer..."
	start explorer.exe
	Write-Output "Windows Explorer has started."
}
	
# Update status: Script execution successful
Function PrintEndTasksDone{
	Write-Output "###########"
	Write-Output "Script execution successful, all tasks have been performed successfully."
	Write-Output "###########"
}

# Call the desired tweak functions
$tweaks | ForEach { Invoke-Expression $_ }
