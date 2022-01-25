# Reverting Changes

## System Restore Point

WinRice provides the option for creating a system restore point before modifying the system. Restoring to the restore point will revert all settings changes performed by WinRice. However, if WinRice didn't create a System restore point, you can still revert changes using the revert preset. Read more about it below.

---

### How to Use

1. [Click here](https://github.com/pratyakshm/WinRice/archive/refs/heads/main.zip) to download the latest code from main branch.
2. Extract the ZIP file and locate `WinRice.ps1`.
3. Open the file in your desired text editor of choice.
4. Replace the default preset with the [revert preset](https://github.com/pratyakshm/WinRice/blob/main/doc/Reverting-changes.md#revert-preset) given below.
5. Save the file.
6. Open Windows Terminal (Admin).
7. Set Location to the WinRice folder (typically under `~\Downloads\WinRice-main`)
8. Use command `Set-ExecutionPolicy Unrestricted -Force -Scope Process` to force set your ExecutionPolicy for current PSSession to Unrestricted.
9. Use `./WinRice.ps1` to execute the script.

### Revert Preset

<details><summary>Tap here to show/hide revert preset</summary>

```
# Revert preset
$tasks = @(
### Maintenance Tasks ### 
"WinRice",
"OSBuildInfo",
# "CreateSystemRestore",
"Activity",

### Apps & Features ###
#"AppsFeatures",
# "InstallVCLibs",
# "UninstallVCLibs",
#" InstallWinGet",
# "InstallNanaZip", 
"UninstallNanaZip",
#"WinGetImport",
#"Winstall",
"Winuninstall"
# "InstallHEVC", 
"UninstallHEVC"
# "EnableWSL", "Activity", 
"DisableWSL",
# "EnabledotNET3.5", "Activity", 
"DisabledotNET3.5",
# "EnableSandbox",
"DisableSandbox",
# "UninstallApps", "Activity", 
# "WebApps",
# "UnpinStartTiles", "Activity", 
# "UnpinAppsFromTaskbar", 
# "UninstallOneDrive", "Activity",
"InstallOneDrive",
# "UninstallFeatures", "Activity", 
"InstallFeatures", "Activity", 
"ChangesDone",

### Privacy ###
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

### Security ###
 "AutoLoginPostUpdate", 		    
# "StayOnLockscreenPostUpdate",
# "DisableVBS",
# "EnableVBS",
#"DisableLogonCredential",
"EnableLogonCredential",
# "DisableLLMNR",
"EnableLLMNR",
# "EnableSEHOP",
"DisableSEHOP",
# "DisableWPAD",
"EnableWPAD",
# "EnableLSAProtection"
"DisableLSAProtection"
# "DisableScriptHost"
"EnableScriptHost"
# "DisableOfficeOLE",
"EnableOfficeOLE",
"ChangesDone",

### Tasks & Services ###
"TasksServices",
"DisableStorageSense",		   
# "EnableStorageSense",
"DisableReserves",	   
# "EnableReserves",
# "DisableAutoplay",             
"EnableAutoplay",
# "DisableAutorun",              
"EnableAutorun",
# "DisableHibernation",
# "EnableHibernation",
# "BIOSTimeUTC",              
"BIOSTimeLocal",
# "EnableNumLock",			   
"DisableNumLock",
# "DisableServices",			   
"EnableServices",
# "DisableTasks",				   
"DisableTasks",
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
# "DisableStickyKeys",           
"EnableStickyKeys",
# "SetExplorerThisPC",           
"SetExplorerQuickAccess",
# "Hide3DObjects",      		   
"Restore3DObjects",
# "HideSearch",			   
"RestoreSearch"
# "HideTaskView",                
"RestoreTaskView",
# "HideCortana",			       
"RestoreCortana",
# "HideMeetNow",				   
"RestoreMeetNow",
# "HideNI",		   
"RestoreNI",  (News and Interests)
# "HideWidgets",
"RestoreWidgets",
# "HideChat",
"RestoreChat",
"ChangesDone",

###  Tasks after successful run ###
"Activity",
"Success"
)
```

</details>

### Irreversible Changes

- Get Help app cannot be re-installed.
- Apps installed using `winget import` feature can't be uninstalled.
- Tiles cannot be pinned back to Start menu.
- Apps cannot be pinned back to taskbar.
- WinGet (a.k.a Windows Package Manager) cannot be uninstalled.

### Re-Installation of Uninstalled Apps

[Microsoft Store](ms-windows-store:) is the recommended place to re-install apps uninstalled by WinRice.  

To re-install Widgets, install the Windows Web Experience Pack from [Microsoft Store](https://www.microsoft.com/store/productId/9MSSGKG348SP).


---

## Feedback

If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).
