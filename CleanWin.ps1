##############
#
# CleanWin
# Author: PratyakshM <pratyakshm@protonmail.com>
#
##############
# Default preset
$tweaks = @(

### Maintenance Tasks ###
	"CleanWin",
	"KindaSleep",
	"ClearShell",
	
### Privacy changes ###
	"PrintPrivacyChanges",
	"DisableDataCollection", 	   # "EnableDataCollection",
	"DisableMapUpdates",	       # "EnableMapUpdates",
	"DisableFeedback",		       # "EnableFeedback",
	"DisableBackgroundApps",       # "EnableBackgroundApps",
	"DisableLocationTracking",     # "EnableLocationTracking",
	"DisableAdvertisingID",        # "EnableAdvertisingID",
	"DisableSpeechRecognition",    # "EnableSpeechRecognition",
	"DisableLangRecommendation",   # "EnableLangRecommendation",
	"LessSleep",
	"ChangesDone",
	"ClearShell",

### Service changes ###
	"PrintServicesChanges",
	"DisableAutoUpdates",		   # "EnableAutoUpdates",
	"DisableLANP2P"                # "EnableLANP2P",
	"DisableAutoplay",             # "EnableAutoplay",
	"DisableAutorun",              # "EnableAutorun",
	"DisableDefragmentation",      # "EnableDefragmentation",
	"SetBIOSTimeUTC",              # "SetBIOSTimeLocal",
	"LessSleep",
	"ChangesDone",
	"ClearShell",

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
	"ChangesDone",
	"ClearShell",

### Features changes ###
	"PrintFeaturesChanges",
	"EnableWSL",
	"EnableVM",
	"LessSleep",
	"ChangesDone",
	"ClearShell",

### Security changes ###
	"PrintSecurityChanges",
	"AutoLoginPostUpdate", 		   # "StayOnLockscreenPostUpdate",
	"DisableMeltdownCompatFlag",   # "EnableMeltdownCompatFlag",
	"DisableSMB",				   # "EnableSMB",
	"LessSleep",
	"ChangesDone",
	"ClearShell",

### System changes ###
	"PrintSystemChanges",
	"EnableUltimatePerf",	
	"LessSleep",
	"ChangesDone",
	"ClearShell",

### App changes ###
	"PrintAppsChanges",
	"DebloatApps",
	"RemoveCamera",
	"RemoveGrooveMusic",
	"RemoveSkype",
	"RemoveYourPhone",
	"QCLS",
	"InstallWinget",
	"QCLS",
	"Install7zip",
	"QCLS",
	"InstallAnydesk",
	"QCLS",
	"InstallDesktopEditors",
	"QCLS",
	"InstallFirefox",
	"QCLS",
	"InstallJRE",
	"QCLS",
	"InstallNotepadplusplus",
	"QCLS",
	"InstallOBS",
	"QCLS",
	"InstallPowerToys",
	"QCLS",
	"InstallqBittorrent",
	"QCLS",
	"InstallRufus",
	"QCLS",
	"InstallSpotify",
	"QCLS",
	"InstallTerminal",
	"QCLS",
	"InstallVLC",
	"QCLS",
	"InstallVSCode",
	"QCLS",
	"InstallWDD",
	"QCLS",
	"LessSleep",
	"ChangesDone",
	"ClearShell",

###  Tasks after successful run ###
	"PrintEndTasksBegin",
	"PrintEndEndTasks"
)


### Maintenance tasks ###

# CleanWin
Function CleanWin {
	Write-Output " "
	Write-Output "CleanWin version 0.6.1 by pratyakshm"
	Write-Output "https://github.com/pratyakshm/CleanWin"
	Write-Output "All rights reserved."
}

# More sleep
Function KindaSleep {
	Start-Sleep 4
}

# Less sleep
Function LessSleep {
	Start-Sleep 3
}

# Clear the shell output
Function ClearShell {
	Write-Output " "
	Write-Output " "
	Write-Output "Clearing shell after waiting for 3 seconds..."
	Start-Sleep 3
	Clear-Host
}

# Clear the shell output quickly
Function QCLS {
	Clear-Host
}

# Changes performed
Function ChangesDone {
	Write-Output " "
	Write-Output "---------------------------"
	Write-Output "     CHANGES PERFORMED     "
	Write-Output "---------------------------"
	Write-Output " "
	Start-Sleep 1
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

# Disable data collection (hardening level - full)
Function DisableDataCollection {
	$message  = 'Data Collection'
	$question = 'Do you want to turn off data collection?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
	if ($decision -eq 0) {
    	Write-Output "Turning off Data collection..."
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
		Get-Service DiagTrack | Stop-Service
		Get-Service DiagTrack | Set-Service -StartupType Disabled
		Get-Service dmwappushservice | Stop-Service
		Get-Service dmwappushservice | Set-Service -StartupType Disabled
		Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
		Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
		Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
		Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
		Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
		Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0
		
		If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
			New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
			}
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
		Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null
		
		If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
			New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
			}
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 1
		
		If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection")) {
			New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
			}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
		Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
		Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
		If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
			New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
			}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
		If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
			New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
			}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1	
		If (!(Test-Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy")) {
			New-Item -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" | Out-Null
			}
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Name "HasAccepted" -Type DWord -Value 0
		If (!(Test-Path "HKCU:\Control Panel\International\User Profile")) {
			New-Item -Path "HKCU:\Control Panel\International\User Profile" | Out-Null
		}
		Set-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut " -Type DWord -Value 1
		Write-Output "Data collection was turned off."
		}
	else {
    "Data collection was not turned off."
	}
}

# Enable Data collection
Function EnableDataCollection {
	Write-Output "Turning on Data collection..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue
	Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Get-Service DiagTrack | Set-Service -StartupType Automatic
	Get-Service dmwappushservice | Set-Service -StartupType Automatic
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -ErrorAction SilentlyContinue
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -ErrorAction SilentlyContinue
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
		}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Allow"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -ErrorAction SilentlyContinue
	If (!(Test-Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy")) {
		New-Item -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" | Out-Null
		}
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Name "HasAccepted" -Type DWord -Value 1
	If (!(Test-Path "HKCU:\Control Panel\International\User Profile")) {
		New-Item -Path "HKCU:\Control Panel\International\User Profile" | Out-Null
		}
	Set-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut " -Type DWord -Value 0
	Write-Output "Data collection has been turned on."
}

# Disable automatic Maps updates
Function DisableMapUpdates {
	Write-Output " "
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
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
	}
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
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach-Object {
		Set-ItemProperty -Path $_.PsPath -Name "Disabled" -Type DWord -Value 1
		Set-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -Type DWord -Value 1
	}
	Write-Output "Background apps have been turned off."
}

# Enable Background application access
Function EnableBackgroundApps {
	Write-Output "Turning on background apps..."
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | ForEach-Object {
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

# Disable Speech Recognition
Function DisableSpeechRecognition {
	Write-Output "Turning off online speech recognition..."
	If (!(Test-Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings")) {
		New-Item -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings" | Out-Null
		New-Item -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Name "HasAccepted" -Type DWord -Value 0
	Write-Output "Online speech recognition has been turned off."
}

# Enable Speech Recognition
Function EnableSpeechRecognition {
	Write-Output "Turning on online speech recognition..."
	If (!(Test-Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy")) {
		New-Item -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Name "HasAccepted" -Type DWord -Value 1
	Write-Output "Online speech recognition has been turned on."
}

# Disable language list access for relevant content
Function DisableLangRecommendation {
	Write-Output "Telling Windows to not give websites access to your language list for recommending local content..."
	If (!(Test-Path "HKCU:\Control Panel\International\User Profile")) {
		New-Item -Path "HKCU:\Control Panel\International\User Profile" | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut " -Type DWord -Value 1
	Write-Output "Websites will now no longer be able to access your language list to provide you locally relevant content."
}

# Enable language list access for relevant content
Function EnableLangRecommendation {
	Write-Output "Telling Windows to let websites access your language list for recommending local content..."
	If (!(Test-Path "HKCU:\Control Panel\International\User Profile")) {
		New-Item -Path "HKCU:\Control Panel\International\User Profile" | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut " -Type DWord -Value 0
	Write-Output "Websites will now be able to access your language list to provide you locally relevant content."
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
	$question = 'Do you want to turn off automatic Windows updates?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
	if ($decision -eq 0) {
		Write-Output "Turning off automatic Windows updates..."
			If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) {
	  		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" | Out-Null
	  		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" | Out-Null
	  		}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoUpdate -Type DWord -Value 1
		Write-Output "Automatic Windows updates have been turned off."
	}
	else {
	"Automatic Windows Updates were left as it is."
	}
}

# Enable automatic updates
Function EnableAutoUpdates {
	Write-Output "Turning on automatic Windows updates..."
	Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue
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
	$message  = 'Disk Defragmentation'
	$question = 'Do you want to turn off disk defragmentation?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
	if ($decision -eq 0) {
		Write-Output "Turning off scheduled defragmentation..."
		Disable-ScheduledTask -TaskName "Microsoft\Windows\Defrag\ScheduledDefrag" | Out-Null
		Write-Output "Scheduled defragmentation has been turned off."
	}
	else {
	"Automatic disk defragmentation was left as it is."
	}
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
	$question = 'Do you want to have the taskbar clock display seconds?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
	if ($decision -eq 0) {
	Write-Output "Telling taskbar clock to display seconds..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
	Write-Output "Taskbar clock will now display seconds."
	}
	else {
	"Taskbar clock was left as it is."
	}
}

# Hide Seconds in taskbar clock
Function HideSecondsFromTaskbar {
	Write-Output "Trying to hide seconds from Taskbar clock..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 0
	Write-Output "Taskbar clock will no longer display seconds."
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
	$question = 'Do you want to turn on Windows Subsystem for Linux?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
		Write-Output "Turning on Windows Subsystem for Linux..."
		dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
		Write-Output "Windows Subsystem for Linux has been turned on."
	}
	else {
	"Windows Subsystem for Linux wasn't turned on."
	}
}

Function EnableVM {
	Write-Output " "
	$question = 'Do you want to turn on Virtual Machine? (hit yes if you turned on WSL)'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
		Write-Output "Turning on Virtual Machine..."
		dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
		Write-Output "Virtual Machine has been turned on."
	}
	else {
	"Virtual Machine wasn't turned on."
	}
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
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent"
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
	 "Microsoft.MicsoftStickyNotes"  
	 "Microsoft.MSPaint"
	 "Microsoft.MicrosoftOfficeHub"
	 "Microsoft.Office.OneNote"
	 "Microsoft.MicrosoftSolitaireCollection" 
	 "Microsoft.NetworkSpeedTest" 
	 "Microsoft.News" 
	 "Microsoft.Office.Sway" 
	 "Microsoft.OneConnect"
	 "Microsoft.People" 
	 "Microsoft.Print3D" 
	 "Microsoft.StorePurchaseApp" 
	 "Microsoft.WindowsAlarms"
	 "Microsoft.WindowsCommunicationsApps" 
	 "Microsoft.WindowsFeedbackHub" 
	 "Microsoft.WindowsMaps" 
	 "Microsoft.WindowsSoundRecorder" 
	 "Microsoft.XboxApp"
	 "Microsoft.XboxGamingOverlay"
	 "Microsoft.ZuneVideo"
	)
	foreach ($Bloat in $Bloatware) {
		Get-AppxPackage -Name $Bloat| Remove-AppxPackage 
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online | Out-Null
        Write-Output "Removing $Bloat."}
	Write-Output "Unnecessary apps have been removed from this PC."
}

Function RemoveCamera {
		Write-Output " "
		$question = 'Do you want to remove Camera app?'
		$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
		$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
		$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
		$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {	
			Removing Camera app...
			Get-AppxPackage "Microsoft.WindowsCamera" | Remove-AppxPackage
			Write-Output "Camera app has been removed."
		}
		else {
			Camera app was not removed.
		}
}

Function RemoveGrooveMusic {
		Write-Output " "
		$question = 'Do you want to remove Groove Music app?'
		$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
		$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
		$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
		$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {	
			Removing Groove Music...
			Get-AppxPackage "Microsoft.ZuneMusic" | Remove-AppxPackage
			Write-Output "Groove Music has been removed."
		}
		else {
			Groove Music was not removed.
		}
}
	
Function RemoveSkype {
		Write-Output " "
		$question = 'Do you want to remove Skype app?'
		$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
		$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
		$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
		$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {	
			Removing Skype...
			Get-AppxPackage "Microsoft.SkypeApp" | Remove-AppxPackage
			Write-Output "Skype has been removed."
		}
		else {
			Skype was not removed.
		}
}

Function RemoveYourPhone {
		Write-Output " "
		$question = 'Do you want to remove Your Phone?'
		$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
		$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
		$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
		$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {	
			Removing Your Phone...
			Get-AppxPackage "Microsoft.YourPhone" | Remove-AppxPackage
			Write-Output "Your Phone has been removed."
		}
		else {
			Your Phone was not removed.
		}
}

# Install new DesktopAppInstaller to get winget compatibility
Function InstallWinget {
	Write-Output " "
	Write-Output "Downloading Windows Package Manager..."
	Invoke-WebRequest https://github.com/microsoft/winget-cli/releases/download/v.0.2.2521-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -O C:\WindowsPackageManager.appx
	Write-Output "Installing Windows Package Manager..."
	Add-AppxPackage "WindowsPackageManager.appx"
	Write-Output "Windows Package Manager has been installed."
	Write-Output "Deleting downloaded installer..."
	Remove-Item C:\WindowsPackageManager.appx
	Write-Output "Deleted downloaded installer."
}

# Install 7zip
Function Install7zip {
	Write-Output " "
	Write-Output "Installing 7-zip..."
	winget install --id=7zip.7zip
}

# Install AnyDesk 
Function InstallAnydesk {
	Write-Output " "
	$question = 'Do you want to install AnyDesk?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing AnyDesk..."
			winget install --id=AnyDeskSoftwareGmbH.AnyDesk		
		}
}

# Install OnlyOffice DesktopEditors
Function InstallDesktopEditors {
	Write-Output " "
	$question = 'Do you want to install OnlyOffice Desktop Editors?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing OnlyOffice Desktop Editors..."
			winget install --id=ONLYOFFICE.DesktopEditors	
		}
}

# Install Firefox
Function InstallFirefox {
	Write-Output " "
	$question = 'Do you want to install Mozilla Firefox?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Mozilla Firefox..."
			winget install --id=Mozilla.Firefox		
		}
}

# Install JRE 
Function InstallJRE {
	Write-Output " "
	$question = 'Do you want to install Java Runtime Environment?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Java Runtime Environment..."
			winget install --id=Oracle.JavaRuntimeEnvironment
		}
}

# Install Microsoft Teams 
Function Install MSTeams {
	Write-Output " "
	$question = 'Do you want to install Microsoft Teams?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Microsoft Teams..."
			winget install --id=Microsoft.Teams
		}
}
# Install Notepad++
Function InstallNotepadplusplus {
	Write-Output " "
	Write-Output " "
	$question = 'Do you want to install Notepad++?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Notepad++..."
			winget install --id=Notepad++.Notepad++	
		}
}

# Install OBS Studio
Function InstallOBS {
	Write-Output " "
	$question = 'Do you want to install OBS Studio?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing OBS Studio..."
			winget install --id=OBSProject.OBSStudio	
		}
	
}

# Install PowerToys
Function InstallPowerToys {
	Write-Output " "
	$question = 'Do you want to install PowerToys?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing PowerToys..."
			winget install --id=Microsoft.PowerToys
		}
}

# Install qBittorrent
Function InstallqBittorrent {
	Write-Output " "
	$question = 'Do you want to install qBittorrent?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing qBittorrent..."
			winget install --id=qBittorrent.qBittorrent
		}
}

# Install Rufus 
Function InstallRufus {
	Write-Output " "
	$question = 'Do you want to install Rufus?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Rufus..."
			winget install --id=Rufus.Rufus
		}
}

# Install Spotify
Function InstallSpotify {
	Write-Output " "
	Write-Output " "
	$question = 'Do you want to install Spotify?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Spotify..."
			winget install --id=Spotify.Spotify	
		}
}

# Install VLC
Function InstallVLC {
	Write-Output " "
	$question = 'Do you want to install VLC?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing VLC..."
			winget install --id=VideoLAN.VLC
		}
}

# Install Visual Studio Code
Function InstallVSCode {
	Write-Output " "
	$question = 'Do you want to install Visual Studio Code?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Visual Studio Code..."
			winget install --id=Microsoft.VisualStudioCode
		}
}

# Install WDD
Function InstallWDD {
	Write-Output " "
	$question = 'Do you want to install WinDynamicDesktop?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing WinDynamicDesktop..."
			winget install --id=t1m0thyj.WinDynamicDesktop
		}
}

# Install Windows Terminal 
Function InstallTerminal {
	Write-Output " "
	$question = 'Do you want to install Windows Terminal?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Windows Terminal..."
			winget install --id=Microsoft.WindowsTerminal
		}
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
	$question = 'CleanWin execution successful. Do you want to restart your PC now?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
	if ($decision -eq 0) {
		Start-Sleep 1
		Restart-Computer
	}
	else {
	"This PC will not automatically restart, however a restart is pending."
	}
}
# Call the desired tweak functions
$tweaks | ForEach-Object { Invoke-Expression $_ }
