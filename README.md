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

## Description

WinRice uses PowerShell automation to setup a Windows device. It currently supports only the latest retail builds of Windows 11 and 10.
  
WinRice, amongst a host of other things, improves privacy, de-clutters the Windows user interface and removes non-essential apps from Windows while still retaining OS functionality.

## Documentation

The documentation for WinRice is available below. Before running WinRice, please ensure that you have read the essential documentation.

**Documentation folder:** [Tap here](https://github.com/pratyakshm/WinRice/tree/main/doc)  
 
**Known issues**: See [Known issues](https://github.com/pratyakshm/WinRice/issues?q=is%3Aopen+is%3Aissue+label%3A%22Bug+report%22) before running WinRice.

**Functions**: See [Functions](https://github.com/pratyakshm/WinRice/wiki/Functions) to get a detailed explanation of each function.

## Requirements

WinRice, when run, checks if all of the following requirements are met:
- Device is online and connected to the Internet.
- Device is powered by a Windows build that's currently in service. [See more](https://github.com/pratyakshm/WinRice/blob/main/doc/Supported-winver.md).
- PowerShell session is elevated to admin.
- If there are any pending device restarts.

If any one of the criteria is not met, WinRice terminates itself.

## Running WinRice

#### Download [WinRice.exe](https://github.com/pratyakshm/WinRice/releases/download/v0.5.04112021/WinRice.exe).

## Contributing

Read [CONTRIBUTING.MD](https://github.com/pratyakshm/WinRice/blob/main/CONTRIBUTING.md).
