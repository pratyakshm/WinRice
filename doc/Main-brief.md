# Ordered list of jobs WinRice performs

## Apps

### Things Installed:

- Cascadia Code
- HEVC Video Extensions
- Visual C++ Libraries
- Windows Package Manager ([GitHub](https://github.com/microsoft/winget-cli/))
- NanaZip ([GitHub](https://github.com/M2Team/NanaZip))

#### Leveraging WinGet to Install Apps

- [`winget.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/winget.md)
- [`import.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/import.md)
- [`winstall.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/winstall.md)

### Apps Updated:

- Windows 11: Microsoft Store and Widgets are updated to newer versions if older versions are detected.

### Apps Uninstalled:

Refer to [`App-uninstallation.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/App-uninstallation.md)

### Apps Unpinned From Taskbar:

- Mail
- Microsoft Store
- Office
- Xbox

## Features

### Features Installed:

- dotNET 3.5 (optional)
- Windows Sandbox (optional)
- Windows Subsystem for Linux (optional)

### Features Uninstalled:

- Hello Face
- Legacy Components (DirectPlay)
- Math Recognizer
- OpenSSH Client
- PowerShell 2.0
- PowerShell ISE
- Quick Assist
- SMB 1.0/CIFS File Sharing Support
- SMB Direct
- Snipping Tool
- Steps Recorder
- Windows Fax & Scan
- Windows Media Player
- WordPad
- Work Folders
- XPS Printer
- XPS Viewer

# Privacy

## Turn Off the Following:

- Activity History
- Advertising ID
- App suggestions
- Background apps
- Feedback notifications
- Inking & typing personalization
- Location tracking
- Maps updates
- Online speech recognition
- Tailored Experiences
- Telemetry
- Websites' access to language list to provide loaclly relevant content

## Turn On the Following:

- Clipboard history
</details>

# System

### Turn Off the Following Tasks:

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


### Turn Off the Following Services:

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

## More Changes:

- Turn off AutoPlay
- Turn off Autorun
- Turn off Reserved Storage
  - This setting will only take effect after an update is installed.
- Set BIOS time to UTC
- Turn on Storage Sense
- Turn on Num lock on startup

# Windows Explorer

## Turn Off the Following:

| Item               | Place                 | OS                        |
| ------------------ | --------------------- | ------------------------- |
| Widgets icon       | Taskbar         | Windows 11                |
| Chat icon          | Taskbar         | Windows 11                |
| Search icon        | Taskbar         | Windows 11 and Windows 10 |
| Task view          | Taskbar         | Windows 11 and Windows 10 |
| Cortana            | Taskbar         | Windows 10                |
| 3D Objects         | File Explorer sidebar | Windows 10                |
| Meet now           | Apps tray           | Windows 10                |
| News and interests | Apps tray           | Windows 10                |

</details>

## More Changes:

- Set File Explorer to open This PC by default
- Turn off Keyboard shortcut for Sticky keys
- Use the Print screen button to open Screen snipping

---

## Feedback

If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).
