# WinGet import command
Together with [`winget export`](https://docs.microsoft.com/en-us/windows/package-manager/winget/export), `winget import` can batch install apps from an exported JSON file.

### Dependency: [`winget`](https://github.com/pratyakshm/CleanWin/blob/main/doc/WINGET.md) 

## Exporting app list to JSON using `winget export` command  
To use `winget import`, you must use the `winget export` command first to export a JSON file of apps currently installed on your device.  
Use the following command to export list of apps to a JSON with file name `apps.json` in `D:`:  
``winget export -o D:\apps.json``  
The partition letter, file location and file name can be changed according to user preference.

## Using `winget import` in CleanWin
If configured during pre-execution environment, CleanWin CLI will ask user to select the exported JSON file using File Explorer picker UI.  


If a **valid** JSON file is selected, CleanWin will use `winget import` to batch install the apps.  
If an **invalid** JSON file is selected, `winget` will throw error and CleanWin will skip to the next jobs.  
If **no** JSON file is selected, CleanWin will skip to the next jobs.

## Related docs
[winget docs](https://docs.microsoft.com/en-us/windows/package-manager/winget/)    
[winget export](https://docs.microsoft.com/en-us/windows/package-manager/winget/export)  
[winget import](https://docs.microsoft.com/en-us/windows/package-manager/winget/import)  

***

## Feedback
If you have observed an issue with docs or if there are accessibility issues, please consider [filing an issue](https://github.com/pratyakshm/CleanWin/issues/new?assignees=pratyakshm&labels=Issue-Docs&template=doc_issue.yaml&title=Docs+issue%3A+).