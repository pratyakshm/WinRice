# WinRice GUI Deprecation notice

WinRice GUI has been fully deprecated and is now in its [archived state](https://github.com/pratyakshm/WinRice/tree/archive).
The core reason behind this is that WinRice GUI was dependent on decades old and now deprecated Windows Forms technology.
The WinRice GUI mostly was not a good experience - either for me as a dev or for the users.
In lieu of this change, WinRice now only has one variant (i.e. CLI), hence its just called WinRice.

## Features affected  
### **App Uninstaller [PORTED to CLI]**  
This feature has been ported to regular WinRice. When run, users will have a choice to uninstall apps using CLI or GUI.    
While the CLI app uninstaller will remove apps as documented in [`TASKS.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/TASKS.md), GUI app uninstaller will give users the choice over which apps they want to uninstall. 

***

## Feedback
If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).