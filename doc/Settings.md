# Express Settings

WinRice presents user with default settings that can be reconfigured by the user. These are called "Express Settings".

There are a few configurable settings in WinRice that have a broader sense of impact on the device usage.


# Uninstallation

## App Uninstallation

A set of non-essential apps [listed in this document](https://github.com/pratyakshm/WinRice/blob/main/doc/App-uninstallation.md) are uninstalled from the device. 

## Feature Uninstallation

A set of non-essential features [listed in this part of this document](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#features-uninstalled-optional) are disabled and/or uninstalled from the device.

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

By default, this feature is not installed, hence WinRice asks if you want to install it.


### Windows Subsystem for Linux

The Windows Subsystem for Linux lets developers run a GNU/Linux environment -- including most command-line tools, utilities, and applications -- directly on Windows, unmodified, without the overhead of a traditional virtual machine or dualboot setup. Read more at [What is the Windows Subsystem for Linux? - docs.microsoft.com](https://docs.microsoft.com/en-us/windows/wsl/about).

By default, this feature is not installed, hence WinRice asks if you want to install it.

### Windows Sandbox

Windows Sandbox provides a lightweight desktop environment to safely run applications in isolation. Software installed inside the Windows Sandbox environment remains "sandboxed" and runs separately from the host machine. Read more at [Windows Sandbox - docs.microsoft.com](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview).

By default, this feature is not installed, hence WinRice asks if you want to install it.

## Feature Uninstallation

Windows, by default, ships with optional features, some of which are no longer broadbly used in most consumer devices. Here's a list of the features: [Link](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#features-uninstalled-optional). If none of these features are useful to you, I suggest you to opt into removing them from your device. 

WinRice asks if you want to uninstall these features.

### Widgets - Windows 11 only

Widgets at a glance is a new experience which ships with Windows 11. Learn more about them: [Stay up to date with widgets - support.microsoft.com](https://support.microsoft.com/en-us/windows/stay-up-to-date-with-widgets-7ba79aaa-dac6-4687-b460-ad16a06be6e4).

Widgets is an optional experience and it can be removed. Hence, WinRice asks if you want to remove Widgets.

## Windows Update

Windows Update, at least in the media, is reputed to cause more problems than offer solutions. Since 2019, however, Microsoft has begun to leverage Microsoft Cloud to use and train ML models that offer intelligent Windows Update rollouts - and it is working. Windows Update experience has globally improved for millions of devices, and there are far less adverse post update scenarios that users face at present day compared to circa 2017.

While Microsoft's ML performs quite a good job in itself, WinRice still applies policies to Windows Update, if the user asks it to do so.

### List of Windows Update policies:
- Disabling of automatic updates
- Delaying of quality updates by 4 days and feature upgrades by 20 days
- Disabling updating of Microsoft products via Windows Update
- Disabling Delivery Optimization (i.e. WU will download updates only from MSFT CDN)

## System

### UTC Time

If your device has Windows and Linux dual booted, its recommended to make Windows OS follow the UTC time in order to avoid time differences with Linux.

However, some reports have shown that this modification might (unintentionally) make the device not display the correct time.

WinRice asks if you want to make this change.

### System Restore

System Restore is a useful utility to restore your device to a previous timestamp. 

Since WinRice performs a good number of registry modifications to a vast amount of devices from notebooks to PCs, across different OS editions, OS versions and hardware, it might sometimes cause something unexpected to occur with your device. 

WinRice asks if you want to create a System restore point.

### Device-wide policies

Some changes need to be applied device-wide for them to take effect. These changes apply to all current and future user accounts that will be created on your device. It is strongly recommended to agree to apply device-wide policies as well, since these policies make up much of the security hardening that WinRice performs to your device.

WinRice asks if you want to apply these device-wide changes.

---

#### ⚠️ Notes regarding Windows Update policies:

- Windows Update policies are not applied in Windows pre-release software.

- Windows Update policies are only applied to Windows editions that support Group policies. These are Education, Enterprise, Enterprise LTSC and Professional editions. Windows editions that are derivates of Windows Core edition (for instance, Windows 11/10 Home) do not support Group policies, hence Windows Update policies cannot be applied to them.


---

## Feedback

If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).