<p align="center"><a href="https://github.com/pratyakshm/WinRice"><img src="files/banner.png" width="470" height="250"></a></p> 
<h2 align ="center">Set up your Windows device using automation</h2>
<p align="center">
<a href="https://github.com/pratyakshm/WinRice#running-WinRice"><img src="https://img.shields.io/static/v1?label=pratyakshm&message=WinRice&color=blue&logo=github" alt="pratyakshm - WinRice"></a>
<a href="https://github.com/pratyakshm/WinRice"><img alt="GitHub all releases" src="https://img.shields.io/github/downloads/pratyakshm/WinRice/total?color=blue"></a>
<a href="https://github.com/pratyakshm/WinRice"><img src="https://img.shields.io/github/stars/pratyakshm/WinRice?style=social" alt="stars - WinRice"></a>
<a href="https://github.com/pratyakshm/WinRice"><img src="https://img.shields.io/github/forks/pratyakshm/WinRice?style=social" alt="forks - WinRice"></a>
<a href="#license"><img src="https://img.shields.io/badge/License-GPL_v3-blue" alt="License"></a>
</p>

<p align="center"><a href="#features">Features</a> &bull; <a href="doc">Documentation</a> &bull; <a href="#using-winrice">Usage</a>

<p align="center"><a href="doc/Frequently-answered-questions.md">FAQ</a>   &bull; <a href="LICENSE">License</a> &bull; <a href="#contributing">Contribution</a>

## About

WinRice is a PowerShell script designed to automate setting up a new Windows device. It automates a few of the useful things that people generally do in a fresh Windows installation or a new Windows device.
  
## Core Features
  - Allows you to batch install apps & features
  - Configures Windows UI
  - Configures Windows Update policies
  - Enhances privacy
  - Disables non-essential tasks
  - Disables silent installation of apps from Microsoft Store
  - Disables suggestions and tips
  - Hardens security
  - Removes non-essential apps
  - Removes non-essential features
  - Restores all power options


## Using WinRice
  
### Requirements

You must meet these requirements before running WinRice.

  - You've read the documentation and you know what WinRice does. If you're new, start with [`Main-brief.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md).
  - Your device:
    - Is connected to the Internet.
    - Is powered by an [in-service Windows version](https://github.com/pratyakshm/WinRice/blob/main/doc/Supported-winver.md).
    - Does not have any pending restarts.

The directory that contains all documents is available [here](https://github.com/pratyakshm/WinRice/tree/main/doc).  
 
### Using an EXE [Recommended]
  
Use [this link](https://github.com/pratyakshm/WinRice/releases/download/v0.5.04112021/WinRice.exe) to download the program.

### Alternative methods

Alternatively, use Win + X shortcut to open the quick links menu, and from there open Terminal (Admin) (or Windows PowerShell (Admin) if you are on Windows 10) and execute this command:

```
Invoke-WebRequest bit.ly/WinRice | Invoke-Expression
```

## Contributing

Read [CONTRIBUTING.MD](https://github.com/pratyakshm/WinRice/blob/main/doc/CONTRIBUTING.md).
