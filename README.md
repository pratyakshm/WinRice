# CleanWin
![No. of Downloads](https://img.shields.io/github/downloads/pratyakshm/CleanWin/total?color=darkgreen&style=flat-square)
![Stars](https://img.shields.io/github/stars/pratyakshm/CleanWin?style=flat-square)
[![Release](https://img.shields.io/github/v/release/pratyakshm/cleanwin?style=flat-square)](https://github.com/pratyakshm/CleanWin/releases/latest)
&nbsp;

## What is CleanWin
An open source project to make your 🐌 PC faster.  
`
💡 Read documentation properly before running CleanWin
`

## Wiki
[Visit the Wiki](https://github.com/pratyakshm/CleanWin/wiki) to read in detail about testing, compatibility, using Winstall, customization, and more.
***
## How to run
   
#### Method 1 (recommended): Running the latest release    
   1. Download the latest release from [Releases](https://github.com/pratyakshm/CleanWin/releases).
   2. Unzip the ZIP file.
   3. Double tap to launch CLI or GUI.
        - CleanWin prebuilt binaries that ship via GitHub releases will not run unless administrator priviliges are provided.

#### Method 2: Running the latest code from main branch

   1. Choose if you want to run CleanWin CLI or GUI.
   2. Copy its corresponding code from the below section.
   3. Paste it into Windows PowerShell (Admin)  
   
  **CLI:**    
   ```
   Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JmqTS'))
   ```
  **GUI:**      
   ```
   Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/Jqcr0'))
   ```    
⚠️ Code from main branch is not quality tested or validated, as oppossed to prebuilt binaries from GitHub releases. Proceed with caution.   


***
## List of changes performed
This section contains the list of tasks that CleanWin performs. They're grouped in the following categories:   
`💡 Tap on the points starting with a triangular bullet to expand or collapse them`

### Apps & Features
<details>
  <summary>Apps</summary>

  - Apps installed:
  
    - HEVC Video Extensions
    - Windows Package Manager ([GitHub](https://github.com/microsoft/winget-cli/))
    - [7-zip](https://www.7-zip.org/)
    - Install your desired apps using [Winstall](https://github.com/pratyakshm/CleanWin/wiki/Winstall:-Installing-your-own-set-of-apps-using-a-simple-list).

  - Apps uninstalled:
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
    - Snip & Sketch
    - Sticky Notes  
    - Skype
    - Voice Recorder
    - Whiteboard
    - Weather
    - Xbox
    - Xbox Game bar
    - Your Phone

  - Unpin the following apps from Taskbar:
    - Mail
    - Microsoft Store
    - Office
    - Xbox

  - More changes include:

    - Add the classic Windows Photo Viewer desktop app into the "Open with" menu for the following extensions: JPG, JPEG, GIF and PNG. 
    - Turn off automatic/silent installation of "suggested apps" / bloatware in layman's terms.
</details>

<details>
  <summary>Features</summary>

  - Features installed:
    - Windows Subsystem for Linux
    - dotNET 3.5 

  - Features uninstalled:
    - Hello Face
    - Math Recognizer
    - Microsoft Paint (Desktop app)
    - OpenSSH Client
    - PowerShell ISE
    - Quick Assist
    - Steps Recorder
    - Snipping Tool
    - Work Folders
    - Windows Media Player
    - WordPad
    - Windows Fax & Scan
    - XPS Viewer
    - XPS Printer
</details>


### Privacy & Security
<details><summary>Privacy</summary>

#### Turn off the following:
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
  </details>

<details><summary>Security</summary>

  - Turn on auto login post restart after Windows is updated.
  - Turn off Meltdown compatibility.
</details>



### Tasks & Services
<details>
  <summary>Tasks</summary>

#### Turn off the following tasks:
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

<details><summary>Services</summary>

#### Turn off the following services:
- DiagTrack
- DMWAppPushService
- SysMain
- RetailDemo
- diagnosticshub.standardcollector.service
- MapsBroker
- NetTcpPortSharing
- RemoteRegistry
- SharedAccess
- TrkWks
</details>

<details><summary>Windows Update</summary>

- Setup Windows Update with the following settings:
  - Turn off automatic updates
  - Do not auto restart PC if users are signed in
  - Delay feature updates by 20 days
  - Delay quality updates by 4 days
  - Turn off re-installation of bloatware after feature update
  - Set Windows Update to download updates only from Microsoft's servers by turning off Delivery through P2P and LAN

- Reset Windows Update is also available for users who want to switch back to stock Windows Update settings.

  </details>

  <details><summary>More changes</summary>

  - Turn off AutoPlay
  - Turn off Autorun
  - Turn off Reserved Storage
    - This setting will only take place after an update is installed.
  - Set BIOS time to UTC
  - Turn on Storage Sense
  - Turn on Num lock on startup
  </details>


### Windows Explorer
<details><summary>Core changes</summary>

#### Hide/cleanup the following:
  -  3D Objects
  -  Cortana button
  -  Meet now button
  -  News and interests
  -  Search bar
  -  Task View button</details>
<details><summary>More changes</summary>

  - Set This PC as default view
  - Turn off sticky keys prompt
  - Use Print Screen key to open Snip & Sketch overlay
</details>

***

## OS Builds supported
CleanWin is tested and supported on Windows 11 Pro OS build 21996, Windows 10 21H1, and Windows 10 20H2

## Known issues
I'm tracking currently known issues [here](https://github.com/pratyakshm/CleanWin/issues/16).


## Advanced usage
  - Run CleanWin with your own custom preset - [Read here](https://github.com/pratyakshm/CleanWin/wiki/Using-a-custom-preset)


## Microsoft Docs
- [Windows 10 Release Information](https://docs.microsoft.com/en-us/windows/release-information/)
- [Windows 10 21H1 "May 2021 Update" - Known Issues tracker](https://docs.microsoft.com/en-us/windows/release-information/status-windows-10-21h1)
- [Windows Blog](https://blogs.windows.com/)
