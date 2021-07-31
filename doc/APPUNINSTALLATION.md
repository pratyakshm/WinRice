# App uninstallation 
CleanWin supports the following methods to uninstall apps:
1.  App Uninstaller CLI
2.  App Uninstaller GUI
3.  App Uninstaller List

### App Uninstaller CLI
Automatically uninstall apps that are documented in the list.

<details><summary>List of apps (tap to show/hide)</summary>
  
- 3D Viewer   
- Alarms & Clock
- Cortana  
- Camera  
- Connect
- Feedback Hub 
- Films & TV  
- Get Help      
- Get started  
- Groove Music 
- HEVC Video Extensions
- Mail and Calendar  
- Messaging  
- Maps  
- Microsoft OneDrive (64-bit variants can also be uninstalled)
- Microsoft News  
- Microsoft Solitaire Collection  
- Mixed Reality Portal
- Network Speed Test
- OneConnect  
- OneNote  
- Office
- Office Lens
- Paint 3D  
- Power Automate Desktop
- Print 3D
- People  
- Sway
- Sticky Notes  
- Skype
- Voice Recorder
- Whiteboard
- Weather
- Xbox
- Xbox Game bar
- Your Phone
</details>

### App Uninstaller GUI
Manually check/uncheck apps from App Uninstaller GUI and uninstall them.

### App Uninstaller List
Automatically uninstall apps from a custom list.  
The list is a text file, and it must fulfil these conditions:
- There is one app name per line
- Write absolute app names, like `Microsoft.WindowsAlarms` instead of `Alarms & Clock`.
- To get absolute name of an app, use `Get-AppxPackage *app*`.
- Save the text file as `uninstallapps.txt`, or locate the text file when asked by CleanWin.
**Example**  
This syntax uninstalls Microsoft News and Weather app:
```
Microsoft.BingNews
Microsoft.BingWeather
```  

***

## Feedback
If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/CleanWin/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).