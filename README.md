<p align="left"><a href="https://github.com/pratyakshm/WinRice"><img src="files/banner.png" width="470" height="250"></a></p> 
<p align="left">
<img alt="GitHub all releases" src="https://img.shields.io/github/downloads/pratyakshm/WinRice/total?style=for-the-badge">
<img alt="Issues" src="https://img.shields.io/github/issues/pratyakshm/WinRice?style=for-the-badge"> 
<img alt="Platform support" src="https://img.shields.io/badge/Windows%2011-Ready-blue?style=for-the-badge&logo=windows11">
<img alt="Platform support" src="https://img.shields.io/badge/Windows%2010-Ready-yellow?style=for-the-badge&logo=windows">
</p>
<h2 align ="left">Set up your Windows device using automation</h2>

<p align="left"><a href="#core-features">Features</a> &bull; <a href="doc">Documentation</a> &bull; <a href="#using-winrice">Usage</a> &bull; <a href="doc/Frequently-answered-questions.md">FAQ</a>   &bull; <a href="LICENSE">License</a> &bull; <a href="https://github.com/pratyakshm/WinRice/blob/main/doc/CONTRIBUTING.md">Contribution</a>

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

  - You've read the documentation and you know what WinRice does. If you're running WinRice for the first time, take a look at [`Main-brief.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md). The directory that contains all documents is available [here](https://github.com/pratyakshm/WinRice/tree/main/doc).
  - Your device must:
    - Be connected to the Internet.
    - Be powered by an [in-service Windows version](https://github.com/pratyakshm/WinRice/blob/main/doc/Supported-winver.md).
    - Not have any pending restarts.
 
### Using an EXE [Recommended]
  
Use [this link](https://github.com/pratyakshm/WinRice/releases/download/v0.5.04112021/WinRice.exe) to download the program.

### Alternative methods
  <details><summary> Click to expand </summary>
  Alternatively, use Win + X shortcut to open the quick links menu, and from there open Terminal (Admin) (or Windows PowerShell (Admin) if you are on Windows 10) and execute this command:

```
Invoke-WebRequest bit.ly/WinRice | Invoke-Expression
```
  </details>
