#Scripts

Scripts for popular functions so that you can run them without having to go through the entire WinRice experience.

To run any script, copy and paste the command into Windows Terminal (Admin).

## Winstall

Installs apps you pre-list in a text file. [Learn more](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/winstall.md).


```powershell
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pratyakshm/WinRice/main/scripts/Winstall.ps1'))
```


## Winget Import

Imports apps from a pre-populated JSON file generated using `winget export` in your older device or previous installation of Windows. [Learn more](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/import.md).

```powershell
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pratyakshm/WinRice/main/scripts/WingetImport.ps1'))
```


## Flow Launcher

Installs [Flow Launcher](https://flowlauncher.com), configures core plugins and installs onsetGlaze acrylic theme.

```powershell
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pratyakshm/WinRice/main/scripts/SetupFlowLauncher.ps1'))
```


## Windows Subsystem for Linux

### Enable

```powershell
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pratyakshm/WinRice/main/scripts/EnableWSL.ps1'))
```


## Virtualization-based security

### Enable

```powershell
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pratyakshm/WinRice/main/scripts/EnableVBS.ps1'))
```

### Disable

```powershell
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pratyakshm/WinRice/main/scripts/DisableVBS.ps1'))
```


## Windows Update

### Setup Policies ([see policies](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#%EF%B8%8F-windows-update))

```powershell
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pratyakshm/WinRice/main/scripts/SetupWU.ps1'))

```

### Restore Default Policies

```powershell
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/pratyakshm/WinRice/main/scripts/ResetWU.ps1'))
```


---


## Feedback

If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).
