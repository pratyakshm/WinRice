# WinRice
<h3 align ="center">WinRice automates setting up Windows devices</h3>
<p align="center">
<a href="https://github.com/pratyakshm/WinRice#running-WinRice"><img src="https://img.shields.io/static/v1?label=pratyakshm&message=WinRice&color=blue&logo=github" alt="pratyakshm - WinRice"></a>
<a href="https://github.com/pratyakshm/WinRice"><img alt="GitHub all releases" src="https://img.shields.io/github/downloads/pratyakshm/WinRice/total?color=blue"></a>
<a href="https://github.com/pratyakshm/WinRice"><img src="https://img.shields.io/github/stars/pratyakshm/WinRice?style=social" alt="stars - WinRice"></a>
<a href="https://github.com/pratyakshm/WinRice"><img src="https://img.shields.io/github/forks/pratyakshm/WinRice?style=social" alt="forks - WinRice"></a>
<a href="#license"><img src="https://img.shields.io/badge/License-GPL_v3-blue" alt="License"></a>
</p>

## Brief
WinRice does everything from removing junk (your hardware doesn't count, yet), cleaning up the Windows UI, setting up privacy policies, Windows Update policies, disabling unnecessary features and enabling useful ones meanwhile retaining maximum app functionality. It also uses [`Winstall`](https://github.com/pratyakshm/WinRice/blob/main/doc/WINSTALL.md) and [`winget import`](https://docs.microsoft.com/en-us/windows/package-manager/winget/import) to batch install apps you want. Sounds pretty cool, eh?

## Documentation
### 💡 Read the docs before using WinRice

| Type | Doc | 
|--------------|--------|
| LICENSE | [`LICENSE`](https://github.com/pratyakshm/WinRice/blob/main/LICENSE) |
| Tasks WinRice does | [`TASKS.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/TASKS.md) |
| Frequently asked questions | [`FAQ.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/FAQ.md) |
| winget | [`WINGET.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/WINGET.md) |
| Docs folder | [`doc`](https://github.com/pratyakshm/WinRice/tree/main/doc) |

***

## Prerequisites
### Windows Terminal  
<a href="https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701"> <img src="https://camo.githubusercontent.com/3710844608ef5f15f9a7b5b33989ab74369d49b2f39a457632b092d12e48a8c2/68747470733a2f2f75706c6f61642e77696b696d656469612e6f72672f77696b6970656469612f636f6d6d6f6e732f662f66372f4765745f69745f66726f6d5f4d6963726f736f66745f42616467652e737667" width="200px" height="100px" alt="License"></a>

More installation methods include: 
   - Getting the latest release from [GitHub](https://github.com/microsoft/terminal/releases)
   - Windows Package Manager CLI (winget): ``winget install --id=Microsoft.WindowsTerminal --source winget``   
### Windows version
The most recent Windows versions are supported.  
Currently supported versions:
- Windows 11 21H2  
- Windows 10 21H1 

Pro edition or up is strongly recommended.   
Older Windows versions are not supported.    
### Internet connection
An active internet connection is needed.
***

## Running WinRice
### Use either of the following methods
### 1. Main branch (recommended)
Open Windows Terminal as Administrator.  
To execute WinRice, paste  
```
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JWj26'))
```

### 2. Manually download and run latest code
- Download the latest code from main branch: [tap here](https://github.com/pratyakshm/WinRice/archive/refs/heads/main.zip).
- Unzip the file.
- Open Windows Terminal (Admin), set location to your Downloads folder.
- Use `Set-ExecutionPolicy Unrestricted -Scope Process -Force` to set ExecutionPolicy to unrestricted for current process.
- Use `.\WinRice.ps1` to run WinRice.  

***

## Known issues
Known issues are being tracked [here](https://github.com/pratyakshm/WinRice/issues/16).  

## Contributing 
WinRice accepts all kinds of contributions such as finding bugs, fixing bugs, adding features, removal of deprecated features and/or values, etc. I'm excited to work with the users and fellow PowerShell enthusiasts to further improve this project.

I ask that **before you start your work on a feature that you would like to request or contribute**, please read WinRice [Principles](https://github.com/pratyakshm/WinRice/wiki/Principles). I will be happy to work with you to figure out good approaches and provide guidance throughout feature development, and help avoid any wasted or duplicated effort.

***

## License
[GPL version 3](https://github.com/pratyakshm/WinRice/blob/main/LICENSE) ©️ Pratyaksh Mehrotra ([@pratyakshm](https://github.com/pratyakshm)).
