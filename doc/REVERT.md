# Reverting changes
## This document explains how to revert changes performed to your device by CleanWin.

## You can simply restore the System restore point if CleanWin created one.
Restoring to the restore point will all settings changes performed by CleanWin
### However, if CleanWin didn't create a System restore point, you can still revert changes using the revert preset. Read more about it below.
###### Creating System restore point is optional in CleanWin.
***

### How to use
1. Download the latest code from main branch. ([Tap here](https://github.com/pratyakshm/CleanWin/archive/refs/heads/main.zip))
2. Extract the ZIP file and locate CW-CLI.ps1.
3. Open the file on your desired text editor of choice.
4. Replace the default preset section with the revert preset section written below.
5. Save the file.
6. Open Windows Terminal (Admin), make sure you are using Windows PowerShell as your shell and NOT PowerShell (OSS).
7. Set Location to the CleanWin folder (typically under `~/CleanWin-main`)
8. Use command ``Set-ExecutionPolicy Unrestricted -Force -Scope Process`` to force set your ExecutionPolicy for current PSSession to Unrestricted.
9. Use ``./CW-CLI.ps1`` to execute the script.
<details><summary>Revert preset (tap to open/close)</summary>

```
# Revert preset
$tasks = @(

### Maintenance Tasks ###
	"CleanWin",
	"OSBuildInfo",
	# "CreateSystemRestore",
	"Activity",

### Apps & Features ###
	# "AppsFeatures",
	# "UninstallApps", "Activity", 
	# "UnpinStartTiles", "Activity", 
	# "UnpinAppsFromTaskbar", "Activity", 
	# "InstallFrameworks",
	"UninstallFrameworks",
	# "InstallWinGet", 
	# "UninstallOneDrive", "Activity",
	"InstallOneDrive",
	# "DisableBrowserRestoreAd",
	# "EnableBrowserRestoreAd",
	# "DisableM365OnValueBanner", 
	# "RevertM365OnValueBanner",
	# "UninstallFeatures", "Activity", 
        "InstallFeatures", "Activity", 
	# "DisableSuggestions",		    
	"EnableSuggestions",
	# "EnableWSL", "Activity", 
	"DisableWSL",
	# "EnabledotNET3.5", "Activity", 
	"DisabledotNET3.5",
	# "EnableSandbox",
	"DisableSandbox",
	# "Install7zip", 
	"Uninstall7zip",
	# "Winstall", 
	# "Activity",
	# "EnableExperimentsWinGet",
	"DisableExperimentsWinGet",
	# "WinGetImport",
	"Activity",
	# "InstallHEVC", 
	"UninstallHEVC",
	# "Widgets",
	# "InstallFonts", 
	"UninstallFonts",
	# "SetPhotoViewerAssociation",
	"UnsetPhotoViewerAssociation",
	"ChangesDone",

### Privacy & Security ###
	"PrivacySecurity",
	#"DisableActivityHistory",	
	 "EnableActivityHistory",
	#"DisableAdvertisingID",			
	 "EnableAdvertisingID",
	#"DisableBackgroundApps",        
	 "EnableBackgroundApps",
	#"DisableFeedback",		       
	 "EnableFeedback",
	#"DisableInkHarvesting",			
	 "EnableInkHarvesting",
	#"DisableLangAccess",  		    
	 "EnableLangAccess",
	#"DisableLocationTracking",      
	 "EnableLocationTracking",
	#"DisableMapUpdates",			
	 "EnableMapsUpdates",
	#"DisableSpeechRecognition",		
	 "EnableSpeechRecognition",
	#"DisableSilentInstallApps",
	 "EnableSilentInstallApps",
	#"HideSuggestedContentInSettings",
	 "ShowSuggestedContentInSettings",
	#"HideSuggestedContentInStart",
	 "ShowSuggestedContentInStart",
	#"DisableTailoredExperiences",	
	 "EnableTailoredExperiences",
	#"DisableTelemetry",				
	 "EnableTelemetry",
	#"EnableClipboard",				
	 "DisableClipboard",
	#"AutoLoginPostUpdate", 		    
	 "StayOnLockscreenPostUpdate",
	"ChangesDone",
	# To revert all privacy changes, use CleanWin GUI -> "Enable data collection".

### Tasks & Services ###
	"TasksServices",
	#"DisableStorageSense",		   
	 "EnableStorageSense",
	#"DisableReservedStorage",	   
	 "EnableReservedStorage",
	#"DisableAutoplay",             
	 "EnableAutoplay",
	#"DisableAutorun",              
	 "EnableAutorun",
	#"SetBIOSTimeUTC",              
	 "SetBIOSTimeLocal",
	#"EnableNumLock",			   
	 "DisableNumLock",
	#"DisableServices",			   
	 "EnableServices",
	#"DisableTasks",				   
	 "EnableTasks",
	#"SetupWindowsUpdate",		   
	 "ResetWindowsUpdate",
	#"EnablePowerdownAfterShutdown",
	 "DisablePowerdownAfterShutdown",
	"ChangesDone",

### Windows Explorer ###
	"PrintExplorerChanges",
	#"EnablePrtScrToSnip",		   
	 "DisablePrtScrSnip",
	#"DisableStickyKeys",           
	 "EnableStickyKeys",
	#"SetExplorerThisPC",           
	 "SetExplorerQuickAccess",
        #"Hide3DObjects",      		   
	 "Restore3DObjects",
	#"HideSearchBar",			   
	 "RestoreSearchBar"
	#"HideTaskView",                
	 "RestoreTaskView",
	# "HideCortana",			       
	 "RestoreCortana",
	# "HideMeetNow",				   
	 "RestoreMeetNow",
	# "DisableTaskbarFeed",		   
	 "EnableTaskbarFeed",  (News and Interests)
	"ChangesDone",

###  Tasks after successful run ###
	"Activity",
	"Success"
)
```
</details>


### Irreversible changes
- Apps installed using Winstall feature can't be uninstalled.
- Apps installed using ``winget import`` feature can't be uninstalled.
- Tiles cannot be pinned back to Start menu.
- Apps cannot be pinned back to taskbar.
- Apps uninstalled from the debloat section cannot be installed.
- WinGet (a.k.a Windows Package Manager) cannot be uninstalled.

### Re-installation of uninstalled apps
[Microsoft Store](ms-windows-store:) is the recommended place to re-install apps uninstalled by CleanWin.  
However, there are cases where an app is not listed on Microsoft Store, for instance the Get help app.  
At the time of writing this, there's no known way to re-install that app. Even though the app might be important for some people (justified), most people don't use it.  
However, currently in the main branch and starting the next CleanWin release, uninstalling apps (and many more things) from CLI will be an optional task.
I highly recommend users to use CleanWin GUI to selectively uninstall apps they don't need.