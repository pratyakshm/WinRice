<p align="center"><a href="https://github.com/pratyakshm/WinRice"><img src="files/banner.png" width="470" height="250"></a></p> 
<h2 align ="center">Set up your Windows device using automation</h2>
<p align="center">
<a href="https://github.com/pratyakshm/WinRice#running-WinRice"><img src="https://img.shields.io/static/v1?label=pratyakshm&message=WinRice&color=blue&logo=github" alt="pratyakshm - WinRice"></a>
<a href="https://github.com/pratyakshm/WinRice"><img alt="GitHub all releases" src="https://img.shields.io/github/downloads/pratyakshm/WinRice/total?color=blue"></a>
<a href="https://github.com/pratyakshm/WinRice"><img src="https://img.shields.io/github/stars/pratyakshm/WinRice?style=social" alt="stars - WinRice"></a>
<a href="https://github.com/pratyakshm/WinRice"><img src="https://img.shields.io/github/forks/pratyakshm/WinRice?style=social" alt="forks - WinRice"></a>
<a href="#license"><img src="https://img.shields.io/badge/License-GPL_v3-blue" alt="License"></a>
</p>

<p align="center"><a href="doc/Main-brief.md">A brief on WinRice</a> &bull; <a href="doc">Documentation</a> &bull; <a href="#-running-winrice">Usage</a>

<p align="center"><a href="doc/Frequently-answered-questions.md">FAQ</a>   &bull; <a href="LICENSE">License</a> &bull; <a href="#%EF%B8%8F-contributing">Contribution</a>

---

## 😃 Description

WinRice uses PowerShell automation to setup a Windows device. It currently supports only the latest retail builds of Windows 11 and 10.
  
WinRice, amongst a host of other things, improves privacy, de-clutters the Windows user interface and removes non-essential apps from Windows.
It aims to provide a clutter free, private and secure Windows experience without breaking any OS functionality.

---

## 📃 Documentation

The documentation for WinRice is available in the below link. The documentation explains every task that WinRice performs on your PC. Make sure you (the user) have read the documentation before going ahead.

**Documentation:** [Tap here](https://github.com/pratyakshm/WinRice/tree/main/doc)  
  P.S. Reading the documentation is strongly recommended
 
**Functions**: See [Functions](https://github.com/pratyakshm/WinRice/wiki/Functions) to get a detailed explanation of each function.
 
---

## ✔️ Requirements

### Supported OS Versions

WinRice supports the latest Windows retail and pre-release builds.

| OS Version | Version | OS Build | Servicing Option    |
| ---------- | ------- | -------- | ------------------- |
| Windows 11 | 21H2    | 22000    | General Availability |
| Windows 10 | 21H2    | 19044    | General Availability |
  
⚠️ This table does not include builds from Windows Insider Program. But if you are a Windows Insider, you can still run WinRice provided you're on a recent build.

### Unsupported OS Versions
| OS Version | Version | OS Build | Servicing Option    |
| ---------- | ------- | -------- | ------------------- |
| Windows 10 | 21H1    | 19043    | Semi-Annual Channel |
| Windows 10 | 20H2    | 19042    | Semi-Annual Channel |

**Notes:**
 - These OS versions are not officially supported by WinRice, but WinRice still runs on these devices because during the time of making this modification (January 2022), OEMs still ship laptops with Windows 10 20H2.
 - As WinRice is not supported on these devices, I do not follow up with bug reports for these specific OS versions. Infact, there is no way to file bug reports for these OS versions.
  
### How to check if my device is compatible?
Go to **Settings > System > About** and scroll down to the **Windows specifications** section.
In here, check out **Version** and **OS build** and verify if its listed in the table provided above.
  
If the Version and OS build that you are currently on are **NOT** listed in the table above, you need to update your device. [Learn more](https://github.com/pratyakshm/WinRice/wiki/Fresh-installation-of-Windows).

### Internet Connection

An active internet connection is needed.

---

## 🚀 Running WinRice

#### Download and run [this executable (.EXE) file](https://github.com/pratyakshm/WinRice/releases/download/v0.5.04112021/WinRice-main.exe).
  
**Notes:**
  - WinRice's Releases page has been hidden because WinRice is a continuously updated project, and using a particular release means that you as a user are still lagging behind in terms of the latest code.
---

## 🤕 Known Issues

Known issues are tracked [here](https://github.com/pratyakshm/WinRice/issues/16).

## 💁‍♂️ Contributing

WinRice accepts all kinds of contributions such as finding bugs, fixing bugs, adding features, removal of deprecated features and/or values, improving documentation, etc. I'm excited to work with the users and fellow PowerShell enthusiasts to further improve this project.

I ask that **before you start your work on a feature that you would like to request or contribute**, please read the WinRice [principles](https://github.com/pratyakshm/WinRice/wiki/Principles). I will be happy to work with you to figure out good approaches and provide guidance throughout feature development, and help avoid any wasted or duplicated effort.

## Credits and acknowledgements
<p align="left"> &bull; WinRice logo and banner is created by <a href="https://linktr.ee/vancelmusic">Vancel</a></p>
<p align=left> &bull; Documentation and UX are contributed to by <a href="https://kenharris.xyz/">Ken</a></p>
  
---

## ⚖️ License

WinRice is licensed under the [GPL-3.0 License](LICENSE).
