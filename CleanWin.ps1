##############
#
# CleanWin
# Author: PratyakshM <pratyakshm@protonmail.com>
#
##############
# Default preset
$tasks = @(

### Maintenance Tasks ###
	"CleanWin",
	"LessSleep",
	"ClearShell",
	
### Privacy changes ###
	"PrintPrivacyChanges",
	"OOShutup10Config",
	"DisableTelemetry", 	   # "EnableDataCollection",
	"DisableActivityHistory",
	"DisableAdvertisingID",
	"DisableFeedback",		       
	"DisableBackgroundApps",     
	"DisableLangRecommendation",  
	"DisableLocationTracking",  
	"DisableMapUpdates",
	"DisableSuggestions",		  
	"DisableSpeechRecognition",    
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
	"DebloatApps", "RemoveCamera", "RemoveGrooveMusic",	"RemoveSkype",	"RemoveYourPhone",	"CleanupRegistry",
	"ConfirmInstall", "InstallWinget",
	"Install7zip", "InstallAutoDark", "InstallFirefox", "InstallJRE", "InstallOBS", "InstallPowerToys",	"InstallPython", "InstallRevo",	"InstallqBittorrent", "InstallRufus",
	"InstallTerminal", "InstallVLC", "InstallVSCode", "InstallWDD",
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
	Write-Output "CleanWin v0.7.1 by pratyakshm"
	Write-Output "https://github.com/pratyakshm/CleanWin"
	Write-Output "CleanWin is licensed under the MIT License: https://github.com/pratyakshm/CleanWin/blob/master/LICENSE"
	Write-Output "All rights reserved."
}

# Less sleep
Function LessSleep {
	Start-Sleep 1
}

# Clear the shell output
Function ClearShell {
	Write-Output " "
	Write-Output "Clearing shell after waiting for 3 seconds..."
	Start-Sleep 3
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

# Apply O&O Shutup10 Recommended Configuration (thanks to Chris Titus for the idea)
Function OOShutup10Config {
	Write-Output " "
	$question = 'Do you want apply O&OShutup10 settings?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
	if ($decision -eq 0) {
	Write-Output "Applying O&OShutup10 settings..."
	Import-Module BitsTransfer
	Start-BitsTransfer -Source "https://raw.githubusercontent.com/pratyakshm/cleanwin/master/ooshutup10.cfg" -Destination ooshutup10.cfg
	Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination OOSU10.exe
	./OOSU10.exe ooshutup10.cfg /quiet
	Remote-Item ooshutup10.cfg OOSU10.exe
	Write-Output "O&OShutup10 settings were applied."
	}
}

# Disable telemetry
Function DisableTelemetry {
	Write-Host " "
	$question = 'Do you want to turn off telemetry?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
	if ($decision -eq 0) {
		Write-Output "Turning off telemetry..."

		# Disable suggestions and bloatware auto-install
		$Suggestions1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
		$Suggestions2 = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
		Set-ItemProperty -Path $Suggestions1 -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
		Set-ItemProperty -Path $Suggestions1 -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
		Set-ItemProperty -Path $Suggestions1 -Name "SoftLandingEnabled" -Type DWord -Value 0
		Set-ItemProperty -Path $Suggestions1 -Name "SubscribedContent" -Type DWord -Value 0

		# Disable tailored experiences
		$CloudContent = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
		If (!(Test-Path $CloudContent )) {
			New-Item $CloudContent -Force | Out-Null
			}
		Set-ItemProperty -Path $CloudContent -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1

		# Disable scheduled tasks
		Get-ScheduledTask Consolidator | Disable-ScheduledTask | Out-Null
		Get-ScheduledTask DmClient | Disable-ScheduledTask | Out-Null
		Get-ScheduledTask DmClientOnScenarioDownload | Disable-ScheduledTask | Out-Null
		Get-ScheduledTask ProgramDataUpdater | Disable-ScheduledTask | Out-Null
		Get-ScheduledTask QueueReporting | Disable-ScheduledTask | Out-Null
		Get-ScheduledTask UsbCeip | Disable-ScheduledTask | Out-Null

		# Disable telemetry
		$DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
		$DataCollection2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
		$DataCollection3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
		Set-ItemProperty -Path $DataCollection1 -Name "AllowTelemetry" -Type DWord -Value 0
		Set-ItemProperty -Path $DataCollection2 -Name "AllowTelemetry" -Type DWord -Value 0
		Set-ItemProperty -Path $DataCollection3 -Name "AllowTelemetry" -Type DWord -Value 0

		# Stop and disable telemetry services
		Stop-Service DiagTrack | Set-Service -StartupType Disabled
		Stop-Service dmwappushservice | Set-Service -StartupType Disabled
		
		Write-Output "Telemetry has been turned off."
	}
	
}

# Disable activity history
Function DisableActivityHistory {
	Write-Output " "
	Write-Output "Turning off activity history..."
	$ActivityFeed = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityFeed -Name "EnableActivityFeed" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "PublishUserActivities" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "UploadUserActivities" -Type DWord -Value 0	
	Write-Output "Activity history has been turned off."
}

# Disable Advertising ID
Function DisableAdvertisingID {
	Write-Output " "
	Write-Output "Turning off Advertising ID..."
	$AdvertisingID = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	If (!(Test-Path $AdvertisingID)) {
		New-Item -Path $AdvertisingID | Out-Null
	}
	Set-ItemProperty -Path $AdvertisingID -Name "DisabledByGroupPolicy" -Type DWord -Value 1
	Write-Output "Advertising ID has been turned off."
}

# Disable Feedback
Function DisableFeedback {
	Write-Output " "
	Write-Output "Turning off Feedback..."
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
	Disable-ScheduledTask -TaskName $Feedback3 -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskName $Feedback4 -ErrorAction SilentlyContinue | Out-Null
	Write-Output "Feedback has been turned off."
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

# Disable Location Tracking
Function DisableLocationTracking {
	Write-Output " "
	Write-Output "Turning off location tracking..."
	$Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	$Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
	If (!(Test-Path $Location1)) {
		New-Item -Path $Location1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Deny"
	Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 0
	Write-Output "Location tracking has been turned off."
}

# Disable language list access for relevant content
Function DisableLangRecommendation {
	Write-Output " "
	Write-Output "Restricting websites from accessing your language list..."
	$Language = "HKCU:\Control Panel\International\User Profile"
	If (!(Test-Path $Language)) {
		New-Item -Path $Language | Out-Null
	}
	Set-ItemProperty -Path $Language -Name "HttpAcceptLanguageOptOut " -Type DWord -Value 1
	Write-Output "Websites have been restricted from accessing your language list."
}

# Disable automatic Maps updates
Function DisableMapUpdates {
	Write-Output " "
	Write-Output "Turning off automatic maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
	Write-Output "Automatic Maps updates have been turned off."
}

# Disable Speech Recognition
Function DisableSpeechRecognition {
	Write-Output " "
	Write-Output "Turning off online speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	If (!(Test-Path $Speech)) {
		New-Item -Path $Speech | Out-Null
	}
	Set-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 0
	Write-Output "Online speech recognition has been turned off."
}

# Disable suggestions and bloatware auto-install
Function DisableSuggestions {
	Write-Output " "
	Write-Output "Turning off suggestions in start menu and file explorer..."
	$Suggestions1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	$Suggestions2 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	Set-ItemProperty -Path $Suggestions1 -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions1 -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions2 -Name "ShowSyncProviderNotifications" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions1 -Name "SoftLandingEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path $Suggestions1 -Name "SubscribedContent" -Type DWord -Value 0
	Write-Output "Suggestions in start menu and file explorer have been turned off."
}


# Reverts all privacy changes made by CleanWin
Function Revert-Privacy {

	# Enable advertising ID
	$Advertising = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	Remove-ItemProperty -Path $Advertising -Name "DisabledByGroupPolicy" -ErrorAction SilentlyContinue

	# Enable activity history
	$ActivityHistory = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityHistory -Name "EnableActivityFeed" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "PublishUserActivities" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "UploadUserActivities" -Type DWord -Value 1
	
	# Enable feedback
	$Feedback = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	If (!(Test-Path $Feedback )) {
		New-Item $Feedback -Force | Out-Null
		}
	Remove-ItemProperty -Path $Feedback -Name "NumberOfSIUFInPeriod"

	# Enable language list
	$LanguageList = "HKCU:\Control Panel\International\User Profile"
	If (!(Test-Path $LanguageList)) {
		New-Item -Path $LanguageList | Out-Null
		}
	Set-ItemProperty -Path $LanguageList  -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 0
	
	# Enable location tracking
	$Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	$Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
	If (!(Test-Path )) {
		New-Item -Path $Location1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Allow"
	Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 1
	
	# Disable Maps updates
	Remove-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled"

	# Enable suggestions and bloatware auto-install
	$Suggestions1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	$Suggestions2 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	Remove-ItemProperty -Path $Suggestions1 -Name "SilentInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions1 -Name "SystemPaneSuggestionsEnabled"
	Remove-ItemProperty -Path $Suggestions2 -Name "ShowSyncProviderNotifications"
	Remove-ItemProperty -Path $Suggestions1 -Name "SoftLandingEnabled"
	Remove-ItemProperty -Path $Suggestions1 -Name "SubscribedContent"

	# Enable speech recognition
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	If (!(Test-Path )) {
		New-Item -Path $Speech | Out-Null
		}
	Set-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 1
	
	# Enable Tailored Experiences
	$TailoredExp1 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	$TailoredExp2 = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
	$TailoredExp3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Remove-ItemProperty -Path $TailoredExp1 -Name "DisableTailoredExperiencesWithDiagnosticData" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $TailoredExp2 -Name "Disabled" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $TailoredExp3 -Name "DoNotShowFeedbackNotifications" -ErrorAction SilentlyContinue
	
	# Enable telemetry
	$Telemetry1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Set-ItemProperty -Path $Telemetry1  -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry2 -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry3 -Name "AllowTelemetry" -Type DWord -Value 3
	
	# Start telemetry services
	Start-Service DiagTrack | Set-Service -StartupType Automatic
	Start-Service dmwappushservice | Set-Service -StartupType Automatic
	
	# Enable tasks
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
	
}



######### Service Changes #########

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
	Write-Host " "
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
		dism.exe /Online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /all /NoRestart /Quiet
		dism.exe /Online /Enable-Feature /FeatureName:VirtualMachinePlatform /All /NoRestart /Quiet
		dism.exe /Online /Enable-Feature /FeatureName:Microsoft-Hyper-V /All /NoRestart	/Quiet
		Write-Output "Windows Subsystem for Linux has been turned on." 
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
	Write-Output "Turning on ultimate performance power plan..."
	powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
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
	Write-Output "Beginning uninstallation of unnecesary apps..."
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
        Write-Output "Uninstalling $Bloat."}
	Write-Output "Unnecessary apps have been uninstalled from this PC."
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
}

Function CleanupRegistry {
    $Keys = @(
            
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
        Write-Output "Removing $Key from registry"
        Remove-Item $Key -Recurse
    }
}

# Install new DesktopAppInstaller to get winget compatibility
Function InstallWinget {
	Write-Output " "
	Write-Output "Downloading Windows Package Manager..."
	Invoke-WebRequest https://github.com/microsoft/winget-cli/releases/download/v.0.2.2521-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -O C:\WindowsPackageManager.appx
	Add-AppxPackage "WindowsPackageManager.appx"
	Remove-Item WindowsPackageManager.appx
	Write-Output "Windows Package Installer has been installed."
}

# Install 7zip
Function Install7zip {
	Write-Output " "
	Write-Output "Installing 7-zip..."
	winget install --id=7zip.7zip
}

# Confirm App Installations
Function ConfirmInstall {
	do
 {
    Clear-Host
    Write-Host "Do you want to proceed with app installations?"
    Write-Host "Y: Press 'Y' to proceed."
    Write-Host "2: Press 'N' to skip and end CleanWin execution"
    $selection = Read-Host "Please make a selection."
    switch ($selection)
    {
    'y' { 
	}
    'n' { Exit }
    }
 }
 until ($selection -match "y" -or $selection -match "n" -or $selection -match "q")
}

# Install Auto Dark Mode
Function InstallAutoDark {
	Write-Output " "
	$question = 'Do you want to install Auto Dark Mode?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Auto Dark Mode..."
			winget install --id=Armin2208.WindowsAutoNightMode --silent	
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
			winget install --id=Mozilla.Firefox --silent	
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
			winget install --id=Oracle.JavaRuntimeEnvironment --silent
		}
}

# Install Logitech Gaming Hub
Function InstallLGHUB {
	Write-Output " "
	$question = 'Do you want to install Logitech Gaming Hub?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Logitech Gaming Hubt..."
			winget install --id=Logitech.LGH --silent
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
			winget install --id=OBSProject.OBSStudio --silent	
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
			winget install --id=Microsoft.PowerToys --silent
		}
}

# Install Python
Function InstallPython {
	Write-Output " "
	$question = 'Do you want to install Python?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Python..."
			winget install --id=Python.Python --silent
		}
}

# Install Revo
Function InstallRevo {
	Write-Output " "
	$question = 'Do you want to install Revo Uninstaller?'
	$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
	$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
	$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
		if ($decision -eq 0) {
			Write-Output "Installing Revo Uninstaller..."
			winget install --id=RevoUninstaller.RevoUninstaller --silent
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
			winget install --id=Rufus.Rufus --silent
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
			winget install --id=VideoLAN.VLC --silent
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
			winget install --id=Microsoft.VisualStudioCode --silent
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
			winget install --id=t1m0thyj.WinDynamicDesktop --silent
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
			winget install --id=Microsoft.WindowsTerminal --silent
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
	Write-Output "This PC will not automatically restart, however a restart is pending."
	}
}
# Call the desired tweak functions
$tasks | ForEach-Object { Invoke-Expression $_ }
