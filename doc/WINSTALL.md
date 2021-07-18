# Winstall
Winstall lets you batch install your own set of apps by defining them in a text file.

### Dependency: [`winget`](https://github.com/pratyakshm/CleanWin/blob/main/doc/WINGET.md) 

## Creating your Winstall config
Create a new text file using any text editor, and add app names separated by a new line.   
Like this:
```
app 1
app 2
```
If Winstall text file is not located in the same directory as CleanWin, it will launch file picker UI for the user to select the text file.  
You may use ``pwd`` to find your current location in terminal.

## Examples
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