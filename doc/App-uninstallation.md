# App uninstallation 

If the user wants to uninstall apps, WinRice asks if the user wants to choose which apps they want to uninstall.
If the user does not answer the question, the predefined list of apps are uninstalled.
If the user does not agree want to uninstall any apps, WinRice obeys that choice.

```P.S.A.:
If [uninstallapps.txt](https://github.com/pratyakshm/WinRice/blob/main/doc/App-uninstallation.md#Using-list-to-uninstall-apps) is found in the same directory as WinRice, WinRice proceeds to uninstall apps using the list without asking questions about app uninstallation.
```
***

### Pre-defined list of apps
The apps documented in this list are removed when the user chooses to uninstall apps without selecting which apps to uninstall.
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
</details>

### Using list to uninstall apps
Automatically uninstall apps from a list.  
The list is a text file, and it must fulfil these conditions:
- There is one app name per line
- It has absolute app names, example: `Microsoft.WindowsMaps`
- List must be named `uninstallapps.txt`
- List must be saved in the same folder as WinRice.
**Note:** To get absolute name of an app, use `Get-AppxPackage *app*`.

***

## Feedback
If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).