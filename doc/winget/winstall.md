# Winstall

Winstall is a powerful feature that enables you to effortlessly batch install applications. It simplifies the process of setting up your system by automating the installation of multiple apps in one go.

**Dependency**: [`winget`](https://github.com/pratyakshm/WinRice/blob/main/doc/winget/winget.md) must installed on your system.

## Creating your Winstall

During the setup process, WinRice scans the current directory for the presence of the `Winstall.txt` file. If the file is found, WinRice will not nudge you. However, if the file is not found, WinRice will create one for you and open it in Notepad for you to populate.

Adhere to the following format when populating the `Winstall.txt` file:

```
app 1
app 2
```

## Examples

Here's an example of the syntax used in the `Winstall.txt` file to install popular applications:

```
Firefox
Visual Studio Code
Windows Terminal
Obsidian
```

By simply specifying the names of the desired applications in the `Winstall.txt` file, you can effortlessly install them using Winstall.

⚠️ **Note:** Kindly ensure that each app name is accurately listed on a separate line. Failure to comply will result in unexpected behavior.

## Related Documentation

Explore the following documentation to further enhance your understanding of Winstall:

- [WinGet Docs](https://docs.microsoft.com/en-us/windows/package-manager/winget/)
- [WinGet Install](https://docs.microsoft.com/en-us/windows/package-manager/winget/install)

---

## Feedback

Your feedback is highly valued! If you encounter any issues with the documentation or come across accessibility concerns, please don't hesitate to [file an issue](https://github.com/pratyakshm/WinRice/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+). We appreciate your contribution in making our documentation better.
