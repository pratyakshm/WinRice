# Main brief document

💡 Your WinRice experience can be customized. Please read [`Settings.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/Settings.md) to learn more.

## Contents of this page

| Category | Link |
| -------- | ---- |
| Apps | [Click here](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#apps)
| Features | [Click here](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#features)
| Privacy | [Click here](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#privacy)
| Security | [Click here](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#security)
| OS | [Click here](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#os)
| Windows Explorer | [Click here](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#windows-explorer)



## Legend
| Symbol | Significance |
| ---------- | -------  |
| 🎛️  | Tasks prefixed with 🎛️ "control knob" emoji are such tasks which are only run when they are configured. You may learn more by visiting [``Settings.md``](https://github.com/pratyakshm/WinRice/blob/main/doc/Settings.md). |
| 🧪 | Tasks prefixed with 🧪 "test tube" emoji behave differently when device is detected to be flighting in the Windows Insider Program. |

# Apps

### Things Installed:

- HEVC Video Extensions
- Visual C++ Libraries
- Windows Package Manager ([GitHub](https://github.com/microsoft/winget-cli/))
- NanaZip ([GitHub](https://github.com/M2Team/NanaZip))

#### 🎛️ Leveraging WinGet to Install Apps

- [`winget.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/winget.md)
- [`import.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/import.md)
- [`winstall.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/winstall.md)


### 🎛️ Apps Uninstalled:

Refer to [`App-uninstallation.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/App-uninstallation.md)

### Apps Unpinned From Taskbar:

- Mail
- Microsoft Store
- Office
- Xbox

## 🔚 End of Apps section

***

# Features

### 🎛️ Features Installed:

- .NET 3.5
- Windows Sandbox 
- Windows Subsystem for Linux

### 🎛️ Features Uninstalled: 

- DirectPlay
- Legacy Components
- Math Recognizer
- SMB 1 Protocol
- SMB Direct
- Snipping Tool (Windows 10)
- Windows Fax & Scan
- Windows Hello Face (if no Camera is connected to device)
- Windows PowerShell ISE
- Windows PowerShell v2 
- Windows XPS Features
- XPS Document Writer
- WordPad
- Work Folders Client


## 🔚 End of Features section

***

# Privacy

## Turn Off the Following:

- Advertising ID
- App suggestions
- Error reporting
- Inking & typing personalization
- Online speech recognition
- Tailored Experiences
- Websites' access to language list to provide locally relevant content

## Limit The Following:

- 🧪 Diagnostic data
- 🧪 Feedback notifications

#### 🔔 Check [notes](https://github.com/pratyakshm/WinRice/blob/main/doc/Main-brief.md#notes)

## Turn On the Following:

- Clipboard history
</details>


## 🔚 End of Privacy section

***

# Security

### Stay on lock screen post a Windows Update restart
After a device restarts after applying a Windows Update, it stays on the lock screen and awaits manual login from a user.

<!-- >
### Virtualization-based Security
Virtualization-based security, or VBS, uses hardware virtualization features to create and isolate a secure region of memory from the normal operating system. 
Virtualization-based security causes big performance impact in devices that do not support, amongst many other things, MBEC. In MBEC-unsupported devices, its behavior is emulated which causes the impact.

WinRice disables Virtualization-based security on MBEC-unsupported devices.

**Note:** Disabling Virtualization-based security results in loss of functionality of WSL and WSA as they are powered by Hyper-V. If you use WSL or WSA, you need to re-enable Virtualization-based security.

To enable, open Windows Terminal (Admin) and run this command:
```
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/J9OZr'))
```
After running this command, restart your device to apply the changes.

See more at [Enable virtualization-based protection of code integrity - docs.microsoft.com](https://docs.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity).
<--->

### Windows WDigest Credential Caching

Digest Authentication is a challenge/response protocol that was primarily used in Windows Server 2003 for LDAP and web-based authentication. It utilizes Hypertext Transfer Protocol (HTTP) and Simple Authentication Security Layer (SASL) exchanges to authenticate. 

This is where WDigest comes into play, something to be concerned with related to WDigest is that it stores passwords in clear-text, in memory. If a malicious user has access to an endpoint and is able to run a tool like Mimikatz, not only would they get the hashes currently stored in memory, but they’d also be able to get the clear-text password for the accounts as well. 

WinRice disables WDigest Credential Caching on all devices.

See more at [What is Digest Authentication?: Logon and Authentication - docs.microsoft.com](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc778868(v%3dws.10)).

### Link-Local Multicast Name Resolution
LLMNR was (is) a protocol used that allowed name resolution without the requirement of a DNS server. It was (is) able to provide a hostname-to-IP based off a multicast packet sent across the network asking all listening Network-Interfaces to reply if they are authoritatively known as the hostname in the query. 
Windows will use LLMNR in certain circumstances to identify certain machines on the network, such as file-servers. If Windows attempts to use LLMNR to identify the server of a file-share and it receives a reply, it will send the current user’s credentials directly to that server assuming it wouldn’t have replied if it wasn’t the authoritative file-server. If that LLMNR received response was actually an impersonator, Windows just disclosed that user’s credential hash to a third-party. What’s worse? The impersonator may forward that packet to the actual file-server, so the user never realizes anything is amiss.

WinRice disables LLMNR on all devices.

See more at [How to Disable LLMNR & Why You Want To - Black Hills Information Security - blackhillsinfosec.com](https://www.blackhillsinfosec.com/how-to-disable-llmnr-why-you-want-to/).

### Structured Exception Handling Overwrite Protection
This feature is designed to block exploits that use the Structured Exception Handler (SEH) overwrite technique. This protection mechanism is provided at run-time. Therefore, it helps protect your device. 

WinRice enables Structured Exception Handling Overwrite Protection on all devices.

See more at [How to enable Structured Exception Handling Overwrite Protection (SEHOP) in Windows operating systems - support.microsoft.com](https://support.microsoft.com/en-us/topic/how-to-enable-structured-exception-handling-overwrite-protection-sehop-in-windows-operating-systems-8d4595f7-827f-72ee-8c34-fa8e0fe7b915).

### Web Proxy Auto-Discovery

WPAD is a protocol, developed in 1999 by people from Microsoft and other technology companies, that allows computers to automatically discover which web proxy they should use. The proxy is defined in a JavaScript file called a proxy auto-config (PAC) file.

The location of PAC files can be discovered through WPAD in several ways: through a special Dynamic Host Configuration Protocol (DHCP) option, through local Domain Name System (DNS) lookups, or through Link-Local Multicast Name Resolution (LLMNR).

Attackers can abuse these options to supply computers on a local network with a PAC file that specifies a rogue web proxy under their control. This can be done on an open wireless network or if the attackers compromise a router or access point.

WinRice disables Web Proxy Auto-Discovery or WPAD on all devices.

See more at [Disable WPAD now or have your accounts and private data compromised - csoonline.com](https://www.csoonline.com/article/3106076/disable-wpad-now-or-have-your-accounts-and-private-data-compromised.html).

Also read: [Disable WPAD on Your PC So Your HTTPS Traffic Won't Be Vulnerable to the Latest SSL Attack -null-byte.wonderhowto.com](https://null-byte.wonderhowto.com/how-to/disable-wpad-your-pc-so-your-https-traffic-wont-be-vulnerable-latest-ssl-attack-0172499).

### Local Security Authority (LSA) Protection

The LSA, which includes the Local Security Authority Server Service (LSASS) process, validates users for local and remote sign-ins and enforces local security policies. The Windows 8.1 operating system provides additional protection for the LSA to prevent reading memory and code injection by non-protected processes. This provides added security for the credentials that the LSA stores and manages.

WinRice enables LSA Protection on all devices.

See more at [Configuring Additional LSA Protection](https://docs.microsoft.com/en-us/windows-server/security/credentials-protection-and-management/configuring-additional-lsa-protection)

### Windows Script Host

Numerous spam campaigns are pushing various crypto-ransomware families (and backdoors) via ZIP file attachments. And such ZIP files typically contain a JScript (.js/.jse) file which, if clicked, will be run via Windows Script Host.

Since Windows Script Host is also not used by personal PC users, WinRice disables this feature.

See more at [How-To Disable Windows Script Host - blog.f-secure.com](https://blog.f-secure.com/how-to-disable-windows-script-host/).

### Office OLE

OLE allows an editing application to export part of a document to another editing application and then import it with additional content. For example, a desktop publishing system might send some text to a word processor or a picture to a bitmap editor using OLE. 
OLE is misused by malware and is often treated by some as an exploit.

WinRice disables Office OLE.

See more at [111 Attacking EvilCorp Anatomy of a Corporate Hack Sean Metcalf Will Schroeder - youtube.com](https://youtu.be/nJSMJyRNvlM?).


## 🔚 End of Security section

***

# OS

## Disables the following tasks:

- Consolidator
- DmClient
- DmClientOnScenarioDownload
- Disk Diagnostics Data Collector
- Feedback Notifications task
- Microsoft Compatibility Appraiser
- ProgramDataUpdater
- QueueReporting
- UsbCeip

### Disables these additional tasks if your device is powered by an AMD processor:

- AMDLinkUpdate
- AMDRyzenMasterSDKTask
- ModifyLinkUpdate
- StartCN
- StartDVR

## Restores Power options

This is useful for OEM devices which ship with a lot of power options hidden by default. WinRice restores them to the user.

<details><summary> Tap to show / hide picture that demonstrates what the Power Options menu looks like after these changes</summary>

![image](https://user-images.githubusercontent.com/54220235/149530018-d71f56a5-f1f2-4365-af8b-92a16e28aae3.png)

</details>

### More OS Level Changes That Are Made:

Things disabled:
- Autoplay & Autorun.
- Hibernation (desktop only).
- Windows welcome experience after an update which shows what's new.
- Tips and suggestions when using Windows.

Things enabled:
- 🎛️ OS may be enabled to follow UTC if its set to follow BIOS time.
- Num lock on startup.
- Long path support.

## 🧪🎛️ Windows Update

### Setup Windows Update

Setup the following policies to Windows Update:

- Turn off automatic updates
- Do not auto restart PC if users are signed in
- Delay feature updates by 20 days
- Delay quality updates by 4 days
- Turn off re-installation of bloatware after feature updates
- Turn off Delivery Optimization

### Reset Windows Update

- Reset Windows Update is available for users who want to switch back to stock Windows Update settings.

## 🔚 End of OS section

***


# Windows Explorer

## Turn Off the Following:

| Item               | Place                 | OS                        |
| ------------------ | --------------------- | ------------------- |
| Widgets icon       | Taskbar         | Windows 11            |
| Chat icon          | Taskbar         | Windows 11            |
| Search icon        | Taskbar         | Windows 11 and 10     |
| Task view          | Taskbar         | Windows 11 and 10     |
| Cortana            | Taskbar         | Windows 10            |
| 3D Objects         | File Explorer sidebar | Windows 10      |
| Meet now           | Other system tray icons | Windows 10    |
| News and interests | Other system tray icons | Windows 10    |

</details>

## More Changes:

- Set File Explorer to open This PC by default
- Turn off Keyboard shortcut for Sticky keys
- Use the Print screen button to open Screen snipping
- If taskbar is found to not preview windows of opened apps correctly, an attempt is made to fix this.


## 🔚 End of Windows Explorer section

***


## Notes

- WinRice sets your Diagnostic data to Required level. On devices running Windows pre-release software, Diagnostic data is set to Optional level.

- Error reporting is not disabled in Windows pre-release software.

- Feedback notifications are not disabled in Windows pre-release software.

- Windows Update policies are not applied in Windows pre-release software.

- Windows Update policies are only applied to Windows editions that support Group policies. These are Education, Enterprise, Enterprise LTSC and Professional editions. Windows editions that are derivates of Windows Core edition (for instance, Windows 11/10 Home) do not support Group policies, hence Windows Update policies cannot be applied to them.



---

## Feedback

If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).
