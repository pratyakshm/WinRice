# Windows Package Manager CLI client
## What is Windows Package Manager (a.k.a winget)?
Windows Package Manager, or simply `winget`, is the official package manager client for Windows. Package managers allow you to deploy and manage apps using the command line. 

## WinRice x WinGet
A lot of features in WinRice are powered by WinGet.   
### Features powered by WinGet
| Feature | Link | 
|-------|--------|
| Winstall | [`WINSTALL.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/WINSTALL.md) |
| winget import | [`WINGETIMPORT.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/WINGETIMPORT.md) |
| Deploy Microsoft OneDrive | [`TASKS.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/TASKS.md) |


# Installing winget
If you have used WinRice, chances are you have winget installed.   
> Verify it by using ``winget.exe`` in Windows Terminal.  

If you still don't have winget installed, install it.

## Methods
- Get the latest release from [GitHub Releases](https://github.com/microsoft/winget-cli/releases/latest).
- Use WinRice's own winget install script [paste in Windows Terminal (Admin)]: ``Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/JWMKj'))``
- Join [WinGet Insider Program](http://aka.ms/winget-InsiderProgram).
- Join [Windows Insider Program](https://insider.windows.com/).

> Once installed through any of the above methods, verify it using ``winget.exe`` in Windows Terminal.

# Basic usage
## Searching apps    
**Command:** `winget search`
| Command with options | Use | 
|-------|--------|
| `winget search app` | Searches for app |
| `winget search "an app"` | Searches for "an app" |
| `winget search publisher.app` | Searches for publisher.app |

## Installing apps     
**Command:** `winget install`
| Command with options | Use | 
|-------|--------|
| `winget install app` | Installs the given app |
| `winget install "an app"` | Installs "an app" |
| `winget install publisher.app` | Installs publisher.app |

## Upgrading apps  
**Command:** `winget upgrade`  
| Command with options | Use | 
|-------|--------|
| `winget upgrade` | Checks for app updates |
| `winget upgrade -all` | Updates all apps |

## Uninstalling apps

**Command:** `winget uninstall`
| Command with options | Use | 
|-------|--------|
| `winget uninstall app` | Uninstalls the given app |
| `winget uninstall "an app"` | Uninstalls "an app" |
| `winget uninstall publisher.app` | Uninstalls publisher.app |

# Advanced usage
## More commands
Use `winget` in Windows Terminal to list all commands and their usage.

## Related links
[source repo](https://github.com/microsoft/winget-cli/)     
[packages repo](https://github.com/microsoft/winget-pkgs/)    
[documentation](https://docs.microsoft.com/en-us/windows/package-manager/winget/)    

***

## Feedback
If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).