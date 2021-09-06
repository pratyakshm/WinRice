# Tasks

# Apps & Features
## Apps
### Apps installed:
- HEVC Video Extensions
- Windows Package Manager ([GitHub](https://github.com/microsoft/winget-cli/))
- 7-zip ([Website](https://www.7-zip.org/))
#### Leveraging winget to install apps
   - [`winget import`](https://github.com/pratyakshm/WinRice/blob/main/doc/WINGETIMPORT.md)
   - [`Winstall`](https://github.com/pratyakshm/WinRice/blob/main/doc/WINSTALL.md)
   - [`winget doc`](https://github.com/pratyakshm/WinRice/blob/main/doc/WINGET.md)
   
### Apps updated:
 - Windows 11: Update Microsoft Store and Widgets to newer versions if older versions are detected.

### Apps uninstalled:
Read [`APPUNINSTALLATION.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/APPUNINSTALLATION.md)

### Apps unpinned from taskbar:
- Mail
- Microsoft Store
- Office
- Xbox

### More changes include:
- Add the classic Windows Photo Viewer desktop app into the "Open with" menu for the following extensions: JPG, JPEG, GIF and PNG. 

## Features
### Features installed:
 - Windows Subsystem for Linux
 - dotNET 3.5 
 - Windows Sandbox
### Features uninstalled:
- Hello Face
- Legacy Components (DirectPlay)
- Math Recognizer
- Microsoft Paint (Desktop app)
- OpenSSH Client
- PowerShell ISE
- PowerShell 2.0
- Quick Assist
- Steps Recorder
- Snipping Tool
- SMB 1.0/CIFS File Sharing Support
- SMB Direct
- Work Folders
- Windows Media Player
- WordPad
- Windows Fax & Scan
- XPS Viewer
- XPS Printer

# Privacy & Security

## Turn off the following:
- Activity History
- Advertising ID 
- App suggestions
- Background apps
-  Feedback notifications
- Inking & typing personalization
- Location tracking 
- Maps updates
- Online speech recognition
- Tailored Experiences
- Telemetry
- Websites' access to language list to provide loaclly relevant content
   
## Turn on the following:
- Clipboard history 
</details>



# Tasks & Services
## Tasks

### Turn off the following tasks:
- Consolidator
- DmClient
- DmClientOnScenarioDownload
- Disk Diagnostics Data Collector
- Disk Defragmentation (optional)
- Feedback Notifications task
- Microsoft Compatibility Appraiser
- ProgramDataUpdater
- QueueReporting
- UsbCeip
  </details>

## Services

### Turn off the following services:
- DiagTrack
- SysMain

## Windows Update
### Setup Windows Update
Setup the following policies to Windows Update:
- Turn off automatic updates
- Do not auto restart PC if users are signed in
- Delay feature updates by 20 days
- Delay quality updates by 4 days
- Turn off re-installation of bloatware after feature updates
- Turn off Delivery Optimization
### Reset Windows Update
- Reset Windows Update is available for users who want to switch back to stock Windows Update settings.

## More changes:
- Turn off AutoPlay
- Turn off Autorun
- Turn off Reserved Storage
  - This setting will only take effect after an update is installed.
- Set BIOS time to UTC
- Turn on Storage Sense
- Turn on Num lock on startup


# Windows Explorer
## Turn off the following:

| Item |  Place  | OS  | 
|------|--------|-------|
| Widgets icon | Next to Start | Windows 11 |
| Chat icon | Next to Start | Windows 11 |
| Search icon | Next to Start | Windows 11 and Windows 10 |
| Task view | Next to Start | Windows 11 and Windows 10 |
| Cortana | Next to Start | Windows 10 |
| 3D Objects | File Explorer sidebar | Windows 10 |
| Meet now | System tray | Windows 10 |
| News and interests | System tray | Windows 10 |

</details>

## More changes:
- Set File Explorer to open This PC by default
- Turn off Keyboard shortcut for Sticky keys
- Use the Print screen button to open Screen snipping

*** 

## Feedback
If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).
