# Winstall
## CleanWin lets you install your own set of apps that you use, using a text file.

### Dependency: [`winget`](https://github.com/pratyakshm/CleanWin/blob/main/doc/WINGET.md) 

### Creating your Winstall config
Create a new text file using any text editor, and add app names separated by a new line.   
Like this:
```
app 1
app 2
```
Remember, Winstall text file must be saved in the same location as CleanWin executable/script.
You may use ``pwd`` to find your current location in terminal.

&nbsp;

### Examples
- This syntax installs Firefox, Visual Studio Code, Windows Terminal and 7zip:
```
Firefox
Visual Studio Code
Windows Terminal
7zip
```
Just like this, you can install any app you want by just writing its name in Winstall.txt

## Related docs
[winget docs](https://docs.microsoft.com/en-us/windows/package-manager/winget/)    
[winget install](https://docs.microsoft.com/en-us/windows/package-manager/winget/install)  

***

## Feedback
If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/CleanWin/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).