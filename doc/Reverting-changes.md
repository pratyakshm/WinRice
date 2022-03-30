# Reverting Changes

## System Restore Point

WinRice provides the option for creating a System restore point before modifying the system. Restoring to the restore point will revert all settings changes performed by WinRice. However, if you configured WinRice to not create a System restore point, you may continue reading below to learn how to configure WinRice to revert its changes.

---

## Revert Changes Using WinRice Itself

WinRice has a revert function for almost every function it has. For example, since WinRice has a function to disable Advertising ID, it also has a function to enable Advertising ID. Read below to learn how to make these functions work for you to revert your device to default settings.

1. [Tap here](https://github.com/pratyakshm/WinRice/archive/refs/heads/main.zip) to download the latest WinRice code from main branch.

2. Extract the ZIP file and locate `WinRice.ps1`.

3. Open this file in your desired text editor of choice.

4. Edit the function calls section by commenting functions that you do not want to run and vice-versa.

    For example, if you don't want the DisableAdvertisingID function to run, comment it by placing a <kbd>#</kbd> (pound) before the function name.

    On the contrary, say if you want the EnableAdvertisingID function to run, uncomment it by removing the pound before its name.

5. Save the file.

6. Open PowerShell as administrator.

7. In PowerShell, navigate to WinRice's folder (typically `~\Downloads\WinRice-main`).  

8. Use command <kbd>Set-ExecutionPolicy Unrestricted -Force -Scope Process</kbd> to force set your ExecutionPolicy for current PSSession to Unrestricted.

9. Use <kbd>./WinRice.ps1</kbd> to execute the script.


## Re-Install Apps and Features

If WinRice removed an app that you want to use, you may use the below links to re-install those app(s):

<details><summary>Tap me to expand list</summary>

- [Clipchamp](https://www.microsoft.com/store/productId/9P1J8S7CCWWT)

- [Cortana](https://www.microsoft.com/store/productId/9NFFX4SZZ23L)

- [Get Help](https://www.microsoft.com/store/productId/9PKDZBMV1H3T)

- [Weather](https://www.microsoft.com/store/productId/9WZDNCRFJ3Q2)

- [Maps](https://www.microsoft.com/store/productId/9WZDNCRDTBVB)

- [Microsoft Solitaire Collection](https://www.microsoft.com/store/productId/9WZDNCRFHWD2)

- [Mixed Reality Portal](https://www.microsoft.com/store/productId/9NG1H8B3ZC7M)

- [Microsoft Whiteboard](https://www.microsoft.com/store/productId/9MSPC6MP8FM4)

- [Mail & Calendar](https://www.microsoft.com/store/productId/9WZDNCRFHVQM)

- [News](https://www.microsoft.com/store/productId/9WZDNCRFHVFW)

- [Office](https://www.microsoft.com/store/productId/9WZDNCRD29V9)

- [OneNote for Windows 10](https://www.microsoft.com/store/productId/9WZDNCRFHVJL)

- [Paint 3D](https://www.microsoft.com/store/productId/9NBLGGH5FV99)

- [Power Automate](https://www.microsoft.com/store/productId/9NFTCH6J7FHV)

- [Tips](https://www.microsoft.com/store/productId/9WZDNCRDTBJJ)

- [Widgets](https://www.microsoft.com/store/productId/9MSSGKG348SP)

</details>

### Notes

- WinRice cannot re-pin apps that it unpinned from the Taskbar and Start menu.

- WinRice cannot uninstall apps that it installed using `winget import` feature.

- WinRice may uninstall apps that it installed using the Winstall feature only if you still have the original Winstall text file which contained the list of apps. 

---

## Feedback

If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).
