# Frequently asked questions

**Q:** **Can I use WinRice safely?**   
**A:** It is safe to run WinRice once you have read the documentation.

**Q:** **Where can I read the detailed documentation for WinRice?**  
**A:** If you are a user, chances are that the [`doc`](https://github.com/pratyakshm/WinRice/tree/main/doc) folder has what you need.   
Otherwise, you may want to check out the [Wiki](https://github.com/pratyakshm/WinRice/wiki).

**Q:** **How do I revert a change?**  
**A:** Read [`REVERT.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/REVERT.md).

**Q:** **I've run WinRice and it broke my computer / killed someone / caused an apocalypse.**   
**A:** This program comes with absolutely no warranty, hence I am not responsible. Tap the photo below to learn more.  
[![warranty.exe](https://i.imgur.com/lfqKSzz.png)](https://github.com/pratyakshm/WinRice/blob/main/LICENSE#L589-L598)

**Q:** **Please add &lt;feature&gt; to WinRice**   
**A:** Submit a [Pull request](https://github.com/pratyakshm/WinRice/pulls) with your code or create an [Issue](https://github.com/pratyakshm/WinRice/issues). As long as it follows WinRice [principles](https://github.com/pratyakshm/WinRice/wiki/Principles) and adds value, I will most likely make it happen.

**Q:** **How is WinRice tested?**  
**A:** Read [`Windows version`](https://github.com/pratyakshm/WinRice#windows-version) section in [`README.md`](https://github.com/pratyakshm/WinRice/blob/main/README.md). Only the listed OS builds are tested, either on my host machine or on virtual machines. Keep in mind that WinRice is a community project and as such it heavily relies on community feedback and input.

**Q:** **I opted to turn off automatic Windows updates, but they're not turned off. Why?**   
**A:** Windows Editions based on Windows Core such as Windows 10 Home, Home Single Language, etc. do not support setting up group policies for Windows Update. WinRice informs the user about this.   
However, if you have Pro edition or up and the group policies are still not set up, file a [bug report](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Bug&template=bug_report.yaml&title=Bug%3A+).  
**Note:** WinRice currently cannot set up update policies on Windows 11. 

***

## Feedback
If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).