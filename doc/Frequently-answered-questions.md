# Frequently Asked Questions

**Q:** **Is it safe to use WinRice?**  
**A:** Yes, given that you've _read the documentation_.

**Q:** **Where can I read the detailed documentation for WinRice?**  
**A:** If you are a user and you want to learn what WinRice does, refer to [`Main-brief.md`](https://github.com/WinRice/WinRice/blob/main/doc/Main-brief.md).  
All documentation for this program is contained in the [doc](https://github.com/pratyakshm/WinRice/tree/main/doc) folder.

**Q:** **How do I revert a change?**  
**A:** Read [`Reverting-changes.md`](https://github.com/pratyakshm/WinRice/blob/main/doc/Reverting-changes.md).

**Q:** **I've run WinRice and I observed an issue.**  
**A:** [Open a ticket](https://github.com/pratyakshm/WinRice/issues/new/choose) in this repository.

**Q:** **Please add &lt;feature&gt; to WinRice**  
**A:** Submit a [Pull request](https://github.com/pratyakshm/WinRice/pulls) with your code or create an [Issue](https://github.com/pratyakshm/WinRice/issues). As long as it follows the WinRice [principles](https://github.com/pratyakshm/WinRice/blob/main/doc/CONTRIBUTING.md#principles) and adds value, I will most likely make it happen.

**Q:** **Which OS versions does WinRice support?**  
**A:** Refer to [doc/Supported-winver.md](https://github.com/pratyakshm/WinRice/blob/main/doc/Supported-winver.md).

**Q:** **I opted to turn off automatic Windows updates, but they're not turned off. Why?**  
**A:** Windows Update policies are only applied to Windows editions that support Group policies. These are Education, Enterprise, Enterprise LTSC and Professional editions. Windows editions that are derivates of Windows Core edition (for instance, Windows 11/10 Home) do not support Group policies, hence Windows Update policies cannot be applied to them.
If WinRice has not set up group policies despite your edition of Windows supporting it, please consider filing a [bug report](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Bug&template=bug_report.yaml&title=Bug%3A+).

---

## Feedback

If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).
