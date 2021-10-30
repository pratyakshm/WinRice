# App Uninstallation

WinRice can uninstall non-essential apps that come bundled with Windows.  
The user is asked if they want to uninstall such apps. If they choose to do so, they are presented with an option to choose which apps to uninstall.  
If the user chooses to uninstall apps but doesn't specify which apps to uninstall, the following apps will be uninstalled:

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
- Microsoft OneDrive (optional) (64-bit variants can also be uninstalled)
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
