<p align="center"><a href="https://github.com/pratyakshm/WinRice"><img src="assets/banner.png" width="500" height="250"></a></p> 
<h2 align ="center">Set up your Windows device using automation</h2>
<p align="center">
<a href="https://github.com/pratyakshm/WinRice#running-WinRice"><img src="https://img.shields.io/static/v1?label=pratyakshm&message=WinRice&color=blue&logo=github" alt="pratyakshm - WinRice"></a>
<a href="https://github.com/pratyakshm/WinRice"><img alt="GitHub all releases" src="https://img.shields.io/github/downloads/pratyakshm/WinRice/total?color=blue"></a>
<a href="https://github.com/pratyakshm/WinRice"><img src="https://img.shields.io/github/stars/pratyakshm/WinRice?style=social" alt="stars - WinRice"></a>
<a href="https://github.com/pratyakshm/WinRice"><img src="https://img.shields.io/github/forks/pratyakshm/WinRice?style=social" alt="forks - WinRice"></a>
<a href="#license"><img src="https://img.shields.io/badge/License-GPL_v3-blue" alt="License"></a>
</p>

<p align="center"><a href="#-description">Description</a> &bull; <a href="https://github.com/pratyakshm/WinRice/blob/main/doc/Features.md">Features</a> &bull; <a href="https://github.com/pratyakshm/WinRice/tree/main/doc">Documentation</a> &bull; <a href="#-running-winrice">Usage</a>

<p align="center"><a href="https://github.com/pratyakshm/WinRice/blob/main/doc/Frequently-answered-questions.md">FAQ</a>   &bull; <a href="#%EF%B8%8F-license">License</a> &bull; <a href="#%EF%B8%8F-contributing">Contribution</a>

---

## 😃 Description

WinRice uses automation to make your Windows experience better. Continue reading to learn more.

---

## ✔️ Prerequisites

### Windows Terminal

<a href="https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701"> <img src="https://user-images.githubusercontent.com/54220235/130347354-d4e7af6e-a153-4954-a7f4-3d7ad27da7c9.png" alt="Windows Terminal product page on Microsoft Store"></a>

More installation methods include:

- Getting the latest release from [GitHub](https://github.com/microsoft/terminal/releases)
- Windows Package Manager CLI (winget): `winget install --id=Microsoft.WindowsTerminal --source winget`

### Supported OS Versions

WinRice supports the latest Windows retail and pre-release builds.

⚠️ This table features builds from Windows retail channel (Production/General availability/ Release to manufacturing). Windows Insider channels are still supported but no longer featured in the list.

| OS Version | Version | OS Build | Servicing Option    |
| ---------- | ------- | -------- | ------------------- |
| Windows 11 | 21H2    | 22000    | Annual Channel      |
| Windows 10 | 21H1    | 19043    | Semi-Annual Channel |

#### Notes

- To check if your device is compatible, go to **Settings > System > About** and scroll down to the **Windows specifications** section. Make sure that the **Version** or **OS Build** you are currently running is listed in the table above.
  - If you are not running a supported OS version, you need to update your device. A fresh installation is strongly recommended and is easy: [Read the document](https://github.com/pratyakshm/WinRice/wiki/Fresh-installation-of-Windows)!
- In case of Retail channel (GA/RTM), WinRice supports **only** the latest retail channel build. I could include support for older Retail (GA/RTM) builds but honestly, I do not have the time to test each change in more than two OS builds.

### Internet Connection

An active internet connection is needed.

---

## 📃 Documentation

Make sure you (the user) have read the documentation before running WinRice.

**Documentation: [Tap here](https://github.com/pratyakshm/WinRice/tree/main/doc)**

---

## 🚀 Running WinRice

#### There are two methods to run WinRice.

### 1. Run the latest release:

- Get the [latest release](https://github.com/pratyakshm/WinRice/releases/latest).
- Run the EXE (as admin).

### 2. Main branch:

- Open Windows Terminal (Admin) and paste:

```
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JBpYc'))
```

---

## 🤕 Known Issues

Known issues are tracked [here](https://github.com/pratyakshm/WinRice/issues/16).

## 💁‍♂️ Contributing

WinRice accepts all kinds of contributions such as finding bugs, fixing bugs, adding features, removal of deprecated features and/or values, improving documentation, etc. I'm excited to work with the users and fellow PowerShell enthusiasts to further improve this project.

I ask that **before you start your work on a feature that you would like to request or contribute**, please read the WinRice [principles](https://github.com/pratyakshm/WinRice/wiki/Principles). I will be happy to work with you to figure out good approaches and provide guidance throughout feature development, and help avoid any wasted or duplicated effort.

## Credits and acknowledgements
<h4 align="left"> &bull; The awesome WinRice logo and banner are created by <a href="https://t.me/vancelmusic">Vancel</a></h4>
  <p align="left"> Vancel is a music producer, he mostly produces future bass or dance music. Do check out his <a href="https://open.spotify.com/artist/0G4AZNtTIxerdDkVLZP4t1?si=Zr_gW6P5T6Gi4eIQrpRWqA&nd=1">Spotify</a> &bull; <a href="https://soundcloud.com/vancelmusic">SoundCloud</a> &bull; <a href="https://youtube.com/vancelmusic">YouTube</a> &bull; <a href="https://music.apple.com/us/artist/vancel/531284996">Apple Music</a>.</p>
<h4 align=left> &bull; Documentation and UX are written and directed by <a href="https://kenharris.xyz/">Ken</a></h4>
  <p align="left">Ken likes to tinker with Android and the Linux kernel. He also writes Python projects for fun. You can check out his projects over at his <a href="https://github.com/kenhv">GitHub</a>.</p>
  
---

## ⚖️ License

WinRice is licensed under the [GPL-3.0 License](https://github.com/pratyakshm/WinRice/blob/main/LICENSE).
