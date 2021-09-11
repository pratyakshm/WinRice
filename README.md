<p align="center"><a href="https://github.com/pratyakshm/WinRice"><img src="assets/icon.png" width="150"></a></p> 
<h2 align="center">WinRice</h2>
<h2 align ="center">Automates setting up Windows devices</h2>
<p align="center">
<a href="https://github.com/pratyakshm/WinRice#running-WinRice"><img src="https://img.shields.io/static/v1?label=pratyakshm&message=WinRice&color=blue&logo=github" alt="pratyakshm - WinRice"></a>
<a href="https://github.com/pratyakshm/WinRice"><img alt="GitHub all releases" src="https://img.shields.io/github/downloads/pratyakshm/WinRice/total?color=blue"></a>
<a href="https://github.com/pratyakshm/WinRice"><img src="https://img.shields.io/github/stars/pratyakshm/WinRice?style=social" alt="stars - WinRice"></a>
<a href="https://github.com/pratyakshm/WinRice"><img src="https://img.shields.io/github/forks/pratyakshm/WinRice?style=social" alt="forks - WinRice"></a>
<a href="#license"><img src="https://img.shields.io/badge/License-GPL_v3-blue" alt="License"></a>
</p>

<p align="center"><a href="#-description">Description</a> &bull; <a href="https://github.com/pratyakshm/WinRice/blob/main/doc/Features.md">Features</a> &bull; <a href="https://github.com/pratyakshm/WinRice/tree/main/doc">Documentation</a> &bull; <a href="#-running-winrice">Usage</a>

<p align="center"><a href="https://github.com/pratyakshm/WinRice/blob/main/doc/Frequently-answered-questions.md">FAQ</a>   &bull; <a href="#%EF%B8%8F-license">License</a> &bull; <a href="#%EF%B8%8F-contributing">Contribution</a> 

***



## 😃 Description
WinRice performs a bunch of tasks including (but not limited to) removing unused apps, installing useful apps (read [`winget.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/WINGET.md#winrice-x-winget)), cleaning up the Windows UI, maximizing privacy, setting up Windows Update policies, configuring optional features, etc. - while retaining maximum OS stability and functionality.   


***

## ✔️ Prerequisites

### Windows Terminal  
<a href="https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701"> <img src="https://user-images.githubusercontent.com/54220235/130347354-d4e7af6e-a153-4954-a7f4-3d7ad27da7c9.png" alt="Windows Terminal product page on Microsoft Store"></a>    

More installation methods include: 
   - Getting the latest release from [GitHub](https://github.com/microsoft/terminal/releases)
   - Windows Package Manager CLI (winget): ``winget install --id=Microsoft.WindowsTerminal --source winget``   

### Windows version
Currently supported versions:
- Windows 11 21H2  
- Windows 10 21H2
- Windows 10 21H1 

The most recent Windows versions are supported.  
Pro edition or up is strongly recommended.   
Older Windows versions are not supported. 

### Documentation
Make sure you (the user) have read documentation regarding this project before its usage.

### Internet connection
An active internet connection is needed.
***

## 🚀 Running WinRice
#### There are two methods to run WinRice
### 1. Run the latest release
- Get the [latest release](https://github.com/pratyakshm/WinRice/releases/latest).
- Run the EXE (as admin).

### 2. Main branch
- Open Windows Terminal (Admin) and paste:
```
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JBpYc'))
```

***

## 🤕 Known issues
Known issues are tracked [here](https://github.com/pratyakshm/WinRice/issues/16).  

## 💁‍♂️ Contributing 
WinRice accepts all kinds of contributions such as finding bugs, fixing bugs, adding features, removal of deprecated features and/or values, etc. I'm excited to work with the users and fellow PowerShell enthusiasts to further improve this project.

I ask that **before you start your work on a feature that you would like to request or contribute**, please read WinRice [principles](https://github.com/pratyakshm/WinRice/wiki/Principles). I will be happy to work with you to figure out good approaches and provide guidance throughout feature development, and help avoid any wasted or duplicated effort.

***

## ⚖️ License
WinRice is licensed under the [GPL-3.0 License](https://github.com/pratyakshm/WinRice/blob/main/LICENSE).