# Reverting changes

## You can simply restore the System restore point if WinRice created one.
Restoring to the restore point will all settings changes performed by WinRice
### However, if WinRice didn't create a System restore point, you can still revert changes using the revert preset. Read more about it below.
###### Creating System restore point is optional in WinRice.
***

### How to use
1. [Tap here](https://github.com/pratyakshm/WinRice/archive/refs/heads/main.zip) to download the latest code from main branch. 
2. Extract the ZIP file and locate `WinRice.ps1`.
3. Open the file on your desired text editor of choice.
4. Replace the default preset with the [revert preset](https://github.com/pratyakshm/WinRice/blob/main/doc/Reverting-changes.md#revert-preset) given below.
5. Save the file.
6. Open Windows Terminal (Admin).
7. Set Location to the WinRice folder (typically under `~\Downloads\WinRice-main`)
8. Use command ``Set-ExecutionPolicy Unrestricted -Force -Scope Process`` to force set your ExecutionPolicy for current PSSession to Unrestricted.
9. Use ``./WinRice.ps1`` to execute the script.

### Revert preset
<details><summary>Tap here to show/hide revert preset</summary>

```
# Revert preset
$tasks = @(

### Maintenance Tasks ###
	"WinRice",
	"OSBuildInfo",
	"CreateSystemRestore",
	"Activity",

### Apps & Features ###
	"AppsFeatures",
	# "InstallVCLibs",
	"UninstallVCLibs",
	# "InstallWinGet",
	# "EnableExperimentsWinGet",
	# "DisableExperimentsWinGet",
	# "MicrosoftStore",
	# "InstallNanaZip", 
	"UninstallNanaZip",
	# "WinGetImport",
	# "Winstall", 
	"Winuninstall",
	# "InstallHEVC", 
	"UninstallHEVC",
	# "Widgets",
	# "InstallFonts",
	"UninstallFonts",
	# "EnableWSL", "Activity", 
	"DisableWSL",
	# "EnabledotNET3.5", "Activity", 
	"DisabledotNET3.5",
	# "EnableSandbox",
	"DisableSandbox",
	# "UninstallApps", "Activity", 
	# "WebApps",
	# "UninstallConnect",
	# "UnpinStartTiles", "Activity", 
	# "UnpinAppsFromTaskbar", 
	# "UninstallOneDrive", "Activity",
	"InstallOneDrive",
	# "UninstallFeatures", "Activity", 
	"InstallFeatures", "Activity", 
	# "SetPhotoViewerAssociation",
	# "UnsetPhotoViewerAssociation",
	"ChangesDone",

### Privacy & Security ###
	"PrivacySecurity",
	# "DisableActivityHistory",	
	"EnableActivityHistory",
	# "DisableAdvertisingID",			
	"EnableAdvertisingID",
	# "DisableBackgroundApps",        
	"EnableBackgroundApps",
	# "DisableErrorReporting",
	"EnableErrorReporting",
	# "DisableFeedback",		       
	"EnableFeedback",
	# "DisableInkHarvesting",			
	"EnableInkHarvesting",
	# "DisableLangAccess",  		    
	"EnableLangAccess",
	# "DisableLocationTracking",      
	"EnableLocationTracking",
	# "DisableMapUpdates",			
	"EnableMapsUpdates",
	# "DisableSpeechRecognition",		
	"EnableSpeechRecognition",
	# "DisableSilentInstallApps",
	"EnableSilentInstallApps",
	# "HideSuggestedContentInSettings",
	"ShowSuggestedContentInSettings",
	# "HideSuggestedContentInStart",
	"ShowSuggestedContentInStart",
	# "DisableTailoredExperiences",	
	"EnableTailoredExperiences",
	# "DisableTelemetry",				
	"EnableTelemetry",
	# "EnableClipboard",				
	"DisableClipboard",
	# "AutoLoginPostUpdate", 		    
	"StayOnLockscreenPostUpdate",
	"ChangesDone",

### Tasks & Services ###
	"TasksServices",
	# "DisableStorageSense",		   
	"EnableStorageSense",
	# "DisableReservedStorage",	   
	"EnableReservedStorage",
	# "DisableAutoplay",             
	"EnableAutoplay",
	# "DisableAutorun",              
	"EnableAutorun",
	# "DisableHibernation",
	"EnableHibernation",
	# "SetBIOSTimeUTC",              
	"SetBIOSTimeLocal",
	# "EnableNumLock",			   
	"DisableNumLock",
	# "DisableServices",			   
	"EnableServices",
	# "DisableTasks",				   
	"EnableTasks",
	# "SetupWindowsUpdate",		   
	"ResetWindowsUpdate",
	# "EnablePowerdownAfterShutdown",
	"DisablePowerdownAfterShutdown",
	"ChangesDone",

### Windows Explorer ###
	"PrintExplorerChanges",
	# "EnablePrtScrToSnip",		   
	"DisablePrtScrSnip",
	# "ShowExtensions",
	"HideExtensions",
	# "HideRecentFilesInQuickAccess",
	"ShowRecentFilesInQuickAccess",
	# "EnableExtensions",
	"DisableExtensions",
	# "DisableStickyKeys",           
	"EnableStickyKeys",
	# "SetExplorerThisPC",           
	"SetExplorerQuickAccess",
    # "Hide3DObjects",      		   
	"Restore3DObjects",
	# "HideSearchBar",			   
	"RestoreSearchBar"
	# "HideTaskView",                
	"RestoreTaskView",
	# "HideCortana",			       
	"RestoreCortana",
	# "HideMeetNow",				   
	"RestoreMeetNow",
	# "DisableTaskbarFeed",		   
	"EnableTaskbarFeed",  (News and Interests)
	# "DisableWidgetsItem",
	"EnableWidgetsItem",
	# "DisableChatItem",
	"EnableChatItem",
	"ChangesDone",

###  Tasks after successful run ###
	"Activity",
	"Success"
)
```
</details>


### Irreversible changes
- Uninstalled store apps can't be re-installed.
- Apps installed using ``winget import`` feature can't be uninstalled.
- Tiles cannot be pinned back to Start menu.
- Apps cannot be pinned back to taskbar.
- WinGet (a.k.a Windows Package Manager) cannot be uninstalled.

### Re-installation of uninstalled apps
[Microsoft Store](ms-windows-store:) is the recommended place to re-install apps uninstalled by WinRice.  
However, there are cases where an app is not listed on Microsoft Store, for instance the Get help app.  
At the time of writing this, there's no known way to re-install that app. Even though the app might be important for some people (justified), most people don't use it.  
However, currently in the main branch and starting the next WinRice release, uninstalling apps will be optional.
I highly recommend users to use WinRice GUI to selectively uninstall apps they don't need.

***

## Feedback
If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).