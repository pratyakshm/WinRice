# WinRice GUI Deprecation notice

WinRice GUI has been fully deprecated and is now in its [archived state](https://github.com/pratyakshm/WinRice/tree/archive).
The core reason behind this is that WinRice GUI was dependent on decades old and now deprecated Windows Forms technology.
The WinRice GUI mostly was not a good experience - either for me as a dev or for the users.
In lieu of this change, WinRice now only has one variant (i.e. CLI), hence its just called WinRice.

## Features affected  
### **App Uninstaller [PORTED to CLI]**  
This feature has been ported to regular WinRice. When run, users will have a choice to uninstall apps using CLI or GUI.    
While the CLI app uninstaller will remove apps as documented in [`Features.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/Features.md), GUI app uninstaller will give users the choice over which apps they want to uninstall. 
### More features
One of the principal reasons GUI variant was used is because of its modular nature, where users can change only the things **they want**.   
While GUI variant currently has no plans of making a comeback, I have created this collection of most useful / relevant features for users to run individually without running the full code of WinRice.  
More features coming soon.

| Feature | Code to run (paste in Windows Terminal (Admin)|
|---------|-------------|
| Windows Update: setup policies | `Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JurYt'`)) |
| Windows Update: reset policies | `Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JurY4'`)) |
| Windows Subsystem for Linux: enable the feature | `Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JurYa'`)) |
| winget: install the client | `Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JurY1'))` |
| winget: use winstall | `Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/Jur3G'`)) |
| winget: import apps | `Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/Jur3F'`)) |



***

## Feedback
If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).