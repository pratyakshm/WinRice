# App Uninstallation

WinRice can uninstall non-essential apps that come bundled with Windows.  
The user is asked if they want to uninstall such apps. If they choose to do so, they are presented with an option to choose which apps to uninstall.  
If the user chooses to uninstall apps but doesn't specify which apps to uninstall, the following apps will be uninstalled:

- Calendar
- Cortana
- Camera (if no camera is detected)
- Get Help
- Mail 
- Maps
- Microsoft OneDrive
- Microsoft News
- Microsoft Solitaire Collection
- Microsoft Teams
- Mixed Reality Portal
- OneNote for Windows 10
- Office
- Paint 3D
- Power Automate Desktop
- Tips
- Whiteboard
- Weather

## Uninstall Apps From a Text File

WinRice supports uninstalling a list of apps from a text file.  
The text file must be formatted as follows:

- There must be one app name per line.
- App names must be absolute. Example: `Microsoft.WindowsMaps`
- The filename must be `uninstallapps.txt`.
- List must be saved in the same folder as WinRice.

If an `uninstallapps.txt` file is detected, WinRice will not ask if the user wants to select which apps to uninstall. The list will be used automatically.

**Note:** To get absolute name of an app, use `Get-AppxPackage *app*`.

---

## Feedback

If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).
