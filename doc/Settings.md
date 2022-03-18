# Express Settings

WinRice presents user with default settings that can be reconfigured by the user. These are called "Express Settings".

There are a few configurable settings in WinRice that have a broader sense of impact on the device usage.


# Uninstallation

## App Uninstallation

A set of non-essential apps [listed in this document](https://github.com/pratyakshm/WinRice/blob/main/doc/App-uninstallation.md) are uninstalled from the device. 

## Feature Uninstallation

A set of non-essential featuers [listed in this part of this document](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#features-uninstalled-optional) are disabled and/or uninstalled from the device.

# Installation

## App Installation

No apps except NanaZip and HEVC Video Extensions are installed. Apps can only be installed if the user opts to use Custom Settings instead of Express Settings.

## Feature Installation

No features are installed. 

# Windows Update
Automatic Windows update is disabled.

Windows quality updates are delayed by 4 days.

Windows feature updates are delayed by up to 20 days.

***
&nbsp;

# Custom Settings

Users can customize their WinRice experience using these Custom Settings if they do not like Express Settings.

## App Installation

WinRice asks if you want to install apps. If you choose to do so, you will be presented with two methods of app installation, which are [Winstall](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/winstall.md) and [WinGet import](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/import.md).


## App Uninstallation

WinRice asks if you want to uninstall some built-in apps that are generally left unused. To learn more, see [App-uninstallation.md](https://github.com/pratyakshm/WinRice/blob/main/doc/App-uninstallation.md).

### Microsoft OneDrive - Uninstallation

WinRice asks if you want to uninstall OneDrive.

## Feature Installation

### .NET 3.5

.NET 3.5 is a legacy runtime which is used to support running legacy applications and programs. While this may prove useful in corporate environments, with some exceptions, this feature is not too important in consumer devices.

WinRice asks if you want to install .NET 3.5.

### Windows Subsystem for Linux

The Windows Subsystem for Linux lets developers run a GNU/Linux environment -- including most command-line tools, utilities, and applications -- directly on Windows, unmodified, without the overhead of a traditional virtual machine or dualboot setup. Read more at [What is the Windows Subsystem for Linux? - docs.microsoft.com](https://docs.microsoft.com/en-us/windows/wsl/about).

By default, WSL is not installed in Windows consumer editions. WinRice will ask if the user wants to install Windows Subsystem for Linux.

WinRice asks if you want to install WSL.

### Windows Sandbox

Windows Sandbox provides a lightweight desktop environment to safely run applications in isolation. Software installed inside the Windows Sandbox environment remains "sandboxed" and runs separately from the host machine. Read more at [Windows Sandbox - docs.microsoft.com](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview).

By default, Windows Sandbox is not installed in Windows consumer editions. WinRice will ask if the user wants to install Windows Sandbox.

WinRice asks if you want to install Windows Sandbox.

## Feature Uninstallation

Windows, by default, ships with optional features, some of which are no longer broadbly used in most consumer devices. Here's a list of the features: [Link](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#features-uninstalled-optional). If none of these features are useful to you, I suggest you to opt into removing them from your device. 

WinRice asks if you want to uninstall these optional features.

### Widgets - Windows 11 only

Widgets at a glance is a new experience which ships with Windows 11. Learn more about them: [Stay up to date with widgets - support.microsoft.com](https://support.microsoft.com/en-us/windows/stay-up-to-date-with-widgets-7ba79aaa-dac6-4687-b460-ad16a06be6e4).

Widgets is an optional experience and it can be both disabled and removed.

WinRice asks if you want to remove Widgets from your device.

## Windows Update

WinRice asks if you want to apply [these Windows Update policies](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#windows-update-optional).

## System

### UTC Time

If your device has Windows and Linux dual booted, its recommended to make Windows OS follow the UTC time in order to avoid time differences with Linux.

However, some reports have shown that this modification might (unintentionally) make the device not display the correct time.

WinRice asks if you want to make this change.

### System Restore

System Restore is a useful utility to restore your device to a previous timestamp. 

Since WinRice performs a good number of registry modifications to a vast amount of devices from notebooks to PCs, across different OS editions, OS versions and hardware, it might sometimes cause something unexpected to occur with your device. 

WinRice asks if you want to create a System restore point.

### ⚠️ Notes regarding Windows Update policies:

- WinRice will not apply update policies to Windows Insiders' devices.

- Update policies are only applied to Windows Pro, Education, Enterprise, and other editions that are derived from Windows Enterprise edition. This is a OS level restriction put forward by Microsoft and WinRice has no control over it.

---

## Feedback

If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).