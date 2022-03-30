# Windows Package Manager CLI Client

## What is Windows Package Manager (a.k.a WinGet)?

Windows Package Manager, or simply `winget`, is the official package manager client for Windows. Package managers allow you to deploy and manage apps using the command line.

## WinRice x WinGet

A lot of features in WinRice are powered by WinGet.

| Feature                   | Documentation                                                                           |
| ------------------------- | --------------------------------------------------------------------------------------- |
| Winstall                  | [`winstall.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/winstall.md) |
| winget import             | [`import.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/import.md)     |
| Deploy Microsoft OneDrive | [`Features.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/Features.md)        |

# Installing WinGet

If you have used WinRice, chances are you have WinGet installed.

Run `winget.exe` in Windows Terminal to check if it's present.

You can install WinGet by the following methods:

- Get the latest release from [WinGet's GitHub repository](https://github.com/microsoft/winget-cli/releases/latest).
- Use WinRice's own winget install script [paste in Windows Terminal (Admin)]: `Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JWMKj'))`
- Join [WinGet Insider Program](http://aka.ms/winget-InsiderProgram).
- Join [Windows Insider Program](https://insider.windows.com/).

Once installed through any of the above methods, verify it by running `winget.exe` in Windows Terminal.

# Basic Usage

## Searching Apps

**Command:** `winget search`
| Command with options | Use |
|-------|--------|
| `winget search app` | Searches for app |
| `winget search "an app"` | Searches for "an app" |
| `winget search publisher.app` | Searches for publisher.app |

## Installing Apps

**Command:** `winget install`
| Command with options | Use |
|-------|--------|
| `winget install app` | Installs the given app |
| `winget install "an app"` | Installs "an app" |
| `winget install publisher.app` | Installs publisher.app |

## Upgrading Apps

**Command:** `winget upgrade`  
| Command with options | Use |
|-------|--------|
| `winget upgrade` | Checks for app updates |
| `winget upgrade -all` | Updates all apps |

## Uninstalling Apps

**Command:** `winget uninstall`
| Command with options | Use |
|-------|--------|
| `winget uninstall app` | Uninstalls the given app |
| `winget uninstall "an app"` | Uninstalls "an app" |
| `winget uninstall publisher.app` | Uninstalls publisher.app |

# Advanced Usage

## More Commands

Use `winget` in Windows Terminal to list all commands and their usage.

## Related Links

[Source Repo](https://github.com/microsoft/winget-cli/)  
[Packages Repo](https://github.com/microsoft/winget-pkgs/)  
[Documentation](https://docs.microsoft.com/en-us/windows/package-manager/winget/)

---

## Feedback

If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).
